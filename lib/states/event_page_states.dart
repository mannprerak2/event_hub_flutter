//states for managing the EventPage state, used as if-elseif.... in streambuilder in event_page.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class EventPageStates {}

class LoadingPage extends EventPageStates {}

class ErrorPage extends EventPageStates {}

class SucessPage extends EventPageStates {
  DocumentSnapshot snap;
  SucessPage(this.snap);
}
