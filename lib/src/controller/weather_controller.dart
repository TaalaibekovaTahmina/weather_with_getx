import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:weather_with_getx/src/constands/api_const.dart';
import 'package:weather_with_getx/src/constands/app_colors.dart';
import 'package:weather_with_getx/src/models/weather_model.dart';

class WeatherController extends GetxController {
  Rx<WeatherModel?> weatherModel = Rxn();

  final dio = Dio();

  @override
  void onInit() {
    super.onInit();
    weatherName(cityName: 'Osh');
  }

  Future<void> wetherLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.always &&
          permission == LocationPermission.whileInUse) {
        Position position = await Geolocator.getCurrentPosition();
        final dio = Dio();
        final response = await dio.get(
          ApiConst.getLocator(
            lat: position.latitude,
            lon: position.longitude,
          ),
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          weatherModel.value = WeatherModel(
            id: response.data['current']['weather'][0]['id'],
            main: response.data['current']['weather'][0]['main'],
            description: response.data['current']['weather'][0]['description'],
            icon: response.data['current']['weather'][0]['icon'],
            temp: response.data['current']['temp'],
            country: response.data['timezone'],
            city: response.data['timezone'],
          );
        }
      }
    } else {
      Position position = await Geolocator.getCurrentPosition();
      final dio = Dio();
      final response = await dio.get(
        ApiConst.getLocator(
          lat: position.latitude,
          lon: position.longitude,
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        weatherModel.value = WeatherModel(
          id: response.data['current']['weather'][0]['id'],
          main: response.data['current']['weather'][0]['main'],
          description: response.data['current']['weather'][0]['description'],
          icon: response.data['current']['weather'][0]['icon'],
          temp: response.data['current']['temp'],
          country: response.data['timezone'],
          city: response.data['timezone'],
        );
      }
    }
  }

  Future<void> weatherName({String? cityName}) async {
    final dio = Dio();
    final response = await dio.get(
      ApiConst.api(cityName: cityName),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      weatherModel.value = WeatherModel(
        id: response.data['weather'][0]['id'],
        main: response.data['weather'][0]['main'],
        description: response.data['weather'][0]['description'],
        icon: response.data['weather'][0]['icon'],
        temp: response.data['main']['temp'],
        country: response.data['sys']['country'],
        city: response.data['name'],
      );
    }
  }

  List<String> cities = [
    'Bishkek',
    'Naryn',
    'Ysyk-Kol',
    'Talas',
    'Osh',
    'Jalal-Abad',
    'Batken',
  ];

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.white,
            ),
            color: AppColors.black,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          height: MediaQuery.of(context).size.height * 0.6,
          // color: Colors.amber,
          child: ListView.builder(
            itemCount: cities.length,
            itemBuilder: (context, index) {
              final city = cities[index];
              return Card(
                child: ListTile(
                  onTap: () {
                    weatherName(cityName: city);
                    Navigator.pop(context);
                  },
                  title: Text(city),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
