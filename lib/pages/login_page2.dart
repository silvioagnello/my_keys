import 'package:flutter/material.dart';
import 'package:my_keys/pages/home_page.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/user_model.dart';

class LoginPage2 extends StatefulWidget {
  LoginPage2({super.key});

  @override
  State<LoginPage2> createState() => _LoginPage2State();
}

class _LoginPage2State extends State<LoginPage2> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _emailController = TextEditingController();

  final _passwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrar'),
        centerTitle: true,
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                TextFormField(
                  controller: _emailController,
                  validator: (msg) {
                    if (msg!.isEmpty || !msg.contains('@')) {
                      return 'Email inválido';
                    }
                  },
                  decoration: const InputDecoration(hintText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextFormField(
                  controller: _passwController,
                  validator: (msg) {
                    if (msg!.isEmpty || msg.length < 6) {
                      return 'Senha inválida';
                    }
                  },
                  decoration: const InputDecoration(hintText: 'Senha'),
                  keyboardType: TextInputType.text,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: ElevatedButton(
                      onPressed: () {
                        model.signIn(
                          email: _emailController.text,
                          pass: _passwController.text,
                          onSucess: _onSucess,
                          onFail: _onFail,
                        );

                        _emailController.clear();
                        _passwController.clear();
                      },
                      child: const Text('Entrar')),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {}
                    },
                    child: const Text('Esqueci a senha',
                        textAlign: TextAlign.right),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onFail() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Falha ao entrar'),
    ));
  }

  void _onSucess() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const HomePage(),
    ));
  }
}
