import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:safety_app/logic/services/auth_service.dart';
import 'package:safety_app/logic/services/storage_service.dart';
import 'package:safety_app/validators/validator.dart';
import 'package:safety_app/utils/ui_theme_extension.dart';

import '../../components/custom_text_field.dart';
import '../../logic/auth_ecxeption_handler.dart';
import '../../logic/models/user_model.dart';
import '../../logic/providers/app_user_provider.dart';
import '../../utils/constants.dart';
import '../../validators/form_validator_cubit.dart';
import '../splash_screen.dart';

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

  final AuthService _authService = AuthService.auth;
  final StorageService _storageService = StorageService.storage;

  bool isLoading = false;

  @override
  void initState() {
    var user = Provider.of<AppUserProvider>(context,listen: false).user;
    _formValidatorCubit = FormValidatorCubit()..initForm(
        name: user.name ?? "",
        email: user.email ?? "",
        password: "",
        autoValidateMode: AutovalidateMode.disabled
    );
    _formData = <String, Object>{
      'name': user.name ?? "",
      'email': user.email ?? "",
      'password': "",
      'rpassword': ""
    };
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: isLoading
      ? const SplashScreen()
      : SafeArea(
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
                                _update();
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

  void _update() async{
    setState(() { isLoading = true; });
    _formKey.currentState!.save();
    if(_formData['password'] != _formData['rpassword']){
      dialog(context, 'RETYPE PASSWORD!');
      setState(() { isLoading = false; });
    }else if(_formKey.currentState!.validate()){
      //update user in firebase auth
      final status = await _authService.updateProfile(
            _formData['name'].toString(),
            _formData['email'].toString(),
            _formData['password'].toString()
        ).whenComplete(() => setState(() { isLoading = false; }));
      if (status == AuthStatus.successful) {
        //update info in local storage
        AppUserModel userToUpdate = AppUserModel(
            id: _authService.getCurrentUser()?.uid,
            name: _formData['name'].toString(),
            email: _formData['email'].toString()
        );
        //set up app user
        context.read<AppUserProvider>().user = userToUpdate;
        _storageService.updateSecureData(
            userKey,
            AppUserModel.userToJson(userToUpdate));
        var db = FirebaseFirestore.instance
            .collection('users')
            .doc(_authService.getCurrentUser()!.uid);
        await db.set(userToUpdate.toMap());
      } else {
        dialog(context, AuthExceptionHandler.generateErrorMessage(status));
      }
    }
  }
}