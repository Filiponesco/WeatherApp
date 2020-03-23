import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_broadcast/broadcast_entity.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:weather_broadcast/custom_icons_icons.dart';

class BroadcastContainer extends StatelessWidget {
  final BroadcastEntity broadcast;
  final double paddingWeight = 20;
  final double iconSize = 42;
  final DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");
  final DateFormat timeFormat = DateFormat("HH:mm:ss");
  final TextStyle textStyle = TextStyle(fontSize: 18);

  BroadcastContainer({Key key, this.broadcast}) : super(key: key);

  Image getBackground(String name) {
    switch (name.toLowerCase()) {
      case "thunderstorm":
        return Image.asset(
          "assets/thunderstorm.jpg",
          fit: BoxFit.fitWidth,
        );
        break;
      case "drizzle":
      case "rain":
        return Image.asset(
          "assets/rain.jpg",
          fit: BoxFit.fitWidth,
        );
        break;
      case "snow":
        return Image.asset(
          "assets/snow.jpg",
          fit: BoxFit.fitWidth,
        );
        break;
      case "mist":
      case "smoke":
      case "haze":
      case "dust":
      case "fog":
      case "sand":
      case "ash":
      case "squall":
        return Image.asset(
          "assets/fog.jpg",
          fit: BoxFit.fitWidth,
        );
        break;
      case "tornado":
        return Image.asset(
          "assets/tornado.jpg",
          fit: BoxFit.fitWidth,
        );
        break;
      case "clear":
        return Image.asset(
          "assets/clear.jpg",
          fit: BoxFit.fitWidth,
        );
        break;
      case "clouds":
        return Image.asset(
          "assets/clouds.jpg",
          fit: BoxFit.fitWidth,
        );
        break;
      default:
        return Image.asset(
          "assets/clouds.jpg",
          fit: BoxFit.fitWidth,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Stack(
            children: <Widget>[
              getBackground(broadcast.weather[0].main),
              Container(
                child: BorderedText(
                  strokeWidth: 0.3,
                  child: Text(
                    broadcast.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.0,
                    ),
                  ),
                ),
                padding: EdgeInsets.all(20),
              ),
            ],
            alignment: Alignment.bottomLeft,
          ),
          //Time and Date
          Container(
            child: Text(
              dateFormat.format(DateTime.now()),
              style: TextStyle(fontSize: 24),
            ),
            padding: EdgeInsets.all(paddingWeight),
          ),
          //Description
          Container(
            child: Text(
              broadcast.weather[0].description[0].toUpperCase() + broadcast.weather[0].description.substring(1),
              style: textStyle,
            ),
            alignment: Alignment.bottomLeft,
            margin: EdgeInsets.only(left: 50),
          ),
          //Icons start here
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
                          (broadcast.main.temp - 273).round().toString() +
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
                          timeFormat.format(DateTime.fromMillisecondsSinceEpoch(
                              broadcast.sys.sunrise * 1000)),
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
                              (broadcast.main.pressure).round().toString() +
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
                          timeFormat.format(DateTime.fromMillisecondsSinceEpoch(
                              broadcast.sys.sunset * 1000)),
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
      margin: EdgeInsets.all(20),
      elevation: 10,
    );
  }
}
