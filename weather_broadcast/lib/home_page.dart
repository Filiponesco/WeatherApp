import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_broadcast/broadcast_container.dart';
import 'package:weather_broadcast/broadcast_entity.dart';
import 'package:connectivity/connectivity.dart';

import 'repository.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  final repo = Repository();
  String cityName = "Katowice";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather forecast"),
      ),
      body: FutureBuilder<BroadcastEntity>(
        future: repo.getBroadcastForCity(cityName),
        builder: (context, data) {
          if (data.hasData) {
            return ListView(
              children: [
                BroadcastContainer(broadcast: data.data),
              ],
            );
          } else if (data.hasError) {
            Future.delayed(Duration.zero, () => errorDialog(context));
            return Column();
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () async {
          String city = "";
          cityName = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Search'),
                content: TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'City name',
                    hintText: 'Warsaw',
                  ),
                  onChanged: (text) {
                    city = text;
                  },
                ),
                actions: [
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.pop(context, city);
                    },
                  ),
                ],
              );
            },
          );
          setState(() {});
        },
      ),
    );
  }
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
            if(data.hasData)
              if(data.data)
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
