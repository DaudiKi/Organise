
class Course {
  final String id;
  final String code; // e.g., "CSE101"
  final String title; // e.g., "Intro to Computer Science"
  final String description;
  final String lecturerId;

  Course({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.lecturerId,
  });

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'],
      code: map['code'],
      title: map['title'],
      description: map['description'],
      lecturerId: map['lecturer_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'title': title,
      'description': description,
      'lecturer_id': lecturerId,
    };
  }
}
