import 'dart:async';

import 'package:flutter/material.dart';

import '../services/api/api_service.dart';
import '../services/api/models/user.dart';

class UsersListScreen extends StatefulWidget {
  @override
  _UsersListScreenState createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  final ApiService _apiService = ApiService();
  List<User> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() {
      _isLoading = true;
    });

    final minLoadingTime = Future.delayed(Duration(seconds: 1));

    try {
      final users = await _apiService.getUsers();
      await minLoadingTime;

      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      await minLoadingTime;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load users')),
      );
    }
  }

  void _logout() async {
    await _apiService.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _navigateToUserDetail(User user) async {
    final result =
        await Navigator.pushNamed(context, '/user-detail', arguments: user);

    if (result == 'updated' || result == 'deleted') {
      _fetchUsers(); // Refrescar la lista después de editar o eliminar
    }
  }

  Future<void> _navigateToNewUser() async {
    final result = await Navigator.pushNamed(context, '/new-user');

    if (result == 'created') {
      _fetchUsers(); // Refrescar la lista después de crear un nuevo usuario
    }
  }

  Widget _buildUserTile(User user) {
    return Card(
      key: Key('user_tile_${user.id}'),
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 3,
      child: ListTile(
        key: Key('user_list_tile_${user.id}'),
        contentPadding: EdgeInsets.all(16.0),
        leading: CircleAvatar(
          backgroundColor: user.isActive ? Colors.green : Colors.red,
          child: Icon(
            user.isActive ? Icons.check : Icons.close,
            color: Colors.white,
          ),
        ),
        title: Text(
          user.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.0),
            Text('Email: ${user.email}', key: Key('user_email_${user.id}')),
            SizedBox(height: 2.0),
            Text('Age: ${user.age}', key: Key('user_age_${user.id}')),
            SizedBox(height: 2.0),
            Text('Status: ${user.isActive ? "Active" : "Inactive"}',
                key: Key('user_status_${user.id}')),
          ],
        ),
        onTap: () {
          _navigateToUserDetail(user);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users List'),
        actions: [
          IconButton(
            key: Key('refresh_button'),
            icon: Icon(Icons.refresh),
            onPressed: _fetchUsers,
          ),
          IconButton(
            key: Key('logout_button'),
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Stack(
        children: [
          _isLoading
              ? Center(
                  child:
                      CircularProgressIndicator(key: Key('loading_indicator')))
              : _users.isEmpty
                  ? Center(
                      child: Text(
                        'No hay elementos para mostrar',
                        key: Key('no_users_text'),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    )
                  : ListView.builder(
                      key: Key('users_list'),
                      itemCount: _users.length,
                      itemBuilder: (context, index) {
                        final user = _users[index];
                        return _buildUserTile(user);
                      },
                    ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: Key('add_user_button'),
        onPressed: _navigateToNewUser,
        child: Icon(Icons.add),
      ),
    );
  }
}
