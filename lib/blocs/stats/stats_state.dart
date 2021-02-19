import 'package:equatable/equatable.dart';

abstract class StatsState extends Equatable {}

class StatsInitial extends StatsState {
  @override
  List<Object> get props => [];
}

class StatsLoading extends StatsState {
  @override
  List<Object> get props => [];
}

class StatsSuccess extends StatsState {
  final Map<String, double> ingredientPercent;

  @override
  List<Object> get props => [ingredientPercent];

  StatsSuccess(this.ingredientPercent);
}

class StatsError extends StatsState {
  @override
  List<Object> get props => [];

  StatsError();
}
