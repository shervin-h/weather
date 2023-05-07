import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/core/widgets/loading_widget.dart';
import 'package:weather/features/feature_weather/domain/use_cases/get_last_city_from_db.dart';
import 'package:weather/features/feature_weather/presentation/bloc/splash/splash_bloc.dart';
import 'package:weather/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const String routeName = '/splash-screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animationController.repeat(min: 0, max: 1, reverse: true);

    BlocProvider.of<SplashBloc>(context, listen: false).add(SplashStartedEvent());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.center,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, widget) {
                  return Text(
                    'Weather',
                    style: context.textTheme.headline1!.copyWith(
                      shadows: [
                        Shadow(
                          color: context.theme.colorScheme.primary.withOpacity(
                            _animationController.value,
                          ),
                          blurRadius: 56,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            SizedBox(
              width: context.width * 0.5,
              height: context.width * 0.5,
              child: Lottie.asset('assets/lottie/weather.json'),
            ),

            Expanded(
              child: BlocBuilder<SplashBloc, SplashState>(
                builder: (context, state) {
                  if (state is SplashLoadingState) {
                    return const LoadingWidget();
                  } else if (state is SplashCompletedState) {
                    Future.delayed(
                      const Duration(seconds: 2),
                      () async {
                        await GetLastCityFromDbUseCase()().then((String cityName) {
                          Navigator.of(context).pushReplacementNamed(
                            HomeScreen.routeName,
                            arguments: cityName,
                          );
                        });
                      },
                    );
                    return Container();
                  } else if (state is SplashErrorState) {
                    final errorMessage = state.errorMessage;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          errorMessage,
                          style: context.textTheme.bodyText1!.copyWith(
                            color: context.theme.errorColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<SplashBloc>(context).add(SplashStartedEvent());
                          },
                          child: Icon(CupertinoIcons.refresh, size: context.isTablet ? 32 : 24),
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),

            AnimatedBuilder(
              animation: _animationController,
              builder: (context, widget) {
                return Container(
                  margin: const EdgeInsets.all(24),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.background,
                    border: Border.all(
                      color: context.theme.colorScheme.secondary.withOpacity(_animationController.value),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: context.theme.colorScheme.secondary.withOpacity(_animationController.value),
                    //     blurRadius: 16,
                    //   ),
                    // ],
                  ),
                  child: Text(
                    'by Shervin Hassanzadeh',
                    style: context.textTheme.bodyText2!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.theme.colorScheme.secondary.withOpacity(_animationController.value)
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
