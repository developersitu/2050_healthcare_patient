import 'dart:async';
import 'dart:convert';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthcare2050/Api/Api.dart';
import 'package:healthcare2050/Screens/Doctors/DoctorScheduleList.dart';
import 'package:healthcare2050/constants/constants.dart';
import 'package:healthcare2050/utils/settings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;


class CallPage extends StatefulWidget {
  /// non-modifiable channel name of the page
  static String? channelName;

  /// non-modifiable client role of the page
  static ClientRole? role;

  

  /// Creates a call page with given channel name.
 // const CallPage({Key? key, this.channelName, this.role}) : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  bool muteVideo= false;
   RtcEngine ? _engine;

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    _engine!.leaveChannel();
    _engine!.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    getPermission();
    // initialize agora sdk

    setState(() {
      CallPage.channelName=DoctorScheduleList.channelName;
      CallPage.role=ClientRole.Broadcaster;
    });
    initialize();
  }

  Future<void> initialize() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await _engine!.enableWebSdkInteroperability(true);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = VideoDimensions(width: 1920, height: 1080);
    await _engine!.setVideoEncoderConfiguration(configuration);
    await _engine!.joinChannel(Token, CallPage.channelName!, null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(APP_ID);
    await _engine!.enableVideo();
    await _engine!.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine!.setClientRole(CallPage.role!);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine!.setEventHandler(RtcEngineEventHandler(error: (code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    }, joinChannelSuccess: (channel, uid, elapsed) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
      });
    }, leaveChannel: (stats) {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    }, userJoined: (uid, elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
      });
    }, userOffline: (uid, elapsed) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
      });
    }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    }));
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    if (CallPage.role == ClientRole.Broadcaster) {
      list.add(RtcLocalView.SurfaceView());
    }
    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid,channelId: "0",)));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container();
  }

  /// Toolbar layout
  Widget _toolbar() {
    if (CallPage.role == ClientRole.Audience) return Container();
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
         
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),

          RawMaterialButton(
            onPressed: _onMuteCamera,
            child: Icon(
              muteVideo ? Icons.videocam_off : Icons.videocam,
              color: muteVideo ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muteVideo ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),

          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),

        ],
      ),
    );
  }

  /// Info panel to show logs
  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return Text("null");  // return type can't be null, a widget was required
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onCallEnd(BuildContext context) {
   // Navigator.pop(context);

    _showDialogCallEnd();
    
  } 

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine!.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    _engine!.switchCamera();
    
  }

  void _onMuteCamera() {
    setState(() {
      muteVideo = !muteVideo;
     
    });
   // _engine.enableLocalVideo(muteVideo);
  
   // _engine.enableFaceDetection(muteVideo);
    _engine!.muteLocalVideoStream(muteVideo);
   //_engine.muteLocalVideoStream(muted);

    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video calling'),
        backgroundColor: themColor,
        backwardsCompatibility: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light
        ),
  

      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: <Widget>[
            _viewRows(),
           // _panel(),
            _toolbar(),
          ],
        ),
      ),
    );
  }

  void getPermission() async{
    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);
  }

   Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

  void _showDialogCallEnd() {

    showDialog(
      context: context, 
      barrierDismissible:false ,
     
      builder: (BuildContext context){
      
        return
        StatefulBuilder(
          builder: (context, setState) {
            return 
            CupertinoAlertDialog(
              title: Column(
                children: [
                  Text("Want To Call End!!"),
                  Icon(
                    Icons.phone,
                    color: Colors.red,
                  ),
          
                ],
                
              ),
              content: Text("Please Choose One"), 
              actions: [
                CupertinoDialogAction(
                  child: Text("Cancel"),
                  onPressed: (){
                    Navigator.of(context).pop();
                  }
                ),
          
                CupertinoDialogAction(
                  child: Text("Call End"),
                  onPressed: ()
                    {
                    // Navigator.pop(context);
                      fetchCallEndProcess();
          
          
                    
                   //  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const VideoCallDonePage())) ;
                  
            
                    
                      
                    // Navigator.of(context);
                      
                      //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginRegistration()));
                    }
                ),
              ],
            );
          }  
        );
          
      } 

    );    
    
  }


  fetchCallEndProcess() async {

  
    var response = await http.post(
      Uri.parse(callEndApi.toString()),
      headers: <String,String> {

      },
      body: {

        "bookscheduleid" : DoctorScheduleList.callEndId.toString()
        
      }
    );
    
    print("call end body ////////////////////////////////////////////////"+response.body);
    if(response.statusCode == 200){
      
      var callEndMessage = json.decode(response.body)['message'] ?? "";

      bool callEndStatus=json.decode(response.body)['status'] ?? false;    
      
      if(callEndStatus){

        print("item of call end ......................... "+callEndMessage.toString());

        Fluttertoast.showToast(
          msg: callEndMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
        );
        
       // Navigator.pop(context);
     
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> DoctorScheduleList()));
             
      }


      if (callEndStatus==false) {
       
        Fluttertoast.showToast(
          msg: callEndMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
        );

      }  

    }

   // return EndVideoCallModel.fromJson(json.decode(response.body));
   
  }
}
