import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_broadcast/models/forecast_entity.dart';
import 'package:weather_broadcast/custom_icons_icons.dart';
import 'package:weather_broadcast/repository.dart';
import 'package:weather_broadcast/widgets/background_photo.dart';

class ForecastPage extends StatefulWidget {
  final ForecastEntity forecast;

  const ForecastPage({Key key, this.forecast}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ForecastPageState();
  }
}

class ForecastPageState extends State<ForecastPage> {
  final double paddingWeight = 20;
  final double iconSize = 42;
  final DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");
  final DateFormat timeFormat = DateFormat("HH:mm:ss");
  final TextStyle textStyle = TextStyle(fontSize: 18);
  final Repository repo = Repository.getInstance();

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
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 13.0),
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          offset: Offset(0.0, 2.0),
                          blurRadius: 6.0,
                          color: Colors.black26,
                        )
                      ]),
                      child: Container(
                        color: Color(0xfff5f6fa),
                        height: 280,
                        width: MediaQuery.of(context).size.width - 26,
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              widget.forecast.weather[0].description[0]
                                      .toUpperCase() +
                                  widget.forecast.weather[0].description
                                      .substring(1),
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
                                            (widget.forecast.main.temp - 273)
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
                                                    widget.forecast.sys
                                                            .sunrise *
                                                        1000)),
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
                                                (widget.forecast.main.pressure)
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
                                                    widget.forecast.sys.sunset *
                                                        1000)),
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
                          child: BackgroundPhoto(
                              name: widget.forecast.weather[0].main),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        Container(
                          child: Text(
                            widget.forecast.name,
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
            Center(
              child: IconButton(
                icon: Icon(
                  widget.forecast.favorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  size: 42.0,
                ),
                tooltip: widget.forecast.favorite ? "Delete" : "Add",
                onPressed: () {
                  if (widget.forecast.favorite) {
                    repo.deleteCity(widget.forecast.name);
                  } else {
                    repo.insertCity(widget.forecast.name);
                  }
                  widget.forecast.favorite = !widget.forecast.favorite;
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
