import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

/* Quick and dirty sample code to illustrate how to use navigation in combination of using the bloc pattern */
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GlobalKey _appKey = GlobalKey();
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccessBloc>(
        create: (context) => AccessBloc(navigatorKey)..add(AccessInit(1)),
        child: MaterialApp(
          home: PageComponent()
        ));
  }
}

class PageComponent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PageComponentState();
  }
}

class _PageComponentState extends State<PageComponent> {
  Widget? theBody;

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: BlocProvider.of<AccessBloc>(context),
      child: BlocBuilder(
          bloc: BlocProvider.of<AccessBloc>(context),
          builder: (BuildContext context, accessState) {
            if (accessState is PageState) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Navigation with flutter_bloc'),
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'You have pushed the button this many times:',
                      ),
                      Text(
                        'Page: ' + accessState.pageId.toString(),
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ],
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () => BlocProvider.of<AccessBloc>(context).add(GotoPage(accessState.pageId + 1)),
                  tooltip: 'Next page',
                  child: const Icon(Icons.add),
                ),
              );

            } else {
              return const Text('Not PageState');
            }
          }),
      listener: (BuildContext context, accessState) {
        if (accessState is PageState) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PageComponent()),
          );
        }
      },
    );

  }
}

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

abstract class AccessEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AccessInit extends AccessEvent {
  final int initialPageId;

  AccessInit(this.initialPageId);

  @override
  List<Object?> get props => [ initialPageId ];
}

class GotoPage extends AccessEvent {
  final int pageId;

  GotoPage(this.pageId);

  @override
  List<Object?> get props => [ pageId ];
}

abstract class AccessState extends Equatable {
  const AccessState();

  @override
  List<Object?> get props => [];
}

class UndeterminedState extends AccessState {

}

class PageState extends AccessState {
  final int pageId;

  PageState(this.pageId);

  @override
  List<Object?> get props => [ pageId ];

  @override
  bool operator == (Object other) =>
      identical(this, other) ||
          other is PageState &&
              pageId == other.pageId;
}