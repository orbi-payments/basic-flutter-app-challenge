import 'package:flutter/material.dart';

import '../services/api/api_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _apiService.login(
            _usernameController.text, _passwordController.text);
        Navigator.pushReplacementNamed(context, '/users');
      } catch (e) {
        debugPrint(e.toString());
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              key: Key('login_failed_snackbar'),
              content: Text('Login failed. Please check your credentials.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login', key: Key('login_appbar_title')),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                key: Key('username_field'),
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              TextFormField(
                key: Key('password_field'),
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        key: Key('login_loading_indicator'),
                      ),
                    )
                  : ElevatedButton(
                      key: Key('login_button'),
                      onPressed: _login,
                      child: Text('Login'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
