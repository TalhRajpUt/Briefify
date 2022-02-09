import 'package:briefify/data/constants.dart';
import 'package:briefify/data/image_paths.dart';
import 'package:briefify/data/routes.dart';
import 'package:briefify/widgets/button_one.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffbfbfb),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(flex: 5, child: Image.asset(gifLogo)),
          const Expanded(
              flex: 1,
              child: Text(
                'Welcome to Briefify',
                style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
              )),
          const Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Text(
                  'Knowledge Simplified for all',
                  style: TextStyle(
                    color: kTextColorLightGrey,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              )),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                ButtonOne(
                  onPressed: () {
                    Navigator.pushNamed(context, termandconditionRoute);
                  },
                  title: 'Create account',
                  minSize: 30,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                ButtonOne(
                  onPressed: () {
                    Navigator.pushNamed(context, loginRoute);
                  },
                  title: 'Login to Briefify',
                  minSize: 30,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: 20,
            ),
          ),
          // Expanded(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       const Text(
          //         'Have an account already? ',
          //         style: TextStyle(
          //           color: kTextColorLightGrey,
          //         ),
          //       ),
          //       TextButton(
          //         onPressed: () {
          //           Navigator.pushNamed(context, loginRoute);
          //         },
          //         child: const Text('Login to Briefify'),
          //       ),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }
}
