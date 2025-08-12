enum FileMenuOption {
  view,
  download
}

enum GenderOption {
  male,
  female,
  notSpecified,
  custom
}

extension FileMenuOptionExtension on FileMenuOption {
  String get label {
    switch (this) {
      case FileMenuOption.download:
        return 'Download';
      case FileMenuOption.view:
        return 'View';
    }
  }
}

extension GenderOptionExtension on GenderOption {
  String get label {
    switch (this) {
      case GenderOption.male:
        return 'Male';
      case GenderOption.female:
        return 'Female';
      case GenderOption.custom:
        return 'Custom';
      case GenderOption.notSpecified:
        return 'NotSpecified';
    }
  }
}