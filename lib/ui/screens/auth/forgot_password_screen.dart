import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/models/models.dart';
import 'package:manga_nih/ui/configs/pallette.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/ui/widgets/widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _key = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final ForgotPasswordCubit _forgotPasswordCubit = ForgotPasswordCubit();
  String? _emailErrorText;

  @override
  void initState() {
    // init bloc

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();

    super.dispose();
  }

  void _sendCodeAction() {
    if (_key.currentState!.validate()) {
      // re-init error
      setState(() {
        _emailErrorText = null;
      });

      String email = _emailController.text.trim();

      if (!EmailValidator.validate(email)) {
        setState(() => _emailErrorText = 'Email invalid');
      } else {
        _forgotPasswordCubit.sendForgotPassword(email);
      }
    }
  }

  void _blocListener(BuildContext context, UserState userState) {
    if (userState is UserForgotPasswordSend) {
      SnackbarModel.custom(false, 'Check your email');
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
                              'Input your valid email',
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                          ),
                          const SizedBox(height: 25.0),
                          InputField(
                            icon: Icons.email,
                            hintText: 'Email',
                            controller: _emailController,
                            errorText: _emailErrorText,
                          ),
                          const SizedBox(height: 25.0),
                          BlocConsumer<ForgotPasswordCubit, UserState>(
                            listener: _blocListener,
                            builder: (context, state) {
                              if (state is UserLoading) {
                                return const PrimaryButton.loading();
                              }

                              return PrimaryButton(
                                label: 'Send code',
                                onTap: _sendCodeAction,
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
