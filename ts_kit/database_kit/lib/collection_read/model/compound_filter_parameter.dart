part of 'package:database_kit/collection_read/model/abstract_filter_parameter.dart';

enum CompoundFilterType { and, or }

class CompoundFilterParameter extends AbstractFilterParameter {
  final Iterable<AbstractFilterParameter> operands;
  final CompoundFilterType type;

  const CompoundFilterParameter({required this.operands, required this.type});

  const CompoundFilterParameter.or({required this.operands}) : type = CompoundFilterType.or;
  const CompoundFilterParameter.and({required this.operands}) : type = CompoundFilterType.and;
}
