import '../../constants/api_endpoints.dart';
import 'base/api_service.dart';

class AppointmentsApiService {
  static Future<Map<String, dynamic>> getAppointments({
    required String accountId,
  }) {
    final url = ApiConstants.getAppointmentsUrl(accountId);
    return ApiRequest.get(
      url,
    );
  }
}
