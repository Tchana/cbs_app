import 'package:center_for_biblical_studies/data/authentication/register_data.dart';
import 'package:center_for_biblical_studies/data/courses/course_data.dart';
import 'package:center_for_biblical_studies/data/group/group_data.dart';
import 'package:center_for_biblical_studies/data/library/library_data.dart';
import 'package:get/get.dart';

class DataController extends GetxController {
  var courses = <CourseData>[].obs;
  var teachers = <RegisterData>[].obs;
  var books = <LibraryData>[].obs;
  var groups = <GroupData>[].obs;
  var userRole = ''.obs;
  var subscriptionType = ''.obs;
  var schoolMaxLevel = 0.obs;
  var subscriptionAccessState = 'none'.obs;

  void setCourses(List<CourseData> newCourses) {
    courses.value = newCourses;
  }

  void setBooks(List<LibraryData> newBooks) {
    books.value = newBooks;
  }

  void setTeachers(List<RegisterData> newTeachers) {
    teachers.value = newTeachers;
  }

  void setGroups(List<GroupData> newGroups) {
    groups.value = newGroups;
  }

  void addGroup(GroupData group) {
    groups.add(group);
  }

  void setAccessProfile({
    required String role,
    required String subscription,
    required int maxLevel,
    String accessState = 'none',
  }) {
    userRole.value = role;
    subscriptionType.value = subscription;
    schoolMaxLevel.value = maxLevel;
    subscriptionAccessState.value = accessState;
  }

  /// Library access should be subscription-driven (ignore role).
  bool get hasLibraryAccess =>
      !isSuspended &&
      (subscriptionType.value == 'student' ||
          subscriptionType.value == 'library_user');

  /// Courses access should be subscription-driven (ignore role).
  bool get hasCourseAccess => !isSuspended && subscriptionType.value == 'student';

  bool get isDowngraded => subscriptionAccessState.value == 'downgraded';

  bool get isSuspended => subscriptionAccessState.value == 'suspended';

  bool get canSubmitAssignments => hasCourseAccess && !isDowngraded;

  bool canAccessCourseLevel(String? levelRaw) {
    if (!hasCourseAccess) {
      return false;
    }
    final raw = (levelRaw ?? '').trim();
    final match = RegExp(r'(\d+)').firstMatch(raw);
    final level = int.tryParse(match?.group(1) ?? raw) ?? 0;
    if (level <= 0) return false;
    return level <= schoolMaxLevel.value;
  }
}
