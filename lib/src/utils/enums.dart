enum enumStatus { info, progress, rpending, pending, complete }

extension ParseToString on enumStatus {
  String toShortString() {
    return toString().split('.').last;
  }
}
