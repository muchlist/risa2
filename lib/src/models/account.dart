class Account {
  final String userID;
  final String name;
  final String branch;
  final String avatarUrl;
  final int expired;
  final List<String> roles;
  final String token;

  Account(
      {required this.userID,
      required this.name,
      required this.branch,
      required this.avatarUrl,
      required this.expired,
      required this.roles,
      required this.token});
}
