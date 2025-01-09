import 'package:flutter/material.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:ui_kit/util/assets.dart';

class AuthPageTemplate extends StatelessWidget {
  final Widget body;

  const AuthPageTemplate({
    super.key,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          Expanded(child: body),
          Flexible(
            child: Container(
              width: 1024,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: Assets.pngAssetImage('auth_pages_cover_image'),
                  fit: BoxFit.cover,
                  alignment: Alignment.topLeft,
                ),
              ),
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(left: 74, top: 55),
              child: SizedBox(
                width: 455,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Assets.svgImage('logo'),
                    const SizedBox(height: 79),
                    Text(
                      'Dentistry is our profession, but people are our focus.',
                      style: appTheme?.textTheme.headingHero,
                    ),
                    const SizedBox(height: 17),
                    Text(
                      'Create the best dental experience.',
                      style: appTheme?.textTheme.bodyL.copyWith(color: appTheme.colorScheme.grey700),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
