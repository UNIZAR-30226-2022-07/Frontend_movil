import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_unogame/src/widgets/input_text.dart';

class CodeForm extends StatefulWidget {
  const CodeForm({ Key? key }) : super(key: key);

  @override
  State<CodeForm> createState() => _CodeFormState();
}

class _CodeFormState extends State<CodeForm> {
  GlobalKey<FormState> _formKey = GlobalKey();
  String _code = '';
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          InputText(
            hint: 'codigo',
            label: 'codigo',
            keyboard: TextInputType.emailAddress,
            icono: const Icon(Icons.check),
            onChanged: (data) {
              _code = data;
            },
            validator: (data) {
              if (data!.trim().isEmpty) {
                return "Código inválido";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}


