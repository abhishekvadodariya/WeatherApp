import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App",style: TextStyle(
          fontWeight: FontWeight.bold,
        ),),
        centerTitle: true,
        actions:  [
          IconButton(onPressed: (){},
              icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body:
      FutureBuilder(
        future: getCurrentWeather(),
        builder:(context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()));
          }
          final data = snapshot.data!;
          final currentTemp = data['list'][0]['main']['temp'];


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
                            const Icon(Icons.cloud,size: 64),
                            const SizedBox(height: 16),
                            const Text("Rain", style: TextStyle(
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
              const Text("Weather Forecast", style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 8),
              const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    HourlyForecastItem(
                      time: "00:00",
                      temperature: "301.22",
                      icon: Icons.cloud,
                    ),
                    HourlyForecastItem(
                      time: "03:00",
                      temperature: "300.52",
                      icon: Icons.sunny,
                    ),
                    HourlyForecastItem(
                      time: "06:00",
                      temperature: "302.22",
                      icon: Icons.cloud,
                    ),
                    HourlyForecastItem(
                      time: "09:00",
                      temperature: "300.12",
                      icon: Icons.sunny,
                    ),
                    HourlyForecastItem(
                      time: "12:00",
                      temperature: "304.12",
                      icon: Icons.cloud,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text("Additional Information", style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                 AdditionalInfoItem(
                   icon: Icons.water_drop,
                   label: "Humidity",
                   value: "91",
                 ),
                 AdditionalInfoItem(
                   icon: Icons.air,
                   label: "Wind Speed",
                   value: "7.5",
                 ),
                 AdditionalInfoItem(
                   icon: Icons.beach_access,
                   label: "Pressure",
                   value: "1000",
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



