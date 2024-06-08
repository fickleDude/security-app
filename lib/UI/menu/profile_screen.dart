import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safety_app/utils/validator.dart';
import 'package:safety_app/utils/ui_theme_extension.dart';

import '../../logic/handlers/auth_ecxeption_handler.dart';
import '../../logic/handlers/text_field_input_handler.dart';
import '../../logic/providers/user_provider.dart';
import '../../utils/constants.dart';
import '../splash_screen.dart';
import '../widgets/custom_button.dart';
import '../widgets/text_field_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileScreen extends StatefulWidget{
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with Validator{
  final _formKey = GlobalKey<FormState>();
  late Map<String, String> _formData;

  bool isLoading = false;

  @override
  void initState() {
    var user = Provider.of<UserProvider>(context,listen: false).user;
    _formData = <String, String>{
      'name': user?.displayName ?? "",
      'email': user?.email ?? ""
    };
  }

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
                  Text('профиль', style: context.titlePrimary),
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
                        CustomFormTextField(
                          hintText: _formData["name"],
                          prefix: const Icon(Icons.person, size: 25, weight: 80,),
                          onChange: (name){
                            _formData.update("name", (value) => name ?? "");
                          },
                          validator: (name){
                            if (name == null || name.isEmpty) {
                              return 'Введите имя';
                            }
                            return null;
                          },
                        ),
                        CustomFormTextField(
                          hintText:  _formData['email'],
                          prefix: const Icon(Icons.email, size: 25, weight: 80,),
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
                      ],
                    ),
                  ),
                  //button
                  SizedBox(height: height/30,),
                  CustomButton(
                    label: "обновить",
                    onPressed: () async{
                      _update();
                    },
                    color: backgroundColor,
                    labelStyle: context.subtitlePrimary!,
                    width: 170,
                  ),
                  SizedBox(height: height/10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(children: [
                        Text('забыл пароль?', style: context.bodyPrimary,),
                        Text('жми сюда', style: context.bodyPrimary,),
                      ],),
                      SizedBox(width: width/30,),
                      CustomButton(
                        label: "сбросить пароль",
                        onPressed: () async{
                          _reset();
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

  void _update() async {
    //UPDATE FORM DATA MAP
    _formKey.currentState!.save();
    //VALIDATE FORM FIELDS
    if (_formKey.currentState!.validate()) {
      //SET LOADING STATE
      setState(() {
        isLoading = true;
      });
      //UPDATE USER IN FIREBASE AUTH
      await Provider.of<UserProvider>(context, listen: false).updateProfile(
        _formData['email'].toString(),
        _formData['name'].toString(),
      ).then((value) {
        setState(() {
          isLoading = false;
        });
        if (!value) {
          Fluttertoast.showToast(msg: AuthExceptionHandler
              .generateErrorMessage(Provider
              .of<UserProvider>(context, listen: false)
              .status));
        }else{
          Fluttertoast.showToast(msg: "Профиль обновлен");
        }
      });
    }
  }

  void _reset() async {
      setState(() {
        isLoading = true;
      });
      //UPDATE USER IN FIREBASE AUTH
      await Provider.of<UserProvider>(context, listen: false).resetPassword(
        _formData['email'].toString(),
      ).then((value) {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

