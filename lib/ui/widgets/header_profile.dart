import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/core/core.dart';
import 'package:manga_nih/ui/screens/screens.dart';
import 'package:manga_nih/ui/widgets/widgets.dart';

class HeaderProfile extends StatelessWidget {
  void _profileAction(BuildContext context) {
    Get.to(() => ProfileScreen());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _profileAction(context),
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (state is UserFetchSuccess)
                  ? Avatar.network(image: state.user.photoURL)
                  : Avatar(),
              const SizedBox(width: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(greetingNow(),
                      style: Theme.of(context).textTheme.bodyText2),
                  const SizedBox(height: 5.0),
                  Text(
                    (state is UserFetchSuccess) ? state.user.displayName! : '',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
              const Spacer(),
              Container(
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 1.0, color: Colors.grey.shade400),
                ),
                child: Icon(Icons.more_horiz),
              ),
            ],
          );
        },
      ),
    );
  }
}
