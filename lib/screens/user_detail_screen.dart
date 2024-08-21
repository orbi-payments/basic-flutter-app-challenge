import 'package:flutter/material.dart';
import '../services/api/api_service.dart';
import '../services/api/models/user.dart';

class UserDetailScreen extends StatefulWidget {
  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  bool _isActive = false;
  bool _isLoading = false;
  late User _user;
  final ApiService _apiService = ApiService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _user = ModalRoute.of(context)!.settings.arguments as User;
    _nameController.text = _user.name;
    _emailController.text = _user.email;
    _ageController.text = _user.age.toString();
    _isActive = _user.isActive;
  }

  Future<void> _updateUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final updateUserInput = UpdateUserInput(
          name: _nameController.text,
          email: _emailController.text,
          age: int.parse(_ageController.text),
          isActive: _isActive,
        );
        await _apiService.updateUser(_user.id, updateUserInput);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User updated successfully')),
        );

        setState(() {
          _isLoading = false;
        });

        Navigator.pop(
            context, 'updated'); // Envía el resultado de actualización
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update user. Please try again.'),
            key: Key('update_failed_snackbar'),
          ),
        );
      }
    }
  }

  Future<void> _deleteUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _apiService.deleteUser(_user.id);
      Navigator.pop(context, 'deleted'); // Envía el resultado de eliminación
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User deleted successfully')),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete user. Please try again.'),
          key: Key('delete_failed_snackbar'),
        ),
      );
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          key: Key('delete_confirmation_dialog'),
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this user?'),
          actions: [
            TextButton(
              key: Key('cancel_delete_button'),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              key: Key('confirm_delete_button'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteUser();
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
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
        title: Text('User Details', key: Key('user_detail_appbar_title')),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    key: Key('user_name_field'),
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    key: Key('user_email_field'),
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the email';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    key: Key('user_age_field'),
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
                  ),
                  SwitchListTile(
                    key: Key('user_is_active_switch'),
                    title: Text('Active'),
                    value: _isActive,
                    onChanged: (bool value) {
                      setState(() {
                        _isActive = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            key: Key('user_detail_loading_indicator'),
                          ),
                        )
                      : ElevatedButton(
                          key: Key('update_user_button'),
                          onPressed: _updateUser,
                          child: Text('Save Changes'),
                        ),
                ],
              ),
            ),
          ),
          if (!_isLoading)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: ElevatedButton(
                key: Key('delete_user_button'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                ),
                onPressed: _confirmDelete,
                child: Text('Delete User'),
              ),
            ),
        ],
      ),
    );
  }
}
