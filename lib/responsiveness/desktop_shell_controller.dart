import 'package:center_for_biblical_studies/data/courses/course_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Returns the shared shell controller, registering it if needed.
DesktopShellController ensureDesktopShellController() {
  if (Get.isRegistered<DesktopShellController>()) {
    return Get.find<DesktopShellController>();
  }
  return Get.put(DesktopShellController(), permanent: true);
}

/// Bridges inline top-bar search and in-shell detail navigation.
class DesktopShellController extends GetxController {
  final searchController = TextEditingController();
  final inlineSearchEnabled = false.obs;
  final searchHint = ''.obs;
  final searchQuery = ''.obs;

  final detailTitle = RxnString();
  final requestedTab = RxnInt();
  final pendingCourse = Rxn<CourseData>();

  VoidCallback? _detailBack;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(_syncQuery);
  }

  void _syncQuery() {
    searchQuery.value = searchController.text;
  }

  void enableInlineSearch(String hint) {
    searchHint.value = hint;
    inlineSearchEnabled.value = true;
  }

  void disableInlineSearch() {
    inlineSearchEnabled.value = false;
    searchHint.value = '';
    searchController.clear();
    searchQuery.value = '';
  }

  void setDetailHeader(String title, {required VoidCallback onBack}) {
    detailTitle.value = title;
    _detailBack = onBack;
  }

  void clearDetailHeader() {
    detailTitle.value = null;
    _detailBack = null;
  }

  void goBackFromDetail() {
    final back = _detailBack;
    if (back != null) back();
  }

  bool get hasDetailHeader => (detailTitle.value ?? '').trim().isNotEmpty;

  /// Switch main shell tab and optionally queue a course to open inline.
  void openCourseInShell(CourseData course, {int coursesTabIndex = 2}) {
    pendingCourse.value = course;
    requestedTab.value = coursesTabIndex;
  }

  CourseData? takePendingCourse() {
    final course = pendingCourse.value;
    pendingCourse.value = null;
    return course;
  }

  @override
  void onClose() {
    searchController.removeListener(_syncQuery);
    searchController.dispose();
    super.onClose();
  }
}
