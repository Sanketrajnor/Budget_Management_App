import 'package:budget_tracker/screens/login.dart';
import 'package:budget_tracker/services/auth_service.dart';
import 'package:budget_tracker/utils/appvalidator.dart';
import 'package:flutter/material.dart';

class SignUpView extends StatefulWidget {
  SignUpView({super.key});
  @override
  State<SignUpView> createState() => _SignUpViewState();
}
class _SignUpViewState extends State<SignUpView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  var authService = AuthService();
  var isLoader = false;
  var _passwordVisible = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });

      var data = {
        "username": _userNameController.text,
        "email": _emailController.text,
        "phone": _phoneController.text,
        "password": _passwordController.text,
        'remainingAmount' : 0,
        'totalCredit' : 0,
        'totalDebit' : 0,
      };
      await authService.createUser(data, context);
      setState(() {
      isLoader = false;
      }); 
    }
}

  var appValidator = AppValidator();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
          appBar: AppBar(
          title: const Text(
            "FinTrack",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28, // Set the font size
              fontWeight: FontWeight.bold, // Set the font weight
              color: Colors.white, // Set the font color
            ),
          ),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 194, 28, 78),
        ),

        backgroundColor: Color.fromARGB(255, 42, 41, 41),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 36.0,
                ),
                Text("Create New Account",
                textAlign: TextAlign.center, 
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 28,
                fontWeight: FontWeight.bold),),
                const SizedBox(
                  height: 36.0,
                ),
                TextFormField(
                  controller: _userNameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  decoration: _buildInpDec("Username", Icons.person),
                  validator: appValidator.validateUsername,
                ),
                const SizedBox(
                  height: 26.0,
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  decoration: _buildInpDec1("Password", Icons.lock,_passwordVisible),
                  validator: appValidator.validatePassword,
                ),
                const SizedBox(
                  height: 26.0,
                ),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: _buildInpDec("Email", Icons.email),
                  validator: appValidator.validateEmail,
                ),
                const SizedBox(
                  height: 26.0,
                ),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: _buildInpDec("Phone Number", Icons.call),
                  validator: appValidator.validatePhoneNum,
                ),
                const SizedBox(
                  height: 56.0,
                ),
                SizedBox(
                  height: 65,
                  width: 200,
                  child: ElevatedButton(
                    onPressed: (){
                      isLoader ? print("Loading") : _submitForm();
                    },
                    child:
                    isLoader ? Center(child: CircularProgressIndicator())
                    : Text("REGISTER"),
                    style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 85, 0),
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold, // Make the text bold
                    ),
                  ),
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                TextButton(onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginView()),
                  );
                },child:  Text("Login Now", 
                style: TextStyle(color: Color.fromARGB(255, 255, 85, 0),
                fontSize: 22,
                // decoration: TextDecoration.underline,
                // decorationColor: Color.fromARGB(255, 252, 0, 135),
                ),
                ),)
                
              ],
            ),
          ),
        ),
      ),
    );
  }
  InputDecoration _buildInpDec(String label, IconData suffixIcon){
    return InputDecoration(
      fillColor: Color.fromARGB(170, 73, 72, 72),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(
        color: Color.fromARGB(53, 36, 36, 35))),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 255, 255, 255))),
      filled: true,
      labelStyle: TextStyle(color: Color.fromARGB(255, 147, 145, 145)),
      labelText: label,
      suffixIcon: Icon(suffixIcon, color: Color.fromARGB(255, 168, 168, 168)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)));
  }
  InputDecoration _buildInpDec1(String label, IconData suffixIcon, bool visible) {
  return InputDecoration(
    fillColor: Color.fromARGB(170, 73, 72, 72),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromARGB(53, 36, 36, 35))),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromARGB(255, 255, 255, 255))),
    filled: true,
    labelStyle: TextStyle(color: Color.fromARGB(255, 147, 145, 145)),
    labelText: label,
    suffixIcon: IconButton(
      icon: Icon(
        visible ? Icons.visibility_off : Icons.visibility,
        color: Color.fromARGB(255, 168, 168, 168),
      ),
      onPressed: () {
        setState(() {
          _passwordVisible = !_passwordVisible;
        });
      },
    ),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
  );
}
}