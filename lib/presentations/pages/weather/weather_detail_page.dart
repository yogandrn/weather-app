import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/core/configs/asset_const.dart';
import 'package:weather_app/data/models/response_forecast_weather.dart';
import 'package:weather_app/presentations/blocs/weather/weather_bloc.dart';
import 'package:weather_app/presentations/pages/errors/no_internet_screen.dart';
import 'package:weather_app/presentations/pages/errors/on_error_screen.dart';
import 'package:weather_app/presentations/themes/colors.dart';
import 'package:weather_app/presentations/themes/textstyles.dart';
import 'package:weather_app/presentations/widgets/custom_fluttertoast.dart';
import 'package:weather_app/presentations/widgets/list_item_daily_weather.dart';
import 'package:weather_app/presentations/widgets/list_item_forecast_weather.dart';

class WeatherDetailPage extends StatefulWidget {
  final Position position;
  const WeatherDetailPage({super.key, required this.position});

  @override
  State<WeatherDetailPage> createState() => _WeatherDetailPageState();
}

class _WeatherDetailPageState extends State<WeatherDetailPage> {
  final weatherBloc = WeatherBloc();
  final fToast = FToast();

  @override
  void initState() {
    super.initState();
    fToast.init(context);
    weatherBloc.add(FetchDetailWeather(position: widget.position));
  }

  @override
  void dispose() {
    super.dispose();
    weatherBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => weatherBloc,
      child: Scaffold(
        body: Container(
          height: double.maxFinite,
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
          child: BlocConsumer<WeatherBloc, WeatherState>(
            builder: (context, state) {
              if (state is WeatherOnLoading) {
                return _buildOnLoading();
              }

              if (state is WeatherForecastSuccess) {
                return _buildPageBody(
                  todayWeathers: state.todayForecast.data!.timelines.intervals,
                  forecastWeathers:
                      state.dailyForecast.data!.timelines.intervals,
                );
              }

              if (state is WeatherFetchError) {
                return OnErrorWidget(message: state.message);
              }

              if (state is WeatherNoInternet) {
                return const NoInternetWidget();
              }

              return Container();
            },
            listener: (context, state) {
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

  Widget _buildPageBody(
      {required List<WeatherInterval> todayWeathers,
      required List<WeatherInterval> forecastWeathers}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Row(
            children: [
              _buildBackButton(),
            ],
          ),
          const SizedBox(height: 32),
          _buildTodayWeather(todayWeathers),
          const SizedBox(height: 32),
          _buildForecastWeather(forecastWeathers),
        ],
      ),
    );
  }

  Widget _buildTodayWeather(List<WeatherInterval> weathers) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Today",
              style: titleStyle.copyWith(
                color: white,
              ),
            ),
            Text(
              DateFormat('dd MMM yyyy').format(
                DateTime.now(),
              ),
              style: subtitleStyle.copyWith(color: white, fontSize: 15),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: 128,
          child: Row(
            children: weathers
                .map((weather) => Expanded(
                        child: ListItemDailyWeather(
                      weather: weather,
                      isCurrent: weather.startTime == weathers[2].startTime,
                    )))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildForecastWeather(List<WeatherInterval> weathers) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Next Forecasts",
              style: titleStyle.copyWith(
                color: white,
              ),
            ),
            ImageIcon(
              const AssetImage(AssetConst.iconCalendar),
              size: 24,
              color: white,
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: weathers.length,
          itemBuilder: (context, index) => ListItemForecastWeather(
            weather: weathers[index],
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.keyboard_arrow_left_rounded,
            size: 28,
            color: white,
          ),
          Text(
            'Back',
            style: textButtonStyle.copyWith(
                color: white, fontWeight: FontWeight.w700, fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildOnLoading() {
    return Column(
      children: [
        const SizedBox(height: 40),
        Row(
          children: [
            const SizedBox(width: 30),
            _buildBackButton(),
          ],
        ),
        Expanded(
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
            ),
          ),
        ),
      ],
    );
  }
}
