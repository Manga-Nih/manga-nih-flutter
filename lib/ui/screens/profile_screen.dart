import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/configs/pallette.dart';
import 'package:manga_nih/event_states/event_states.dart';
import 'package:manga_nih/ui/screens/screens.dart';
import 'package:manga_nih/ui/widgets/widgets.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late GlobalKey<FormState> _key;
  late SnackbarBloc _snackbarBloc;
  late UserBloc _userBloc;
  late TextEditingController _editNameController;

  @override
  void initState() {
    // init bloc
    _snackbarBloc = BlocProvider.of<SnackbarBloc>(context);
    _userBloc = BlocProvider.of<UserBloc>(context);

    // init key
    _key = GlobalKey();

    // init controller
    _editNameController = TextEditingController();

    // set name
    UserState state = _userBloc.state;
    if (state is UserFetchSuccess) {
      _editNameController.text = state.name;
    }

    super.initState();
  }

  @override
  void dispose() {
    _editNameController.dispose();

    super.dispose();
  }

  void _editNameAction() {
    final Size screenSize = MediaQuery.of(context).size;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text('Edit your name'),
          content: Container(
            width: screenSize.width * 0.7,
            child: Wrap(
              children: [
                Form(
                  key: _key,
                  child: Column(
                    children: [
                      InputField(
                        hintText: 'Name',
                        icon: Icons.edit,
                        controller: _editNameController,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            MaterialButton(
              onPressed: () => Navigator.pop(context),
              minWidth: 100.0,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              color: Pallette.buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Text('Nah, i like my current name'),
            ),
            MaterialButton(
              onPressed: () {
                if (_key.currentState!.validate()) {
                  String name = _editNameController.text.trim();

                  _userBloc.add(UserUpdateProfile(name: name));
                  _snackbarBloc.add(
                    SnackbarShow.custom(false, 'Success update your name'),
                  );

                  Navigator.pop(context);
                }
              },
              minWidth: 70.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Text('Save...'),
            ),
          ],
        );
      },
    );
  }

  void _logoutAction() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text(
            'Log out',
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Colors.red),
          ),
          content: Text('Are you sure want to log out ?'),
          actions: [
            MaterialButton(
              onPressed: () => Navigator.pop(context),
              color: Pallette.buttonColor,
              minWidth: 100.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Text('I will stay'),
            ),
            MaterialButton(
              onPressed: () async {
                await _userBloc.userLogout();
                _snackbarBloc.add(SnackbarShow.custom(false, 'Bye bye...'));

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => SplashScreen()),
                    (route) => false);
              },
              minWidth: 70.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Text(
                'Yes...',
                style: Theme.of(context)
                    .textTheme
                    .button!
                    .copyWith(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              _buildHeader(),
              const SizedBox(height: 40.0),
              _buildBody(),
              const SizedBox(height: 30.0),
              LogoutButton(onPressed: _logoutAction),
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
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 2.0,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Avatar(),
          const SizedBox(width: 20.0),
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (state is UserFetchSuccess) ? state.name : '',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    (state is UserFetchSuccess) ? state.email : '',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              );
            },
          ),
          const Spacer(),
          Icon(Icons.expand_more),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        ProfileButton(
          label: 'Edit Name',
          icon: Icons.edit,
          onPressed: _editNameAction,
        ),
        const SizedBox(height: 10.0),
        ProfileButton(
          label: 'Favorite',
          icon: Icons.favorite_border_outlined,
          onPressed: () {},
        ),
        const SizedBox(height: 10.0),
        ProfileButton(
          label: 'History',
          icon: Icons.history_outlined,
          onPressed: () {},
        ),
      ],
    );
  }
}
