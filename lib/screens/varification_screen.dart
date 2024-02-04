import 'package:chat_app/utils/routes/routes_names.dart';
import 'package:chat_app/viewmodel/login_signup_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class VarificationScreen extends StatefulWidget {
  const VarificationScreen({super.key, required});

  @override
  State<VarificationScreen> createState() => _VarificationScreenState();
}

class _VarificationScreenState extends State<VarificationScreen> {
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(48, 110, 165, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: const Color.fromARGB(255, 148, 174, 195)),
      borderRadius: BorderRadius.circular(20),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Varification'),
      ),
      body: Consumer<LoginSignUpViewModel>(
        builder: (ctx, loginSignUpViewModel, cild) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40, width: double.infinity),
                Text(
                  'Verify your number',
                  style: GoogleFonts.akshar(
                    textStyle: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Kindly input the six-digit code you received on the provided phone number.',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Pinput(
                  length: 6,
                  defaultPinTheme: defaultPinTheme.copyWith(
                      decoration: BoxDecoration(
                          color:
                              Theme.of(context).colorScheme.primaryContainer)),
                  focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromRGBO(114, 178, 238, 1)),
                    borderRadius: BorderRadius.circular(8),
                  )),
                  showCursor: true,
                  onCompleted: (smsCode) {
                    if (!loginSignUpViewModel.isLogin) {
                      loginSignUpViewModel.loginWithNumber(context, smsCode,
                          () {
                        final user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              RoutesNames.tabsScreen, (route) => false);
                        }
                      });
                    } else {
                      loginSignUpViewModel.signUpWithPhoneNumber(
                        context,
                        smsCode,
                        () {
                          final user = FirebaseAuth.instance.currentUser;
                          if (user != null) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                RoutesNames.tabsScreen, (route) => false);
                          }
                        },
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
                if (loginSignUpViewModel.isVerifying)
                  const CircularProgressIndicator(),
              ],
            ),
          );
        },
      ),
    );
  }
}
