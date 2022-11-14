class DoctorScheduleListModel {
  factory DoctorScheduleListModel.fromJson(Map<String, dynamic> json) {
    return DoctorScheduleListModel(
      id: json['Id'],
      fullName: json['FullName'],
      patientName : json['PatientName'],
      status: json['Status'],
      scheduleDate: DateTime.parse(json['ScheduleDate']),
      mobileNumber: json['MobileNumber'],
      rejectionReason: json['Reason'],
      channelName: json['ChannelName']
       
    );
      
  }
  DoctorScheduleListModel(
      {required this.id,
      required this.fullName,
      required this.patientName,
      required this.status,
      required this.scheduleDate,
      required this.mobileNumber,
      required this.rejectionReason,
      required this.channelName
     
      });
  final int? id;
  final String? fullName;
  final String? patientName;
  final String ? status;
  final DateTime ? scheduleDate;
  final String mobileNumber;
  final String rejectionReason;
  final String channelName;
  
 
}