import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_info_item.dart';
import 'package:http/http.dart' as http;
import 'hourly_forecast_item.dart';
import 'key.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}
class _WeatherScreenState extends State<WeatherScreen> {
late Future<Map<String,dynamic>> weather;
  Future<Map<String,dynamic>> getCurrentWeather() async {
    try{
          String cityName = "London";
          final res = await
          http.get(Uri.parse('http://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey'));
          final data = jsonDecode(res.body);
          if(data['cod'] != '200'){
              throw 'Somethings Went wrong';
          }
          return data;
    }catch(e){
        throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App",style: TextStyle(
          fontWeight: FontWeight.bold,
        ),),
        centerTitle: true,
        actions:  [
          IconButton(onPressed: (){
            setState(() {
              weather = getCurrentWeather();
            });
          },
              icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body:
      FutureBuilder(
        future: weather,
        builder:(context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()));
          }
          final data = snapshot.data!;
          final weatherData = data['list'][0];
          final currentTemp = weatherData['main']['temp'];
          final currentSky = weatherData['weather'][0]['main'];
          final currentPressure = weatherData['main']['pressure'];
          final currentHumidity = weatherData['main']['humidity'];
          final currentWindSpeed = weatherData['wind']['speed'];


          return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox( width: double.infinity,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text("$currentTemp K", style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              fontSize: 32,
                              ),
                            ),
                            const SizedBox(height: 16),
                            currentSky == 'Clouds' || currentSky == 'Rain'
                                ?Icon(Icons.cloud,size: 64)
                                :Icon(Icons.sunny,size: 64),
                            const SizedBox(height: 16),
                            Text(currentSky, style: TextStyle(
                              fontSize: 20,
                            ),)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Hourly Forecast", style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  itemCount: 5,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context,index){
                    final hourlyForecast = data['list'][index+1];
                    final hourlySky = data['list'][index+1]['weather'][0]['main'];
                    final hourlyTemp = hourlyForecast['main']['temp'].toString();
                    final time = DateTime.parse(hourlyForecast['dt_txt']);
                    return HourlyForecastItem(
                        time: DateFormat.j().format(time),
                        temperature: hourlyTemp,
                        icon: hourlySky == 'Clouds' || hourlySky == 'Rain'? Icons.cloud:Icons.sunny);
                  },
                ),
              ),

              const SizedBox(height: 20),
              const Text("Additional Information", style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                 AdditionalInfoItem(
                   icon: Icons.water_drop,
                   label: "Humidity",
                   value: currentHumidity.toString(),
                 ),
                 AdditionalInfoItem(
                   icon: Icons.air,
                   label: "Wind Speed",
                   value: currentWindSpeed.toString(),
                 ),
                 AdditionalInfoItem(
                   icon: Icons.beach_access,
                   label: "Pressure",
                   value: currentPressure.toString(),
                 ),
                ],
              ),
            ],
          ),
        );
        },
      ),
    );
  }
}



