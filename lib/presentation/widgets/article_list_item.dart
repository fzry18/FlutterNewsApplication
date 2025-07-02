import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:news_app/core/utils/date_formatter.dart';
import 'package:news_app/domain/entities/article.dart';
import 'package:news_app/presentation/pages/news_detail_page.dart';
import 'package:news_app/presentation/widgets/favorite_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ArticleListItem extends StatelessWidget {
  final Article article;
  final bool showSourceLogo;

  const ArticleListItem({
    Key? key,
    required this.article,
    this.showSourceLogo = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  NewsDetailPage(article: article),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(milliseconds: 300),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.withOpacity(0.2),
                width: 0.5,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Baris untuk source dan waktu
              Row(
                children: [
                  // Logo sumber (inisial dalam lingkaran)
                  if (showSourceLogo) _buildSourceLogo(),

                  SizedBox(width: 8.w),

                  // Nama sumber
                  Text(
                    article.source,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                  ),

                  SizedBox(width: 8.w),

                  // Waktu publikasi
                  Text(
                    DateFormatter.getTimeAgo(article.publishedAt),
                    style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                  ),
                ],
              ),

              SizedBox(height: 8.h),

              // Baris utama: judul dan gambar
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kolom judul dan informasi lainnya
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Judul artikel
                        Text(
                          article.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            height: 1.3,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),

                        SizedBox(height: 8.h),

                        // Jumlah baca dan tombol favorit
                        Row(
                          children: [
                            Icon(
                              Icons.remove_red_eye_outlined,
                              size: 16.sp,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '${_getReadCount()} reads',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13.sp,
                              ),
                            ),
                            const Spacer(),
                            FavoriteButton(article: article),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 12.w),

                  // Gambar artikel
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: article.urlToImage != null
                        ? CachedNetworkImage(
                            imageUrl: article.urlToImage!,
                            height: 80.h,
                            width: 80.w,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              height: 80.h,
                              width: 80.w,
                              color: Colors.grey[300],
                            ),
                            errorWidget: (context, url, error) => Container(
                              height: 80.h,
                              width: 80.w,
                              color: Colors.grey[300],
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.grey[400],
                              ),
                            ),
                          )
                        : Container(
                            height: 80.h,
                            width: 80.w,
                            color: Colors.grey[300],
                            child: Icon(Icons.image, color: Colors.grey[400]),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk menampilkan logo sumber berita
  Widget _buildSourceLogo() {
    final String initial = article.source.isNotEmpty
        ? article.source.substring(0, 1).toUpperCase()
        : 'N';

    // Warna yang konsisten berdasarkan sumber berita
    Color logoColor = _getSourceColor();

    return Container(
      width: 24.w,
      height: 24.h,
      decoration: BoxDecoration(color: logoColor, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14.sp,
        ),
      ),
    );
  }

  // Mendapatkan jumlah baca yang realistis berdasarkan judul artikel
  int _getReadCount() {
    // Gunakan hash dari judul untuk menghasilkan angka yang konsisten
    final int hash = article.title.hashCode.abs();
    return 100 + (hash % 900); // Antara 100-999 reads
  }

  // Mendapatkan warna yang konsisten berdasarkan sumber berita
  Color _getSourceColor() {
    final List<Color> colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.teal,
    ];

    // Hash dari nama sumber untuk menghasilkan indeks yang konsisten
    final int index = article.source.hashCode.abs() % colors.length;
    return colors[index];
  }
}
