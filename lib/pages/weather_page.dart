import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:lottie/lottie.dart";
import "package:project_weather/model/weather.dart";
import "package:project_weather/service/weather_service.dart";

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // Api
  final WeatherService _weatherService =
      WeatherService("d80f527e3b16b75f1f23e7723e3c018c");
  Weather? _weather;

  // fetch data
  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();
    if (kDebugMode) {
      print(cityName);
    }
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // animations
  String getWeatherAnimationType(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/clouds.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
      case 'clear sky':
        return 'assets/sunny.json';
      default:
        return 'assets/clearsky.json';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              child: Column(
            children: [
              Icon(
                Icons.location_on,
                color: Colors.grey[500],
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                textAlign: TextAlign.center,
                _weather?.cityName.toUpperCase() ?? "Loading City...",
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Colors.white),
              ),
            ],
          )),
          Text(_weather?.mainCondition ?? "Loading city condition...",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 12,
                  color: Colors.grey[600])),
          // Animation
          Expanded(
              child: Lottie.asset(
                  getWeatherAnimationType(_weather?.mainCondition))),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Text('${_weather?.temperature.round() ?? "0"}°',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 54,
                    color: Colors.grey[500])),
          ),
          SizedBox(
            height: 50,
          ),
        ]),
      ),
    );
  }
}
