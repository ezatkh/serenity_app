import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiRequest {
  static const Duration timeoutDuration = Duration(seconds: 10);

  static Future<Map<String, dynamic>> get(
      String endpoint, {
        required BuildContext context,
      }) async {
    try {
      // final prefs = await SharedPreferences.getInstance();
      // final token = prefs.getString('token') ?? '';
      final response = await http
          .get(
        Uri.parse(endpoint),
        headers: {
          "Content-Type": "application/json",
          // "Authorization": "Bearer $token",
          // "Idempotency-Key": IdempotencyHelper.generateKey(),
        },
      )
          .timeout(timeoutDuration, onTimeout: _onTimeout);
      print("the response is :${response.body}");

      return await _handleResponse(
        response,
        context,
            () => ApiRequest.get(endpoint, context: context), // Wrap the request inside a closure
      );
    } on TimeoutException {
      return _handleTimeout();
    } catch (e) {
      return _handleError(e);
    }
  }

  static Future<Map<String, dynamic>> post(
      String endpoint,
      Map<String, dynamic> body, {
        Map<String, String>? headers,
        required BuildContext context,
      }) async {
    try {
      // final prefs = await SharedPreferences.getInstance();
      // final token = prefs.getString('token') ?? '';

      final defaultHeaders = {
        "Content-Type": "application/json",
        // "Authorization": "Bearer $token",
      };

      final mergedHeaders = headers ?? defaultHeaders;

      final response = await http
          .post(
        Uri.parse(endpoint),
        body: json.encode(body),
        headers: mergedHeaders,
      ).timeout(timeoutDuration, onTimeout: _onTimeout);

      return await _handleResponse(response, context, () => post(endpoint, body, context: context, headers: headers),);
    } on TimeoutException {
      return _handleTimeout();
    } catch (e) {
      return _handleError(e);
    }
  }

  static Future<Map<String, dynamic>> _handleResponse(
      http.Response response,
      BuildContext context,
      Future<Map<String, dynamic>> Function() apiRequest,
      ) async {

    debugPrint("Response ${response.statusCode}: ${response.body}");

    switch (response.statusCode) {
      case 200:
        return {
          'success': true,
          'data': json.decode(response.body),
          'status': 200,
        };

      case 401:
        // final loginState = Provider.of<LoginState>(context, listen: false);
        // final success = await loginState.autoLogin(context);

        // if (success["success"]) {
        //   print("success :${success}");
        //   debugPrint("Auto login successful. Retrying original request...");
        //   // After successful login, retry the original request
        //   final retryResponse = await apiRequest();
        //   print("retryCallback finished");
        //
        //   // Return the result of the retry request directly
        //   return retryResponse; // Ensure to return the retry result
        // } else {
          // If auto-login fails, return 401 error response
          return {
            'success': false,
            'error': 'Unauthorized - auto-login failed.',
            'status': 401,
          };
        // }

      case 404:
        return {
          'success': false,
          'error': 'Request error',
          'status': 404,
        };

      case 408:
        return {
          'success': false,
          'error': 'Request timed out',
          'status': 408,
        };

      case 500:
        return {
          'success': false,
          'error': 'Server error: ${response.body}',
          'status': response.statusCode,
        };

      default:
        return {
          'success': false,
          'error': 'Error: ${response.body}',
          'status': response.statusCode,
        };
    }
  }

  static Future<http.Response> _onTimeout() async {
    return http.Response('Request timed out', 408);
  }

  static Map<String, dynamic> _handleError(Object error) {
    return {
      'success': false,
      'error': 'Client-side error: $error',
      'status': 400,
    };
  }

  static Map<String, dynamic> _handleTimeout() {
    return {
      'success': false,
      'error': 'Request timed out',
      'status': 408,
    };
  }

  Future<bool> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }
}
