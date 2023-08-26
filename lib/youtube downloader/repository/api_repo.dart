


import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart'as http;
// import 'package:dio/dio.dart';

// import '../utils/injector.dart';

class ApiRepository{


  // final Dio dio = locator<Dio>();

  getData(String url) async {
    try {
      print(url);
      http.Response response = await http.get(Uri.parse(url));
      print(response.body);
      if(response.statusCode==200) {
        print(response.statusCode);
        return response;
      }else{
        return null;
      }
    } catch (error, stacktrace) {
      throw Exception("Exception occured: $error stackTrace: $stacktrace");
    }
  }


}