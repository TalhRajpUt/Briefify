import 'package:briefify/data/constants.dart';
import 'package:briefify/data/image_paths.dart';
import 'package:briefify/data/routes.dart';
import 'package:briefify/fragments/home_fragment.dart';
import 'package:briefify/fragments/search_fragment.dart';
import 'package:briefify/models/user_model.dart';
import 'package:briefify/providers/user_provider.dart';
import 'package:briefify/services/firebase_message_service.dart';
import 'package:briefify/widgets/home_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  bool homeSelected = true;

  @override
  void initState() {
    FirebaseMessageService.startMessageListener(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// User Provider
    final _userData = Provider.of<UserProvider>(context);
    final UserModel _user = _userData.user;

    return Scaffold(
      key: _key,
      backgroundColor: kSecondaryColorLight,
      drawer: const HomeDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
                height: 185,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _key.currentState!.openDrawer();
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 39,
                            ),
                            // child: ClipRRect(
                            //   borderRadius: BorderRadius.circular(200),
                            //   child: FadeInImage(
                            //     placeholder: const AssetImage(userAvatar),
                            //     image: NetworkImage(_user.image),
                            //     fit: BoxFit.cover,
                            //     imageErrorBuilder: (context, object, trace) {
                            //       return Image.asset(
                            //         appLogo,
                            //         height: 50,
                            //         width: 50,
                            //       );
                            //     },
                            //     height: 50,
                            //     width: 50,
                            //   ),
                            // ),
                            child: Icon(
                              Icons.menu,
                              size: 32,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 37),
                            if (_user.city.isEmpty) const SizedBox(height: 9),
                            Text(
                              _user.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (_user.city.isNotEmpty)
                              Text(
                                _user.city,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SizedBox(height: 39),
                              Image.asset(
                                appLogo,
                                height: 32,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      height: 75,
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Expanded(flex: 1, child: Container()),
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                                    ),
                                  )),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    homeSelected = !homeSelected;
                                  });
                                },
                                child: Container(
                                  child: Icon(
                                    homeSelected ? Icons.search : Icons.home,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: kPrimaryColorLight,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(200),
                                  color: Colors.white,
                                ),
                                child: Container(
                                  child: Icon(
                                    homeSelected ? Icons.home : Icons.search,
                                    color: Colors.white,
                                    size: 38,
                                  ),
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(200),
                                    color: kPrimaryColorLight,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (_user.badgeStatus == badgeVerificationApproved) {
                                    Navigator.pushNamed(context, createPostRoute);
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return CupertinoAlertDialog(
                                            content: const Text(
                                                'You need to verify your profile before posting context'),
                                            title: const Text('Verification Required'),
                                            actions: [
                                              CupertinoDialogAction(
                                                child: const Text('Start'),
                                                isDefaultAction: true,
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  Navigator.pushNamed(context, profileVerificationRoute);
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  }
                                },
                                child: Container(
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: kPrimaryColorLight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                )),
            homeSelected ? const HomeFragment() : const SearchFragment(),
          ],
        ),
      ),
    );
  }
}
