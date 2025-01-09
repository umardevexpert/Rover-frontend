import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ui_kit/stream/widget/handling_stream_builder.dart';
import 'package:ui_kit/util/shared_type_definitions.dart';

// The reason for not using a [MultiStreamBuilder] super class is that all child MultiStreamBuilders would only have
// one less line (the 'late final combinedStream') and would remain the same.
// The second reason is that in the builder methods, you would need to cast values from List<dynamic> to the generic types
// of each MultiStreamBuilder. This leads to an error, since the first build method is always called with null values,
// so we would have to check null values and somehow convert types.
class MultiStreamBuilder2<T1, T2> extends StatelessWidget {
  final Stream<T1> stream1;
  final Stream<T2> stream2;
  final WidgetBuilder2<T1, T2> builder;
  final WidgetBuilder1<Object>? errorBuilder;
  final WidgetBuilder? waitingForDataWidgetBuilder;
  final (T1, T2)? initialData;

  const MultiStreamBuilder2({
    super.key,
    required this.stream1,
    required this.stream2,
    required this.builder,
    this.initialData,
    this.errorBuilder,
    this.waitingForDataWidgetBuilder,
  });

  @override
  Widget build(BuildContext context) {
    late final combinedStream = Rx.combineLatest2<T1, T2, (T1, T2)>(stream1, stream2, (data1, data2) => (data1, data2));

    return HandlingStreamBuilder<(T1, T2)>(
      initialData: initialData,
      stream: combinedStream,
      builder: (context, tuple) => builder(context, tuple.$1, tuple.$2),
      errorBuilder: errorBuilder,
      waitingForDataWidget: waitingForDataWidgetBuilder?.call(context),
    );
  }
}
