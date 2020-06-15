extension StringCheck on String {
  bool isUrl() {
    return RegExp("(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]")
        .hasMatch(this);
  }
}
