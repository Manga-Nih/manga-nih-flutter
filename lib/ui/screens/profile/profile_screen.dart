import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/core/core.dart';
import 'package:manga_nih/models/models.dart';
import 'package:manga_nih/ui/screens/screens.dart';
import 'package:manga_nih/ui/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserBloc _userBloc;
  late EmailVerificationCubit _emailVerificationCubit;

  @override
  void initState() {
    // init bloc
    _userBloc = BlocProvider.of<UserBloc>(context);
    _emailVerificationCubit = BlocProvider.of(context);

    super.initState();
  }

  void _editProfileAction() {
    Get.to(() => const EditProfileScreen());
  }

  void _favoriteAction() {
    Get.to(() => const ListFavoriteHistoryScreen(
        section: FavoriteHistorySection.favorite));
  }

  void _historyAction() {
    Get.to(() => const ListFavoriteHistoryScreen(
        section: FavoriteHistorySection.history));
  }

  void _feedbackAction() {
    Get.to(() => BlocProvider(
          create: (context) => FeedbackBloc(),
          child: const FeedbackScreen(),
        ));
  }

  void _logoutAction() async {
    showDialog(
      context: context,
      builder: (context) {
        return LogoutDialog(
          onLogout: () async {
            await _userBloc.userLogout();
          },
        );
      },
    );
  }

  Future<void> _freepikAction() async {
    await launch(Constants.freepik);
  }

  void _verifyEmailAction() {
    _emailVerificationCubit.sendEmailVerification();
  }

  void _emailVerificationListener(BuildContext context, UserState state) {
    if (state is UserVerificationEmailSent) {
      SnackbarModel.custom(false, 'Check your email to verify');
    }

    if (state is UserEmailVerified) {
      SnackbarModel.custom(false, 'Your email has been verified');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmailVerificationCubit, UserState>(
      listener: _emailVerificationListener,
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                _buildHeader(),
                const SizedBox(height: 20.0),
                _checkEmailVerified(),
                const SizedBox(height: 20.0),
                _buildBody(),
                const SizedBox(height: 30.0),
                LogoutButton(onPressed: _logoutAction),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Wrap(
            children: [
              GestureDetector(
                onTap: _freepikAction,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 1.0,
                        blurRadius: 2.0,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    children: const [
                      Text('App Icon by'),
                      SizedBox(height: 5.0),
                      Text('freepik/rochakshukla'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: Colors.grey),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 2.0,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          return Row(
            children: [
              (state is UserFetchSuccess)
                  ? Avatar.network(image: state.user.photoURL)
                  : Avatar(),
              const SizedBox(width: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (state is UserFetchSuccess) ? state.user.displayName! : '',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    (state is UserFetchSuccess) ? state.user.email! : '',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.expand_more),
            ],
          );
        },
      ),
    );
  }

  Widget _checkEmailVerified() {
    return BlocBuilder<EmailVerificationCubit, UserState>(
      builder: (context, state) {
        if (!_emailVerificationCubit.user.emailVerified) {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 2.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your email not verified',
                  style: TextStyle(color: Colors.white),
                ),
                MaterialButton(
                  minWidth: 100.0,
                  onPressed: _verifyEmailAction,
                  color: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: (state is UserLoading)
                      ? const SizedBox(
                          width: 20.0,
                          height: 20.0,
                          child: LoadingIndicator(
                            indicatorType: Indicator.ballPulse,
                            colors: [Colors.white],
                          ),
                        )
                      : const Text(
                          'Verify now',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        ProfileButton(
          label: 'Edit Profile',
          icon: Icons.edit,
          onPressed: _editProfileAction,
        ),
        const SizedBox(height: 10.0),
        ProfileButton(
          label: 'Favorite',
          icon: Icons.favorite_border_outlined,
          onPressed: _favoriteAction,
        ),
        const SizedBox(height: 10.0),
        ProfileButton(
          label: 'History',
          icon: Icons.history_outlined,
          onPressed: _historyAction,
        ),
        const SizedBox(height: 10.0),
        ProfileButton(
          label: 'Feedback',
          icon: Icons.report_problem,
          onPressed: _feedbackAction,
        ),
      ],
    );
  }
}
