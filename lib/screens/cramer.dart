import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:math_expressions/math_expressions.dart';

class CramerScreen extends StatefulWidget {
  const CramerScreen({super.key, required this.unknowns});

  final int unknowns;

  @override
  State<CramerScreen> createState() => _CramerScreenState();
}

class _CramerScreenState extends State<CramerScreen> {
  final List<Row> _list = [];
  final List<List<dynamic>> numberList = [];

  final List<Widget> _dList = [];
  final List<dynamic> dNumberList = [];

  final List<Widget> solutionList = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.unknowns; i++) {
      List<Widget> newList = [];
      List<int> newNumList = [];
      for (int j = 0; j < widget.unknowns; j++) {
        newList.add(buildTextField(i, j));
        newNumList.add(0);
      }
      Row newRow = Row(
        children: newList,
      );
      _list.add(newRow);
      numberList.add(newNumList);
    }

    for (int i = 0; i < widget.unknowns; i++) {
      List<Widget> newList = [];
      newList.add(buildDTextField(i));
      Row newRow = Row(
        children: newList,
      );
      _dList.add(newRow);
      dNumberList.add(0);
    }
  }

  Widget buildTextField(i, j) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: TextField(
          onChanged: (value) {
            numberList[i][j] = int.parse(value);
          },
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget buildDTextField(i) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: TextField(
          onChanged: (value) {
            dNumberList[i] = int.parse(value);
          },
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget buildSolution(
    String title,
    String expression,
    String answer, {
    String d = "",
  }) {
    if (title == "D") {
      return Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Solve for $title"),
              Text("$title=$expression"),
              Text("$title=$answer"),
            ],
          ),
        ),
      );
    }

    // String varAns = (int.parse(d) / int.parse(answer)).toString();
    Parser p = Parser();
    Expression varAnsExp = p.parse("($answer)/($d)");
    String varAns =
        varAnsExp.evaluate(EvaluationType.REAL, ContextModel()).toString();

    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Solve for $title"),
            Text("$title=$expression"),
            Text("$title=$answer"),
            Text("${title.replaceAll('D', 'X')}=$answer/$d"),
            Text("${title.replaceAll("D", "X")}=$varAns"),
          ],
        ),
      ),
    );
  }

  void solve() {
    solutionList.clear();
    Map<String, dynamic> d = solveForD();
    int steps = 1;
    solutionList.add(
      Text(
        "Step #$steps",
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
    );
    solutionList.add(buildSolution("D", d['expression'], d['answer']));
    List<Map<String, dynamic>> dVars = solveForDVars();
    steps++;

    for (int i = 0; i < dVars.length; i++) {
      solutionList.add(
        Text(
          "Step #$steps",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      );
      solutionList.add(
        buildSolution(
          "D${i + 1}",
          dVars[i]['expression'],
          dVars[i]['answer'],
          d: d['answer'],
        ),
      );
      steps++;
    }

    setState(() {});
  }

  dynamic getExpression(grid) {
    String firstStringExpression = "";
    for (int count = 0; count < grid.length; count++) {
      int xOffset = 0 + count;
      int yOffset = 0;

      String stringExp = "";
      for (int i = 0; i < grid.length; i++) {
        for (int j = 0; j < grid.length; j++) {
          if (i == yOffset && j == xOffset) {
            if (i == 0) {
              stringExp = stringExp + grid[yOffset][xOffset].toString();
            } else {
              stringExp = "$stringExp*(${grid[yOffset][xOffset]})";
            }
          }
        }
        xOffset++;
        yOffset++;
        if (xOffset == grid.length) xOffset = 0;
      }

      Parser p = Parser();
      Expression exp = p.parse(stringExp);
      double sagot = exp.evaluate(EvaluationType.REAL, ContextModel());

      if (count == 0) {
        firstStringExpression = "(${sagot.toString()}";
      } else if (count == grid.length - 1) {
        firstStringExpression = "$firstStringExpression+(${sagot.toString()}))";
      } else {
        firstStringExpression = "$firstStringExpression+(${sagot.toString()})";
      }
    }

    String secondStringExpression = "";
    for (int count = 0; count < grid.length; count++) {
      int xOffset = grid.length - 1 - count;
      int yOffset = 0;

      String stringExp = "";
      for (int i = 0; i < grid.length; i++) {
        for (int j = 0; j < grid.length; j++) {
          if (i == yOffset && j == xOffset) {
            if (i == 0) {
              stringExp = stringExp + grid[yOffset][xOffset].toString();
            } else {
              stringExp = "$stringExp*(${grid[yOffset][xOffset]})";
            }
          }
        }
        xOffset--;
        yOffset++;
        if (xOffset == 0 - 1) xOffset = grid.length - 1;
      }

      Parser p = Parser();
      Expression exp = p.parse(stringExp);
      double sagot = exp.evaluate(EvaluationType.REAL, ContextModel());

      if (count == 0) {
        secondStringExpression = "(${sagot.toString()}";
      } else if (count == grid.length - 1) {
        secondStringExpression =
            "$secondStringExpression+(${sagot.toString()}))";
      } else {
        secondStringExpression =
            "$secondStringExpression+(${sagot.toString()})";
      }
    }

    return "$firstStringExpression-$secondStringExpression";
  }

  Map<String, dynamic> solveForD() {
    String stringExp = getExpression(numberList);
    Parser p = Parser();
    Expression exp = p.parse(stringExp);
    String ans = exp.evaluate(EvaluationType.REAL, ContextModel()).toString();

    return {
      "expression": stringExp,
      "answer": ans,
    };
  }

  List<Map<String, dynamic>> solveForDVars() {
    List<Map<String, dynamic>> listOfAns = [];
    for (int count = 0; count < numberList.length; count++) {
      final List<List<dynamic>> newNumList = numberList.map((e) {
        return e.map((e2) => e2).toList();
      }).toList();

      for (int row = 0; row < numberList.length; row++) {
        for (int col = 0; col < numberList.length; col++) {
          if (col == count) {
            newNumList[row][col] = dNumberList[row];
          }
        }
      }
      String stringExp = getExpression(newNumList);
      Parser p = Parser();
      Expression exp = p.parse(stringExp);
      String ans = exp.evaluate(EvaluationType.REAL, ContextModel()).toString();

      listOfAns.add({
        "expression": stringExp,
        "answer": ans,
      });
    }

    return listOfAns;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Cramer's Rule"),
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          for (var item in _list) item,
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Column(
                          children: [
                            for (var item in _dList) item,
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: solve,
                      child: const Padding(
                        padding: EdgeInsets.all(15),
                        child: Text("Solve"),
                      ),
                    ),
                  ),
                ),
                for (var solution in solutionList) solution,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
