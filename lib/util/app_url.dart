import 'package:hivoyage/constants/constants.dart';

class AppUrl {
  static const String liveBaseURL =
      "https://hivoyage.herokuapp.com/api/customer";

  static const String localBaseURL = "http://10.0.2.2:8000/api/customer";

  static const String baseURL = liveBaseURL;
  static const String login = baseURL + "/login";
  static const String register = baseURL + "/register";
  static const String forgotPassword = baseURL + "/forgot-password";
  static const String logout = baseURL + "/logout";
  static const String home = baseURL + "/home";
  static const String city = baseURL + "/city";
  static const String search = baseURL + "/search";
  static const String place = baseURL + "/place";
  static const String storePlace = baseURL + "/store/place";
  static const String allTicket = baseURL + "/tickets";
  static const String usedTicket = baseURL + "/tickets/used";
  static const String ticketDetail = baseURL + "/ticket/data";
  static const String updatePersonal = baseURL + "/update/personal";
  static const String pay = baseURL + "/pay";
}
