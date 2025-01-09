import 'package:flutter/widgets.dart';
import 'package:master_kit/util/shared_type_definitions.dart';

typedef WidgetBuilder1<T> = Projector2<BuildContext, T, Widget>;
typedef WidgetBuilder2<T1, T2> = Projector3<BuildContext, T1, T2, Widget>;
typedef WidgetBuilder3<T1, T2, T3> = Projector4<BuildContext, T1, T2, T3, Widget>;
typedef WidgetBuilder4<T1, T2, T3, T4> = Projector5<BuildContext, T1, T2, T3, T4, Widget>;
typedef IndexedDataWidgetBuilder<T> = Widget Function(BuildContext, T, int index);

typedef CheckboxBuilder<T> = Widget Function(
  BuildContext context,
  T value,
  bool isChecked,
  ValueChanged<bool?>? onChanged,
);
typedef CheckboxGroupBuilder<T> = Widget Function(BuildContext context, List<Widget> checkboxWidgets);
