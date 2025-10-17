import 'package:crm/app_const/theme/app_theme.dart';
import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/routes/app_routes.dart';
import 'package:crm/screen/login/controller/login_controller.dart';
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

  @override
  void dispose() {
    // _emailFocusNode.dispose();
    // _passwordFocusNode.dispose();
    // _emailController.dispose();
    // _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // _emailFocusNode.unfocus();
        // _passwordFocusNode.unfocus();
      },
      child: Scaffold(
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
                    SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
                    Image.asset("assets/images/logo.png", scale: 1.5),
                    const SizedBox(height: 50),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    // child: Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.center,
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Text(
                    //           "Login",
                    //           style: Theme.of(context).textTheme.displayLarge,
                    //         ),
                    //         // Text("Enter your details to get started"),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.all(
                    //     MediaQuery.of(context).size.width * 0.04,
                    //   ),
                    //   child: TextFormField(
                    //     focusNode: _emailFocusNode,
                    //     controller: _emailController,
                    //     keyboardType: TextInputType.emailAddress,
                    //     decoration: InputDecoration(
                    //       hintText: "Email",
                    //       prefixIcon: const Icon(Icons.email),
                    //       border: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(10),
                    //       ),
                    //       contentPadding: EdgeInsets.symmetric(
                    //         horizontal: MediaQuery.of(context).size.width * 0.04,
                    //       ),
                    //     ),
                    //     validator: (value) {
                    //       if (value == null || value.isEmpty) {
                    //         return 'Please enter your email';
                    //       }
                    //       if (!GetUtils.isEmail(value)) {
                    //         return 'Please enter a valid email address';
                    //       }
                    //       return null;
                    //     },
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.all(
                    //     MediaQuery.of(context).size.width * 0.04,
                    //   ),
                    //   child: Column(
                    //     children: [
                    //       TextFormField(
                    //         focusNode: _passwordFocusNode,
                    //         controller: _passwordController,
                    //         obscureText: true,
                    //         obscuringCharacter: "*",
                    //         decoration: InputDecoration(
                    //           hintText: "Password",
                    //           prefixIcon: const Icon(Icons.lock),
                    //           border: OutlineInputBorder(
                    //             borderRadius: BorderRadius.circular(10),
                    //           ),
                    //           contentPadding: EdgeInsets.symmetric(
                    //             horizontal:
                    //                 MediaQuery.of(context).size.width * 0.04,
                    //           ),
                    //         ),
                    //         validator: (value) {
                    //           if (value == null || value.isEmpty) {
                    //             return 'Please enter your password';
                    //           }
                    //           return null;
                    //         },
                    //       ),

                    //       const SizedBox(height: 5),
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.end,
                    //         children: [
                    //           InkWell(
                    //             onTap: () {
                    //               Get.toNamed(AppRoutes.forgotPassword);
                    //               AppUtils.showlog("Forgot password pressed");
                    //             },
                    //             child: const Text("Forgot Password?"),
                    //           ),
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // InkWell(
                    //   onTap: () async {
                    //     if (_formKey.currentState?.validate() ?? false) {
                    //       await controller.login(
                    //         _emailController.text,
                    //         _passwordController.text,
                    //       );
                    //       AppUtils.showlog("Login in pressed");
                    //     }
                    //   },
                    //   child: Padding(
                    //     padding: EdgeInsets.all(
                    //       MediaQuery.of(context).size.width * 0.04,
                    //     ),
                    //     child: Obx(() {
                    //       return controller.isLoading.value == true
                    //           ? CircularProgressIndicator()
                    //           : Container(
                    //               decoration: BoxDecoration(
                    //                 border: Border.all(),
                    //                 borderRadius: BorderRadius.circular(10),
                    //                 color: AppTheme.lightTheme.primaryColor,
                    //               ),
                    //               child: Padding(
                    //                 padding: const EdgeInsets.all(8.0),
                    //                 child: Row(
                    //                   mainAxisAlignment: MainAxisAlignment.center,
                    //                   children: [
                    //                     Text(
                    //                       "Sign in",
                    //                       style:
                    //                           Theme.of(context).brightness ==
                    //                               Brightness.dark
                    //                           ? const TextStyle(
                    //                               color: Colors.black,
                    //                             )
                    //                           : const TextStyle(
                    //                               color: Colors.white,
                    //                             ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //             );
                    //     }),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.all(
                    //     MediaQuery.of(context).size.width * 0.04,
                    //   ),
                    //   child: const Row(
                    //     children: [
                    //       Expanded(child: Divider()),
                    //       Padding(
                    //         padding: EdgeInsets.symmetric(horizontal: 10),
                    //         child: Text("OR"),
                    //       ),
                    //       Expanded(child: Divider()),
                    //     ],
                    //   ),
                    // ),
                    // InkWell(
                    //   onTap: () {
                    //     AppUtils.showlog("Google Sign in pressed");
                    //   },
                    //   child: Padding(
                    //     padding: EdgeInsets.all(
                    //       MediaQuery.of(context).size.width * 0.04,
                    //     ),
                    //     child: Container(
                    //       decoration: BoxDecoration(
                    //         border: Border.all(),
                    //         borderRadius: BorderRadius.circular(10),
                    //       ),
                    //       child: Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             Image.asset(
                    //               "assets/images/google_logo.png",
                    //               scale: 2,
                    //             ),
                    //             const SizedBox(width: 10),
                    //             const Text("Continue with Google"),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
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
                                    margin: const EdgeInsets.only(bottom: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.red[300],
                                      borderRadius: BorderRadius.circular(8),
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
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.2,
                                                ),
                                                spreadRadius: 1,
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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

                              const SizedBox(height: 24),

                              // User Info (if signed in)
                              // Obx(() {
                              //   if (controller.user.value != null) {
                              //     return Container(
                              //       padding: const EdgeInsets.all(16),
                              //       decoration: BoxDecoration(
                              //         color: Colors.white24,
                              //         borderRadius: BorderRadius.circular(12),
                              //         border: Border.all(color: Colors.white30),
                              //       ),
                              //       child: Column(
                              //         children: [
                              //           CircleAvatar(
                              //             backgroundImage: NetworkImage(
                              //               controller.user.value!.photoUrl ?? '',
                              //             ),
                              //             radius: 40,
                              //           ),
                              //           const SizedBox(height: 12),
                              //           Text(
                              //             controller.user.value!.displayName ?? '',
                              //             style: const TextStyle(
                              //               color: Colors.white,
                              //               fontSize: 18,
                              //               fontWeight: FontWeight.w600,
                              //             ),
                              //           ),
                              //           const SizedBox(height: 4),
                              //           Text(
                              //             controller.user.value!.email,
                              //             style: const TextStyle(
                              //               color: Colors.white70,
                              //               fontSize: 14,
                              //             ),
                              //           ),
                              //           const SizedBox(height: 16),
                              //           Row(
                              //             mainAxisAlignment:
                              //                 MainAxisAlignment.spaceEvenly,
                              //             children: [
                              //               ElevatedButton.icon(
                              //                 onPressed: controller.signOut,
                              //                 icon: const Icon(Icons.logout),
                              //                 label: const Text('Sign Out'),
                              //                 style: ElevatedButton.styleFrom(
                              //                   backgroundColor: Colors.red[400],
                              //                   foregroundColor: Colors.white,
                              //                 ),
                              //               ),
                              //               ElevatedButton.icon(
                              //                 onPressed: controller.disconnect,
                              //                 icon: const Icon(Icons.delete),
                              //                 label: const Text('Disconnect'),
                              //                 style: ElevatedButton.styleFrom(
                              //                   backgroundColor: Colors.orange[400],
                              //                   foregroundColor: Colors.white,
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //         ],
                              //       ),
                              //     );
                              //   }
                              // return const SizedBox.shrink();
                              // }),
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
      ),
    );
  }
}
