import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:safety_app/components/custom_text_field.dart';
import 'package:safety_app/utils/constants.dart';
import 'package:safety_app/utils/ui_theme_extension.dart';
import 'package:safety_app/validators/validator.dart';

import '../validators/form_validator_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen> with Validator{
  bool isPasswordShown = false;
  //uniquely identifies elements across the app and provides access to State
  final formKey = GlobalKey<FormState>();
  final FormValidatorCubit _formValidatorCubit = FormValidatorCubit();
  final formData = <String, Object>{};


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        //custom padding based on system
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocSelector<FormValidatorCubit, FormValidatorState, AutovalidateMode>(
            bloc: _formValidatorCubit,
            selector: (state) => state.autoValidateMode,
            builder: (context, AutovalidateMode autoValidateMode){
              return Form(
                key: formKey,
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
                        formData["email"] = email ?? "";
                      },
                      inputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    //password
                    CustomTextField(
                      hintText: 'enter password',
                      isPassword: isPasswordShown,
                      prefix: const Icon(Icons.vpn_key_rounded),
                      suffix: IconButton(
                        onPressed: (){
                          setState(() {
                            isPasswordShown = !isPasswordShown;
                          });
                        },
                        icon: isPasswordShown
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                      ),
                      onValidate: validatePassword,
                      onChange: _formValidatorCubit.updatePassword,
                      onSave: (password){
                        formData["password"] = password ?? "";
                      },
                    ),
                    //button
                    ElevatedButton(
                      onPressed: () {
                        if(formKey.currentState!.validate()){
                          onSubmit();
                        }
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

  void onSubmit(){
    formKey.currentState!.save();
    context.go("/home");
    // try {
    //   UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
    //       email: formData['email'].toString(),
    //       password: formData['password'].toString()
    //   );
    //   if(userCredential.user != null){
    //     context.go("/home");
    //   }
    // } on FirebaseAuthException catch (e) {
    //   if (e.code == 'user-not-found') {
    //     dialog(context, 'No user found for that email.');
    //     print('No user found for that email.');
    //   } else if (e.code == 'wrong-password') {
    //     dialog(context, 'Wrong password provided for that user.');
    //     print('Wrong password provided for that user.');
    //   }
    // }
  }

}
