import 'package:firebase_project_store/src/models/user/user_model.dart';
import 'package:firebase_project_store/src/pages/signup/pages/signup_page.dart';

import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        toolbarHeight: 60,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
        ),
        backgroundColor: Colors.brown.shade700,
        title: Text(
          "Entrar",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SignupPage()));
            },
            icon: const Icon(Icons.login),
            color: Colors.white,
          ),
        ],
      ),
      body: ScopedModelDescendant<UserModel>(builder: (context, child, model) {
        if (model.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(30),
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (text) {
                  if (text!.isEmpty || !text.contains('@')) {
                    return 'Email invalido';
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  hintText: 'Senha',
                ),
                obscureText: true,
                validator: (text) {
                  if (text!.isEmpty || text.length < 7) {
                    return 'Senha invalida';
                  }
                },
              ),
              const SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      surfaceTintColor: Colors.white),
                  onPressed: () {
                    //LOGICA
                    if (_emailController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Insira seu email para recuperação',
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                          backgroundColor: Color.fromARGB(210, 113, 5, 5),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      model.resetPass(_emailController.text);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Confira sua caixa de entrada',
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                          backgroundColor: Color.fromARGB(210, 5, 32, 113),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: Text(
                    'Esqueci a senha',
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.brown.shade500),
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  backgroundColor: Colors.brown.shade800,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {}
                  model.signIn(
                    email: _emailController.text,
                    password: _passwordController.text,
                    onSuccess: _onSuccess,
                    onFail: _onFaild,
                  );
                },
                child: const Text(
                  'Entrar',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  void _onSuccess() {
    Navigator.of(context).pop();
  }

  void _onFaild() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Falha ao logar',
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: Color.fromARGB(210, 113, 5, 5),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
