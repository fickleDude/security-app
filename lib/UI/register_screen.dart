import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safety_app/UI/splash_screen.dart';
import 'package:safety_app/UI/widgets/custom_button.dart';
import 'package:safety_app/UI/widgets/text_field_widget.dart';
import 'package:safety_app/utils/validator.dart';
import 'package:safety_app/utils/ui_theme_extension.dart';
import '../logic/handlers/auth_ecxeption_handler.dart';
import '../logic/handlers/text_field_input_handler.dart';
import '../logic/providers/user_provider.dart';
import '../utils/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterScreen extends StatefulWidget{
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with Validator{
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, String>{
    "email" : "",
    "password" : "",
    "rpassword" : "",
    "name" : ""
  };

  bool isLoading = false;
  bool _isPasswordShown = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: isLoading
            ? const SplashScreen()
            : Container(
            color: accentColor,
            alignment: Alignment.topCenter,
            padding: EdgeInsets.symmetric(vertical: height/15, horizontal: width/10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('регистрация', style: context.titlePrimary),
                  SizedBox(height: height/20,),
                  const Image(
                    image: AssetImage('assets/cropped_avatar.png'),
                    height: 150,
                    width: 150,
                  ),
                  SizedBox(height: height/30,),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomFormTextField(
                          hintText: "имя",
                          prefix: const Icon(Icons.person, size: 25, weight: 80,),
                          onChange: (name){
                            _formData.update("name", (value) => name ?? "");
                          },
                          validator: (name){
                            if (name == null || name.isEmpty) {
                              return 'Неверно введено имя';
                            }else if(!TextFieldInputHandler.isValidName(name)){
                                return 'Введите имя';
                            }
                            return null;
                          },
                        ), 
                        //email
                        CustomFormTextField(
                          hintText: "почта",
                          prefix: const Icon(Icons.person, size: 25, weight: 80,),
                          onChange: (email){
                            _formData.update("email", (value) => email ?? "");
                          },
                          validator: (email){
                            if (email == null || email.isEmpty
                                || !TextFieldInputHandler.isValidEmail(email)) {
                              return 'Введите почту';
                            } else if (!TextFieldInputHandler.isValidEmail(email)) {
                              return 'Неверно введена почта';
                            }
                            return null;
                          },
                        ),
                        //password
                        CustomFormTextField(
                          hintText: "пароль",
                          isVisible: _isPasswordShown,
                          prefix: const Icon(Icons.vpn_key_rounded, size: 25, weight: 80,),
                          suffix: IconButton(
                            onPressed: (){
                              setState(() {
                                _isPasswordShown = !_isPasswordShown;
                              });
                            },
                            icon: _isPasswordShown
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility),
                          ),
                          onChange: (password){
                            _formData.update("password", (value) => password ?? "");
                          },
                          validator: (password){
                            if (password == null || password.isEmpty
                                || !TextFieldInputHandler.isValidPassword(password)) {
                              return 'Неверно введен пароль';
                            }
                            return null;
                          },
                        ),
                        CustomFormTextField(
                          hintText: "повтор пароля",
                          isVisible: _isPasswordShown,
                          prefix: const Icon(Icons.vpn_key_rounded, size: 25, weight: 80,),
                          suffix: IconButton(
                            onPressed: (){
                              setState(() {
                                _isPasswordShown = !_isPasswordShown;
                              });
                            },
                            icon: _isPasswordShown
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility),
                          ),
                          onChange: (password){
                            _formData.update("rpassword", (value) => password ?? "");
                          },
                          validator: (password){
                            if (password == null || password.isEmpty
                                || _formData["rpassword"] != _formData["password"]) {
                              return 'Неверно введен пароль';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  //button
                  SizedBox(height: height/20,),
                  CustomButton(
                    label: "регистрация",
                    onPressed: () async{
                      _register();
                    },
                    color: backgroundColor,
                    labelStyle: context.subtitlePrimary!,
                    width: width/2,
                  ),
                ],
              ),
            )
        )
    );
  }

  void _register() async{
    //UPDATE FORM DATA MAP
    // _formKey.currentState!.save();
    //VALIDATE FIELDS
    if(_formKey.currentState!.validate()){
        //SET LOADING STATE
        setState(() { isLoading = true; });
        //REGISTER NEW USER IN FIREBASE AUTH
        await Provider.of<UserProvider>(context, listen: false)
            .register(_formData['email']!,_formData['password']!, _formData['name']!)
            .then((value){
          setState(() { isLoading = false; });
          if(!value){
            Fluttertoast.showToast(msg: AuthExceptionHandler
                .generateErrorMessage(Provider.of<UserProvider>(context, listen: false).status));
          }
        });
    }
  }
}