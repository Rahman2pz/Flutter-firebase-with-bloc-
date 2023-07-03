import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:using_firebase/features/authentication/authentication_bloc.dart';
import 'package:using_firebase/features/form_validation/form_bloc.dart';
import 'package:using_firebase/view/home_view.dart';
import 'package:using_firebase/view/signup_view.dart';
import 'package:using_firebase/utils/constants.dart';
import 'package:using_firebase/widgets/signin/email_field.dart';
import 'package:using_firebase/widgets/signin/password_field.dart';
import 'package:using_firebase/widgets/signin/signin_navigate.dart';
import 'package:using_firebase/widgets/signin/submit_button.dart';

OutlineInputBorder border = const OutlineInputBorder(
    borderSide: BorderSide(color: Constants.kBorderColor, width: 3.0));

class SignInView extends StatelessWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MultiBlocListener(
      listeners: [
        BlocListener<FormBloc, FormsValidate>(
          listener: (context, state) {
            if (state.errorMessage.isNotEmpty) {
              showDialog(
                  context: context,
                  builder: (context) =>
                      ErrorDialog(errorMessage: state.errorMessage));
            } else if (state.isFormValid && !state.isLoading) {
              context.read<AuthenticationBloc>().add(AuthenticationStarted());
            } else if (state.isFormValidateFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(Constants.textFixIssues)));
            }
          },
        ),
        BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is AuthenticationSuccess) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const HomeView()),
                      (Route<dynamic> route) => false);
            }
          },
        ),
      ],
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.white),
          ),
          backgroundColor: Constants.kPrimaryColor,
          body: Center(
              child: SingleChildScrollView(
                child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Image.asset("assets/images/sign-in.png"),
                  RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(children: <TextSpan>[
                        TextSpan(
                            text: Constants.textSignInTitle,
                            style: TextStyle(
                              color: Constants.kBlackColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 30.0,
                            )),
                      ])),
                  SizedBox(height: size.height * 0.01),
                  const Text(
                    Constants.textSmallSignIn,
                    style: TextStyle(color: Constants.kDarkGreyColor),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: size.height * 0.02)),
                  const EmailField(),
                  SizedBox(height: size.height * 0.01),
                  const PasswordField(),
                  SizedBox(height: size.height * 0.01),
                  const SubmitButton(),
                  const SignInNavigate(),
                ]),
              ))),
    );
  }
}









