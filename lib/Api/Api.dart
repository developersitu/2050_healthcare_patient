
//Home Page Api
import 'package:healthcare2050/Api/Url.dart';

//Home Page Api
String categoryApi="http://"+ipaddress+"/public/api/auth/category_fetch";
String cityApi="http://"+ipaddress+"/public/api/auth/city_details_fetch";
String doctorApi="http://"+ipaddress+"/public/api/auth/doctor_fetch";

//Login Page Api
String entryMobileNoApi="http://"+ipaddress+"/public/api/auth/WebsiteLoginUser";
String validOtpApi="http://"+ipaddress+"/public/api/auth/ValidateOtp";

//Doctor Page Api
String doctorScheduleApi="http://"+ipaddress+"/public/api/auth/Insertbookschedule";
String allDoctorsListApi="http://"+ipaddress+"/public/api/auth/doctor_fetch";
String doctorSpecializationApi="http://"+ipaddress+"/public/api/auth/specialization_fetch";
String doctorListOnSpecializationApi= "http://"+ipaddress+"/public/api/auth/CategoryWiseDoctor";
String doctorScheduleListApi= "http://"+ipaddress+"/public/api/auth/CategoryWiseDoctor";
String doctorSearchApi="http://"+ipaddress+"public/api/auth/doctorSearch";
String doctorAppointmentScheduleListApi="http://"+ipaddress+"/public/api/auth/doctorScheduleList";

//Book Code Api
String bookCodeApi="http://"+ipaddress+"/public/api/auth/getBookCodeAsSubcategoty";
String bookNowApi="http://"+ipaddress+"/public/api/auth/Book_Insert";


//Our Presence api
String zoneApi="http://"+ipaddress+"/public/api/auth/ZoneFetch";
String zoneWiseStateApi="http://"+ipaddress+"/public/api/auth/ZoneWiseStateFetch";
String stateWiseCityApi="http://"+ipaddress+"/public/api/auth/ZoneWiseCityFetch";
String cityFacilitiesApi="http://"+ipaddress+"/public/api/auth/CityWiseDataFetch";

//Video Consult
String specializationApi="http://"+ipaddress+"/public/api/auth/SpecializationFetch";
String specializationWiseDoctorApi="http://"+ipaddress+"/public/api/auth/SpecializationWiseDataFetch";
String DoctorSlotApi="http://"+ipaddress+"/public/api/auth/ConsultTypeSlotVisibility";
String DoctorAppointmentApi="http://"+ipaddress+"/public/api/auth/InsertAppointmentConsult";
String callEndApi="http://"+"101.53.150.64/2050Healthcare/2050admin"+"/public/api/auth/EndVideoCall";

//request a service
String reuestAserviceApi= "http://"+ipaddress+"/public/api/auth/requestaservice";

//book appointment
String CityNameApi= "http://"+ipaddress+"/public/api/auth/CityNameBookAppointment";
String cityBasedSpecializationApi= "http://"+ipaddress+"/public/api/auth/CityWiseSpecification";
String specializationBasedDoctorsApi= "http://"+ipaddress+"/public/api/auth/city_specialization_wise_doctor";
String offlineBookAppointmentApi="http://"+ipaddress+"/public/api/auth/BookAppointmentWiseSlotVisibility";


//Razorpay 
String oderIdApi="http://"+ipaddress+"/public/api/auth/GetAnOrderId";
String goToRazorPayApi="http://"+ipaddress+"/public/api/auth/GotoPaymentRazorpay";
String updateRazorPayApi="http://"+ipaddress+"/public/api/auth/RazorpaymentIdUpdate";

//Profile
String profileImageUploadApi="http://"+ipaddress+"/public/api/auth/UserImageUpload";
String profileEditApi="http://"+ipaddress+"/public/api/auth/UserAllDataUpload";




