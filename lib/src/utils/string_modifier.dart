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
