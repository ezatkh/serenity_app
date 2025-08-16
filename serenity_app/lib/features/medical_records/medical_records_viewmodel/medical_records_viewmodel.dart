import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:mime/mime.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../core/services/cache/sharedPreferences.dart';
import '../../../../../core/services/local/toast_service.dart';
import '../../../core/services/api/medical_record_service.dart';
import '../../../core/utils/file_helper.dart';
import '../../../data/Models/file_model.dart';
import '../../../data/Models/medical_report_model.dart';

class MedicalRecordsViewModel extends ChangeNotifier {
  List<MedicalRecordModel> medicalRecords = [];
  MedicalRecordModel? selectedMedicalRecord;
  bool isLoading = false;
  bool isLoadingFile = false;
  String? errorMessage;
  bool _hasFetched = false;

  void resetFetched() {
    _hasFetched = false;
  }

  void selectMedicalRecord(MedicalRecordModel medicalRecordItem) {
    selectedMedicalRecord = medicalRecordItem;
    notifyListeners();
  }

  Future<void> fetchMedicalRecords(BuildContext context) async {
    if (isLoading) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final accountId = await SharedPrefsUtil.getString(USER_ID);

      if (accountId == null || accountId.isEmpty) {
        errorMessage = 'No accountId found';
        ToastService.show(message: errorMessage!, type: ToastType.error);
        return;
      }

      final response = await MedicalRecordsApiService.getMedicalRecords(accountId: accountId);

      final status = response['status'];
      final data = response['data'];

      if (status == 200 && data != null) {
        try {
          final List<dynamic> list = data['list'] ?? [];
          medicalRecords = list.map((json) => MedicalRecordModel.fromJson(json)).toList();
          _hasFetched = true;
        } catch (e) {
          errorMessage = 'Error parsing Medical Records data: $e';
          ToastService.show(message: errorMessage!, type: ToastType.error);
        }
      } else {
        errorMessage = response['error'] ?? 'Something went wrong';
        ToastService.show(message: errorMessage!, type: ToastType.error);
      }
    } catch (e) {
      errorMessage = 'Failed to fetch medical Records: $e';
      ToastService.show(message: errorMessage!, type: ToastType.error);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Uint8List?> fetchMedicalRecordFile(String fileId) async {
    try {
      isLoadingFile = true;
      notifyListeners();

      final response = await MedicalRecordsApiService.getMedicalRecordFile(fileId: fileId);

      if (response['status'] == 200 && response['data'] != null) {
        final fileBytes = response['data'];
        print('Medical record file fetched successfully');
        return fileBytes;
      } else {
        ToastService.show(
          message: response['error'] ?? 'Failed to fetch file',
          type: ToastType.error,
        );
      }
    } catch (e) {
      ToastService.show(
        message: 'Error fetching medical record file: $e',
        type: ToastType.error,
      );
    } finally {
      isLoadingFile = false;
      notifyListeners();
    }
    return null;
  }

  Future<List<MedicalFolderModel>> fetchMedicalFolders(BuildContext context) async {
    if (isLoading) return [];

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {

      final response = await MedicalRecordsApiService.getMedicalFolders();

      final status = response['status'];
      final data = response['data'];

      if (status == 200 && data != null) {
        try {
          final List<dynamic> list = data['list'] ?? [];
          final medicalFolderModel = list.map((json) => MedicalFolderModel.fromJson(json)).toList();
          return  medicalFolderModel;
        } catch (e) {
          errorMessage = 'Error parsing Medical Records data: $e';
          ToastService.show(message: errorMessage!, type: ToastType.error);
          return [];
        }
      } else {
        errorMessage = response['error'] ?? 'Something went wrong';
        ToastService.show(message: errorMessage!, type: ToastType.error);
        return [];
      }
    } catch (e) {
      errorMessage = 'Failed to fetch medical Records: $e';
      ToastService.show(message: errorMessage!, type: ToastType.error);
      return [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> uploadNewFile(
      BuildContext context, {
    required File file,
    required String fileName,

  }) async {
    try {
      if (isLoading) return null;

      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final accountId = await SharedPrefsUtil.getString(USER_ID);
      if (accountId == null || accountId.isEmpty) {
        debugPrint('No accountId found in Shared Preferences');
        return null;
      }

      final mimeType = FileHelper.getMimeType(file);
      final base64File = await FileHelper.fileToBase64(file);

      final body = {
        "name": fileName,
        "type": mimeType,
        "role": "Attachment",
        "relatedType": "PMRFile",
        "field": "file",
        "file": base64File,
      };

      final response = await MedicalRecordsApiService.postAttachment(body: body);
      print("response is :${response}");
      final success = response['success'];
      final status = response['status'];
      final data = response['data'];

      if (success && status == 200) {
        final fileId = data['id']?.toString();
        if (fileId != null && fileId.isNotEmpty) {
          debugPrint('✅ Uploaded file ID: $fileId');
          return fileId;
        } else {
          debugPrint('⚠️ Upload succeeded but no file ID returned.');
          ToastService.show(
            message: 'Upload succeeded, but file ID is missing.',
            type: ToastType.warning,
          );
          return null;
        }
      }
      else {
        print("error :${response['error']}");
        ToastService.show(
          message: response['error'] ?? 'Something went wrong',
          type: ToastType.error,
        );
        return null;
      }
    } catch (e) {
      debugPrint('Exception in updateProfile: $e');
      ToastService.show(
        message: 'Unexpected error occurred while uploaded new file.',
        type: ToastType.error,
      );
      return null;
    }
    finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> postMedicalRecord(
      BuildContext context, {
        required String description,
        required String medicalFolderId,
        required String uploadedFileId,
        required String uploadedFileName,
      }) async {
    try {
      if (isLoading) return false;

      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final accountId = await SharedPrefsUtil.getString(USER_ID);
      if (accountId == null || accountId.isEmpty) {
        debugPrint('No accountId found in Shared Preferences');
        return false;
      }

      final body = {
        "description": description,
        "name" : uploadedFileName,
        "pMRId" :medicalFolderId,
        "accountId": accountId,
        "fileId": uploadedFileId
      };

      final response = await MedicalRecordsApiService.postMedicalRecord(body: body);
      print("response is :$response");
      final success = response['success'];
      final status = response['status'];
      final data = response['data'];

      if (success && status == 200) {
        ToastService.show(
          message: 'Medical record saved successfully',
          type: ToastType.success,
        );
        return true;
      }
      else {
        print("error :${response['error']}");
        ToastService.show(
          message: response['error'] ?? 'Something went wrong',
          type: ToastType.error,
        );
        return false;
      }
    } catch (e) {
      debugPrint('Unexpected error occurred while uploaded new file.:${e}');
      ToastService.show(
        message: 'Unexpected error occurred while uploaded new file.:${e}',
        type: ToastType.error,
      );
      return false;
    }
    finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> getAttachmentType(BuildContext context,String fileId) async {

    if (fileId.isEmpty) {
      ToastService.show(message: 'Invalid file information', type: ToastType.error);
      return null;
    }

    if (isLoading) return null;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {

      final response = await MedicalRecordsApiService.getAttachmentDetail(fileId: fileId);

      final status = response['status'];
      final data = response['data'];

      if (status == 200 && data != null) {
        try {
          final String type = (data['type']?.toString() ?? '').trim();

          if (type.isEmpty) {
            ToastService.show(message: 'cant find the file type', type: ToastType.error);
            return null;
          }

          return type;
        } catch (e) {
          errorMessage = 'Error parsing attachment detail data: $e';
          ToastService.show(message: errorMessage!, type: ToastType.error);
          return null;
        }
      } else {
        errorMessage = response['error'] ?? 'Something went wrong';
        ToastService.show(message: errorMessage!, type: ToastType.error);
        return null;
      }
    } catch (e) {
      errorMessage = 'Failed to fetch attachment detail: $e';
      ToastService.show(message: errorMessage!, type: ToastType.error);
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    medicalRecords = [];
    selectedMedicalRecord = null;
    isLoading = false;
    isLoadingFile = false;
    errorMessage = null;
    _hasFetched = false;
    notifyListeners();
  }
}