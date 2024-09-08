import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/presentations/pages/errors/no_internet_screen.dart';
import 'package:weather_app/presentations/pages/errors/on_error_screen.dart';
import 'package:weather_app/presentations/pages/weather/weather_detail_page.dart';
import 'package:weather_app/presentations/widgets/custom_fluttertoast.dart';
import '../../themes/colors.dart';
import '../../themes/textstyles.dart';
import '../../widgets/custom_button.dart';
import '../../../core/utilities/helper.dart';
import '../../../data/models/response_geocoding.dart';
import '../../../data/models/response_realtime_weather.dart';
import '../../../data/weather_codes.dart';
import '../../../presentations/blocs/weather/weather_bloc.dart';
import '../../../presentations/widgets/list_item_notification.dart';
import '../../../core/configs/asset_const.dart';
import '../../../core/utilities/extensions.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final weatherBloc = WeatherBloc();
  final fToast = FToast();
  Position? position;

  @override
  void initState() {
    super.initState();
    fToast.init(context);
    weatherBloc.add(const FetchRealtimeWeather());
  }

  @override
  void dispose() {
    super.dispose();
    weatherBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primaryLight,
              primary,
            ],
          ),
        ),
        child: BlocProvider(
          create: (context) => weatherBloc,
          child: BlocConsumer<WeatherBloc, WeatherState>(
            builder: (context, state) {
              if (state is WeatherOnLoading) {
                return _buildOnLoading();
              }

              if (state is WeatherFetchError) {
                return OnErrorWidget(message: state.message);
              }

              if (state is WeatherNoInternet) {
                return const NoInternetWidget();
              }

              if (state is WeatherFetchSuccess) {
                return _buildOnLoaded(
                  realtimeWeather: state.realtimeWeather,
                  geocoding: state.geocoding,
                  newNotifList: state.newNotifications,
                  earlyNotifList: state.earlyNotifications,
                );
              }

              return Container();
            },
            listener: (context, state) {
              if (state is WeatherFetchSuccess) {
                setState(() {
                  position = state.position;
                });
              }
              if (state is WeatherFetchError) {
                fToast.showToast(
                  child: CustomFlutterToast(message: state.message),
                  gravity: ToastGravity.TOP,
                  toastDuration: const Duration(milliseconds: 2500),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildOnLoaded({
    required ResponseRealtimeWeather realtimeWeather,
    required ResponseGeocoding geocoding,
    required List<Map<String, dynamic>> newNotifList,
    required List<Map<String, dynamic>> earlyNotifList,
    bool isLoading = false,
  }) {
    return Stack(
      children: [
        Positioned(
          top: 65,
          left: 30,
          right: 30,
          child: _buildHeading(
            "${geocoding.address?.county}",
            newNotifList: newNotifList,
            earlyNotifList: earlyNotifList,
          ),
        ),
        Positioned(
          top: 100,
          right: 30,
          left: 30,
          child: Center(
            child: _buildIconWeather(
              Helper.getWeatherAssetFromCode(
                  "${realtimeWeather.data?.values.weatherCode}"),
            ),
          ),
        ),
        Positioned(
          top: 256,
          right: 30,
          left: 30,
          child: _buildWeatherInfo(realtimeWeather.data!),
        ),
        Positioned(
          bottom: 64,
          left: 80,
          right: 80,
          child: !isLoading
              ? CustomButton(
                  text: "Weather Details",
                  height: 60,
                  backgroundColor: white,
                  textColor: primaryDark,
                  icon: Icons.keyboard_arrow_right_rounded,
                  action: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WeatherDetailPage(
                          position: position!,
                        ),
                      )),
                )
              : const SizedBox.shrink(),
        )
      ],
    );
  }

  Widget _buildHeading(String city,
      {required List<Map<String, dynamic>> newNotifList,
      required List<Map<String, dynamic>> earlyNotifList}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Wrap(
          children: [
            ImageIcon(
              const AssetImage(AssetConst.iconLocation),
              color: white,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              city,
              style: subtitleStyle.copyWith(color: white, fontSize: 16),
            ),
          ],
        ),
        Stack(
          children: [
            GestureDetector(
              onTap: () {
                _showNotifBottomSheet(newNotifList, earlyNotifList);
              },
              child: ImageIcon(
                const AssetImage(AssetConst.iconNotification),
                color: white,
                size: 25,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6), color: errorColor),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildIconWeather(String assetPath) {
    final size = MediaQuery.sizeOf(context);
    return Stack(
      children: [
        Container(
          width: size.width / 3,
          height: size.width / 3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(72),
            boxShadow: [
              BoxShadow(
                color: primaryDark.withOpacity(0.12),
                spreadRadius: 8,
                blurRadius: 16,
                offset: const Offset(2, 6),
              ),
            ],
          ),
        ),
        SvgPicture.asset(
          assetPath,
          width: size.width / 3.2,
        ),
      ],
    );
  }

  Widget _buildWeatherInfo(Data data) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width,
      height: 285,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: white, width: 1),
          boxShadow: [
            BoxShadow(
                color: black.withOpacity(0.12),
                offset: const Offset(3, 8),
                blurRadius: 16)
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Today, ${data.time!.toIndonesiaDateFormat()}',
            style: subtitleStyle.copyWith(color: white),
          ),
          Text(
            '${data.values.temperature.toInt()}°C',
            style: headingStyle.copyWith(
                fontSize: 72,
                fontWeight: FontWeight.w400,
                color: white,
                height: 1.25),
          ),
          Text(
            '${weatherCodes["${data.values.weatherCode}"]}',
            style: subtitleStyle.copyWith(
              color: white,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ImageIcon(
                      const AssetImage(AssetConst.iconWind),
                      color: white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Wind',
                      style: textbodyStyle.copyWith(
                        color: white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  '|',
                  textAlign: TextAlign.center,
                  style: textbodyStyle.copyWith(
                    color: white,
                    fontSize: 16,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  '${data.values.windSpeed.toInt()} km/h',
                  style: textbodyStyle.copyWith(
                    color: white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ImageIcon(
                      const AssetImage(AssetConst.iconHumidity),
                      color: white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Hum',
                      style: textbodyStyle.copyWith(
                        color: white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  '|',
                  textAlign: TextAlign.center,
                  style: textbodyStyle.copyWith(
                    color: white,
                    fontSize: 16,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  '${data.values.humidity.toInt()} %',
                  style: textbodyStyle.copyWith(
                    color: white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showNotifBottomSheet(List<Map<String, dynamic>> newNotifs,
      List<Map<String, dynamic>> earlyNotifs) {
    showModalBottomSheet(
        context: context,
        backgroundColor: white,
        builder: (context) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Your notifications',
                        style: headingStyle.copyWith(color: black),
                      ),
                    ),
                    const SizedBox(height: 16),
                    newNotifs.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              "New",
                              style: textbodyStyle.copyWith(
                                  color: darkGrey,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14),
                            ),
                          )
                        : const SizedBox.shrink(),
                    newNotifs.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: newNotifs.length,
                            itemBuilder: (context, index) =>
                                ListItemNotification(
                                  message: newNotifs[index]['message'],
                                  iconAsset: newNotifs[index]['icon_asset'],
                                  date: newNotifs[index]['date'],
                                  isRead: newNotifs[index]['is_read'],
                                ))
                        : const SizedBox.shrink(),
                    const SizedBox(height: 16),
                    newNotifs.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              "Early",
                              style: textbodyStyle.copyWith(
                                  color: darkGrey,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14),
                            ),
                          )
                        : const SizedBox.shrink(),
                    earlyNotifs.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: earlyNotifs.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) =>
                                ListItemNotification(
                                  message: earlyNotifs[index]['message'],
                                  iconAsset: earlyNotifs[index]['icon_asset'],
                                  date: earlyNotifs[index]['date'],
                                  isRead: earlyNotifs[index]['is_read'],
                                ))
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ));
  }

  Widget _buildOnLoading() {
    final size = MediaQuery.sizeOf(context);

    return Stack(
      children: [
        Positioned(
          top: 256,
          left: 30,
          right: 30,
          child: Container(
            width: size.width,
            height: 285,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
                color: white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: white, width: 1),
                boxShadow: [
                  BoxShadow(
                      color: black.withOpacity(0.12),
                      offset: const Offset(3, 8),
                      blurRadius: 16)
                ]),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: white,
                ),
                const SizedBox(height: 12),
                Text(
                  'Sedang memuat...',
                  style: textbodyStyle.copyWith(color: white),
                ),
              ],
            )),
          ),
        ),
      ],
    );
  }
}
