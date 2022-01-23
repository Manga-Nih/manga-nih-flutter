import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/models/models.dart';
import 'package:manga_nih/ui/configs/pallette.dart';
import 'package:manga_nih/constants/enum.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/ui/screens/screens.dart';
import 'package:manga_nih/ui/widgets/widgets.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String _displayName;
  late UserBloc _userBloc;

  @override
  void initState() {
    // init bloc
    _userBloc = BlocProvider.of<UserBloc>(context);

    // set name
    UserState state = _userBloc.state;
    if (state is UserFetchSuccess) {
      _displayName = state.user.displayName!;
    }

    super.initState();
  }

  void _editNameAction() {
    showDialog(
      context: context,
      builder: (context) {
        return EditNameDialog(
          displayName: _displayName,
          onSuccess: (name) {
            _userBloc.add(UserUpdateProfile(name: name));
          },
        );
      },
    );
  }

  void _favoriteAction() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ListFavoriteHistoryScreen(
            section: FavoriteHistorySection.favorite,
          ),
        ));
  }

  void _historyAction() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ListFavoriteHistoryScreen(
            section: FavoriteHistorySection.history,
          ),
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
                    (state is UserFetchSuccess) ? state.user.displayName! : '',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    (state is UserFetchSuccess) ? state.user.email! : '',
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
          onPressed: _favoriteAction,
        ),
        const SizedBox(height: 10.0),
        ProfileButton(
          label: 'History',
          icon: Icons.history_outlined,
          onPressed: _historyAction,
        ),
      ],
    );
  }
}
