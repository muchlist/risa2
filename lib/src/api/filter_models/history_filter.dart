class FilterHistory {
  final String? branch;
  final String? category;
  final int? completeStatus;
  final int? start;
  final int? end;
  final int? limit;

  FilterHistory(
      {this.branch,
      this.category,
      this.completeStatus,
      this.start,
      this.end,
      this.limit});
}
