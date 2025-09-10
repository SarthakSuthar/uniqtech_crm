import 'package:crm/app_const/utils/app_utils.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png'),
            const SizedBox(height: 50),
            Text(
              "Reset Password",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text("enter your email to reset your password"),

            const SizedBox(height: 50),

            Padding(
              // padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
              padding: EdgeInsets.all(0),
              child: TextFormField(
                // focusNode: _emailFocusNode,
                // controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Email",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.04,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            InkWell(
              onTap: () {
                showlog("Forgot password pressed");
              },
              child: Padding(
                padding: EdgeInsets.all(0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text("Reset Password")],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
