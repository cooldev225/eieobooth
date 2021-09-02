import 'dart:convert';
import 'dart:io';

import 'package:easyguard/public/lang/sit_localizations.dart';
import 'package:easyguard/ui/widgets/toast.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:http/http.dart' as http;
import 'package:easyguard/public/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

post(url, body, context) async {
  var headers;
  SharedPreferences sp = await SharedPreferences.getInstance();
  var token = sp.getString('token');

  if (token == null) token = '';
  headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    HttpHeaders.authorizationHeader: token.toString()
  };
  body = jsonEncode(body);
  try {
    final http.Response response =
        await http.post(SERVER_URL + url, headers: headers, body: body);
    var result = json.decode(response.body);
    return await returnResult(result, context);
  } catch (e) {
    return {'success': false, 'message': e};
  }
}

get(url, context) async {
  var headers;
  SharedPreferences sp = await SharedPreferences.getInstance();
  var token = sp.getString('token');

  if (token == null) token = '';
  headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    HttpHeaders.authorizationHeader: token.toString()
  };
  try {
    final http.Response response =
        await http.get(SERVER_URL + url, headers: headers);
    var result = json.decode(response.body);
    return await returnResult(result, context);
  } catch (e) {
    return {'success': false, 'error': e};
  }
}

delete(url, context) async {
  var headers;
  SharedPreferences sp = await SharedPreferences.getInstance();
  var token = sp.getString('token');

  if (token == null) token = '';
  headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    HttpHeaders.authorizationHeader: token.toString()
  };
  try {
    final http.Response response =
        await http.delete(SERVER_URL + url, headers: headers);
    var result = json.decode(response.body);
    return await returnResult(result, context);
  } catch (e) {
    return {'success': false, 'message': e};
  }
}

returnResult(res, context) async {
  if (res['success']) {
    return {'success': true, 'result': res['result']};
  } else {
    if (res['multipleLogin'] == null) {
      return {'success': false, 'message': res['message']};
    }
    if (res['multipleLogin']) {
      showToast(SitLocalizations.of(context).multipleLoginMessage());
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString('token', '');
      await Future.delayed(Duration(seconds: 2));
      Phoenix.rebirth(context);
      return {'success': false, 'message': 'Rebirthing'};
    }
  }
}
