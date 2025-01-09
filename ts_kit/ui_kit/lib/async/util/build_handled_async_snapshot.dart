import 'package:flutter/material.dart';
import 'package:master_kit/util/print_util.dart';
import 'package:ui_kit/util/shared_type_definitions.dart';

@protected
Widget buildHandledAsyncSnapshotNullUnsafe<T>({
  required BuildContext context,
  required AsyncSnapshot<T> snapshot,
  T? initialData,
  Widget? waitingForDataWidget,
  required WidgetBuilder1<T> builder,
  WidgetBuilder1<Object>? errorBuilder,
}) {
  if (snapshot.hasError) {
    final error = snapshot.error ?? StateError('snapshot.hasError was true but snapshot.error is null');
    errorPrint(error);
    if (errorBuilder != null) {
      return errorBuilder(context, error);
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SelectableText('The following error occurred:\n${snapshot.error}'),
      ),
    );
  }

  if (!snapshot.hasData) {
    return waitingForDataWidget ?? const Center(child: CircularProgressIndicator());
  }
  // ignore: null_check_on_nullable_type_parameter
  return builder(context, snapshot.data!);
}
