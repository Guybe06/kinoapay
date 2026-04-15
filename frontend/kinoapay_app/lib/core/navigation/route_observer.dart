import "package:flutter/material.dart";

/// Observer global de navigation, utilisé par [StaggeredEntrance] pour rejouer les animations au retour.
final RouteObserver<ModalRoute<void>> appRouteObserver = RouteObserver<ModalRoute<void>>();
