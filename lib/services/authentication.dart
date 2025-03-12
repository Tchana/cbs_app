import 'dart:io';

import 'package:center_for_biblical_studies/data/authentication/login_data.dart';
import 'package:center_for_biblical_studies/data/authentication/register_data.dart';
import 'package:center_for_biblical_studies/data/courses/course_data.dart';
import 'package:center_for_biblical_studies/data/library/library_data.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://127.0.0.1:8000",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  Future<File> fetchPdfData(String url) async {
    var dir = Directory.systemTemp; // Temporary directory
    String filePath = '${dir.path}/downloaded.pdf';

    try {
      await Dio().download(url, filePath);
      return File(filePath);
    } catch (e) {
      throw Exception('Error downloading PDF: $e');
    }
  }

  Future<Map<String, dynamic>> login(LoginData data) async {
    try {
      Response response = await _dio.post(
        "/login",
        data: data,
      );

      if (response.statusCode == 200) {
        String token = response.data["token"];
        await _saveToken(token);
        return {"success": true, "token": token};
      } else {
        throw Exception("Login failed");
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<List<RegisterData>> fetchTeachers() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      if (token == null) {
        throw Exception("No token found");
      }

      Response response = await _dio.get(
        "/user/teachers",
        options: Options(
          headers: {
            "Authorization": "Token $token",
          },
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => RegisterData.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load teachers");
      }
    } on DioException catch (e) {
      throw Exception("Failed to load teachers: ${e.message}");
    }
  }

  Future<void> _saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
  }

  Map<String, dynamic> _handleDioError(DioException e) {
    if (e.response != null) {
      return {
        "error": true,
        "message": e.response?.data["message"] ?? "Something went wrong",
        "status": e.response?.statusCode,
      };
    } else {
      return {
        "error": true,
        "message": "Network error. Please try again.",
        "status": 500,
      };
    }
  }

  Future<List<CourseData>> fetchCourses() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      if (token == null) {
        throw Exception("No token found");
      }

      Response response = await _dio.get(
        "/course",
        options: Options(
          headers: {
            "Authorization": "Token $token",
          },
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => CourseData.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load courses");
      }
    } on DioException catch (e) {
      throw Exception("Failed to load courses: ${e.message}");
    }
  }

  Future<List<LibraryData>> fetchBooks() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      if (token == null) {
        throw Exception("No token found");
      }

      Response response = await _dio.get(
        "/book/get",
        options: Options(
          headers: {
            "Authorization": "Token $token",
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> data = response.data;
        return data.map((json) => LibraryData.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load books");
      }
    } on DioException catch (e) {
      throw Exception("Failed to load books: ${e.message}");
    }
  }
}
