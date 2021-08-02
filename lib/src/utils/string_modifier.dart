String thumbnailModifier(String path) {
  var splitted = path.split("/");
  splitted.last = "thumb_" + splitted.last;
  return splitted.join("/");
}

extension PathUrl on String {
  String thumbnailMod() {
    var splitted = split("/");
    splitted.last = "thumb_" + splitted.last;
    return splitted.join("/");
  }
}

extension CapExtension on String {
  // Hello world
  String get inCaps =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : '';
  // Hello World
  String get capitalizeFirstofEach => replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.inCaps)
      .join(" ");
}
