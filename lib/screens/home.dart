import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import './numberUnknowns.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 244, 249),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                NumecTitle(),
                ButtonGroup(),
                Bosh(),
                Avatars(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NumecTitle extends StatelessWidget {
  const NumecTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Hi There!",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Select a Numerical Method to continue",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonGroup extends StatelessWidget {
  const ButtonGroup({super.key});

  @override
  Widget build(BuildContext context) {
    void onPressCallback(String method) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NumberUnknownsScreen(
            method: method,
          ),
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ButtonOption(
          onPress: () => onPressCallback("Cramer's Rule"),
          title: "Cramer's Rule",
          module: "Module 5",
        ),
        ButtonOption(
          onPress: () => onPressCallback("Gauss Elimination"),
          title: "Gauss Elimination",
          module: "Module 6",
        ),
        ButtonOption(
          onPress: () => onPressCallback("Gauss-Jordan Elimination"),
          title: "Gauss-Jordan Elimination",
          module: "Module 6",
        ),
      ],
    );
  }
}

class ButtonOption extends StatelessWidget {
  const ButtonOption({
    super.key,
    required this.title,
    required this.onPress,
    required this.module,
  });

  final String title;
  final String module;
  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: SizedBox(
        width: double.infinity,
        height: 100,
        child: GestureDetector(
          onTap: onPress,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(38, 199, 199, 199),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        module,
                        style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const Icon(Icons.arrow_right_sharp),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Bosh extends StatelessWidget {
  const Bosh({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        BoshImage(
          image: "assets/Cough.png",
        ),
        BoshImage(
          image: "assets/Eartquake.png",
        ),
        BoshImage(
          image: "assets/Fire.png",
        ),
        BoshImage(
          image: "assets/Hotline.png",
        ),
      ],
    );
  }
}

class BoshImage extends StatelessWidget {
  const BoshImage({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(38, 199, 199, 199),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image(
          image: AssetImage(image),
        ),
      ),
    );
  }
}

class Avatars extends StatefulWidget {
  const Avatars({super.key});

  @override
  State<Avatars> createState() => _AvatarsState();
}

class _AvatarsState extends State<Avatars> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Group 4 wow",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ),
          NewAvatar(image: "assets/1.jpg", name: "Jan Rix Salazar"),
          NewAvatar(image: "assets/2.jpg", name: "John Biencent Sundiam"),
          NewAvatar(image: "assets/3.jpg", name: "Cyrielle Lou Sunga"),
          NewAvatar(image: "assets/4.jpeg", name: "Harlan Sunga"),
          NewAvatar(image: "assets/5.jpg", name: "John Clarenze Tayag"),
          NewAvatar(image: "assets/6.jpg", name: "Mary Rose Tayag"),
          NewAvatar(image: "assets/7.jpg", name: "Aldrin Te"),
          NewAvatar(image: "assets/8.jpg", name: "John Villander Timbol"),
          NewAvatar(image: "assets/9.jpg", name: "Jhon Mark Torno"),
          NewAvatar(image: "assets/10.jpg", name: "Hervie Torres"),
          NewAvatar(image: "assets/11.jpg", name: "Francis James Tolentino"),
          NewAvatar(image: "assets/12.jpg", name: "Daniel Tiglao"),
        ],
      ),
    );
  }
}

class NewAvatar extends StatelessWidget {
  const NewAvatar({
    super.key,
    required this.image,
    required this.name,
  });

  final String image;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        // color: Colors.white,
        // boxShadow: const [
        //   BoxShadow(
        //     color: Color.fromARGB(38, 199, 199, 199),
        //     spreadRadius: 5,
        //     blurRadius: 7,
        //     offset: Offset(0, 3),
        //   ),
        // ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(image),
              radius: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
