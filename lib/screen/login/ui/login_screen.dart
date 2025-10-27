import 'package:crm/app_const/theme/app_theme.dart';
import 'package:crm/screen/login/controller/login_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // final FocusNode _emailFocusNode = FocusNode();
  // final FocusNode _passwordFocusNode = FocusNode();
  // final TextEditingController _emailController = TextEditingController();
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final TextEditingController _passwordController = TextEditingController();
  final LoginController controller = Get.put(LoginController());

  // @override
  // void initState() {
  //   super.initState();
  //   // controller.checkInternet();
  // }

  // @override
  // void dispose() {
  //   // _emailFocusNode.dispose();
  //   // _passwordFocusNode.dispose();
  //   // _emailController.dispose();
  //   // _passwordController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        // _emailFocusNode.unfocus();
        // _passwordFocusNode.unfocus();
      },
      child: !kIsWeb
          ? Scaffold(
              body: Form(
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: MediaQuery.sizeOf(context).width,
                        height: MediaQuery.sizeOf(context).height * 0.3,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.01,
                          ),
                          Image.asset("assets/images/logo.png", scale: 1.5),
                          const SizedBox(height: 50),

                          // Google Sign-In Button
                          GetBuilder<LoginController>(
                            init: LoginController(),
                            builder: (controller) {
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    // Error Message
                                    Obx(() {
                                      if (controller.error.value != null) {
                                        return Container(
                                          padding: const EdgeInsets.all(12),
                                          margin: const EdgeInsets.only(
                                            bottom: 16,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.red[300],
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            controller.error.value!,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    }),

                                    // Sign-In Button
                                    InkWell(
                                      onTap: controller.isLoading.value
                                          ? null
                                          : controller.signInWithGoogle,
                                      child: Obx(() {
                                        return controller.isLoading.value
                                            ? CircularProgressIndicator(
                                                color: Colors.white,
                                                // Theme.of(context).brightness ==
                                                //     Brightness.dark
                                                // ? Colors.white
                                                // : Colors.black,
                                              )
                                            : Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 16,
                                                      horizontal: 32,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      //  controller.isLoading.value
                                                      //     ? Colors.grey[400]
                                                      //     :
                                                      Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.2),
                                                      spreadRadius: 1,
                                                      blurRadius: 4,
                                                      offset: const Offset(
                                                        0,
                                                        2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Image.asset(
                                                      'assets/images/google_logo.png',
                                                      height: 24,
                                                      width: 24,
                                                    ),
                                                    const SizedBox(width: 12),
                                                    const Text(
                                                      'Sign in with Google',
                                                      style: TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                      }),
                                    ),

                                    const SizedBox(height: 24),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Scaffold(
              backgroundColor: Colors.grey[100],
              body: Center(
                child: Container(
                  width: screenWidth > 600
                      ? screenWidth * 0.4
                      : screenWidth * 0.9,

                  height: screenHeight > 600
                      ? screenHeight * 0.5
                      : screenHeight * 0.7,
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset("assets/images/logo.png", scale: 1.5),
                          // const SizedBox(height: 50),
                          // Text(
                          //   "Welcome Back",
                          //   style: Theme.of(context).textTheme.headlineSmall
                          //       ?.copyWith(
                          //         fontWeight: FontWeight.bold,
                          //         color: Colors.black87,
                          //       ),
                          // ),
                        ],
                      ),
                      // SizedBox(height: 40),
                      InkWell(
                        onTap: controller.isLoading.value
                            ? null
                            : controller.signInWithGoogle,
                        child: Obx(() {
                          return controller.isLoading.value
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                  // Theme.of(context).brightness ==
                                  //     Brightness.dark
                                  // ? Colors.white
                                  // : Colors.black,
                                )
                              : Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 32,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        //  controller.isLoading.value
                                        //     ? Colors.grey[400]
                                        //     :
                                        Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 1,
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        'assets/images/google_logo.png',
                                        height: 24,
                                        width: 24,
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'Sign in with Google',
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
