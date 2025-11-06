import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:wellnest_chatbot/models/storage_service.dart';
import 'package:wellnest_chatbot/pages/chat_screen.dart';
import 'package:wellnest_chatbot/pages/gender_selection.dart';
import 'package:wellnest_chatbot/theme/theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storageService = StorageService();

  // Form field controllers
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  String? _selectedGender;

  bool _isLoading = false;
  double? _bmi;

  @override
  void initState() {
    super.initState();
    _weightController.addListener(_calculateBmi);
    _heightController.addListener(_calculateBmi);
  }

  void _calculateBmi() {
    final weight = double.tryParse(_weightController.text);
    final height = double.tryParse(_heightController.text);

    if (weight != null && height != null && height > 0) {
      final heightInMeters = height / 100;
      setState(() {
        _bmi = weight / (heightInMeters * heightInMeters);
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final name = _nameController.text;
      final age = int.parse(_ageController.text);
      final weight = double.parse(_weightController.text);
      final height = double.parse(_heightController.text);
      final gender = _selectedGender;

      if (gender == null) {
        // Optionally show a snackbar or message to select gender
      }

      await _storageService.saveUserProfile(
        name: name,
        age: age,
        weight: weight,
        height: height,
        gender: gender!,
      );

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ChatScreen()),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _weightController.removeListener(_calculateBmi);
    _heightController.removeListener(_calculateBmi);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff191A1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Tell Us About Yourself',
          style: TextStyle(color: blueColor, fontFamily: googleFontBold),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTextField(_nameController, 'Name', TextInputType.name),
                SizedBox(height: 16.h),
                GenderSelection(
                  onChanged: (gender) {
                    setState(() {
                      _selectedGender = gender;
                    });
                  },
                ),
                _buildTextField(_ageController, 'Age', TextInputType.number),
                SizedBox(height: 16.h),
                _buildTextField(
                  _weightController,
                  'Weight (KG)',
                  const TextInputType.numberWithOptions(decimal: true),
                ),
                SizedBox(height: 16.h),
                _buildTextField(
                  _heightController,
                  'Height (CM)',
                  const TextInputType.numberWithOptions(decimal: true),
                ),
                if (_bmi != null) ...[
                  SizedBox(height: 20.h),
                  Text(
                    'Your BMI: ${_bmi!.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: blueColor,
                      fontFamily: googleFontBold,
                      fontSize: 18.sp,
                    ),
                  ),
                ],
                SizedBox(height: 32.h),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: blueColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: 50.w,
                            vertical: 15.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                        ),
                        child: Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                            fontFamily: googleFontBold,
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

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    TextInputType keyboardType,
  ) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: const Color(0xff2F3030),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        if (keyboardType == TextInputType.number &&
            int.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
    );
  }
}
