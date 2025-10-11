class MissingClasses {
  final Map<String, bool> items;

  MissingClasses({required this.items});

  factory MissingClasses.fromJson(Map<String, dynamic> json) {
    // نحول كل القيم إلى bool بشكل آمن
    return MissingClasses(
      items: json.map((key, value) => MapEntry(key, value as bool)),
    );
  }

  Map<String, dynamic> toJson() {
    return items;
  }
}
