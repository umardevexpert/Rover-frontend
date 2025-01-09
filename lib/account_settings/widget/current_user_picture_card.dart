import 'package:flutter/material.dart';
import 'package:ui_kit/util/assets.dart';

class CurrentUserCard extends StatelessWidget {
  const CurrentUserCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: 346,
      padding: const EdgeInsets.all(29),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Assets.svgImage('icon/more', width: 24, height: 24),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: 167,
            height: 188,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                CircleAvatar(
                  radius: 83.5,
                ),
                Positioned(
                  bottom: 0,
                  right: 20,
                  child: Container(
                    width: 53,
                    height: 53,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 37),
          Text('Joined 16th March 2023'),
        ],
      ),
    );
  }
}
