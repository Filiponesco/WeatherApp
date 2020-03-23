import 'package:weather_broadcast/generated/json/base/json_convert_content.dart';
import 'package:weather_broadcast/generated/json/base/json_filed.dart';

class BroadcastEntity with JsonConvert<BroadcastEntity> {
	BroadcastCoord coord;
	List<BroadcastWeather> weather;
	String base;
	BroadcastMain main;
	int visibility;
	BroadcastWind wind;
	BroadcastClouds clouds;
	int dt;
	BroadcastSys sys;
	int timezone;
	int id;
	String name;
	int cod;
}

class BroadcastCoord with JsonConvert<BroadcastCoord> {
	double lon;
	double lat;
}

class BroadcastWeather with JsonConvert<BroadcastWeather> {
	int id;
	String main;
	String description;
	String icon;
}

class BroadcastMain with JsonConvert<BroadcastMain> {
	double temp;
	@JSONField(name: "feels_like")
	double feelsLike;
	@JSONField(name: "temp_min")
	double tempMin;
	@JSONField(name: "temp_max")
	double tempMax;
	int pressure;
	int humidity;
}

class BroadcastWind with JsonConvert<BroadcastWind> {
	double speed;
	int deg;
}

class BroadcastClouds with JsonConvert<BroadcastClouds> {
	int all;
}

class BroadcastSys with JsonConvert<BroadcastSys> {
	int type;
	int id;
	String country;
	int sunrise;
	int sunset;
}
