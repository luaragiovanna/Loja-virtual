import 'package:firebase_project_store/src/models/cart/cart_model.dart';
import 'package:firebase_project_store/src/models/user/user_model.dart';
import 'package:firebase_project_store/src/pages/home/home_page.dart';
import 'package:firebase_project_store/src/pages/login/pages/login_page.dart';
import 'package:firebase_project_store/src/pages/signup/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:scoped_model/scoped_model.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
        model: UserModel(),
        child:
            ScopedModelDescendant<UserModel>(builder: (context, child, model) {
          return ScopedModel<CartModel>(
            model: CartModel(
              model,
              user: model,
              products: [],
            ),
            child: MaterialApp(
              title: 'Virtual Store',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                primaryColor: Color.fromARGB(255, 161, 135, 193),
                useMaterial3: true,
              ),
              debugShowCheckedModeBanner: false,
              home: HomePage(),
            ),
          );
        }));
  }
}
