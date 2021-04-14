enum enumStatus { info, progress, rpending, pending, completed }

extension ParseToString on enumStatus {
  String toShortString() {
    return toString().split('.').last;
  }
}

enum ViewState { idle, busy }
