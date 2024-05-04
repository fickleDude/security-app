import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:safety_app/UI/splash_screen.dart';
import 'package:safety_app/UI/widgets/custom_button.dart';
import 'package:safety_app/UI/widgets/text_field_widget.dart';
import 'package:safety_app/components/custom_text_field.dart';
import 'package:safety_app/logic/handlers/text_field_input_handler.dart';
import 'package:safety_app/logic/services/cloud_storage_service.dart';
import 'package:safety_app/utils/constants.dart';
import 'package:safety_app/utils/ui_theme_extension.dart';
import 'package:safety_app/validators/validator.dart';

import '../logic/handlers/auth_ecxeption_handler.dart';
import '../logic/providers/user_provider.dart';
import '../validators/form_validator_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen> with Validator{
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, String>{
    "email" : "",
    "password" : ""
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
                  Text('вход', style: context.titlePrimary),
                  SizedBox(height: height/20,),
                  const Image(
                    image: AssetImage('assets/cropped_avatar.png'),
                    height: 200,
                    width: 200,
                  ),
                  SizedBox(height: height/30,),
                  Form(
                    key: _formKey,
                    child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
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
                              if (password == null || password.isEmpty) {
                                return 'Неверно введен пароль';
                              }
                              return null;
                            },
                          ),
                        ],
                  ),
                ),
                  //button
                  SizedBox(height: height/30,),
                  CustomButton(
                    label: "вход",
                    onPressed: () async{
                      _login();
                    },
                    color: backgroundColor,
                    labelStyle: context.subtitlePrimary!,
                    width: 150,
                  ),
                  SizedBox(height: height/10,),
                   Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(children: [
                          Text('нет аккаунта?', style: context.bodyPrimary,),
                          Text('жми сюда', style: context.bodyPrimary,),
                        ],),
                        SizedBox(width: width/30,),
                        CustomButton(
                          label: "создать аккаунт",
                          onPressed: () {
                            context.go("/welcome/register");
                          },
                          color: primaryColor,
                          labelStyle: context.bodyAccent!,
                        ),
                      ],
                    ),
        ],
    ),
          )
    )
    );
  }

  //LOGIC
  void _login() async{
    //UPDATE FORM DATA MAP
    // _formKey.currentState!.save();
    if(_formKey.currentState!.validate()){
      //SET LOADING STATE
      setState(() { isLoading = true; });
      await Provider.of<UserProvider>(context, listen: false).signIn(
          _formData['email']!,
          _formData['password']!
      ).then((value){
        setState(() { isLoading = false; });
        if(!value){
          dialog(context, AuthExceptionHandler
              .generateErrorMessage(Provider.of<UserProvider>(context, listen: false).status));
        }
      });
    }
  }
}
