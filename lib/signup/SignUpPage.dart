import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import '../../utils/color_helper.dart';
import '../../utils/widgets/CustomTextField.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _obscureText = true;
  bool _isLoading = false;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.month}/${picked.day}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 70),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Sign Up!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  labelText: "Full Name:",
                  hintText: "i.e., John Smith",
                  controller: _fullNameController,
                ),
                CustomTextField(
                    labelText: "Email:",
                    hintText: "i.e., JohnSmith123@gmail.com",
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Image.asset(
                      'assets/images/mail.png',
                      width: 14,
                      height: 14,
                    )),
                const SizedBox(height: 5),
                CustomTextField(
                  labelText: "Phone Number (optional):",
                  hintText: "i.e., +1223452334",
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 5),
                CustomTextField(
                  labelText: "Password:",
                  hintText: "i.e., ************",
                  controller: _passwordController,
                  obscureText: _obscureText,
                  keyboardType: TextInputType.text,
                  prefixIcon: Image.asset(
                    'assets/images/lock.png',
                    width: 14,
                    height: 14,
                  ),
                  suffixIcon: IconButton(
                    icon: Image.asset(
                      _obscureText
                          ? 'assets/images/eye_on.png'
                          : 'assets/images/eye_off.png',
                      width: 24, // Customize size if needed
                      height: 24, // Customize size if needed
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_emailController.text.isEmpty) {
                            Get.snackbar("Error", "Email is required",
                                backgroundColor: Colors.red,
                                colorText: Colors.white);
                            return;
                          }

                          if (_passwordController.text.isEmpty) {
                            Get.snackbar("Error", "Password is required",
                                backgroundColor: Colors.red,
                                colorText: Colors.white);
                            return;
                          }

                          await registerUser(
                            name: _fullNameController.text,
                            email: _emailController.text,
                            dob: _dobController.text,
                            password: _passwordController.text,
                            phoneNumber: _phoneController.text,
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorHelper.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    minimumSize: const Size.fromHeight(45),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                              color: Colors.blue, strokeWidth: 2),
                        )
                      : const Text("Sign Up",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 15),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> registerUser({
    required String name,
    required String email,
    required String dob,
    required String password,
    required String phoneNumber,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Email and password are required",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    setState(() => _isLoading = true);

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Optional: update the user's display name
      await userCredential.user?.updateDisplayName(name);

      // Optional: store extra fields in Firestore later (e.g., dob, phone)

      Get.snackbar("Success", "Account created successfully",
          backgroundColor: Colors.green, colorText: Colors.white);

      // Navigate to login or home
      Get.offAllNamed(Routes.LOGIN);
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);

      String errorMsg = "Something went wrong";

      if (e.code == 'email-already-in-use') {
        errorMsg = "This email is already in use.";
      } else if (e.code == 'invalid-email') {
        errorMsg = "Invalid email address.";
      } else if (e.code == 'weak-password') {
        errorMsg = "Password is too weak.";
      }

      Get.snackbar("Error", errorMsg,
          backgroundColor: Colors.red, colorText: Colors.white);
    } catch (e) {
      setState(() => _isLoading = false);
      Get.snackbar("Error", "Unexpected error: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
      print("❌ Error: $e");
    }
  }
}
