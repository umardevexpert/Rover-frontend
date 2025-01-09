import 'package:flutter/material.dart';
import 'package:master_kit/sdk_extension/object_extension.dart';
import 'package:master_kit/util/reference_wrapper.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ui_kit/async/util/build_handled_async_snapshot.dart';
import 'package:ui_kit/util/shared_type_definitions.dart';

class HandlingStreamBuilder<T> extends StatelessWidget {
  final Stream<T>? stream;
  final WidgetBuilder1<T> builder;
  final WidgetBuilder1<Object>? errorBuilder;
  final T? initialData;
  final Widget? waitingForDataWidget;
  final bool ignoreNullInitialData;

  const HandlingStreamBuilder({
    super.key,
    required this.stream,
    required this.builder,
    this.initialData,
    this.waitingForDataWidget,
    this.ignoreNullInitialData = true,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_declarations
    final isTNullable = null is T;
    final maybeValueStream = stream?.maybeCast<ValueStream<T>>();
    final initialDataOrStreamValue = initialData ?? ((maybeValueStream?.hasValue ?? false) ? maybeValueStream?.value : null);
    if (isTNullable) {
      return _buildHandlingNullUnsafeStream<ReferenceWrapper<T?>>(
        stream: stream?.map(ReferenceWrapper.new),
        builder: (context, lastWrappedValue) => builder(context, lastWrappedValue.wrapped as T),
        errorBuilder: errorBuilder,
        initialData: !ignoreNullInitialData || initialDataOrStreamValue != null
            ? ReferenceWrapper(initialDataOrStreamValue)
            : null,
        waitingForDataWidget: waitingForDataWidget,
      );
    }
    return _buildHandlingNullUnsafeStream(
      stream: stream,
      builder: builder,
      errorBuilder: errorBuilder,
      initialData: initialDataOrStreamValue,
      waitingForDataWidget: waitingForDataWidget,
    );
  }
}

Widget _buildHandlingNullUnsafeStream<T>(
    {Stream<T>? stream,
    required WidgetBuilder1<T> builder,
    WidgetBuilder1<Object>? errorBuilder,
    T? initialData,
    Widget? waitingForDataWidget}) {
  return StreamBuilder<T>(
    stream: stream,
    initialData: initialData,
    builder: (context, snapshot) => buildHandledAsyncSnapshotNullUnsafe(
      context: context,
      builder: builder,
      errorBuilder: errorBuilder,
      snapshot: snapshot,
      waitingForDataWidget: waitingForDataWidget,
    ),
  );
}
