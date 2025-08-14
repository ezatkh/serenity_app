class AppointmentModel {
  final String? id;
  final String? name;
  final bool? deleted;
  final String? status;
  final String? dateStart;
  final String? dateEnd;
  final bool? isAllDay;
  final String? duration;
  final String? description;
  final String? createdAt;
  final String? modifiedAt;
  final String? dateStartDate;
  final String? dateEndDate;
  final String? parentId;
  final String? parentType;
  final String? parentName;
  final String? accountId;
  final String? accountName;
  final String? createdById;
  final String? createdByName;
  final String? modifiedById;
  final String? modifiedByName;
  final String? assignedUserId;
  final String? assignedUserName;

  AppointmentModel({
    this.id,
    this.name,
    this.deleted,
    this.status,
    this.dateStart,
    this.dateEnd,
    this.isAllDay,
    this.duration,
    this.description,
    this.createdAt,
    this.modifiedAt,
    this.dateStartDate,
    this.dateEndDate,
    this.parentId,
    this.parentType,
    this.parentName,
    this.accountId,
    this.accountName,
    this.createdById,
    this.createdByName,
    this.modifiedById,
    this.modifiedByName,
    this.assignedUserId,
    this.assignedUserName,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      deleted: json['deleted'] as bool?,
      status: json['status'] as String?,
      dateStart: json['dateStart']?.toString(),
      dateEnd: json['dateEnd']?.toString(),
      isAllDay: json['isAllDay'] as bool?,
      duration: json['duration']?.toString(),
      description: json['description'] as String?,
      createdAt: json['createdAt'] as String?,
      modifiedAt: json['modifiedAt'] as String?,
      dateStartDate: json['dateStartDate']?.toString(),
      dateEndDate: json['dateEndDate']?.toString(),
      parentId: json['parentId'] as String?,
      parentType: json['parentType'] as String?,
      parentName: json['parentName'] as String?,
      accountId: json['accountId'] as String?,
      accountName: json['accountName'] as String?,
      createdById: json['createdById'] as String?,
      createdByName: json['createdByName'] as String?,
      modifiedById: json['modifiedById'] as String?,
      modifiedByName: json['modifiedByName'] as String?,
      assignedUserId: json['assignedUserId'] as String?,
      assignedUserName: json['assignedUserName'] as String?,
    );
  }

  @override
  String toString() {
    return '''
AppointmentModel(
  id: $id,
  name: $name,
  deleted: $deleted,
  status: $status,
  dateStart: $dateStart,
  dateEnd: $dateEnd,
  isAllDay: $isAllDay,
  duration: $duration,
  description: $description,
  createdAt: $createdAt,
  modifiedAt: $modifiedAt,
  dateStartDate: $dateStartDate,
  dateEndDate: $dateEndDate,
  parentId: $parentId,
  parentType: $parentType,
  parentName: $parentName,
  accountId: $accountId,
  accountName: $accountName,
  createdById: $createdById,
  createdByName: $createdByName,
  modifiedById: $modifiedById,
  modifiedByName: $modifiedByName,
  assignedUserId: $assignedUserId,
  assignedUserName: $assignedUserName,
)
''';
  }
}
