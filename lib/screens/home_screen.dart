import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/features/feature_map/presentation/screens/map_screen.dart';
import 'package:weather/features/feature_weather/presentation/screens/weather_screen.dart';
import 'package:weather/core/widgets/bottom_navigation_bar_widget.dart';
import 'package:weather/locator.dart';

import '../features/feature_compass/presentation/screens/compass_screen.dart';
import '../features/feature_weather/presentation/bloc/weather/weather_bloc.dart';
import '../features/feature_bookmark/presentation/screens/bookmark_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String routeName = '/home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // late final PageController _pageController;
  final _pageController = getIt.get<PageController>();

  @override
  void initState() {
    super.initState();
    // _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String cityName = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBarWidget(
        pageController: _pageController,
      ),
      body: SafeArea(
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: (value) {},
          children: [
            WeatherScreen(defaultCityName: cityName.trim().isEmpty ? 'Tehran' : cityName.trim()),
            BookmarkScreen(pageController: _pageController),
            const CompassScreen(),
            const MapScreen(),
          ],
        ),
      ),
    );
  }
}
