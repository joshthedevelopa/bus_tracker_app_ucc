extension StringExtension on String {
  String capitalize() {
    if (length > 1) {
      return "${this[0].toUpperCase()}${substring(1)}";
    }

    return "";
  }

  String sentenceCase() {
    List<String> _value = [];
    for (String word in split(" ")) {
      _value.add(word.capitalize());
    }

    return _value.join(" ");
  }
}
