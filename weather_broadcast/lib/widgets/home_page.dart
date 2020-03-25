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
  final repo = Repository();

  @override
  Widget build(BuildContext context) {
    List<Future<ForecastEntity>> _forecasts = [
      repo.getBroadcastForCity("Katowice"),
      repo.getBroadcastForCity("Warszawa"),
      repo.getBroadcastForCity("Ruda Slaska"),
      repo.getBroadcastForCity("Madagaskar"),
    ];

    //Future<ForecastEntity> _currentLocation = repo.currentLocation;
    var _lookups = List<Widget>();

    for (var forecast in _forecasts) {
      _lookups.add(_futureLookup(forecast));
    }

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
            Column(
              children: _lookups,
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

Widget _futureLookup(Future<ForecastEntity> forecast) {
  return FutureBuilder(
    future: forecast,
    builder: (context, data) {
      if (data.hasData) {
        return ForecastLookup(forecast: data.data);
      } else if (data.hasError) {
        Future.delayed(Duration.zero, () => errorDialog(context));
        return Column();
      }
      return Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}

void errorDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Error'),
        content: FutureBuilder<bool>(
          future: isConnectedToInternet(),
          builder: (context, data) {
            if (data.hasData) if (data.data)
              return Text("There is no such city in API");
            else
              return Text("There is problem with connection");
            return Container();
          },
        ),
        actions: [
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

Future<bool> isConnectedToInternet() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult != ConnectivityResult.none) return true;
  return false;
}
