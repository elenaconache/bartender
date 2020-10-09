import 'package:equatable/equatable.dart';

abstract class LogoutState extends Equatable {}

class LogoutInitial extends LogoutState {
  @override
  List<Object> get props => [];
}

class LogoutLoading extends LogoutState {
  @override
  List<Object> get props => [];
}

class LogoutFinished extends LogoutState {
  @override
  List<Object> get props => [];
}
