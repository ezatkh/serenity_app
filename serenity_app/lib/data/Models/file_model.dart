class MedicalFolderModel {
  final String? id;
  final String? name;

  MedicalFolderModel({
    this.id,
    this.name,
  });

  factory MedicalFolderModel.fromJson(Map<String, dynamic> json) {
    return MedicalFolderModel(
      id: json['id'],
      name: json['name'],
    );
  }

  @override
  String toString() {
    return '''
MedicalFolderModel(
  id: $id,
  name: $name,
)
''';
  }
}
