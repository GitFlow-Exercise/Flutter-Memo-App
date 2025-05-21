import 'package:flutter/material.dart';

class EventKeyState {
  // snackbar를 띄우기 위한 전역적으로 관리하는 scaffoldKey
  final GlobalKey<ScaffoldMessengerState> scaffoldKey;
  // dialog/navigate에 사용되는 전역적으로 관리하는 navigateKey
  final GlobalKey<NavigatorState> navigateKey;
  const EventKeyState({required this.scaffoldKey, required this.navigateKey});
}
