import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:safety_app/components/custom_text_field.dart';
import 'package:safety_app/logic/services/auth_service.dart';
import 'package:safety_app/logic/services/local_storage_service.dart';
import 'package:safety_app/screens/splash_screen.dart';
import 'package:safety_app/utils/constants.dart';
import 'package:safety_app/utils/ui_theme_extension.dart';
import 'package:safety_app/validators/validator.dart';

import '../logic/auth_ecxeption_handler.dart';
import '../logic/models/user_model.dart';
import '../logic/providers/app_user_provider.dart';
import '../validators/form_validator_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen> with Validator{
  bool _isPasswordShown = false;
  //uniquely identifies elements across the app and provides access to State
  final _formKey = GlobalKey<FormState>();
  final FormValidatorCubit _formValidatorCubit = FormValidatorCubit();
  final _formData = <String, String>{};

  final _authService = AuthService.auth;
  final _storageService = LocalStorageService.storage;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
        ? const SplashScreen()
        : SafeArea(
        //custom padding based on system
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocSelector<FormValidatorCubit, FormValidatorState, AutovalidateMode>(
            bloc: _formValidatorCubit,
            selector: (state) => state.autoValidateMode,
            builder: (context, AutovalidateMode autoValidateMode){
              return Form(
                key: _formKey,
                autovalidateMode: autoValidateMode,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //label
                    Text('USER LOGIN', style: context.t1),
                    //icon
                    const Image(
                      image: AssetImage('assets/user.png'),
                      height: 100,
                      width: 100,
                    ),
                    //email
                    CustomTextField(
                      hintText: 'enter email',
                      prefix: const Icon(Icons.person),
                      onValidate: validateEmail,
                      onChange: _formValidatorCubit.updateEmail,
                      onSave: (email){
                        _formData["email"] = email ?? "";
                      },
                      inputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    //password
                    CustomTextField(
                      hintText: 'enter password',
                      isPassword: _isPasswordShown,
                      prefix: const Icon(Icons.vpn_key_rounded),
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
                      onValidate: validatePassword,
                      onChange: _formValidatorCubit.updatePassword,
                      onSave: (password){
                        _formData["password"] = password ?? "";
                      },
                    ),
                    //button
                    ElevatedButton(
                      onPressed: () async{
                        _login();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)
                          )
                      ),
                      child: Text('LOGIN', style: context.l1,),
                    ),
                    //to register
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('DO NOT HAVE ACCOUNT?', style: context.l2,),
                        const SizedBox(width: 11,),
                        ElevatedButton(
                          onPressed: () {
                            context.go("/welcome/register");
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: backgroundColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)
                              )
                          ),
                          child: Text('CLICK HERE', style: context.l2,),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          )
        ),
      ),
    );
  }

  //LOGIC
  void _login() async{
    //show splash screen while login
    setState(() { isLoading = true; });
    _formKey.currentState!.save();
    if(_formKey.currentState!.validate()){
      final status = await _authService.login(
          _formData['email']!,
          _formData['password']!
      ).whenComplete((){
        setState(() { isLoading = false; });
      });
      if (status == AuthStatus.successful) {
        // set userinfo if sucess login.
        // this will rebuild the consumer in main.dart
        // and navigate to homescreen
        User currentUser = _authService.getCurrentUser()!;
        AppUserModel userToStore = AppUserModel(
            id: currentUser.uid,
            name: currentUser.displayName,
            email: currentUser.email
        );
        //set up app user
        context.read<AppUserProvider>().user = userToStore;
        // then save the user info
        await _storageService.writeSecureData(userKey, AppUserModel.userToJson(userToStore));
      } else {
        dialog(context, AuthExceptionHandler.generateErrorMessage(status));
      }
    }
  }


  void _resetPassword() async{
    final status = await _authService.resetPassword(_formData['email']!);
    dialog(context, AuthExceptionHandler.generateErrorMessage(status));
  }

}
