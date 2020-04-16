import 'package:flutter/material.dart';

import 'main.dart';

// Colors
const kBackgroundColor = Color(0xFFFEFEFE);
const kTitleTextColor = Color(0xFF303030);
const kBodyTextColor = Color(0xFF4B4B4B);
const kTextLightColor = Color(0xFF959595);
const kInfectedColor = Color(0xFFFF8748);
const kDeathColor = Color(0xFFFF4848);
const kRecovercolor = Color(0xFF36C12C);
const kPrimaryColor = Color(0xFF3382CC);
final kShadowColor = Color(0xFFB7B7B7).withOpacity(.16);
final kActiveShadowColor = Color(0xFF4056C6).withOpacity(.15);

// Text Style
const kHeadingTextStyle = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.w600,
);

const kSubTextStyle = TextStyle(fontSize: 20, color: kTextLightColor);

const kTitleTextstyle = TextStyle(
  fontSize: 28,
  color: kPrimaryColor,
  fontWeight: FontWeight.bold,
);

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Get to know', icon: Icons.add_box),
  const Choice(title: 'Sites References', icon: Icons.bookmark_border),
  const Choice(title: 'About', icon: Icons.info),
];
