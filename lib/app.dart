import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/di/injection_container.dart';
import 'package:news_app/presentation/blocs/favorites/favorites_bloc.dart';
import 'package:news_app/presentation/blocs/news/news_bloc.dart';
import 'package:news_app/presentation/pages/home_page.dart';

class NewsApp extends StatelessWidget {
  const NewsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<NewsBloc>()),
        BlocProvider(create: (_) => sl<FavoritesBloc>()),
      ],
      child: MaterialApp(
        title: 'News App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          textTheme: GoogleFonts.poppinsTextTheme(),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
          textTheme: GoogleFonts.poppinsTextTheme(
            ThemeData(brightness: Brightness.dark).textTheme,
          ),
          useMaterial3: true,
        ),
        themeMode: ThemeMode.system,
        home: const HomePage(),
      ),
    );
  }
}
