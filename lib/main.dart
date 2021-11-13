import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'access_bloc.dart';
import 'access_event.dart';
import 'access_state.dart';

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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var initialRoute = '1';

    return BlocProvider<AccessBloc>(
        create: (context) => AccessBloc(navigatorKey)..add(AccessInit(1)),
        child: MaterialApp(
          key: _appKey,
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          scaffoldMessengerKey: rootScaffoldMessengerKey,
          initialRoute: initialRoute,
          onGenerateRoute: generateRoute,
          title: 'No title',
        ));
  }
}

class Arguments {
  final String? mainArgument;
  final Map<String, dynamic>? parameters;

  Arguments(this.mainArgument, this.parameters);
}

Route<dynamic> generateRoute(RouteSettings settings) {
  var settingsUri = Uri.parse(settings.name!);
  var path = settingsUri.path;
  return getRoute(path);
}

Route<dynamic> getRoute(String path/*, Map<String, dynamic>? parameters*/) {
  return pageRouteBuilderWithAppId(path, page());
}

Widget page() => PageComponent();

PageRouteBuilder pageRouteBuilderWithAppId(String pageId, Widget page) {
  return FadeRoute(
      name: pageId,
      page: page,
      milliseconds: 1000);
}

class FadeRoute extends PageRouteBuilder {
  final Widget? page;
  final int milliseconds;

  FadeRoute(
      {String? name,
      Map<String, dynamic>? parameters,
      this.page,
      required this.milliseconds})
      : super(
          settings: RouteSettings(name: name, arguments: parameters),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page!,
          transitionDuration: Duration(milliseconds: milliseconds),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}


class PageComponent extends StatefulWidget {
  final GlobalKey _pageKey = GlobalKey();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();

  PageComponent();

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
                  title: Text('Navigation with flutter_bloc'),
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
                ), // This trailing comma makes auto-formatting nicer for build methods.
              );

            } else {
              return Text("Not PageState");
            }
          }),
      listener: (BuildContext context, accessState) {
        if (accessState is PageState) {
          unawaited(Navigator.of(context).pushNamed(
            accessState.pageId.toString(),
            //arguments: Arguments(accessState.pageId,)));
          ));
        }
      },
    );

  }
}
