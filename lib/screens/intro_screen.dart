import 'package:ctrl_f/screens/camera_screen.dart';
import 'package:ctrl_f/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreen extends StatefulWidget {
  IntroScreen({Key key}) : super(key: key);

  static String id = 'intro_screen';

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  List<Slide> welcomeSlides = List();

  @override
  void initState() {
    super.initState();

    welcomeSlides.add(
      Slide(
        title: 'CTRL - F',
        backgroundColor: Colors.black,
        styleTitle: kSlideTitleStyle,
        description:
            'CTRL - F te ajuda a encontrar palavras em tempo real usando a câmera',
        styleDescription: kSlideDescriptionStyle,
      ),
    );

    welcomeSlides.add(
      Slide(
        title: 'CTRL - F',
        backgroundColor: Colors.black,
        styleTitle: kSlideTitleStyle,
        description:
            'Facilite sua vida quando precisar encontrar informações relevantes em documentos',
        styleDescription: kSlideDescriptionStyle,
      ),
    );
  }

  void onDonePress() {
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setBool(kCheckAccessKey, true));
    Navigator.pushNamed(context, CameraScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(slides: welcomeSlides, onDonePress: this.onDonePress);
  }
}
