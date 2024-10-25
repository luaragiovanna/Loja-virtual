import 'package:firebase_project_store/src/models/user/user_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class SignupPage extends StatefulWidget {
  SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          toolbarHeight: 65,
          backgroundColor: Colors.brown.shade600,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          title: const Text(
            'Criar conta',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
          ),
          centerTitle: true,
        ),
        body:
            ScopedModelDescendant<UserModel>(builder: (context, child, model) {
          if (model.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(30),
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Nome',
                  ),
                  validator: (text) {
                    if (text!.isEmpty) {
                      return 'Nome invalido';
                    }
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    hintText: 'Endereço',
                  ),
                  validator: (text) {
                    if (text!.isEmpty) {
                      return 'Endereço invalido';
                    }
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
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
                    if (_formKey.currentState!.validate()) {
                      //map com validacoes
                      Map<String, dynamic> userData = {
                        "name": _nameController.text,
                        "email": _emailController.text,
                        "address": _addressController.text,
                      };
                      model.signUp(
                          userData: userData,
                          password: _passwordController.text,
                          onSuccess: _onSuccess,
                          onFaild: _onFaild);
                    }
                  },
                  child: const Text(
                    'Criar conta',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                )
              ],
            ),
          );
        }));
  }

  void _onSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Usuário criado com sucesso',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 7, 121, 41),
        duration: Duration(seconds: 2),
      ),
    );
    Future.delayed(
      Duration(seconds: 2),
    ).then((_) {
      Navigator.of(context).pop();
    });
  }

  void _onFaild() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Falha ao criar o usuario',
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: Color.fromARGB(210, 113, 5, 5),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
