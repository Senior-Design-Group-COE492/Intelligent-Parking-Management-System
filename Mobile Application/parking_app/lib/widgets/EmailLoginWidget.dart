import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_app/handlers/LoginHandler.dart';

class EmailLoginWidget extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final RxBool _isShowingPassword = true.obs;
  final RxString _errorMessage = ''.obs;
  final RxString _email = ''.obs;
  final RxString _password = ''.obs;
  final RxBool _isLoading = false.obs;
  LoginHandler handler;

  @override
  Widget build(context) {
    final _orangeColor = context.theme.primaryColor;
    final _lightOrangeColor = Color(0xFFFFBFA0);
    final _lightBlueColor = context.theme.accentColor;
    final _fieldBorder = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: _orangeColor, width: 2));
    final _transparentBorder = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: Colors.grey[300], width: 2));

    return Scaffold(
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
                cursorColor: Colors.black,
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
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(Icons.remove_red_eye,
                          color: _isShowingPassword.value
                              ? Colors.grey[600]
                              : _lightBlueColor),
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
                    color: Colors.red[900],
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
                        : () async {
                            // Validate will return true if the form is valid, or false if
                            // the form is invalid.
                            if (_formKey.currentState.validate()) {
                              _isLoading.toggle();
                              if (await LoginHandler.signIn(
                                      _email.value, _password.value) !=
                                  false) {
                                Get.back();
                              } else {
                                print('Error Loggin in.');
                                _isLoading.toggle();
                              }
                            }
                          },
                    color: _orangeColor,
                    disabledColor: _lightOrangeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 52,
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
