import 'dart:async';
import 'package:flutter/material.dart';

class BannerCarousel extends StatefulWidget {
  @override
  _BannerCarouselState createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  final List<String> banners = [
    'assets/images/banner1.jpg',
    'assets/images/banner2.jpg',
    'assets/images/banner3.jpg',
  ];
  late PageController _controller;
  int _currentPage = 1; // Start at 1 for infinite loop
  Timer? _timer;
  void _startAutoScrollTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_controller.hasClients) {
        int nextPage = _currentPage + 1;
        _controller.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: _currentPage);
    _startAutoScrollTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // For infinite loop, add first and last banners at the ends
    final List<String> loopedBanners = [
      banners.last,
      ...banners,
      banners.first,
    ];
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification notification) {
                if (notification is ScrollStartNotification ||
                    notification is ScrollUpdateNotification) {
                  _startAutoScrollTimer();
                }
                return false;
              },
              child: PageView.builder(
                controller: _controller,
                itemCount: loopedBanners.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                  // Infinite loop logic with smooth transition
                  if (page == 0) {
                    Future.delayed(Duration(milliseconds: 350), () {
                      if (_controller.hasClients) {
                        _controller.jumpToPage(banners.length);
                      }
                    });
                  } else if (page == loopedBanners.length - 1) {
                    Future.delayed(Duration(milliseconds: 350), () {
                      if (_controller.hasClients) {
                        _controller.jumpToPage(1);
                      }
                    });
                  }
                  _startAutoScrollTimer(); // Reset timer on manual swipe
                },
                itemBuilder: (context, index) {
                  return Image.asset(
                    loopedBanners[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  );
                },
              ),
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(banners.length, (index) {
                  return Container(
                    width: 8,
                    height: 8,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (_currentPage == index + 1)
                          ? Colors.white
                          : Colors.white54,
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
