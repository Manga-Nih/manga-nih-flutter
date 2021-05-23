import 'package:flutter/material.dart';
import 'package:manga_nih/ui/widgets/widgets.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 40.0),
              _buildBody(context),
              const SizedBox(height: 30.0),
              _logOutButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Zukron Alviandy R',
                  style: Theme.of(context).textTheme.bodyText1),
              const SizedBox(height: 5.0),
              Text(
                'zukronalviandy@gmail.com',
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
          const Spacer(),
          Icon(Icons.expand_more),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        _profileButton(
          context,
          label: 'Favorite',
          icon: Icons.favorite_border_outlined,
        ),
        const SizedBox(height: 10.0),
        _profileButton(
          context,
          label: 'History',
          icon: Icons.history_outlined,
        ),
      ],
    );
  }

  Widget _profileButton(
    BuildContext context, {
    required String label,
    required IconData icon,
  }) {
    return MaterialButton(
      padding: const EdgeInsets.all(20.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
      ),
      color: Color(0xFF334148),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 25.0),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontSize: 17.0,
                  color: Colors.white,
                  letterSpacing: 1.3,
                ),
          ),
        ],
      ),
      onPressed: () {},
    );
  }

  Widget _logOutButton(BuildContext context) {
    return MaterialButton(
      padding: const EdgeInsets.all(20.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
        side: BorderSide(
          color: Colors.red,
        ),
      ),
      color: Colors.white,
      child: Row(
        children: [
          Icon(Icons.logout, color: Colors.red),
          const SizedBox(width: 25.0),
          Text(
            'Log Out',
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontSize: 17.0,
                  color: Colors.red,
                  letterSpacing: 1.3,
                ),
          ),
        ],
      ),
      onPressed: () {},
    );
  }
}
