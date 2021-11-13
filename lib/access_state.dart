import 'package:equatable/equatable.dart';

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
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PageState &&
              pageId == other.pageId;
}