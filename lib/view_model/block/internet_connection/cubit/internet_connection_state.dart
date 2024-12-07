part of 'internet_connection_cubit.dart';

abstract class InternetConnectionState {}

class InternetConnectionInitial extends InternetConnectionState {}
class ConnectedState extends InternetConnectionState {
}
class NotConnectedState extends InternetConnectionState {
  final String message;
  NotConnectedState({required this.message});
}