/// enumStatus digunakan pada history
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

/// ViewState digunakan pada berita acara
enum ViewState { idle, busy }

/// enumTypeParty digunakan pada berita acara
enum enumTypeParty { participant, approver }

extension ParsePartyToString on enumTypeParty {
  String toShortString() {
    if (this == enumTypeParty.participant) {
      return "partisipan";
    }
    if (this == enumTypeParty.approver) {
      return "approver";
    }
    return toString().split('.').last;
  }
}
