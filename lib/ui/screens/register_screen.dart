import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/configs/pallette.dart';
import 'package:manga_nih/event_states/event_states.dart';
import 'package:manga_nih/ui/screens/home_screen.dart';
import 'package:manga_nih/ui/widgets/widgets.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late SnackbarBloc _snackbarBloc;
  late UserBloc _userBloc;
  late GlobalKey<FormState> _key;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late String? _passwordErrorText;
  late String? _emailErrorText;

  @override
  void initState() {
    // init bloc
    _snackbarBloc = BlocProvider.of<SnackbarBloc>(context);
    _userBloc = BlocProvider.of<UserBloc>(context);

    // init
    _passwordErrorText = null;
    _emailErrorText = null;

    // init form key
    _key = GlobalKey();

    // init controller
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  void _registerAction() {
    if (_key.currentState!.validate()) {
      // re-init error
      setState(() {
        _emailErrorText = null;
        _passwordErrorText = null;
      });

      String email = _emailController.text.trim();
      String name = _nameController.text.trim();
      String password = _passwordController.text.trim();
      String confirmPassword = _confirmPasswordController.text.trim();

      if (!EmailValidator.validate(email)) {
        setState(() => _emailErrorText = 'Email invalid');
      } else if (password != confirmPassword) {
        setState(() => _passwordErrorText = 'Password must be same');
      } else if (password.length < 6) {
        setState(() =>
            _passwordErrorText = 'Password should be at least 6 characters');
      } else {
        // register
        _userBloc.add(
          UserRegister(name: name, email: email, password: password),
        );
      }
    }
  }

  void _loginAction() {
    Navigator.pop(context);
  }

  void _blocListener(BuildContext context, UserState userState) {
    if (userState is UserFetchSuccess) {
      _snackbarBloc.add(SnackbarShow.custom(false, 'Welcome to Manga nih'));

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: ListView(
            physics: BouncingScrollPhysics(),
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
                            'Register Account',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Register a new account to read manga',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.grey.shade700),
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        InputField(
                          icon: Icons.person,
                          hintText: 'Name',
                          controller: _nameController,
                        ),
                        const SizedBox(height: 10.0),
                        InputField(
                          icon: Icons.email,
                          hintText: 'Email',
                          controller: _emailController,
                          errorText: _emailErrorText,
                        ),
                        const SizedBox(height: 10.0),
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
                          errorText: _passwordErrorText,
                        ),
                        const SizedBox(height: 25.0),
                        BlocConsumer<UserBloc, UserState>(
                          listener: _blocListener,
                          builder: (context, state) {
                            if (state is UserLoading) {
                              return LoginRegisterButton.loading();
                            }

                            return LoginRegisterButton(
                              label: 'Register',
                              onTap: _registerAction,
                            );
                          },
                        ),
                        const SizedBox(height: 25.0),
                        Row(
                          children: [
                            Text(
                              'Already registered ?',
                              style: Theme.of(context).textTheme.bodyText2!,
                            ),
                            const SizedBox(width: 5.0),
                            MaterialButton(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              onPressed: _loginAction,
                              child: Text(
                                'Login an account',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        color: Pallette.gradientStartColor),
                              ),
                            ),
                          ],
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
    );
  }
}