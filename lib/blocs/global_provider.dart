import 'package:events_flutter/blocs/global_bloc.dart';
import 'package:flutter/widgets.dart';

//this is a wrapper around bloc, to be used as the parent
//so that it can be accessed anywhere (using of method) down the tree like a scoped model...

class GlobalProvider extends InheritedWidget {
  final GlobalBloc globalBloc;

  GlobalProvider({
    Key? key,
    required this.globalBloc,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static GlobalBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GlobalProvider>()!
        .globalBloc;
  }
}
