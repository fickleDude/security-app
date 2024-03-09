import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:safety_app/validators/validator.dart';
import 'package:safety_app/utils/ui_theme_extension.dart';

import '../components/custom_text_field.dart';
import '../utils/constants.dart';
import '../validators/form_validator_cubit.dart';

class ProfileScreen extends StatefulWidget{
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with Validator{
  bool _isPasswordShown = false;//make password visible or invisible
  final _formKey = GlobalKey<FormState>();//manage form state
  late final FormValidatorCubit _formValidatorCubit;//manage form fields state
  late final _formData; //store form fields value

  late double screenHeight;

  @override
  void initState() {
    _formValidatorCubit = FormValidatorCubit()..initForm(
        name: 'Joseph Kamal',
        email: 'josephkamal@gmail.com',
        password: 'password',
        autoValidateMode: AutovalidateMode.disabled
    );
    _formData = <String, Object>{
      'name': 'Joseph Kamal',
      'email': 'josephkamal@gmail.com',
      'password': 'password',
      'rpassword': 'password'
    };
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        //custom padding based on system
        child: Padding(
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
                          Text('MY PROFILE',style: context.t1),
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
                            initialValue: _formValidatorCubit.state.name,
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
                            initialValue: _formValidatorCubit.state.email,
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
                            initialValue: _formValidatorCubit.state.password,
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
                            initialValue: _formValidatorCubit.state.password,
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
                            onPressed: () {
                              if(_formKey.currentState!.validate()){
                                onSubmit();
                              }
                              // //onSubmit();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)
                                )
                            ),
                            child: Text('UPDATE', style: context.l1,),
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

  void onSubmit(){
    _formKey.currentState!.save();
    if(_formData['password'] != _formData['rpassword']){
      dialog(context, 'RETYPE PASSWORD!');
    }else{
      context.go("/home");
      // try {
      //   UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      //       email: formData['email'].toString(),
      //       password: formData['password'].toString()
      //   ).whenComplete(() => context.go("/welcome/login"));
      // } on FirebaseAuthException catch (e) {
      //   if (e.code == 'weak-password') {
      //     dialog(context, 'The password provided is too weak.');
      //     print('The password provided is too weak.');
      //   } else if (e.code == 'email-already-in-use') {
      //     dialog(context, 'The account already exists for that email.');
      //     print('The account already exists for that email.');
      //   }
      // } catch (e) {
      //   dialog(context, e.toString());
      //   print(e);
      // }
    }
  }
}