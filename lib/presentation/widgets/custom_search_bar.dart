import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/presentation/pages/search_page.dart';
import 'package:news_app/di/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/presentation/blocs/search/search_bloc.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        children: [
          Expanded(
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0.8, end: 1.0),
              duration: const Duration(milliseconds: 350),
              builder: (context, value, child) {
                return Transform.scale(scale: value, child: child);
              },
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          BlocProvider(
                            create: (_) => sl<SearchBloc>(),
                            child: const SearchPage(),
                          ),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                      transitionDuration: const Duration(milliseconds: 250),
                    ),
                  );
                },
                child: Container(
                  height: 46.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[800]
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(23.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey[500], size: 22.sp),
                      SizedBox(width: 12.w),
                      Text(
                        'Search',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: 8.w),

          // Notification button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // Show notification animation
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Notifications'),
                    duration: const Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              customBorder: const CircleBorder(),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(8.r),
                child: Icon(Icons.notifications_outlined, size: 24.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
