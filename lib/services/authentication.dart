import 'dart:io';

import 'package:center_for_biblical_studies/data/authentication/login_data.dart';
import 'package:center_for_biblical_studies/data/authentication/register_data.dart';
import 'package:center_for_biblical_studies/data/courses/course_data.dart';
import 'package:center_for_biblical_studies/data/group/group_data.dart';
import 'package:center_for_biblical_studies/data/library/library_data.dart';
import 'package:center_for_biblical_studies/data/message/message_data.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://mardoche.pythonanywhere.com",
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  // Helper method to get token from SharedPreferences
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  // Helper method to get authenticated options
  Future<Options> _getAuthenticatedOptions() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception("No token found. Please login first.");
    }
    return Options(
      headers: {
        "Authorization": "Token $token",
      },
    );
  }

  // Helper method to save token
  Future<void> _saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
  }

  // Generic error handler
  Map<String, dynamic> _handleDioError(DioException e, String url) {
    if (e.response != null) {
      final errorMessage =
          e.response?.data["message"] ?? "Something went wrong";
      final statusCode = e.response?.statusCode;

      _logger.e(
        'API Error',
        error:
            'URL: $url\nStatus: $statusCode\nMessage: $errorMessage\nResponse: ${e.response?.data}',
      );

      return {
        "error": true,
        "message": errorMessage,
        "status": statusCode,
      };
    } else {
      _logger.e(
        'Network Error',
        error: 'URL: $url\nMessage: ${e.message}\nType: ${e.type}',
      );

      return {
        "error": true,
        "message": "Network error. Please try again.",
        "status": 500,
      };
    }
  }

  // Generic method to handle GET requests that return a list
  Future<List<T>> _getList<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final url = '${_dio.options.baseUrl}$endpoint';

    try {
      _logger.i('API Request: GET $url');

      final options = await _getAuthenticatedOptions();
      final response = await _dio.get(endpoint, options: options);

      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> data = response.data;
        final result =
            data.map((json) => fromJson(json as Map<String, dynamic>)).toList();

        _logger.i(
          'API Response: GET $url\nStatus: ${response.statusCode}\nItems Count: ${result.length}\nResponse: ${response.data}',
        );

        return result;
      } else {
        _logger.w('API Response: GET $url - Status: ${response.statusCode}');
        throw Exception("Failed to load data from $endpoint");
      }
    } on DioException catch (e) {
      _handleDioError(e, url);
      throw Exception("Failed to load data: ${e.message}");
    }
  }

  // PDF download (doesn't need authentication)
  Future<File> fetchPdfData(String url) async {
    var dir = Directory.systemTemp;
    String filePath = '${dir.path}/downloaded.pdf';

    try {
      _logger.i('API Request: GET $url (PDF Download)');

      final pdfDio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
          sendTimeout: const Duration(seconds: 60),
        ),
      );

      await pdfDio.download(url, filePath);

      _logger.i('API Response: PDF downloaded successfully to $filePath');

      return File(filePath);
    } catch (e) {
      _logger.e('PDF Download Error', error: 'URL: $url\nError: $e');
      throw Exception('Error downloading PDF: $e');
    }
  }

  // Authentication
  Future<Map<String, dynamic>> login(LoginData data) async {
    final url = '${_dio.options.baseUrl}/login/';

    try {
      // Log all request details
      _logger.i('═══════════════════════════════════════════════════════════');
      _logger.i('🔐 LOGIN REQUEST');
      _logger.i('═══════════════════════════════════════════════════════════');
      _logger.i('📤 URL: $url');
      _logger.i('📤 Method: POST');
      _logger.i('📤 Headers: ${_dio.options.headers}');

      // Log login data (be careful with sensitive data)
      final loginJson = data.toJson();
      _logger.i('📤 Request Body:');
      _logger.i('   - Email: ${loginJson['email'] ?? 'N/A'}');
      _logger
          .i('   - Password: ${loginJson['password'] != null ? '***' : 'N/A'}');
      _logger.i('   - Full JSON: $loginJson');

      _logger.i('───────────────────────────────────────────────────────────');

      Response response = await _dio.post(
        "/login/",
        data: data,
      );

      if (response.statusCode == 200) {
        String token = response.data["token"];
        await _saveToken(token);

        // Log response details
        _logger.i('✅ LOGIN RESPONSE');
        _logger
            .i('───────────────────────────────────────────────────────────');
        _logger.i('📥 Status Code: ${response.statusCode}');
        _logger.i('📥 Status Message: ${response.statusMessage ?? 'N/A'}');
        _logger.i('📥 Headers: ${response.headers.map}');
        _logger.i('📥 Response Data:');
        final tokenPreview =
            token.length > 20 ? '${token.substring(0, 20)}...' : token;
        _logger.i('   - Token (preview): $tokenPreview');
        _logger.i('   - Token Length: ${token.length}');
        _logger.i('   - Full Response: ${response.data}');
        _logger
            .i('═══════════════════════════════════════════════════════════');

        return {"success": true, "token": token};
      } else {
        _logger.w('⚠️ LOGIN RESPONSE - Non-200 Status');
        _logger.w('📥 Status Code: ${response.statusCode}');
        _logger.w('📥 Response Headers: ${response.headers.map}');
        _logger.w('📥 Response Data: ${response.data}');
        _logger
            .i('═══════════════════════════════════════════════════════════');
        final data = response.data;
        final msg = (data is Map && data['message'] != null)
            ? data['message'].toString()
            : 'Login failed';
        return {"error": true, "message": msg, "status": response.statusCode};
      }
    } on DioException catch (e) {
      _logger.e('❌ LOGIN ERROR');
      _logger.e('📥 Error Type: ${e.type}');
      _logger.e('📥 Error Message: ${e.message}');
      _logger.e('📥 Request URL: ${e.requestOptions.uri}');
      _logger.e('📥 Request Headers: ${e.requestOptions.headers}');
      _logger.e('📥 Request Data: ${e.requestOptions.data}');
      if (e.response != null) {
        _logger.e('📥 Response Status: ${e.response?.statusCode}');
        _logger.e('📥 Response Headers: ${e.response?.headers.map}');
        _logger.e('📥 Response Data: ${e.response?.data}');
      }
      _logger.i('═══════════════════════════════════════════════════════════');
      return _handleDioError(e, url);
    }
  }

  // Teachers
  Future<List<RegisterData>> fetchTeachers() async {
    return _getList<RegisterData>(
      "/teachers",
      (json) => RegisterData.fromJson(json),
    );
  }

  // Courses
  Future<List<CourseData>> fetchCourses() async {
    return _getList<CourseData>(
      "/course",
      (json) => CourseData.fromJson(json),
    );
  }

  // Books
  Future<List<LibraryData>> fetchBooks() async {
    return _getList<LibraryData>(
      "/book/get",
      (json) => LibraryData.fromJson(json),
    );
  }

  // Groups
  Future<List<GroupData>> fetchGroups() async {
    return _getList<GroupData>(
      "/chat/api/rooms/",
      (json) => GroupData.fromJson(json),
    );
  }

  Future<Map<String, dynamic>> createGroup({
    required String name,
    required String description,
    bool isPrivate = false,
  }) async {
    final url = '${_dio.options.baseUrl}/chat/api/rooms/';
    final requestData = {
      "name": name,
      "description": description,
      "is_private": isPrivate,
    };

    try {
      _logger.i('API Request: POST $url');
      _logger.d('Request Data: $requestData');

      final options = await _getAuthenticatedOptions();
      final response = await _dio.post(
        "/chat/api/rooms/",
        data: requestData,
        options: options,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _logger.i(
          'API Response: POST $url\nStatus: ${response.statusCode}\nGroup created successfully\nResponse: ${response.data}',
        );

        return {
          "success": true,
          "data": GroupData.fromJson(response.data),
        };
      } else {
        _logger.w('API Response: POST $url - Status: ${response.statusCode}');
        throw Exception("Failed to create group");
      }
    } on DioException catch (e) {
      return _handleDioError(e, url);
    }
  }

  // Messages
  Future<List<MessageData>> fetchMessages(String roomUuid) async {
    return _getList<MessageData>(
      "/chat/api/rooms/$roomUuid/messages/",
      (json) => MessageData.fromJson(json),
    );
  }

  Future<Map<String, dynamic>> sendMessage({
    required String roomUuid,
    required String content,
  }) async {
    final url = '${_dio.options.baseUrl}/chat/api/rooms/$roomUuid/messages/';
    final requestData = {
      "content": content,
    };

    try {
      _logger.i('API Request: POST $url');
      _logger.d('Request Data: $requestData');

      final options = await _getAuthenticatedOptions();
      final response = await _dio.post(
        "/chat/api/rooms/$roomUuid/messages/",
        data: requestData,
        options: options,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _logger.i(
          'API Response: POST $url\nStatus: ${response.statusCode}\nMessage sent successfully\nResponse: ${response.data}',
        );

        return {
          "success": true,
          "data": MessageData.fromJson(response.data),
        };
      } else {
        _logger.w('API Response: POST $url - Status: ${response.statusCode}');
        throw Exception("Failed to send message");
      }
    } on DioException catch (e) {
      return _handleDioError(e, url);
    }
  }
}
