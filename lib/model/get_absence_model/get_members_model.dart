class NumbersModel {
  final List<int> numbers;

  NumbersModel({required this.numbers});

  factory NumbersModel.fromJson(List<dynamic> json) {
    return NumbersModel(numbers: json.map((e) => e as int).toList());
  }

  List<dynamic> toJson() => numbers;
}
