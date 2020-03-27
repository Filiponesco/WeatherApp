import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_broadcast/models/forecast_entity.dart';

import 'background_photo.dart';
import '../pages/forecast_page.dart';

class ForecastLookup extends StatelessWidget {
  final ForecastEntity forecast;

  const ForecastLookup({Key key, this.forecast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ForecastPage(forecast: forecast,)),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        elevation: 10,
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: BackgroundPhoto(name: forecast.weather[0].main),
            ),
            Positioned(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    forecast.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    (forecast.main.temp - 273).round().toString() + '\u2103',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              bottom: 10,
              left: 20,
            ),
          ],
          alignment: Alignment.bottomLeft,
        ),
      ),
    );
  }
}
