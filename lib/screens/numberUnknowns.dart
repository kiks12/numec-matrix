import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import './cramer.dart';
import './gaussJordan.dart';
import './gauss.dart';

class NumberUnknownsScreen extends StatefulWidget {
  const NumberUnknownsScreen({
    super.key,
    required this.method,
  });

  final String method;

  @override
  State<NumberUnknownsScreen> createState() => _NumberUnknownsScreenState();
}

class _NumberUnknownsScreenState extends State<NumberUnknownsScreen> {
  final controller = TextEditingController();

  void onContinue() {
    if (widget.method == "Cramer's Rule") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: ((context) => CramerScreen(
                unknowns: int.parse(controller.text),
              )),
        ),
      );
    }
    if (widget.method == "Gauss-Jordan Elimination") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: ((context) => GaussJordanScreen(
                unknowns: int.parse(controller.text),
              )),
        ),
      );
    }
    if (widget.method == "Gauss Elimination") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: ((context) => GaussScreen(
                unknowns: int.parse(controller.text),
              )),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.method),
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 50,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text("Enter number of unknown variables"),
              ),
              SizedBox(
                height: 200,
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 100, vertical: 40),
                  ),
                  style: const TextStyle(
                    fontSize: 100,
                    fontWeight: FontWeight.w700,
                  ),
                  controller: controller,
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onContinue,
                    child: const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("Continue"),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
