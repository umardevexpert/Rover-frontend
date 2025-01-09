import 'dart:math';

class Presentation {
  final String status;
  final DateTime date;
  final int percentage;
  final int slidesCount;

  Presentation(this.status, this.date, this.percentage, this.slidesCount);

  Presentation.demo()
      : status = 'Sent',
        date = DateTime.now(),
        percentage = Random().nextInt(100) + 1,
        slidesCount = Random().nextInt(20) + 1;
}
