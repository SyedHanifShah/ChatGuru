import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../viewmodel/login_signup_view_model.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final onBoardingProvider = Provider.of<LoginSignUpViewModel>(context);

    return Scaffold(
      body: Container(
        padding:
            const EdgeInsets.only(left: 20, top: 60, bottom: 20, right: 20),
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.black,
            Theme.of(context).colorScheme.primary,
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/images/chat_logo.png',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 130.0),
              child: Text(
                'Connect friends easily & quickly',
                style: GoogleFonts.akshar(
                  textStyle: const TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Our chat app is the perfect way to stay\nconnected with friends and family.',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 16,
                    color: const Color(0xffB9C1BE),
                  ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(
              height: 40,
            ),
            Center(
              child: Image.asset(
                'assets/images/google.png',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Divider(
                    thickness: 0.3,
                    color: Color(0xffB9C1BE),
                  ),
                ),
                Text(
                  '  OR  ',
                  style: TextStyle(color: Color(0xffB9C1BE), fontSize: 15),
                ),
                Expanded(
                  child: Divider(
                    thickness: 0.3,
                    color: Color(0xffB9C1BE),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  onBoardingProvider.onLogin(context);
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                child: Text(
                  'Sign up with number',
                  style: GoogleFonts.akshar(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Existig account?',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 12,
                        color: const Color(0xffB9C1BE),
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  width: 5,
                ),
                InkWell(
                  onTap: () {
                    onBoardingProvider.onSignUpWithEmail(context);
                  },
                  child: Text(
                    'Log in',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
