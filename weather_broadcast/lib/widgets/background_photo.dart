import 'package:flutter/cupertino.dart';

class BackgroundPhoto extends StatelessWidget {
  final String name;

  const BackgroundPhoto({Key key, this.name}) : super(key: key);

  String _getPathName(String name) {
    switch (name.toLowerCase()) {
      case "thunderstorm":
        return "assets/images/thunderstorm.jpg";
        break;
      case "drizzle":
      case "rain":
        return "assets/images/rain.jpg";
        break;
      case "snow":
        return "assets/images/snow.jpg";
        break;
      case "mist":
      case "smoke":
      case "haze":
      case "fog":
      case "squall":
        return "assets/images/fog.jpg";
        break;
      case "dust":
      case "sand":
      case "ash":
        return "assets/images/dust.jpg";
        break;
      case "tornado":
        return "assets/images/tornado.jpg";
        break;
      case "clear":
        return "assets/images/clear.jpg";
        break;
      case "clouds":
        return "assets/images/clouds.jpg";
        break;
      default:
        return "assets/images/clouds.jpg";
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _getPathName(name),
      fit: BoxFit.fitWidth,
    );
  }
}
