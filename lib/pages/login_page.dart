import 'package:flutter/material.dart';
import 'package:my_keys/blocs/login_bloc.dart';
import 'package:my_keys/widgets/text_field.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginBloc = LoginBloc();

  @override
  void initState() {
    _loginBloc.outState.listen((state) {
      switch (state) {
        case LoginState.SUCCESS:
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const HomePage()));
          break;
        case LoginState.FAIL:
          showDialog(
              context: context,
              builder: (context) => const AlertDialog(
                    title: Text("Erro"),
                    content: Text("Você não possui os privilégios necessários"),
                  ));
          break;
        case LoginState.LOADING:
        case LoginState.IDLE:
      }
    });
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<LoginState>(
        stream: _loginBloc.outState,
        initialData: LoginState.LOADING,
        builder: (context, snapshot) {
          switch (snapshot.data) {
            case null:
            case LoginState.LOADING:
              return const Center(child: CircularProgressIndicator());
            case LoginState.IDLE:
            case LoginState.SUCCESS:
            case LoginState.FAIL:
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/images/icons8-forgot-password-94.png',
                        scale: 1.0,
                      ),
                    ),
                    InputField(
                      icon: Icons.person_outline,
                      hint: 'Usuário',
                      obscure: false,
                      stream: _loginBloc.outEmail,
                      onChanged: _loginBloc.changeEmail,
                    ),
                    InputField(
                      icon: Icons.lock_outline,
                      hint: 'Senha',
                      obscure: true,
                      stream: _loginBloc.outPassw,
                      onChanged: _loginBloc.changePassw,
                    ),
                    StreamBuilder<bool>(
                        stream: _loginBloc.outSubmitValid,
                        builder: (context, snapshot) {
                          return Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: SizedBox(
                              height: 36,
                              child: ElevatedButton(
                                  onPressed: snapshot.hasData
                                      ? _loginBloc.submit
                                      : null,
                                  child: const Text('Entrar')),
                            ),
                          );
                        })
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}
