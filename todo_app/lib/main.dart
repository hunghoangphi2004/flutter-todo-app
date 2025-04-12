import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_app/db/db_helper.dart';
import 'package:todo_app/services/theme_services.dart';
import 'package:todo_app/ui/home_page.dart';
import 'package:todo_app/ui/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb(); // Khởi tạo cơ sở dữ liệu
  await GetStorage.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeService().theme,
      home: const MyHomePage(title: 'My first todo app'),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:todo_app/ui/login_screen.dart';
// import 'package:todo_app/ui/theme.dart';
// import 'ui/register_screen.dart'; // Đảm bảo import file chứa RegisterScreen

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Đăng ký',
//       theme: ThemeData(
//         primarySwatch: Colors.cyan, // Replace with a valid MaterialColor
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: LoginScreen(), // Set RegisterScreen làm màn hình khởi đầu
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:todo_app/ui/login_screen.dart';
// import 'package:todo_app/ui/theme.dart';
// import 'package:todo_app/ui/add_task_category.dart'; // Đảm bảo import file chứa RegisterScreen

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter danh mục',
//       theme: ThemeData(
//         primarySwatch: Colors.cyan, // Replace with a valid MaterialColor
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: AddTaskCategory(), // Set RegisterScreen làm màn hình khởi đầu
//     );
//   }
// }
