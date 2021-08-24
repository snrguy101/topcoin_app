import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String messsage;
  const Failure({this.messsage = ""});

  @override
  // TODO: implement props
  List<Object?> get props => [messsage];
}
