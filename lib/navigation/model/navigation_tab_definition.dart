import 'package:rover/common/model/tab_definition.dart';

class NavigationTabDefinition extends TabDefinition {
  final String route;

  const NavigationTabDefinition({super.icon, required super.label, required this.route});
}
