import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:news_app/core/utils/date_formatter.dart';
import 'package:news_app/domain/entities/article.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewsDetailPage extends StatefulWidget {
  final Article article;

  const NewsDetailPage({Key? key, required this.article}) : super(key: key);

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Hero(
          tag: 'article_${widget.article.id}',
          child: Material(
            type: MaterialType.transparency,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // App bar
                SliverAppBar(
                  expandedHeight: 240.h,
                  pinned: true,
                  stretch: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: widget.article.urlToImage != null
                        ? CachedNetworkImage(
                            imageUrl: widget.article.urlToImage!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(color: Colors.white),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[300],
                              child: Center(
                                child: Icon(
                                  Icons.error,
                                  color: Colors.red,
                                  size: 40.sp,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 40.sp,
                              ),
                            ),
                          ),
                  ),
                ),

                // Content
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Source and time
                            Row(
                              children: [
                                Container(
                                  height: 24.h,
                                  width: 24.w,
                                  decoration: BoxDecoration(
                                    color: _getSourceColor(
                                      widget.article.source,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    _getSourceInitial(widget.article.source),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),

                                Text(
                                  widget.article.source,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,
                                  ),
                                ),

                                SizedBox(width: 8.w),

                                Text(
                                  DateFormatter.formatNewsDate(
                                    widget.article.publishedAt,
                                  ),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 16.h),

                            // Title
                            Text(
                              widget.article.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22.sp,
                                height: 1.3,
                              ),
                            ),

                            SizedBox(height: 16.h),

                            // Author
                            if (widget.article.author != null)
                              Row(
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: 16.sp,
                                    color: Colors.grey[700],
                                  ),
                                  SizedBox(width: 4.w),
                                  Expanded(
                                    child: Text(
                                      'By ${widget.article.author}',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                            if (widget.article.author != null)
                              SizedBox(height: 16.h),

                            // Description
                            Text(
                              'Description',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: 16.sp,
                                height: 1.5,
                              ),
                            ),
                            if (widget.article.description != null)
                              Text(
                                widget.article.description!,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5,
                                ),
                              ),

                            SizedBox(height: 16.h),

                            // Content
                            Text(
                              'Content',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: 16.sp,
                                height: 1.5,
                              ),
                            ),
                            Text(
                              widget.article.content,
                              style: TextStyle(fontSize: 16.sp, height: 1.5),
                            ),

                            SizedBox(height: 32.h),

                            // Read more button
                            Center(
                              child: ElevatedButton.icon(
                                onPressed: () => _launchUrl(widget.article.url),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24.w,
                                    vertical: 12.h,
                                  ),
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.r),
                                  ),
                                ),
                                icon: const Icon(Icons.open_in_new),
                                label: Text(
                                  'Read Full Article',
                                  style: TextStyle(fontSize: 16.sp),
                                ),
                              ),
                            ),

                            SizedBox(height: 32.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.inAppWebView)) {
      throw Exception('Could not launch $url');
    }
  }

  // Helper method untuk mendapatkan inisial dari source
  String _getSourceInitial(String source) {
    if (source.isEmpty) return '';
    return source.substring(0, 1).toUpperCase();
  }

  // Helper method untuk mendapatkan warna berdasarkan source
  Color _getSourceColor(String source) {
    if (source.isEmpty) return Colors.blue;

    // Buat warna yang konsisten berdasarkan nama source
    final int hashCode = source.hashCode;
    final List<Color> colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.indigo,
    ];

    return colors[hashCode % colors.length];
  }
}
