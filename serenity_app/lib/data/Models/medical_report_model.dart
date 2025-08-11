class MedicalRecordModel {
  final String? id;
  final String? name;
  final bool? deleted;
  final String? description;
  final String? createdAt;
  final String? modifiedAt;
  final String? createdById;
  final String? createdByName;
  final String? modifiedById;
  final String? modifiedByName;
  final String? assignedUserId;
  final String? assignedUserName;
  final String? pMRId;
  final String? pMRName;
  final String? accountId;
  final String? accountName;
  final String? fileId;
  final String? fileName;

  MedicalRecordModel({
    this.id,
    this.name,
    this.deleted,
    this.description,
    this.createdAt,
    this.modifiedAt,
    this.createdById,
    this.createdByName,
    this.modifiedById,
    this.modifiedByName,
    this.assignedUserId,
    this.assignedUserName,
    this.pMRId,
    this.pMRName,
    this.accountId,
    this.accountName,
    this.fileId,
    this.fileName,
  });

  factory MedicalRecordModel.fromJson(Map<String, dynamic> json) {
    return MedicalRecordModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      deleted: json['deleted'] as bool?,
      description: json['description'] as String?,
      createdAt: json['createdAt'] as String?,
      modifiedAt: json['modifiedAt'] as String?,
      createdById: json['createdById'] as String?,
      createdByName: json['createdByName'] as String?,
      modifiedById: json['modifiedById'] as String?,
      modifiedByName: json['modifiedByName'] as String?,
      assignedUserId: json['assignedUserId'] as String?,
      assignedUserName: json['assignedUserName'] as String?,
      pMRId: json['pMRId'] as String?,
      pMRName: json['pMRName'] as String?,
      accountId: json['accountId'] as String?,
      accountName: json['accountName'] as String?,
      fileId: json['fileId'] as String?,
      fileName: json['fileName'] as String?,
    );
  }

  @override
  String toString() {
    return '''
MedicalRecordModel(
  id: $id,
  name: $name,
  deleted: $deleted,
  description: $description,
  createdAt: $createdAt,
  modifiedAt: $modifiedAt,
  createdById: $createdById,
  createdByName: $createdByName,
  modifiedById: $modifiedById,
  modifiedByName: $modifiedByName,
  assignedUserId: $assignedUserId,
  assignedUserName: $assignedUserName,
  pMRId: $pMRId,
  pMRName: $pMRName,
  accountId: $accountId,
  accountName: $accountName,
  fileId: $fileId,
  fileName: $fileName,
)
''';
  }
}
