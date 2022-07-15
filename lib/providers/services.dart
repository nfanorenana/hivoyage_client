import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:hivoyage/constants/constants.dart';
import 'package:hivoyage/domain/city.dart';
import 'package:hivoyage/domain/qr_ticket.dart';
import 'package:hivoyage/domain/schedule.dart';
import 'package:hivoyage/domain/ticket.dart';
import 'package:hivoyage/domain/user.dart';
import 'package:hivoyage/util/app_url.dart';
import 'package:hivoyage/util/storage.dart';
import 'package:http/http.dart';

Future<Map<String, dynamic>> loadAllCities() async {
  String token = await UserPreferences().getToken();
  try {
    Response response = await post(
      Uri.parse(AppUrl.city),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final parsed =
          json.decode(response.body)['city'].cast<Map<String, dynamic>>();
      return {
        'status': true,
        'city': parsed.map<City>((json) => City.fromJson(json)).toList(),
      };
    } else {
      return {
        'status': false,
        'message': json.decode(response.body)['message'],
      };
    }
  } catch (e) {
    return {
      'status': false,
      'message': e.toString(),
    };
  }
}

Future<Map<String, dynamic>> searchSchedule(
    String departure, String arrival, String tripDate) async {
  String token = await UserPreferences().getToken();
  try {
    Response response = await post(
      Uri.parse(AppUrl.search),
      body: {
        'departure': departure,
        'arrival': arrival,
        'tripDate': tripDate,
      },
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final parsed =
          json.decode(response.body)['schedules'].cast<Map<String, dynamic>>();
      return {
        'status': true,
        'schedules':
            parsed.map<Schedule>((json) => Schedule.fromJson(json)).toList(),
      };
    } else {
      return {
        'status': false,
        'message': json.decode(response.body)['message'],
      };
    }
  } catch (e) {
    return {
      'status': false,
      'message': e.toString(),
    };
  }
}

Future<Map<String, dynamic>> scheduleData(Schedule schedule) async {
  String token = await UserPreferences().getToken();
  try {
    Response response = await post(
      Uri.parse(AppUrl.place),
      body: {
        'schedule_id': schedule.id.toString(),
      },
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<String> seatMap = getSeatMap(json.decode(response.body)['seatlayout']
          [json.decode(response.body)['layout_id']]['map']);
      List<String> unavailableSeat =
          getUnavailableSeat(json.decode(response.body)['unavailable_seat']);
      Map<String, dynamic> seatPrice = getSeatPrice(
          json.decode(response.body)['seatlayout']
              [json.decode(response.body)['layout_id']]['seats']);
      return {
        'status': true,
        'schedule': schedule,
        'seat_map': seatMap,
        'seat_price': seatPrice,
        'unavailable_seat': unavailableSeat,
        'exchange_value': json.decode(response.body)['exchange_value'],
      };
    } else {
      return {
        'status': false,
        'message': json.decode(response.body)['message'],
      };
    }
  } catch (e) {
    return {
      'status': false,
      'message': e.toString(),
    };
  }
}

Future<Map<String, dynamic>> loadAllTickets() async {
  String token = await UserPreferences().getToken();
  try {
    Response response = await post(
      Uri.parse(AppUrl.allTicket),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final parsed =
          json.decode(response.body)['tickets'].cast<Map<String, dynamic>>();
      return {
        'status': true,
        'ticket': parsed.map<Ticket>((json) => Ticket.fromJson(json)).toList(),
      };
    } else {
      return {
        'status': false,
        'message': json.decode(response.body)['message'],
      };
    }
  } catch (e) {
    return {
      'status': false,
      'message': e.toString(),
    };
  }
}

Future<Map<String, dynamic>> bookAndPayWithPayPal(
    BraintreeDropInResult result,
    Schedule schedule,
    List<String> selectedSeat,
    List<int> selectedSeatPrice,
    List<String> selectedSeatCategory,
    int price) async {
  String token = await UserPreferences().getToken();
  List selected = [];
  for (var i = 0; i < selectedSeat.length; i++) {
    selected.add({
      'seat_id': selectedSeat[i],
      'price': selectedSeatPrice[i],
      'category': selectedSeatCategory[i],
    });
  }
  try {
    Response response = await post(
      Uri.parse(AppUrl.pay),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: {
        'payment_method_nonce': result.paymentMethodNonce.nonce,
        'device_data': result.deviceData,
        'schedule_id': schedule.id.toString(),
        'selected_seat': json.encode(selected),
        'total_amount': price.toString()
      },
    );
    if (response.statusCode == 200) {
      return {
        'status': true,
        'message': json.decode(response.body)['message'],
      };
    } else {
      return {
        'status': false,
        'message': json.decode(response.body)['message'],
      };
    }
  } catch (e) {
    return {
      'status': false,
      'message': e.toString(),
    };
  }
}

Future<Map<String, dynamic>> loadAllUsedTickets() async {
  String token = await UserPreferences().getToken();
  try {
    Response response = await post(
      Uri.parse(AppUrl.usedTicket),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    inspect(response.body);
    if (response.statusCode == 200) {
      final parsed =
          json.decode(response.body)['tickets'].cast<Map<String, dynamic>>();
      return {
        'status': true,
        'ticket': parsed.map<Ticket>((json) => Ticket.fromJson(json)).toList(),
      };
    } else {
      return {
        'status': false,
        'message': json.decode(response.body)['message'],
      };
    }
  } catch (e) {
    return {
      'status': false,
      'message': e.toString(),
    };
  }
}

Future<Map<String, dynamic>> ticketDetail(int ticketId) async {
  String token = await UserPreferences().getToken();
  try {
    Response response = await post(
      Uri.parse(AppUrl.ticketDetail),
      body: {
        'ticket_id': ticketId.toString(),
      },
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final parsed =
          json.decode(response.body)['tickets'].cast<Map<String, dynamic>>();
      return {
        'status': true,
        'qrticket':
            parsed.map<QrTicket>((json) => QrTicket.fromJson(json)).toList()[0],
        'qrdata': json.decode(response.body)['data'],
      };
    } else {
      return {
        'status': false,
        'message': json.decode(response.body)['message'],
      };
    }
  } catch (e) {
    return {
      'status': false,
      'message': e.toString(),
    };
  }
}

Future<Map<String, dynamic>> updatePersonalInformations(
  name,
  username,
  contact,
  email,
) async {
  String token = await UserPreferences().getToken();
  User user = await UserPreferences().getUser();
  try {
    Response response = await post(
      Uri.parse(AppUrl.updatePersonal),
      body: {
        'user_id': user.userId.toString(),
        'name': name,
        'username': username,
        'contact': contact,
        'email': email
      },
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return {
        'status': true,
        'message': json.decode(response.body)['message'],
      };
    } else {
      return {
        'status': false,
        'message': json.decode(response.body)['message'],
      };
    }
  } catch (e) {
    return {
      'status': false,
      'message': e.toString(),
    };
  }
}

// -----------------------------------------------------------------------------

List<String> getSeatMap(List<dynamic> map) {
  List<String> seatMap = (map)?.map((item) => item as String)?.toList();
  return seatMap;
}

List<String> getUnavailableSeat(List<dynamic> map) {
  List<String> unavailableSeat = (map)?.map((item) => item as String)?.toList();
  return unavailableSeat;
}

Map<String, dynamic> getSeatPrice(Map<String, dynamic> map) {
  return {
    'f': map['f'],
    'e': map['e'],
  };
}
