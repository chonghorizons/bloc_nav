import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'access_event.dart';
import 'access_state.dart';

class AccessBloc extends Bloc<AccessEvent, AccessState> {
  StreamSubscription? _appSubscription;
  final GlobalKey<NavigatorState> navigatorKey;

  AccessBloc(this.navigatorKey) : super(UndeterminedState());

  @override
  Stream<AccessState> mapEventToState(AccessEvent event) async* {
    if (event is AccessInit) {
      yield PageState(event.initialPageId);
    } else if (event is GotoPage) {
      yield PageState(event.pageId);
    }
  }
}
