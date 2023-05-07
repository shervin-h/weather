import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({required this.pageController, Key? key}) : super(key: key);

  final PageController pageController;

  @override
  State<BottomNavigationBarWidget> createState() => _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    widget.pageController.addListener(() {
      if (widget.pageController.page != null) {
        setState(() {
          _currentPage = widget.pageController.page!.round();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentPage,
      selectedItemColor: context.theme.colorScheme.secondary,
      unselectedItemColor: Colors.white,
      items:  [
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {
              widget.pageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
              setState(() {_currentPage = 0;});
            },
            icon: const Icon(CupertinoIcons.home),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {
              widget.pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
              setState(() {_currentPage = 1;});
            },
            icon: const Icon(CupertinoIcons.bookmark),
          ),
          label: 'Bookmark',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {
              widget.pageController.animateToPage(2, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
              setState(() {_currentPage = 1;});
            },
            icon: const Icon(CupertinoIcons.compass),
          ),
          label: 'Compass',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {
              widget.pageController.animateToPage(3, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
              setState(() {_currentPage = 1;});
            },
            icon: const Icon(CupertinoIcons.map),
          ),
          label: 'Map',
        ),
      ],
    );
  }
}
