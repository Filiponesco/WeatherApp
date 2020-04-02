import 'package:weather_broadcast/generated/json/base/json_convert_content.dart';
import 'package:weather_broadcast/generated/json/base/json_filed.dart';

class ForecastEntity with JsonConvert<ForecastEntity> {
	ForecastCoord coord;
	List<ForecastWeather> weather;
	String base;
	ForecastMain main;
	ForecastWind wind;
	ForecastClouds clouds;
	int dt;
	ForecastSys sys;
	int timezone;
	int id;
	String name;
	int cod;
	bool favorite = false;
}

class ForecastCoord with JsonConvert<ForecastCoord> {
	double lon;
	double lat;
}

class ForecastWeather with JsonConvert<ForecastWeather> {
	int id;
	String main;
	String description;
	String icon;
}

class ForecastMain with JsonConvert<ForecastMain> {
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

class ForecastWind with JsonConvert<ForecastWind> {
	double speed;
	int deg;
	double gust;
}

class ForecastClouds with JsonConvert<ForecastClouds> {
	int all;
}

class ForecastSys with JsonConvert<ForecastSys> {
	int type;
	int id;
	String country;
	int sunrise;
	int sunset;
}