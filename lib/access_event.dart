import 'package:equatable/equatable.dart';

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

