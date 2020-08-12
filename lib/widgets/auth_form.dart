import 'dart:io';

import 'package:chat_app/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final bool loading;

  AuthForm(this.submitFn, this.loading);
  final void Function(String email, String userName, String password,
      bool isLogin, BuildContext context,File image) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  bool _isLogin = true;
  File _userImageFile;

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Please Select an Image'),
        backgroundColor: Theme.of(context).errorColor,
      ));
    }

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(_userEmail, _userName, _userPassword, _isLogin, context,_userImageFile);
    }
  }

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(8),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_isLogin) UserImagePicker(_pickedImage),
                TextFormField(
                  key: ValueKey('email'),
                  onSaved: (value) {
                    _userEmail = value.trim();
                  },
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@'))
                      return 'Please Enter a Valid Email Address';
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'Email Address'),
                ),
                if (!_isLogin)
                  TextFormField(
                    key: ValueKey('username'),
                    onSaved: (value) {
                      _userName = value.trim();
                    },
                    validator: (value) {
                      if (value.isEmpty || value.length < 4)
                        return 'Short Username';
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(labelText: 'UserName'),
                  ),
                TextFormField(
                  key: ValueKey('password'),
                  onSaved: (value) {
                    _userPassword = value.trim();
                  },
                  validator: (value) {
                    if (value.isEmpty || value.length < 8)
                      return 'Short Password';
                    return null;
                  },
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Password'),
                ),
                SizedBox(
                  height: 12,
                ),
                if (widget.loading) CircularProgressIndicator(),
                if (!widget.loading)
                  RaisedButton(
                    child: Text(_isLogin ? 'Login' : 'Sign Up'),
                    onPressed: _trySubmit,
                  ),
                if (!widget.loading)
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text(_isLogin
                        ? 'Create New Account'
                        : 'I Already Have an Account! Login'),
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
