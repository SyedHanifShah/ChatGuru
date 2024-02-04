import 'package:chat_app/utils/routes/routes.dart';
import 'package:chat_app/utils/routes/routes_names.dart';
import 'package:chat_app/viewmodel/contacts_view_model.dart';
import 'package:chat_app/viewmodel/chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'viewmodel/login_signup_view_model.dart';

final myTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xff8c52ff),
  ),
  textTheme: GoogleFonts.anaheimTextTheme(),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginSignUpViewModel()),
        ChangeNotifierProvider(create: (_) => ChatViewModel()),
        ChangeNotifierProvider(create: (_) => ContactsViewModel()),
      ],
      child: MaterialApp(
        title: 'FlutterChat',
        theme: myTheme,
        initialRoute: RoutesNames.splashScreen,
        onGenerateRoute: Routes.genrateRoutes,
      ),
    );
  }
}
