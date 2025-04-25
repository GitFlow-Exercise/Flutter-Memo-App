import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(routes: routes);

final List<RouteBase> routes = [];
