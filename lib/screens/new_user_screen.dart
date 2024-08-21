import 'package:flutter/material.dart';
import 'package:test/services/api/models/user.dart';
import '../services/api/api_service.dart';

class NewUserScreen extends StatefulWidget {
  @override
  _NewUserScreenState createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  Future<void> _createUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final createUserInput = CreateUserInput(
          name: _nameController.text,
          email: _emailController.text,
          age: int.parse(_ageController.text),
        );
        await _apiService.createUser(createUserInput);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User created successfully')),
        );

        Navigator.pop(context, 'created'); // Envía el resultado de creación
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create user. Please try again.'),
            key: Key('create_failed_snackbar'),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New User', key: Key('new_user_appbar_title')),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                key: Key('new_user_name_field'),
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the name';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              TextFormField(
                key: Key('new_user_email_field'),
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              TextFormField(
                key: Key('new_user_age_field'),
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the age';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                textInputAction: TextInputAction.done,
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        key: Key('new_user_loading_indicator'),
                      ),
                    )
                  : ElevatedButton(
                      key: Key('create_user_button'),
                      onPressed: _createUser,
                      child: Text('Create User'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
