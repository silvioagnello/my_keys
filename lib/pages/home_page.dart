import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_keys/models/user_model.dart';
import 'package:random_password_generator/random_password_generator.dart';
import 'package:my_keys/models/keys.dart';
import 'package:scoped_model/scoped_model.dart';

import '../blocs/login_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _loginBloc = LoginBloc();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _chaveController = TextEditingController();

  List<Keys> lista = [];

  void removerKey(int index) {
    Keys key = lista[index];
    FirebaseFirestore.instance
        .collection('chaves')
        .doc(key.title.toString())
        .delete();
    setState(() {
      lista.removeAt(index);
    });
    // Prefs.saveKey(lista);
  }

  void addKey({required Keys key}) {
    setState(() {
      lista.add(key);
    });

    FirebaseFirestore.instance
        .collection('chaves')
        .doc(key.title)
        .set({'chave': key.chave});

    //Prefs.saveKey(lista);

    _chaveController.clear();
    _titleController.clear();
  }

  getDataFirebase() async {
    Map<String, dynamic> val = <String, dynamic>{};
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('chaves').get();
    for (DocumentSnapshot item in querySnapshot.docs) {
      var dados = item['chave'];
      Keys Mkey = Keys(title: item.id, chave: dados);
      lista.add(Mkey);
    }
    return lista;
  }

  @override
  void initState() {
    super.initState();

    getDataFirebase().then((v) {
      // Prefs.readKey().then((v) {
      if (v != null) {
        setState(() {
          lista = v.cast<Keys>();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: Scaffold(
        //backgroundColor: primaryColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text('My_Keys (${lista.length.toString()})'),
        ),
        body: buildColumn(),
        floatingActionButton: SizedBox(
          height: 60,
          width: 60,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            shape: const CircleBorder(),
            clipBehavior: Clip.none,
            //   tooltip: 'Nova CHAVE',
            onPressed: _showDialog,
            child: const Icon(Icons.add, size: 45),
            // ),
          ),
        ),

        floatingActionButtonLocation:
            FloatingActionButtonLocation.endContained, //centerDocked,
        bottomNavigationBar: const BottomAppBar(
          color: Colors.pink,
          notchMargin: 6,
        ),
      ),
    );
  }

  buildColumn() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, index) {
              final item = lista[index];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: GestureDetector(
                    onTap: () {
                      final newItem = item;
                      _showDialog(key: newItem);
                    },
                    child: ListTile(
                      trailing: GestureDetector(
                          onTap: () {
                            var lastRemoved = item;
                            bool wantedRemoved = true;
                            final snack = SnackBar(
                              duration: const Duration(seconds: 8),
                              content: const Text('Chave será removida'),
                              action: SnackBarAction(
                                label: 'Continuar?',
                                onPressed: () {
                                  removerKey(index);
                                },
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snack);
                          },
                          child: const Icon(
                            size: 54,
                            Icons.remove_circle_outline_sharp,
                            //color: Colors.pinkAccent,
                          )),
                      title: Text(item.title),
                      subtitle: Text(
                        item.chave,
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  _showDialog({key}) async {
    var txtButton = 'Atualizar ';
    var txtHead = '';
    if (key == null) {
      txtButton = 'Adicionar ';
    } else {
      _titleController.text = key.title;
      _chaveController.text = key.chave;
    }
    txtHead = '${txtButton}Chave';

    showDialog(
      context: context,
      builder: (context) {
        /*Keys k = Keys(
          title: _titleController.text,
          chave: _chaveController.text,
        );*/

        return AlertDialog(
          actions: [
            TextButton(
              onPressed: () {
                String newPassword = '';
                if (_titleController.text.isNotEmpty) {
                  newPassword = getPassword(true, true, true, true, true, 10.0);
                }
                _chaveController.text = newPassword;
              },
              child: const Text('Gerar'),
            ),
            TextButton(
              onPressed: () async {
                _chaveController.text = '';
                _titleController.text = '';
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Keys M = Keys(
                  title: _titleController.text,
                  chave: _chaveController.text,
                );
                if (M.title.isNotEmpty) {
                  addKey(key: M);
                }
                Navigator.pop(context);
              },
              child: Text(txtButton),
            ),
          ],
          title: Text(txtHead),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: _textField(
                    c: _titleController,
                    f: true,
                    h: 'Digite o Título',
                    tit: 'Título'),
              ),
              _textField(
                  c: _chaveController,
                  f: false,
                  h: 'Digite a Chave',
                  tit: 'Chave'),
            ],
          ),
        );
      },
    );
  }

  _textField(
      {required TextEditingController c,
      required bool f,
      required String tit,
      required String h}) {
    return TextField(
      textInputAction: TextInputAction.next,
      controller: c,
      autofocus: f,
      decoration: InputDecoration(labelText: tit, hintText: h),
    );
  }

  String getPassword(c, u, l, s, a, d) {
    String np;

    final exp1 = RegExp(r"[0-9]");
    final exp2 = RegExp(r"[\W|_]");
    final exp3 = RegExp(r"[a-z]");
    final exp4 = RegExp(r"[A-Z]");

    bool? valid1;
    bool? valid2;
    bool? valid3;
    bool? valid4;

    np = '';
    final pass = RandomPasswordGenerator();
    valid1 = a;
    valid2 = s;
    valid3 = l;
    valid4 = u;

    for (var i = 0; i < 200; i++) {
      np = pass.randomPassword(
          letters: l,
          numbers: a,
          passwordLength: d,
          specialChar: s,
          uppercase: u);

      if (exp1.hasMatch(np) != valid1 ||
          exp2.hasMatch(np) != valid2 ||
          exp3.hasMatch(np) != valid3 ||
          exp4.hasMatch(np) != valid4) {
        continue;
      } else {
        break;
      }
    }

    return np;
  }
}
