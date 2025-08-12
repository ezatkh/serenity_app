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
    final data = <String, dynamic>{};

    void addIfNotEmpty(String key, dynamic value) {
      if (value != null) {
        if (value is String) {
          if (value.trim().isNotEmpty) {
            data[key] = value;
          }
        } else {
          data[key] = value;
        }
      }
    }

    addIfNotEmpty("name", name);
    addIfNotEmpty("emailAddress", email);
    addIfNotEmpty("dateofbirth", dateOfBirth);
    addIfNotEmpty("countryOfOrigin", countryOfOrigin);
    addIfNotEmpty("gender", gender);
    addIfNotEmpty("emergencyContact", emergencyContactName);
    addIfNotEmpty("contactMobile", emergencyContactPhone);
    addIfNotEmpty("userName", clientManager);
    addIfNotEmpty("assignedUserName", caseManager);
    addIfNotEmpty("billingAddressStreet", billingAddressStreet);
    addIfNotEmpty("billingAddressCity", billingAddressCity);
    addIfNotEmpty("billingAddressPostalCode", billingAddressPostalCode);
    addIfNotEmpty("doorNumber", doorNumber);
    addIfNotEmpty("apartmentNumber", apartmentNumber);

    return data;
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
