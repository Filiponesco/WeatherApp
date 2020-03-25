import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_broadcast/models/forecast_entity.dart';
import 'package:weather_broadcast/custom_icons_icons.dart';
import 'package:weather_broadcast/widgets/background_photo.dart';

class ForecastPage extends StatelessWidget {
  final ForecastEntity forecast;
  final double paddingWeight = 20;
  final double iconSize = 42;
  final DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");
  final DateFormat timeFormat = DateFormat("HH:mm:ss");
  final TextStyle textStyle = TextStyle(fontSize: 18);

  ForecastPage({Key key, this.forecast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              height: 490,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 10.0,
                    child: Card(
                      margin: EdgeInsets.symmetric(horizontal: 13.0),
                      child: Container(
                        color: Color(0xfff5f6fa),
                        height: 280,
                        width: MediaQuery.of(context).size.width - 26,
                        alignment: Alignment.bottomLeft,

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              forecast.weather[0].description[0].toUpperCase() +
                                  forecast.weather[0].description.substring(1),
                              style: textStyle,
                            ),
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          Icon(
                                            CustomIcons.thermometer,
                                            size: iconSize,
                                          ),
                                          Text(
                                            (forecast.main.temp - 273)
                                                    .round()
                                                    .toString() +
                                                ' \u1d52' +
                                                'C',
                                            style: textStyle,
                                          ),
                                        ],
                                      ),
                                      padding: EdgeInsets.all(paddingWeight),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Icon(
                                            CustomIcons.sunrise,
                                            size: iconSize,
                                          ),
                                          Text(
                                            timeFormat.format(DateTime
                                                .fromMillisecondsSinceEpoch(
                                                    forecast.sys.sunrise * 1000)),
                                            style: textStyle,
                                          ),
                                        ],
                                      ),
                                      padding: EdgeInsets.all(paddingWeight),
                                    ),
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                ),
                                Column(
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          Icon(
                                            CustomIcons.meter,
                                            size: iconSize,
                                          ),
                                          Text(
                                            " " +
                                                (forecast.main.pressure)
                                                    .round()
                                                    .toString() +
                                                " hPa",
                                            style: textStyle,
                                          ),
                                        ],
                                      ),
                                      padding: EdgeInsets.all(paddingWeight),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Icon(
                                            CustomIcons.sunset,
                                            size: iconSize,
                                          ),
                                          Text(
                                            timeFormat.format(DateTime
                                                .fromMillisecondsSinceEpoch(
                                                    forecast.sys.sunset * 1000)),
                                            style: textStyle,
                                          ),
                                        ],
                                      ),
                                      padding: EdgeInsets.all(paddingWeight),
                                    ),
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 10.0,
                    margin: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 15.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Stack(
                      children: <Widget>[
                        ClipRRect(
                          child:
                              BackgroundPhoto(name: forecast.weather[0].main),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        Container(
                          child: Text(
                            forecast.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40.0,
                            ),
                          ),
                          padding: EdgeInsets.all(20),
                        ),
                      ],
                      alignment: Alignment.bottomLeft,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

//    Card(
//      child: Column(
//        children: [
//
//          //Time and Date
//          Container(
//            child: Text(
//              dateFormat.format(DateTime.now()),
//              style: TextStyle(fontSize: 24),
//            ),
//            padding: EdgeInsets.all(paddingWeight),
//          ),
//          //Description
//          Container(
//            child: Text(
//              broadcast.weather[0].description[0].toUpperCase() + broadcast.weather[0].description.substring(1),
//              style: textStyle,
//            ),
//            alignment: Alignment.bottomLeft,
//            margin: EdgeInsets.only(left: 50),
//          ),
//          //Icons start here
//
//        ],
//      ),
//      margin: EdgeInsets.all(20),
//      elevation: 10,
//    );
  }
}
