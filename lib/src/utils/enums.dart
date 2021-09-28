enum enumStatus {
  info,
  progress,
  rpending,
  pending,
  completed,
  rcompleted,
  completedwithnote
}

extension ParseToString on enumStatus {
  String toShortString() {
    if (this == enumStatus.rpending) {
      return "req-pending";
    }
    if (this == enumStatus.rcompleted) {
      return "req-completed";
    }
    if (this == enumStatus.completedwithnote) {
      return "completed-w-note";
    }
    return toString().split('.').last;
  }
}

enum ViewState { idle, busy }
