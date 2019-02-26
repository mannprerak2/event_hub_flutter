// states for managing the main screen state, used as if-elseif....
// in streambuilder in main_screen.dart

class MainState {}

class TabState extends MainState {
  int tabIndex;
  bool animate;
  TabState(this.tabIndex, this.animate);
}
