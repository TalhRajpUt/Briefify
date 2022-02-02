import 'package:briefify/data/constants.dart';
import 'package:briefify/data/image_paths.dart';
import 'package:briefify/data/routes.dart';
import 'package:briefify/models/user_model.dart';
import 'package:briefify/providers/user_provider.dart';
import 'package:briefify/utils/prefs.dart';
import 'package:briefify/widgets/drawer_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// User Provider
    final _userData = Provider.of<UserProvider>(context);
    final UserModel _user = _userData.user;

    return Drawer(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              DrawerHeader(
                  child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(200),
                      child: FadeInImage(
                        placeholder: const AssetImage(userAvatar),
                        image: NetworkImage(_user.image),
                        fit: BoxFit.cover,
                        imageErrorBuilder: (context, object, trace) {
                          return Image.asset(
                            appLogo,
                            height: 60,
                            width: 60,
                          );
                        },
                        height: 80,
                        width: 80,
                      ),
                    ),
                  ),
                  Text(
                    _user.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: kPrimaryTextColor,
                    ),
                  ),
                ],
              )),
              DrawerItem(
                  icon: Icons.person,
                  title: 'Profile',
                  onTap: () {
                    Navigator.pushNamed(context, myProfileRoute);
                  }),
              DrawerItem(
                  icon: Icons.verified,
                  title: 'Verification',
                  onTap: () {
                    Navigator.pushNamed(context, profileVerificationRoute);
                  }),
              DrawerItem(
                  icon: Icons.category,
                  title: 'Categories',
                  onTap: () {
                    Navigator.pushNamed(context, categoriesRoute);
                  }),
              DrawerItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    await Prefs().logoutUser();
                    Navigator.pushNamedAndRemoveUntil(context, welcomeRoute, ModalRoute.withName(homeRoute));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
