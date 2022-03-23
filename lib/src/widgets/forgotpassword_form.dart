import 'package:flutter/material.dart';
import 'package:flutter_unogame/src/widgets/input_text.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({ Key? key }) : super(key: key);

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  GlobalKey<FormState> _formKey = GlobalKey();
  // String _name = '';
  String _email = '';
  // String _password = '';
  _submit(){
    final forgotPassword = _formKey.currentState?.validate();
    print('ForgotPassword Form $forgotPassword');
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget> [
          InputText(
            hint: 'Email address',
            label: 'Email address',
            keyboard: TextInputType.emailAddress,
            icono: Icon(Icons.verified_user),
            onChanged: (data) {
              _email = (data);
            },
            validator: (data) {
              if (!data!.contains('@')) {
                return "Invalid email";
              }
              else if (data.trim().isEmpty){
                return "Invalid email";
              }
              return null;
            },
          ),
          Divider(
            height: 25.0,
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xE6CC0E08)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
              onPressed: _submit,  // poner lo de la pagina que han dicho estos,
              child: Text('Send email',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'FredokaOne',
                  fontSize: 25.0
                ),
              ),
            ),
          ),
          Divider(
            height: 25.0,
          ),
        ],
      )
    );
  }
}