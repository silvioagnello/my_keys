import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_keys/helpers/prefs.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_password_generator/random_password_generator.dart';
import 'package:my_keys/models/keys.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _chaveController = TextEditingController();

  List<Keys> lista = [];

  void removerKey(int index) {
    setState(() {
      lista.removeAt(index);
    });
    Prefs.saveKey(lista);
  }

  void addKey({required Keys key}) {
    setState(() {
      lista.add(key);
      //_saveData();
    });
    Prefs.saveKey(lista);
    _chaveController.clear();
    _titleController.clear();
  }
  //
  // Future<File> _getFile() async {
  //   final directory = await getApplicationDocumentsDirectory();
  //
  //   return File("${directory.path}/data.json");
  // }
  //
  // Future<File> _saveData() async {
  //   String data = jsonEncode(lista);
  //
  //   final file = await _getFile();
  //   return file.writeAsString(data);
  // }
  //
  // Future<String?> _readData() async {
  //   try {
  //     final file = await _getFile();
  //
  //     return file.readAsString();
  //   } catch (e) {
  //     return null;
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // _readData().then((value) {
    //   List<dynamic> lista = jsonDecode(value!);
    // });
    Prefs.readKey().then((v) {
      if (v != null) {
        setState(() {
          lista = v.cast<Keys>();
          // print(lista);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: primaryColor,
      appBar: AppBar(
        title: const Text('My_Keys'),
      ),
      body: buildColumn(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Nova CHAVE',
        onPressed: _showDialog,
        child: Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.pink,
            ),
            child: const Icon(Icons.add)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.pink,
        // this creates a notch in the center of the bottom bar
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(
                Icons.home,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Icons.people,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            const SizedBox(
              width: 20,
            ),
            IconButton(
              icon: const Icon(
                Icons.notifications,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ],
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
