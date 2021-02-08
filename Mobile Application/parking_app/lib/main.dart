import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_app/handlers/LoginHandler.dart';
import 'package:parking_app/screens/Navigation.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    GetMaterialApp(
      home: App(),
      theme: ThemeData(
        primaryColor: Color(0xFFFF8E71),
        accentColor: Color(0xFF7ACAFF),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          throw ('Snapshot has an error!!');
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return Home();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );
  }
}

class Home extends StatelessWidget {
  // TODO: move this into another file
  final _formKey = GlobalKey<FormState>();
  RxBool _isShowingPassword = true.obs;
  RxString _errorMessage = ''.obs;
  RxString _email = ''.obs;
  RxString _password = ''.obs;
  RxBool _isLoading = false.obs;
  LoginHandler handler;

  @override
  Widget build(context) {
    const _orangeColor = Color(0xFFFF8E71);

    const _fieldBorder = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: Color(0xFFFF8E71), width: 2));
    const _transparentBorder = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: Color(0xFF808080), width: 2));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login Page',
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: ListView(
            physics: ClampingScrollPhysics(),
            padding: EdgeInsets.all(Get.width * 0.05),
            shrinkWrap: true,
            children: <Widget>[
              Container(
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 40),
                ),
                alignment: Alignment.center,
              ),
              Padding(padding: EdgeInsets.all(Get.height * 0.05)),
              TextFormField(
                cursorColor: Colors.purple,
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Enter your email',
                  focusedBorder: _fieldBorder,
                  border: _fieldBorder,
                  focusedErrorBorder: _fieldBorder,
                  enabledBorder: _transparentBorder,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  _email.value = value;
                  _email.refresh();
                  return null;
                },
              ),
              Padding(padding: EdgeInsets.all(Get.height * 0.02)),
              Obx(
                () => TextFormField(
                  obscureText: _isShowingPassword.value,
                  cursorColor: Colors.purple,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(Icons.remove_red_eye,
                          color: _isShowingPassword.value
                              ? _orangeColor
                              : Colors.purple),
                      onPressed: () => _isShowingPassword.toggle(),
                    ),
                    filled: true,
                    hintText: 'Enter your password',
                    focusedBorder: _fieldBorder,
                    focusedErrorBorder: _fieldBorder,
                    border: _fieldBorder,
                    enabledBorder: _transparentBorder,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    _password.value = value;
                    _password.refresh();
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(Get.height * 0.05),
              ),
              Obx(
                () => Text(
                  _errorMessage.value,
                  style: TextStyle(
                    color: Colors.red[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(0),
                child: Obx(
                  () => FlatButton(
                    onPressed: _isLoading.value
                        ? null
                        : () {
                            // Validate will return true if the form is valid, or false if
                            // the form is invalid.
                            if (_formKey.currentState.validate()) {
                              _isLoading.toggle();
                              handler = new LoginHandler(
                                  _email.value, _password.value);
                              if (handler.signIn() != false) {
                                Get.offAll(Navigation());
                              } else {
                                print('Error Loggin in.');
                                _isLoading.toggle();
                              }
                            }
                          },
                    color: _orangeColor,
                    splashColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 60,
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
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
