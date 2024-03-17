import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:safety_app/logic/models/user_model.dart';
import 'package:safety_app/logic/services/auth_service.dart';
import 'package:safety_app/logic/services/local_storage_service.dart';
import 'package:safety_app/screens/splash_screen.dart';
import 'package:safety_app/validators/validator.dart';
import 'package:safety_app/utils/ui_theme_extension.dart';

import '../components/custom_text_field.dart';
import '../logic/auth_ecxeption_handler.dart';
import '../utils/constants.dart';
import '../validators/form_validator_cubit.dart';

class RegisterScreen extends StatefulWidget{
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with Validator{
  //FORM
  bool _isPasswordShown = false;//make password visible or invisible
  final _formKey = GlobalKey<FormState>();//manage form state
  final FormValidatorCubit _formValidatorCubit = FormValidatorCubit();//manage form fields state
  final _formData = <String, String>{};//store form fields value

  late double screenHeight;
  bool isLoading = false;

  //AUTH
  final _authService = AuthService.auth;
  final _storageService = LocalStorageService.storage;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        //custom padding based on system
        child: isLoading
          ? const SplashScreen()
          : Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocSelector<FormValidatorCubit, FormValidatorState, AutovalidateMode>(
            bloc: _formValidatorCubit,
            //selector used to compute the derived state from the existing state in a reactive way
            selector: (state) => state.autoValidateMode,
            builder: (context, AutovalidateMode autoValidateMode) {
              return Form(
                key: _formKey,
                autovalidateMode: autoValidateMode,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //label
                      Text('REGISTER USER',style: context.t1),
                      SizedBox(height: screenHeight*0.03,),
                      //icon
                      const Image(
                        image: AssetImage('assets/user.png'),
                        height: 100,
                        width: 100,
                      ),
                      SizedBox(height: screenHeight*0.03,),
                      //name
                      CustomTextField(
                        hintText: 'enter name',
                        prefix: const Icon(Icons.person),
                        onValidate: validateName,
                        onChange: _formValidatorCubit.updateName,
                        onSave: (name){
                          _formData["name"] = name ?? "";
                        },
                        inputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                      ),
                      SizedBox(height: screenHeight*0.03,),
                      //email
                      CustomTextField(
                        hintText: 'enter email',
                        prefix: const Icon(Icons.person),
                        onValidate: validateEmail,
                        onChange:  _formValidatorCubit.updateEmail,
                        onSave: (email){
                          _formData["email"] = email ?? "";
                        },
                        inputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: screenHeight*0.03,),
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
                          icon: _isPasswordShown ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                        ),
                        onValidate: validatePassword,
                        onChange: _formValidatorCubit.updatePassword,
                        onSave: (password){
                          _formData["password"] = password ?? "";
                        },
                      ),
                      SizedBox(height: screenHeight*0.03,),
                      //rpassword
                      CustomTextField(
                        hintText: 'retype password',
                        isPassword: _isPasswordShown,
                        prefix: const Icon(Icons.vpn_key_rounded),
                        suffix: IconButton(
                          onPressed: (){
                            setState(() {
                              _isPasswordShown = !_isPasswordShown;
                            });
                          },
                          icon: _isPasswordShown ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                        ),
                        onValidate: (value) =>
                            validateConfirmPassword(
                              value,
                              _formValidatorCubit.state.password,
                            ),
                        onChange: _formValidatorCubit.updatePassword,
                        onSave: (rpassword){
                          _formData["rpassword"] = rpassword ?? "";
                        },
                      ),
                      SizedBox(height: screenHeight*0.03,),
                      //button
                      ElevatedButton(
                        onPressed: () async{
                          _register();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)
                            )
                        ),
                        child: Text('REGISTER', style: context.l1,),
                      ),
                    ],
                  ),
                )
                );
            },
          )
        ),
      ),
    );
  }

  void _register() async{
    setState(() { isLoading = true; });
    _formKey.currentState!.save();
    if(_formKey.currentState!.validate()){
      if(_formData['password'] != _formData['rpassword']){
        dialog(context, 'RETYPE PASSWORD!');
        return;
      }
      final status = await _authService.register(
          _formData['email']!,
          _formData['password']!,
        _formData['name']!
      ).whenComplete((){
        setState(() { isLoading = false; });
      });
      if (status == AuthStatus.successful) {
        //never show on boarding screen again
        await _storageService.writeSecureData(onBoardKey, "true");
        var db = FirebaseFirestore.instance
            .collection('users')
            .doc(_authService.getCurrentUser()!.uid);
        AppUserModel user = AppUserModel(
            id: _authService.getCurrentUser()!.uid,
            name: _formData['name'],
            email: _formData['email']
        );
        await db.set(user.toMap());
        context.go('/welcome/login');
      } else {
        dialog(context, AuthExceptionHandler.generateErrorMessage(status));
      }
    }
  }
}