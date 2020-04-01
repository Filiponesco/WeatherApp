import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:weather_broadcast/models/forecast_entity.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:geolocator/geolocator.dart';

class Repository {
  final String apiKey = "d525041c8bf169941d6f6f7e3400d59f";

  static Repository _instance;

  static Repository getInstance() {
    if (_instance == null) {
      _instance = Repository();
    }

    return _instance;
  }

  Future<ForecastEntity> getBroadcastForCity(String name) async {
    var url =
        "https://api.openweathermap.org/data/2.5/weather?q=$name&appid=$apiKey";
    var response = await http.get(url);
    var result = json.decode(response.body);
    return ForecastEntity().fromJson(result);
  }

  final Future<Database> database = getDatabasesPath().then((String path) {
    return openDatabase(
      join(path, 'weatherapp.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE locations(id INTEGER PRIMARY KEY, city TEXT)",
        );
      },
      version: 1,
    );
  });

  Future<void> insertCity(String city) async {
    final Database db = await database;

    await db.insert(
      'locations',
      {
        'city': city,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<String>> allSavedCities() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('locations');

    return List.generate(maps.length, (i) {
      return maps[i]['city'];
    });
  }

  Future<void> deleteCity(String city) async {
    final db = await database;

    await db.delete(
      'locations',
      where: "city = ?",
      whereArgs: [city],
    );
  }

  Future<ForecastEntity> getBroadcastForGPS() async {
    final position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
//    print(placemark[0].locality);
    var url =
        "https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey";

    var response = await http.get(url);
    var result = json.decode(response.body);
    return ForecastEntity().fromJson(result);
  }
}
