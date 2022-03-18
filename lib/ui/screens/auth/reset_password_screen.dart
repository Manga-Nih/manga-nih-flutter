import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/models/models.dart';
import 'package:manga_nih/ui/configs/pallette.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/ui/screens/screens.dart';
import 'package:manga_nih/ui/widgets/widgets.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String code;

  const ResetPasswordScreen({
    Key? key,
    required this.code,
  }) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _key = GlobalKey();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final ForgotPasswordCubit _forgotPasswordCubit = ForgotPasswordCubit();
  String? _passwordErrorText;
  String? _confirmPasswordErrorText;

  @override
  void initState() {
    // init bloc

    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  void _submitAction() {
    if (_key.currentState!.validate()) {
      // re-init error
      setState(() {
        _passwordErrorText = null;
        _confirmPasswordErrorText = null;
      });

      bool doResetPasswordScreen = true;
      String password = _passwordController.text.trim();
      String confirmPassword = _confirmPasswordController.text.trim();

      if (password.length < 6) {
        doResetPasswordScreen = false;

        setState(() =>
            _passwordErrorText = 'Password should be at least 6 characters');
      }

      if (confirmPassword.length < 6) {
        doResetPasswordScreen = false;

        setState(() => _confirmPasswordErrorText =
            'Confirm password should be at least 6 characters');
      }

      if (password != confirmPassword) {
        doResetPasswordScreen = false;

        setState(() {
          _passwordErrorText = 'Password must be same';
          _confirmPasswordErrorText = 'Password must be same';
        });
      }

      if (doResetPasswordScreen) {
        // reset password
        _forgotPasswordCubit.verifyCode(widget.code, password);
      }
    }
  }

  void _blocListener(BuildContext context, UserState userState) {
    if (userState is UserForgotPasswordSuccess) {
      SnackbarModel.custom(false, 'Success reset password, please login');

      Get.offAll(() => const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return BlocProvider<ForgotPasswordCubit>(
      create: (_) => _forgotPasswordCubit,
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 10.0),
                    width: screenSize.width * 0.9,
                    child: Form(
                      key: _key,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Forgot Password',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(color: Pallette.gradientEndColor),
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Recover your password, to start reading',
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                          ),
                          const SizedBox(height: 25.0),
                          InputField(
                            icon: Icons.vpn_key,
                            hintText: 'Password',
                            isPassword: true,
                            controller: _passwordController,
                            errorText: _passwordErrorText,
                          ),
                          const SizedBox(height: 10.0),
                          InputField(
                            icon: Icons.vpn_key,
                            hintText: 'Confirm Password',
                            isPassword: true,
                            controller: _confirmPasswordController,
                            errorText: _confirmPasswordErrorText,
                          ),
                          const SizedBox(height: 25.0),
                          BlocConsumer<ForgotPasswordCubit, UserState>(
                            listener: _blocListener,
                            builder: (context, state) {
                              if (state is UserLoading) {
                                return const PrimaryButton.loading();
                              }

                              return PrimaryButton(
                                label: 'Submit',
                                onTap: _submitAction,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
