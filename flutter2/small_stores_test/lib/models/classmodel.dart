class ClassModel {
  final int id;
  final String class_name;

  ClassModel({
    required this.id,
    required this.class_name,
  });

  // Factory method to convert JSON to Product object
  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'],
      class_name: json['class_name'],
    );
  }
}
