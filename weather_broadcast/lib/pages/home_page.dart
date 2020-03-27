import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_broadcast/models/forecast_entity.dart';
import 'package:connectivity/connectivity.dart';
import 'package:weather_broadcast/widgets/forecast_lookup.dart';

import '../repository.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  final repo = Repository.getInstance();

  @override
  Widget build(BuildContext context) {
    Future<List<Future<ForecastEntity>>> _forecasts =
        repo.allSavedCities().then((result) {
      return List.generate(result.length, (i) {
        return repo.getBroadcastForCity(result[i]);
      });
    });

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(
                "Current location",
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            //tutaj masz w _futurelookup dac swoje
            _futureLookup(repo.getBroadcastForCity("Honolulu")),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(
                "Saved locations",
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            FutureBuilder(
              future: _forecasts,
              builder: (context, data) {
                if(data.hasData){
                  var _lookups = List<Widget>();

                  for(var forecast in data.data){
                    _lookups.add(_futureLookup(forecast, favorite: true));
                  }

                  return Column(children: _lookups,);
                }
                else if(data.hasError){
                  //error handling with connection to database
                  return Text("Connection with database error");
                }
                return CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {},
      ),
    );
  }
}

Widget _futureLookup(Future<ForecastEntity> forecast, {bool favorite = false}) {
  return FutureBuilder(
    future: forecast,
    builder: (context, data) {
      if (data.hasData) {
        (data.data as ForecastEntity).favorite = favorite;
        return ForecastLookup(forecast: data.data);
      } else if (data.hasError) {
        //error handling with connecting to api or internet connection
        return Column();
      }
      return Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}
