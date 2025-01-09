import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ui_kit/stream/widget/handling_stream_builder.dart';
import 'package:ui_kit/util/shared_type_definitions.dart';

class MultiStreamBuilder3<T1, T2, T3> extends StatelessWidget {
  final Stream<T1> stream1;
  final Stream<T2> stream2;
  final Stream<T3> stream3;
  final WidgetBuilder3<T1, T2, T3> builder;
  final WidgetBuilder1<Object>? errorBuilder;
  final WidgetBuilder? waitingForDataWidgetBuilder;
  final (T1, T2, T3)? initialData;

  const MultiStreamBuilder3({
    super.key,
    required this.stream1,
    required this.stream2,
    required this.stream3,
    required this.builder,
    this.initialData,
    this.errorBuilder,
    this.waitingForDataWidgetBuilder,
  });

  @override
  Widget build(BuildContext context) {
    late final combinedStream = Rx.combineLatest3<T1, T2, T3, (T1, T2, T3)>(
      stream1,
      stream2,
      stream3,
      (data1, data2, data3) => (data1, data2, data3),
    );

    return HandlingStreamBuilder<(T1, T2, T3)>(
      initialData: initialData,
      stream: combinedStream,
      builder: (context, tuple) => builder(context, tuple.$1, tuple.$2, tuple.$3),
      errorBuilder: errorBuilder,
      waitingForDataWidget: waitingForDataWidgetBuilder?.call(context),
    );
  }
}
