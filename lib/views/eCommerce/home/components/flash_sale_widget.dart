import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_grocery/config/app_color.dart';
import 'package:ready_grocery/config/app_text_style.dart';

class FlashSaleWidget extends StatefulWidget {
  final DateTime endTime;
  const FlashSaleWidget({super.key, required this.endTime});

  @override
  State<FlashSaleWidget> createState() => _FlashSaleWidgetState();
}

class _FlashSaleWidgetState extends State<FlashSaleWidget> {
  late Timer timer;

  int days = 0;
  int hours = 0;
  int minutes = 0;
  int seconds = 0;

  @override
  void initState() {
    super.initState();

    // initial calculation
    _updateTime();

    // Auto update every second
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateTime();
    });
  }

  void _updateTime() {
    final now = DateTime.now();
    final endTime = widget.endTime;
    final remaining = endTime.difference(now);
    if (remaining.isNegative) {
      timer.cancel();
      setState(() {
        days = 0;
        hours = 0;
        minutes = 0;
        seconds = 0;
      });
      return;
    }

    setState(() {
      days = remaining.inDays;
      hours = remaining.inHours.remainder(24);
      minutes = remaining.inMinutes.remainder(60);
      seconds = remaining.inSeconds.remainder(60);
    });
  }

  @override
  void dispose() {
    super.dispose();
    // stop timer
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> timeUnits = [
      {'label': 'Days', 'value': days},
      {'label': 'Hrs', 'value': hours},
      {'label': 'Min', 'value': minutes},
      {'label': 'Sec', 'value': seconds},
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 70.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.r),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/png/flash_deal_bg.png"),
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0.r),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Flash Sale",
                              style: AppTextStyle(context).bodyText.copyWith(
                                    fontSize: 16.sp,
                                    color: EcommerceAppColor.orange,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Gap(8.w),
                            Image.asset(
                              "assets/png/fire.png",
                              width: 16.w,
                            )
                          ],
                        ),
                        Spacer(),
                        Text(
                          "View More",
                          style: AppTextStyle(context).bodyText.copyWith(
                                color: Colors.white,
                                fontSize: 14.sp,
                              ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -20.h,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    timeUnits.length,
                    (index) => CountdownItemWidget(
                      count: timeUnits[index]['value'],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CountdownItemWidget extends StatelessWidget {
  final int count;
  const CountdownItemWidget({
    super.key,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    // make count always 2 digit
    final countAfterPadding = count.toString().padLeft(2, '0');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: EcommerceAppColor.black,
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: Text(
        countAfterPadding,
        style: AppTextStyle(context).bodyText.copyWith(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
