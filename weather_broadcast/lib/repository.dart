import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_broadcast/models/forecast_entity.dart';

class Repository{
  final String apiKey = "d525041c8bf169941d6f6f7e3400d59f";

  Future<ForecastEntity> getBroadcastForCity(String name) async {
    var url = "https://api.openweathermap.org/data/2.5/weather?q=$name&appid=$apiKey";
    var response = await http.get(url);
    var result = json.decode(response.body);
    return ForecastEntity().fromJson(result);
  }
}