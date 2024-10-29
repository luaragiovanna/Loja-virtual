import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  late FirebaseAuth _auth = FirebaseAuth.instance;
  UserCredential? firebaseUser;
  
  static UserModel of(BuildContext contex) => ScopedModel.of<UserModel>(contex);

  Map<String, dynamic> userData = Map(); //vai ter nome email address
  bool isLoading = false;

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _loadCurrentUser();
  }

  void signUp(
      {required Map<String, dynamic> userData,
      required String password,
      required VoidCallback onSuccess,
      required VoidCallback onFaild}) {
    isLoading = true;
    notifyListeners();

    _auth
        .createUserWithEmailAndPassword(
      email: userData["email"],
      password: password,
    ) //passando email e senha
        .then((user) async {
      //usuario do firebase
      firebaseUser = user; //passa usuario
      await _saveUserData(userData);
      onSuccess(); //se funcionar passa essa funcao
      //isLoading = false;
    }).catchError((e) {
      print(e);
      onFaild(); //se der erro
      //isLoading = false;
      //notifyListeners();
    }).whenComplete(() {
      isLoading = false;
      notifyListeners();
    });
  }

  void signIn(
      {required String email,
      required String password,
      required VoidCallback onSuccess,
      required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();
    //await Future.delayed(Duration(seconds: 3));
    //isLoading = false;
    //notifyListeners();
    _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((user) {
      //sucesso savar usuario
      firebaseUser = user;
      print('user salvo');
      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void resetPass(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await FirebaseFirestore
        .instance //salva  os dados na colecao "users" no documento correspondente ao id do usuario
        .collection("users")
        .doc(firebaseUser!.user!.uid)
        .set(userData);
  }

  void signOut() async {
    await _auth.signOut();
    //resetar dados do usuario
    firebaseUser = null;
    notifyListeners(); //estado do usuario mudou
  }

  Future<Null> _loadCurrentUser() async {
    User? firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      print("User UID: ${firebaseUser.uid}");

      if (userData["name"] == null) {
        DocumentSnapshot<Map<String, dynamic>> docUser = await FirebaseFirestore
            .instance
            .collection("users")
            .doc(firebaseUser.uid)
            .get();

        if (docUser.exists) {
          userData = docUser.data()!;
          print("User data loaded: $userData");
        } else {
          print("Documento do usuário não encontrado.");
        }
      }
    } else {
      print("Nenhum usuário está autenticado.");
    }
    notifyListeners();
  }
}
//SCOPED MODEL (ESPECIFICA O MODEL) MODEL CONTEM ESTADO DO LOGINE FUNCAO Q MODIFICA O ESTADO, AO MODIFICAR ESTADO, NOTIFICA LISTENER E TUDO Q TA DENTRO DO SCOPED É RECRIADO NA TELA