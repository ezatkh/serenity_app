import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../constants/constants.dart';

class ApiRequest {
  static const Duration timeoutDuration = Duration(seconds: 10);

  static Future<Map<String, dynamic>> get(
      String endpoint) async {
    try {

      final hasConnection = await ApiRequest().checkConnectivity();
      if (!hasConnection) {
        return {
          'success': false,
          'error': 'No internet connection',
          'status': 503,
        };
      }

      print("url is ${endpoint}");
      final response = await http
          .get(
        Uri.parse(endpoint),
        headers: {
          "Content-Type": "application/json",
          "X-Api-Key": API_KEY
        },
      )
          .timeout(timeoutDuration, onTimeout: _onTimeout);
      return await _handleResponse(
        response,
            () => ApiRequest.get(endpoint),
      );
    } on TimeoutException {
      return _handleTimeout();
    } catch (e) {
      return _handleError(e);
    }
  }

  static Future<Map<String, dynamic>> post(
      String endpoint,
      Map<String, dynamic> body) async {
    try {

      final hasConnection = await ApiRequest().checkConnectivity();
      if (!hasConnection) {
        return {
          'success': false,
          'error': 'No internet connection',
          'status': 503,
        };
      }

      final defaultHeaders = {
        "Content-Type": "application/json",
        "X-Api-Key": API_KEY
      };

      print("header\n${defaultHeaders}");
      print("url\n${endpoint}");
      print("body\n${body}");

      final response = await http
          .post(
        Uri.parse(endpoint),
        body: json.encode(body),
        headers: defaultHeaders,
      ).timeout(timeoutDuration, onTimeout: _onTimeout);

      return await _handleResponse(response, () => post(endpoint, body),);
    } on TimeoutException {
      return _handleTimeout();
    } catch (e) {
      return _handleError(e);
    }
  }

  static Future<Map<String, dynamic>> patch(
      String endpoint,
      Map<String, dynamic> body, {
        Map<String, String>? headers,
      }) async {
    try {
      final hasConnection = await ApiRequest().checkConnectivity();
      if (!hasConnection) {
        return {
          'success': false,
          'error': 'No internet connection',
          'status': 503,
        };
      }

      final defaultHeaders = {
        "Content-Type": "application/json",
        "X-Api-Key": API_KEY
      };
      final mergedHeaders = headers ?? defaultHeaders;

      final response = await http
          .patch(
        Uri.parse(endpoint),
        body: json.encode(body),
        headers: mergedHeaders,
      ).timeout(timeoutDuration, onTimeout: _onTimeout);

      return await _handleResponse(
        response,
            () => patch(endpoint, body, headers: headers),
      );
    } on TimeoutException {
      return _handleTimeout();
    } catch (e) {
      return _handleError(e);
    }
  }

  static Future<Map<String, dynamic>> getBytes(String endpoint) async {
    try {

      final hasConnection = await ApiRequest().checkConnectivity();
      if (!hasConnection) {
        return {
          'success': false,
          'error': 'No internet connection',
          'status': 503,
        };
      }

      print("body is ${endpoint}");
      final response = await http
          .get(
        Uri.parse(endpoint),
        headers: {
          "Content-Type": "application/json",
          "X-Api-Key": API_KEY
        },
      )
          .timeout(timeoutDuration, onTimeout: _onTimeout);


      return await _handleBytesResponse(
        response,
            () => ApiRequest.getBytes(endpoint),
      );
    } on TimeoutException {
      return _handleTimeout();
    } catch (e) {
      return _handleError(e);
    }
  }

  static Future<Map<String, dynamic>> _handleBytesResponse(
      http.Response response,
      Future<Map<String, dynamic>> Function() apiRequest,
      ) async {
    debugPrint("_handleBytesResponse|response: ${response.statusCode}");

    switch (response.statusCode) {
      case 200:
        return {
          'success': true,
          'data': response.bodyBytes,
          'status': 200,
        };

      case 401:
        return {
          'success': false,
          'error': 'Request error ${response.body}',
          'status': 401,
        };

      case 404:
        return {
          'success': false,
          'error': 'Request error ${response.body}',
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
          'status': 500,
        };

      default:
        return {
          'success': false,
          'error': 'Error: ${response.body}',
          'status': response.statusCode,
        };
    }
  }



  static Future<Map<String, dynamic>> _handleResponse(
      http.Response response,
      Future<Map<String, dynamic>> Function() apiRequest,
      ) async {

    debugPrint("_handleResponse|response: ${response.statusCode}: ${response.body}");

    switch (response.statusCode) {
      case 200:
        return {
          'success': true,
          'data': json.decode(response.body),
          'status': 200,
        };

      case 401:
          return {
            'success': false,
            'error': 'Request error ${response.body}',
            'status': 401,
          };

      case 404:
        return {
          'success': false,
          'error': 'Request error ${response.body}',
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
    return connectivityResult[0] != ConnectivityResult.none;
  }
}
