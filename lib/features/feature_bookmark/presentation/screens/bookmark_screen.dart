import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/features/feature_bookmark/domain/entities/city_entity.dart';
import 'package:weather/features/feature_bookmark/presentation/bloc/bookmark/bookmark_bloc.dart';
import 'package:weather/features/feature_bookmark/presentation/bloc/bookmark/get_all_cities_status.dart';
import 'package:weather/features/feature_weather/presentation/bloc/weather/weather_bloc.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({required this.pageController, Key? key}) : super(key: key);

  static const String routeName = '/bookmark-screen';
  final PageController pageController;

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> with AutomaticKeepAliveClientMixin {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<BookmarkBloc>(context, listen: false).add(GetAllCitiesEvent());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: BlocBuilder<BookmarkBloc, BookmarkState>(
        builder: (context, state) {
          if (state.getAllCitiesStatus is GetAllCitiesLoadingStatus) {
            return Center(
              child: CupertinoActivityIndicator(
                color: context.theme.colorScheme.primary,
                radius: 12,
              ),
            );
          } else if (state.getAllCitiesStatus is GetAllCitiesCompletedStatus) {
            final getAllCitiesCompletedStatus = state.getAllCitiesStatus as GetAllCitiesCompletedStatus;
            final List<CityEntity> cities = getAllCitiesCompletedStatus.cities;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Watch List', style: context.textTheme.headline5,),
                ),
                Expanded(
                  child: cities.isEmpty
                      ? Center(
                          child: Lottie.asset(
                            'assets/lottie/add_to_watchlistcart.json',
                            width: context.width * 0.6,
                            height: context.width * 0.6,
                          ),
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(8),
                          itemCount: cities.length,
                          itemBuilder: (context, index) {
                            return BookmarkItem(city: cities[index], pageController: widget.pageController,);
                          },
                        ),
                ),
              ],
            );
          } else if (state.getAllCitiesStatus is GetAllCitiesErrorStatus) {
            final String errorMessage = (state.getAllCitiesStatus as GetAllCitiesErrorStatus).errorMessage;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/lottie/error.json',
                    width: context.width * 0.3,
                    height: context.width * 0.3,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    errorMessage,
                    style: context.textTheme.bodyText1!.copyWith(
                      color: context.theme.errorColor,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}


class BookmarkItem extends StatelessWidget {
  const BookmarkItem({required this.city, required this.pageController, Key? key}) : super(key: key);

  final CityEntity city;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<WeatherBloc>(context).add(LoadCurrentWeatherEvent(city.name));
        pageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.only(top: 4, bottom: 4, left: 16, right: 8),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.background,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: context.theme.colorScheme.shadow,
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(city.name, style: context.textTheme.headline6!.copyWith(fontWeight: FontWeight.bold),),
            IconButton(
              onPressed: () {
                BlocProvider.of<BookmarkBloc>(context).add(DeleteCityByNameEvent(city.name));
                BlocProvider.of<BookmarkBloc>(context).add(GetAllCitiesEvent());
              },
              icon: Icon(CupertinoIcons.delete, color: context.theme.errorColor,),
            ),
          ],
        ),
      ),
    );
  }
}
