import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'sql_helper.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isStudentChecked = false;
  bool _isTeacherChecked = false;

  Future<void> _register() async {
    if (_nameController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _emailController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please fill all fields.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Passwords do not match.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final role = _isStudentChecked ? 'student' : 'teacher';
    print(
        "Registering user: ${_nameController.text}, ${_usernameController.text}, ${_passwordController.text}, ${_emailController.text}, $role"); // Debug log

    if (!kIsWeb) {
      await DBHelper().newUser(
        _nameController.text,
        _usernameController.text,
        _passwordController.text,
        _emailController.text,
        role,
      );

      await DBHelper()
          .printUsers(); // Tambahkan ini untuk mencetak pengguna ke konsol

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Registration successful!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Registration is not supported on web platform.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Kata sandi'),
              obscureText: true,
            ),
            TextFormField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(labelText: 'Ulangi kata sandi'),
              obscureText: true,
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Checkbox(
                  value: _isStudentChecked,
                  onChanged: (value) {
                    setState(() {
                      _isStudentChecked = value!;
                      if (value) _isTeacherChecked = false;
                    });
                  },
                ),
                Text('Student'),
                Checkbox(
                  value: _isTeacherChecked,
                  onChanged: (value) {
                    setState(() {
                      _isTeacherChecked = value!;
                      if (value) _isStudentChecked = false;
                    });
                  },
                ),
                Text('Teacher'),
              ],
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _register,
              child: Text('Daftar'),
            ),
          ],
        ),
      ),
    );
  }
}
