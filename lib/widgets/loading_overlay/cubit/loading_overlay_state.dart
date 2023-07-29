import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class LoadingOverlayState extends Equatable {}

class Loading extends LoadingOverlayState {
  @override
  List<Object?> get props => [];
}

class Waiting extends LoadingOverlayState {
  @override
  List<Object?> get props => [];
}