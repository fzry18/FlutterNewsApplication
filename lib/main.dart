import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/app.dart';
import 'package:news_app/di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // PERBAIKAN: Pastikan box dibuka dengan benar dan registrasi adapter jika diperlukan
  print('Debug: Menginisialisasi Hive...');
  final favoritesBox = await Hive.openBox('favorites');
  print(
    'Debug: Favorites box berhasil dibuka. Item count: ${favoritesBox.length}',
  );

  // Initialize dependency injection
  await di.init();

  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => const NewsApp(),
    ),
  );
}
