import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:using_firebase/features/form_validation/form_bloc.dart';
import 'package:using_firebase/utils/constants.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<FormBloc, FormsValidate>(
      builder: (context, state) {
        return state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
          width: size.width * 0.8,
          child: OutlinedButton(
            onPressed: !state.isFormValid
                ? () => context
                .read<FormBloc>()
                .add(const FormSubmitted(value: Status.signIn))
                : null,
            child: const Text(Constants.textSignIn),
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                    Constants.kPrimaryColor),
                backgroundColor: MaterialStateProperty.all<Color>(
                    Constants.kBlackColor),
                side: MaterialStateProperty.all<BorderSide>(
                    BorderSide.none)),
          ),
        );
      },
    );
  }
}