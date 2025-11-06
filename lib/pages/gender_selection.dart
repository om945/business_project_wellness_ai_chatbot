import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wellnest_chatbot/theme/theme.dart';

class GenderSelection extends StatefulWidget {
  final Function(String) onChanged;

  const GenderSelection({super.key, required this.onChanged});

  @override
  State<GenderSelection> createState() => _GenderSelectionState();
}

class _GenderSelectionState extends State<GenderSelection> {
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: TextStyle(color: Colors.white70, fontSize: 16.sp),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            _buildGenderOption('Male'),
            SizedBox(width: 16.w),
            _buildGenderOption('Female'),
          ],
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildGenderOption(String gender) {
    final isSelected = _selectedGender == gender;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedGender = gender;
          });
          widget.onChanged(gender);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected ? blueColor : const Color(0xff2F3030),
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Center(
            child: Text(
              gender,
              style: TextStyle(
                color: Colors.white,
                fontFamily: googleFontSemiBold,
                fontSize: 16.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
