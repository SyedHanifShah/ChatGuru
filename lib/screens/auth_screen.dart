import 'dart:io';

import 'package:chat_app/res/widgets/user_image_picker.dart';
import 'package:chat_app/utils/routes/routes_names.dart';
import 'package:chat_app/viewmodel/login_signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AuthScreenn extends StatefulWidget {
  const AuthScreenn({super.key});

  @override
  State<AuthScreenn> createState() => _AuthScreennState();
}

class _AuthScreennState extends State<AuthScreenn> {
  final _form = GlobalKey<FormState>();
  var _enterdEmail = '';
  var _enterdNumber = '';
  var _enterdPassword = '';
  var _confirmPassword = '';
  var _enterdUsername = '';
  var _enterdIdentifier = '';
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_sharp),
          onPressed: () {},
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 30),
          child: Consumer<LoginSignUpViewModel>(
            builder: (context, loginSignUpViewModel, child) => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  !loginSignUpViewModel.isLogin
                      ? 'Log in to ChatGuru'
                      : 'Sign up with ChatGuru',
                  style: GoogleFonts.akshar(
                    textStyle: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  !loginSignUpViewModel.isLogin
                      ? 'Welcome back! Sign in using your social\nccount or email to continue us'
                      : 'Get chatting with friends and family today by signing up for our chat app!',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 16,
                        color: const Color(0xff797C7B),
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 30,
                ),
                if (!loginSignUpViewModel.isLogin)
                  Image.asset(
                    'assets/images/google.png',
                    fit: BoxFit.cover,
                  ),
                if (!loginSignUpViewModel.isLogin)
                  const SizedBox(
                    height: 30,
                  ),
                if (!loginSignUpViewModel.isLogin)
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
                        style:
                            TextStyle(color: Color(0xffB9C1BE), fontSize: 15),
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
                  height: 10,
                ),
                Form(
                  key: _form,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (loginSignUpViewModel.isLogin)
                        UserImagePicker(
                          onImageSelection: (pickedImage) {
                            _selectedImage = pickedImage;
                          },
                        ),
                      TextFormField(
                        decoration: InputDecoration(
                          prefix: const Text(
                            '+ ',
                            style: TextStyle(fontSize: 20),
                          ),
                          hintText: '123456789',
                          label: Text(
                            'Phone number',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontSize: 16,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w700),
                            textAlign: TextAlign.left,
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().length <= 5) {
                            return 'Please enter a vaild number.';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _enterdNumber = newValue!;
                        },
                      ),
                      if (loginSignUpViewModel.isLogin)
                        const SizedBox(
                          height: 10,
                        ),
                      if (loginSignUpViewModel.isLogin)
                        TextFormField(
                          decoration: InputDecoration(
                            label: Text(
                              'Your name',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontSize: 16,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w700),
                              textAlign: TextAlign.left,
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                          enableSuggestions: false,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.trim().length < 4) {
                              return 'Please enter a valid username (at least 4 characters). ';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _enterdUsername = newValue!;
                          },
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 70),
                        child: Column(
                          children: [
                            if (!loginSignUpViewModel.isAutheticating)
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    final isValid =
                                        _form.currentState!.validate();

                                    if (!isValid ||
                                        loginSignUpViewModel.isLogin &&
                                            _selectedImage == null) {
                                      return;
                                    }
                                    _form.currentState!.save();
                                    loginSignUpViewModel
                                        .setPhoneNumber(_enterdNumber);
                                    loginSignUpViewModel
                                        .setUserName(_enterdUsername);
                                    if (loginSignUpViewModel.isLogin) {
                                      loginSignUpViewModel
                                          .setUserImage(_selectedImage!);
                                    }
                                    loginSignUpViewModel
                                        .requestForNumberVerification(context,
                                            () {
                                      Navigator.of(context).pushNamed(
                                        RoutesNames.varificationScreen,
                                      );
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    loginSignUpViewModel.isLogin
                                        ? 'Signup'
                                        : 'Login',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            fontSize: 16,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                            fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            if (loginSignUpViewModel.isAutheticating)
                              const CircularProgressIndicator(),
                            if (!loginSignUpViewModel.isAutheticating)
                              TextButton(
                                onPressed: () {
                                  loginSignUpViewModel.setIsLogIn(
                                      !loginSignUpViewModel.isLogin);
                                },
                                child: Text(
                                  loginSignUpViewModel.isLogin
                                      ? 'I already have an account. Login'
                                      : 'Create an account',
                                ),
                              ),
                          ],
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
}
