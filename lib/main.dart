
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/config/app_theme.dart';
import 'package:weather/core/utils/date_time_helper.dart';
import 'package:weather/features/feature_bookmark/presentation/bloc/bookmark/bookmark_bloc.dart';
import 'package:weather/features/feature_compass/presentation/screens/compass_screen.dart';
import 'package:weather/features/feature_map/presentation/bloc/map_bloc.dart';
import 'package:weather/features/feature_map/presentation/screens/map_screen.dart';
import 'package:weather/features/feature_weather/presentation/bloc/splash/splash_bloc.dart';
import 'package:weather/features/feature_bookmark/presentation/screens/bookmark_screen.dart';
import 'package:weather/features/feature_weather/presentation/screens/forecast_screen.dart';
import 'package:weather/screens/home_screen.dart';
import 'package:weather/screens/splash_screen.dart';
import 'package:weather/locator.dart';

import 'features/feature_weather/presentation/bloc/weather/weather_bloc.dart';
import 'features/feature_weather/presentation/screens/weather_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );

  await setup();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<WeatherBloc>()),
        BlocProvider(create: (context) => getIt<SplashBloc>()),
        BlocProvider(create: (context) => getIt.get<BookmarkBloc>()),
        BlocProvider(create: (context) => getIt.get<MapBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = true;
    // if (timeOfDay().toLowerCase().contains('evening') ||
    //     timeOfDay().toLowerCase().contains('night')) {
    //   isDark = true;
    // } else {
    //   isDark = false;
    // }
    return MaterialApp(
      title: 'Flutter Weather',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightThemeData,
      darkTheme: AppTheme.darkThemeData,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: const SplashScreen(),
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        WeatherScreen.routeName: (context) => const WeatherScreen(),
        ForecastScreen.routeName: (context) => const ForecastScreen(),
        BookmarkScreen.routeName: (context) => BookmarkScreen(pageController: getIt.get<PageController>(),),
        SplashScreen.routeName: (context) => const SplashScreen(),
        CompassScreen.routeName: (context) => const CompassScreen(),
        MapScreen.routeName: (context) => const MapScreen(),
      },
    );
  }
}
