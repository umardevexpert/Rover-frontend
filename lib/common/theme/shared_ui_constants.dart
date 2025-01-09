import 'package:flutter/material.dart';

/// 40.0
const LARGER_UI_GAP = 40.0;

/// 32.0
const LARGE_UI_GAP = 32.0;

/// 24.0
const STANDARD_UI_GAP = 24.0;

/// 16.0
const SMALL_UI_GAP = 16.0;

/// 8.0
const SMALLER_UI_GAP = 8.0;

/// 40.0
const LARGER_GAP = SizedBox(
  height: LARGER_UI_GAP,
  width: LARGER_UI_GAP,
);

/// 32.0
const LARGE_GAP = SizedBox(
  height: LARGE_UI_GAP,
  width: LARGE_UI_GAP,
);

/// 24.0
const STANDARD_GAP = SizedBox(
  height: STANDARD_UI_GAP,
  width: STANDARD_UI_GAP,
);

/// 16.0
const SMALL_GAP = SizedBox(
  height: SMALL_UI_GAP,
  width: SMALL_UI_GAP,
);

/// 8.0
const SMALLER_GAP = SizedBox(
  height: SMALLER_UI_GAP,
  width: SMALLER_UI_GAP,
);

/// 8.0
const STANDARD_CORNER_RADIUS = Radius.circular(8.0);

/// 6.0
const SMALL_CORNER_RADIUS = Radius.circular(6.0);

/// 4.0
const SMALLER_CORNER_RADIUS = Radius.circular(4.0);

/// 8.0
const STANDARD_BORDER_RADIUS = BorderRadius.all(STANDARD_CORNER_RADIUS);

/// 6.0
const SMALL_BORDER_RADIUS = BorderRadius.all(SMALL_CORNER_RADIUS);

/// 4.0
const SMALLER_BORDER_RADIUS = BorderRadius.all(SMALLER_CORNER_RADIUS);

/// 72.0
const PAGE_HORIZONTAL_PADDING_SIZE = 72.0;

/// 72.0
const PAGE_HORIZONTAL_PADDING = EdgeInsets.symmetric(horizontal: PAGE_HORIZONTAL_PADDING_SIZE);

/// 75.0
const NAVIGATION_BAR_HEIGHT = 75.0;

/// 48.0
const STANDARD_INPUT_HEIGHT = 48.0;

/// 250
const PAGE_CROSS_FADE_ANIMATION_DURATION = 250;

/// 8:55 AM
const TIME_FORMAT = 'h:mm a';

/// 10/21/2023
const SHORT_DATE = 'MM/dd/yyyy';

/// Wed, 10/21/2023
const SHORT_DATE_WITH_DAY = 'E, $SHORT_DATE';

/// Oct 21 2023
const MEDIUM_DATE = 'MMM dd yyyy';

/// Tue, Oct 21 2023
const MEDIUM_DATE_WITH_DAY = 'E, $MEDIUM_DATE';

/// Tuesday, October 21 2023
const LONG_DATE = 'EEEE, MMMM dd yyyy';
