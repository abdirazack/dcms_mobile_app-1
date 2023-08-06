import 'dart:async';
import 'dart:convert';
import 'package:dcms_mobile_app/assets/component.dart';
import 'package:dcms_mobile_app/themes/darktheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../index.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(API_ENDPOINT('login/login.php')),
        body: {
          'username': usernameController.text,
          'password': passwordController.text,
        },
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final status = jsonData['status'];
        final data = jsonData['data'];
        print(jsonData);

        if (status == 'success' && data != null) {
          await saveResponseInSharedPreferences(data);
          await showSuccessAnimation();
          navigateToIndexPage();
        } else {
          showSnackBar('Invalid username or password.');
        }
      } else {
        showSnackBar('An error occurred during login.');
      }
    } on TimeoutException {
      showSnackBar('Request timeout. Please try again later.');
    } catch (e) {
      print(e.toString());
      showSnackBar('An unexpected error occurred. Please try again later.' +
          e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> showSuccessAnimation() async {
    final controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    controller.forward();

    await Future.delayed(Duration(milliseconds: 500));
    controller.dispose();
  }

  Future<void> saveResponseInSharedPreferences(
      Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('patient_id', data['patient_id']);
    prefs.setString('first_name', data['first_name']);
    prefs.setString('middle_name', data['middle_name']);
    prefs.setString('last_name', data['last_name']);
    prefs.setString('birth_date', data['birth_date']);
    prefs.setString('gender', data['gender']);
    prefs.setString('phone_number', data['phone_number']);
    prefs.setString('address', data['address']);
    prefs.setString('username', data['username']);
    prefs.setString('password', data['password']);
  }

  void navigateToIndexPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => IndexPage()),
    );
  }

  void showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;
    final textColor = isDarkMode ? Colors.black : Colors.white;
    final iHeadColor = isDarkMode ? Colors.white : Colors.blue[700];
    final containerColor = isDarkMode ? Colors.grey[800] : Colors.blue[50];
    final inputColor = isDarkMode ? Colors.grey : Colors.blue[800];
    final elevatedButtonColor = isDarkMode ? Colors.white : Colors.blue[800];
    final comColor = isDarkMode ? Colors.white : Colors.blue[800];

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 500,
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10),
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome to ",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: iHeadColor,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: comColor!),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: comColor),
                        ),
                        child: Text(
                          "Emirates",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: comColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Best Dental in Somalia",
                style: TextStyle(fontSize: 24, color: iHeadColor),
              ),
              SizedBox(height: 50),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  style: TextStyle(color: inputColor),
                  controller: usernameController,
                  decoration: InputDecoration(
                    focusColor: inputColor,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(width: 2, color: inputColor!),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(width: 1, color: inputColor),
                    ),
                    hintText: 'Enter your username',
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    focusColor: inputColor,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(width: 2, color: inputColor),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(width: 1, color: inputColor),
                    ),
                    hintText: 'Enter your Password',
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(MediaQuery.of(context).size.width, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                    backgroundColor: elevatedButtonColor,
                  ),
                  onPressed: isLoading ? null : login,
                  child: Center(
                    child: isLoading
                        ? CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.amber,
                            backgroundColor: Colors.amber[900],
                          )
                        : Text(
                            "Sign In",
                            style: TextStyle(
                              fontSize: 28,
                              color: textColor,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
