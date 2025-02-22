import 'package:center_for_biblical_studies/data/courses/course_data.dart';
import 'package:center_for_biblical_studies/data/teacher_data/teacher_data.dart';
import 'package:get/get.dart';

class DataController extends GetxController {
  var courses = <CourseData>[].obs;
  var teachers = <TeacherData>[].obs;

  void setCourses(List<CourseData> newCourses) {
    courses.value = newCourses;
  }

  void setTeachers(List<TeacherData> newTeachers) {
    teachers.value = newTeachers;
  }
}
