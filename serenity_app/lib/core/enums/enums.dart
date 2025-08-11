enum FileMenuOption {
  view,
  download
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