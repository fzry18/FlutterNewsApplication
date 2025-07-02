import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/constants/category_constants.dart';
import 'package:news_app/presentation/blocs/news/news_bloc.dart';
import 'package:news_app/presentation/blocs/news/news_event.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategorySelector extends StatefulWidget {
  const CategorySelector({Key? key}) : super(key: key);

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  String _selectedCategoryId = 'general'; // Default kategori

  @override
  Widget build(BuildContext context) {
    // Kategori dalam bahasa Inggris sesuai dengan referensi
    final Map<String, String> categoryNameMap = {
      'general': 'For You',
      'business': 'Business',
      'entertainment': 'Entertainment',
      'health': 'Health',
      'science': 'Science',
      'sports': 'Sports',
      'technology': 'Tech',
    };

    return Container(
      height: 38.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.2), width: 0.5),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: CategoryConstants.categories.map((category) {
            final bool isSelected = _selectedCategoryId == category.id;
            final String displayName =
                categoryNameMap[category.id] ?? category.name;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategoryId = category.id;
                });

                // Dispatch event untuk mengubah kategori
                BlocProvider.of<NewsBloc>(
                  context,
                ).add(ChangeNewsCategoryEvent(category.id));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      displayName,
                      style: TextStyle(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.grey[600],
                        fontSize: 14.sp,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    if (isSelected)
                      Container(
                        height: 3.h,
                        width: displayName.length * 3.5.w,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(1.5.r),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
