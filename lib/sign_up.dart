import 'package:flutter/material.dart';
import 'sign_up_controller.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final SignUpController _signUpControllerP5 = SignUpController();
  final _formKey = GlobalKey<FormState>();

  bool _passwordVisible = false;

  String? _validateEmail(String? value)
  {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // Regular expression for email validation
    const String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$";
    final RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up")),
        body: Padding(
          padding: EdgeInsets.all(100),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    )
                  ),
                  validator: _validateEmail,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Create a password',
                    hintText: 'must be 8 characters or more',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                  obscureText: !_passwordVisible,
                  validator: (value) {
                    if(value == null || value.length < 8){
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ButtonStyle(),
                  child: Text("Complete sign up"),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _signUpControllerP5.completeSignUP(
                        _emailController.text,
                        _passwordController.text,
                      );
                      Navigator.pushReplacementNamed(context, '/dashboard');
                    } else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please fill in all fields'),
                        ),
                      );
                    }
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text("Sign in instead"),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                )
              ],
            ),
          ),
        )
    );
  }
}
