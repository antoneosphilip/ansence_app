
class ClassStatistics {
  final int classNumber;
  final int capacity;
  final int numberOfAttendants;
  final int numberOfAbsents;

  ClassStatistics({
    required this.classNumber,
    required this.capacity,
    required this.numberOfAttendants,
    required this.numberOfAbsents,
  });

  factory ClassStatistics.fromJson(Map<String, dynamic> json) {
    return ClassStatistics(
      classNumber: json['classNumber'] ?? 0,
      capacity: json['capacity'] ?? 0,
      numberOfAttendants: json['numberOfAttendants'] ?? 0,
      numberOfAbsents: json['numberOfAbsents'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'classNumber': classNumber,
      'capacity': capacity,
      'numberOfAttendants': numberOfAttendants,
      'numberOfAbsents': numberOfAbsents,
    };
  }
}

class ClassStatisticsResponse {
  final List<ClassStatistics> classes;

  ClassStatisticsResponse({required this.classes});

  factory ClassStatisticsResponse.fromJson(List<dynamic> jsonList) {
    final classes = jsonList.map((e) => ClassStatistics.fromJson(e)).toList();
    return ClassStatisticsResponse(classes: classes);
  }
}
