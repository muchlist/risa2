class FilterHistory {
  FilterHistory(
      {this.branch,
      this.category,
      this.completeStatus,
      this.start,
      this.end,
      this.limit});
  String? branch;
  String? category;
  int? completeStatus;
  int? start;
  int? end;
  int? limit;
}
