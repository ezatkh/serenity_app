class AccountProfile {
  final String? nif;
  final String? name;
  final String? email;
  final String? dateOfBirth;
  final String? countryOfOrigin;
  final String? gender;
  final String? status;
  final String? joinDate;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? clientManager;
  final String? caseManager;
  final String? billingAddressStreet;
  final String? billingAddressCity;
  final String? billingAddressPostalCode;
  final String? doorNumber;
  final String? apartmentNumber;
  final String? phoneNumber;

  AccountProfile({
    this.nif,
    this.name,
    this.email,
    this.dateOfBirth,
    this.countryOfOrigin,
    this.gender,
    this.status,
    this.joinDate,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.clientManager,
    this.caseManager,
    this.billingAddressStreet,
    this.billingAddressCity,
    this.billingAddressPostalCode,
    this.doorNumber,
    this.apartmentNumber,
    this.phoneNumber,
  });

  factory AccountProfile.fromJson(Map<String, dynamic> json) {
    return AccountProfile(
      nif: json['nIF'],
      name: json['name'],
      email: json['emailAddress'],
      dateOfBirth: json['dateofbirth'],
      countryOfOrigin: json['countryOfOrigin'],
      gender: json['gender'],
      status: json['status'],
      joinDate: json['joiningdate'],
      emergencyContactName: json['emergencyContact'],
      emergencyContactPhone: json['contactMobile'],
      clientManager: json['userName'],
      caseManager: json['assignedUserName'],
      billingAddressStreet: json['billingAddressStreet'],
      billingAddressCity: json['billingAddressCity'],
      billingAddressPostalCode: json['billingAddressPostalCode'],
      doorNumber: json['doorNumber'],
      apartmentNumber: json['apartmentNumber'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "nIF": nif,
      "name": name,
      "emailAddress": email,
      "dateofbirth": dateOfBirth,
      "countryOfOrigin": countryOfOrigin,
      "gender": gender,
      "status": status,
      "joiningdate": joinDate,
      "emergencyContact": emergencyContactName,
      "contactMobile": emergencyContactPhone,
      "userName": clientManager,
      "assignedUserName": caseManager,
      "billingAddressStreet": billingAddressStreet,
      "billingAddressCity": billingAddressCity,
      "billingAddressPostalCode": billingAddressPostalCode,
      "doorNumber": doorNumber,
      "apartmentNumber": apartmentNumber,
      "phoneNumber": phoneNumber,
    };
  }

  @override
  String toString() {
    return '''
nif: $nif
name: $name
email: $email
dateOfBirth: $dateOfBirth
countryOfOrigin: $countryOfOrigin
gender: $gender
status: $status
joinDate: $joinDate
emergencyContactName: ${emergencyContactName ?? 'N/A'}
emergencyContactPhone: ${emergencyContactPhone ?? 'N/A'}
clientManager: $clientManager
caseManager: $caseManager
billingAddressStreet: $billingAddressStreet
billingAddressCity: $billingAddressCity
billingAddressPostalCode: $billingAddressPostalCode
doorNumber: $doorNumber
apartmentNumber: $apartmentNumber
phoneNumber: $phoneNumber
''';
  }
}
