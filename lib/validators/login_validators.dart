import 'dart:async';

mixin class LoginValidators {
  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains('@')) {
      sink.add(email);
    } else {
      sink.addError('Insira um email válido');
    }
  });

  final validatePassw =
      StreamTransformer<String, String>.fromHandlers(handleData: (passw, sink) {
    if (passw.length > 5) {
      sink.add(passw);
    } else {
      sink.addError('Senha inválida. Mínimo de 6 dígitos');
    }
  });
}
