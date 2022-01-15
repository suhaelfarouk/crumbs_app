import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';

import '../constants.dart';

class OnBoardScreen extends StatefulWidget {
  @override
  _OnBoardScreenState createState() => _OnBoardScreenState();
}

final _controller = PageController(
  initialPage: 0,
);

int _currentPage = 0;

List<Widget> _pages = [
  Column(
    children: [
      SizedBox(
        height: 80,
      ),
      // Text(
      //   'Welcome To Crumbs',
      //   style: kPageViewTextStyle,
      // ),
      Expanded(
        child: Image.asset(
          'images/bakery.png',
          scale: 1,
        ),
      ),
    ],
  ),
  Column(
    children: [
      SizedBox(
        height: 80,
      ),
      // Text(
      //   'Order From Comfort',
      //   style: kPageViewTextStyle,
      // ),
      Expanded(
        child: Image.asset(
          'images/food.png',
          scale: 1,
        ),
      ),
    ],
  ),
  // Column(
  //   children: [
  //     SizedBox(
  //       height: 80,
  //     ),
  //     Text(
  //       'DELIVERY ON TIME',
  //       style: kPageViewTextStyle,
  //     ),
  //     Expanded(
  //       child: Image.asset(
  //         'images/deliverbakery.png',
  //         scale: 3,
  //       ),
  //     ),
  //   ],
  // ),
];

class _OnBoardScreenState extends State<OnBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //SizedBox(height: 30),
        Expanded(
          child: PageView(
            physics: BouncingScrollPhysics(parent: ScrollPhysics()),
            controller: _controller,
            children: _pages,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
        ),
        SizedBox(height: 10),
        DotsIndicator(
          dotsCount: _pages.length,
          position: _currentPage.toDouble(),
          decorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(10.0, 10.0),
            activeColor: Theme.of(context).primaryColor,
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
