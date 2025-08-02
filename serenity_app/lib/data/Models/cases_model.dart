class CaseModel {
  final String? id;
  final String? name;
  final bool? deleted;
  final int? number;
  final String? status;
  final String? priority;
  final String? type;
  final String? description;
  final String? createdAt;
  final String? modifiedAt;
  final String? dateStart;
  final String? dateEnd;
  final String? dateStartDate;
  final String? dateEndDate;
  final String? dateCompleted;
  final String? closingDate;
  final String? resolution;
  final String? resolutionDesc;
  final String? source;
  final String? category;
  final bool? isFollowupCase;
  final String? accountId;
  final String? accountName;
  final String? leadId;
  final String? leadName;
  final String? contactId;
  final String? contactName;
  final String? inboundEmailId;
  final String? inboundEmailName;
  final String? createdById;
  final String? createdByName;
  final String? modifiedById;
  final String? modifiedByName;
  final String? assignedUserId;
  final String? assignedUserName;
  final String? caseParentId;
  final String? caseParentName;

  CaseModel({
    this.id,
    this.name,
    this.deleted,
    this.number,
    this.status,
    this.priority,
    this.type,
    this.description,
    this.createdAt,
    this.modifiedAt,
    this.dateStart,
    this.dateEnd,
    this.dateStartDate,
    this.dateEndDate,
    this.dateCompleted,
    this.closingDate,
    this.resolution,
    this.resolutionDesc,
    this.source,
    this.category,
    this.isFollowupCase,
    this.accountId,
    this.accountName,
    this.leadId,
    this.leadName,
    this.contactId,
    this.contactName,
    this.inboundEmailId,
    this.inboundEmailName,
    this.createdById,
    this.createdByName,
    this.modifiedById,
    this.modifiedByName,
    this.assignedUserId,
    this.assignedUserName,
    this.caseParentId,
    this.caseParentName,
  });

  factory CaseModel.fromJson(Map<String, dynamic> json) {
    return CaseModel(
      id: json['id'],
      name: json['name'],
      deleted: json['deleted'],
      number: json['number'],
      status: json['status'],
      priority: json['priority'],
      type: json['type'],
      description: json['description'],
      createdAt: json['createdAt'],
      modifiedAt: json['modifiedAt'],
      dateStart: json['dateStart'],
      dateEnd: json['dateEnd'],
      dateStartDate: json['dateStartDate'],
      dateEndDate: json['dateEndDate'],
      dateCompleted: json['dateCompleted'],
      closingDate: json['closingDate'],
      resolution: json['resolution'],
      resolutionDesc: json['resolutionDesc'],
      source: json['source'],
      category: json['category'],
      isFollowupCase: json['isFollowupCase'],
      accountId: json['accountId'],
      accountName: json['accountName'],
      leadId: json['leadId'],
      leadName: json['leadName'],
      contactId: json['contactId'],
      contactName: json['contactName'],
      inboundEmailId: json['inboundEmailId'],
      inboundEmailName: json['inboundEmailName'],
      createdById: json['createdById'],
      createdByName: json['createdByName'],
      modifiedById: json['modifiedById'],
      modifiedByName: json['modifiedByName'],
      assignedUserId: json['assignedUserId'],
      assignedUserName: json['assignedUserName'],
      caseParentId: json['caseParentId'],
      caseParentName: json['caseParentName'],
    );
  }

  @override
  String toString() {
    return '''
CaseModel(
  id: $id,
  name: $name,
  deleted: $deleted,
  number: $number,
  status: $status,
  priority: $priority,
  type: $type,
  description: $description,
  createdAt: $createdAt,
  modifiedAt: $modifiedAt,
  dateStart: $dateStart,
  dateEnd: $dateEnd,
  dateStartDate: $dateStartDate,
  dateEndDate: $dateEndDate,
  dateCompleted: $dateCompleted,
  closingDate: $closingDate,
  resolution: $resolution,
  resolutionDesc: $resolutionDesc,
  source: $source,
  category: $category,
  isFollowupCase: $isFollowupCase,
  accountId: $accountId,
  accountName: $accountName,
  leadId: $leadId,
  leadName: $leadName,
  contactId: $contactId,
  contactName: $contactName,
  inboundEmailId: $inboundEmailId,
  inboundEmailName: $inboundEmailName,
  createdById: $createdById,
  createdByName: $createdByName,
  modifiedById: $modifiedById,
  modifiedByName: $modifiedByName,
  assignedUserId: $assignedUserId,
  assignedUserName: $assignedUserName,
  caseParentId: $caseParentId,
  caseParentName: $caseParentName,
)
''';
  }
}
