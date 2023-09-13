import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_with_getx/src/components/custom_icon_button.dart';
import 'package:weather_with_getx/src/constands/api_const.dart';
import 'package:weather_with_getx/src/constands/app_colors.dart';
import 'package:weather_with_getx/src/constands/app_text.dart';
import 'package:weather_with_getx/src/controller/weather_controller.dart';
import '../constands/app_text_styles.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final ctl = Get.put(WeatherController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.white,
        title: const Text(AppText.appBar, style: AppTextStyles.appBar),
      ),
      body: ctl.weatherModel.value == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/surot.jpg'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomIconsButton(
                        onPressed: () async {
                          ctl.wetherLocation();
                        },
                        icon: Icons.near_me,
                      ),
                      CustomIconsButton(
                        onPressed: () {
                          ctl.showBottomSheet(context);
                        },
                        icon: Icons.location_city,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    flex: 2,
                    child: Obx(() {
                      return Row(
                        children: [
                          const SizedBox(width: 12),
                          Text(
                            '${temp(ctl.weatherModel.value!.temp)}',
                            style: const TextStyle(
                              fontSize: 96,
                              color: Colors.amber,
                            ),
                          ),
                          Image.network(
                            ApiConst.getIcon(ctl.weatherModel.value!.icon, 4),
                          ),
                        ],
                      );
                    }),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Obx(() {
                          return Text(
                            ctl.weatherModel.value!.description.replaceAll(
                              ' ',
                              '\n',
                            ),
                            style: const TextStyle(
                              fontSize: 60,
                              color: Colors.amber,
                            ),
                          );
                        }),
                        const SizedBox(width: 40),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: FittedBox(
                          child: Obx(() {
                            return Text(
                              ctl.weatherModel.value!.city!,
                              style: const TextStyle(
                                fontSize: 65,
                                color: Colors.amber,
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  int temp(double? temp) {
    return (temp! - 273.15).toInt();
  }
}
