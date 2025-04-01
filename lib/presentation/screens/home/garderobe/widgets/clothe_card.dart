import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yconic/core/theme/app_text_styles.dart';
import 'package:yconic/domain/entities/clothe.dart';

class ClotheCard extends StatelessWidget {
  final Clothe clothe;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const ClotheCard({
    super.key,
    required this.clothe,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = 'http://10.0.2.2:5000${clothe.MainPhoto}';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16.r)),
                  child: Image.network(
                    Uri.encodeFull(imageUrl),
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, _, __) => const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.06,
                padding: EdgeInsets.all(10.w),
                child: Text(
                  clothe.Name,
                  style: AppTextStyles.bodyBold.copyWith(color: Colors.black),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
