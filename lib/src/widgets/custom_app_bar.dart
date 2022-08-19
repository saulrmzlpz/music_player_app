import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 30),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: const [
            Icon(FontAwesomeIcons.chevronLeft),
            Spacer(),
            Icon(FontAwesomeIcons.message),
            SizedBox(width: 20),
            Icon(FontAwesomeIcons.headphonesSimple),
            SizedBox(width: 20),
            Icon(FontAwesomeIcons.upRightFromSquare),
          ],
        ),
      ),
    );
  }
}
