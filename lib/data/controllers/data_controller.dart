import 'package:center_for_biblical_studies/data/authentication/register_data.dart';
import 'package:center_for_biblical_studies/data/courses/course_data.dart';
import 'package:center_for_biblical_studies/data/group/group_data.dart';
import 'package:center_for_biblical_studies/data/library/library_data.dart';
import 'package:get/get.dart';

class DataController extends GetxController {
  var courses = <CourseData>[].obs;
  var enrolledCourseIds = <String>{}.obs;
  var teachers = <RegisterData>[].obs;
  var books = <LibraryData>[].obs;
  var groups = <GroupData>[].obs;

  void setCourses(List<CourseData> newCourses) {
    courses.value = newCourses;
  }

  void setEnrolledCourseIds(Set<String> newCourseIds) {
    enrolledCourseIds.assignAll(newCourseIds);
  }

  bool isCourseEnrolled(String courseId) {
    return enrolledCourseIds.contains(courseId);
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
}
