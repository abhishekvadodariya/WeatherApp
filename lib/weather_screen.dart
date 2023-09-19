import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_app/additional_info_item.dart';

import 'hourly_forecast_item.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

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
      body: Padding(
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
                    child: const Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text("300°K", style: TextStyle(
                              fontWeight: FontWeight.bold,
                            fontSize: 32,
                            ),
                          ),
                          SizedBox(height: 16),
                          Icon(Icons.cloud,size: 64),
                          SizedBox(height: 16),
                          Text("Rain", style: TextStyle(
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
      ),
    );
  }
}



