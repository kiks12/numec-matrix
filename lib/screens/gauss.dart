import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:math_expressions/math_expressions.dart';

class GaussScreen extends StatefulWidget {
  const GaussScreen({super.key, required this.unknowns});

  final int unknowns;

  @override
  State<GaussScreen> createState() => _GaussScreenState();
}

class _GaussScreenState extends State<GaussScreen> {
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

  void printAugmentedMatrix(List<List<double>> augmentedMatrix) {
    String str = "";
    List<TableRow> tableRowList = [];

    for (List<double> row in augmentedMatrix) {
      String newStr = "";
      List<TableCell> tableCellList = [];

      for (double element in row) {
        TableCell cell = TableCell(
            child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            element.toString(),
            textAlign: TextAlign.center,
          ),
        ));
        tableCellList.add(cell);
        newStr = "$newStr$element ";
      }

      TableRow newRow = TableRow(children: tableCellList);
      tableRowList.add(newRow);
      str += newStr;
      str += "\n";
      // print(newStr);
    }

    Table newTable = Table(
      children: tableRowList,
    );
    solutionList.add(Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: newTable,
    ));
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

  List<List<double>> createAugmentedMatrix() {
    List<List<double>> newList = [];

    int count = 0;
    for (int i = 0; i < numberList.length; i++) {
      List<double> newNewList = [];
      for (int j = 0; j <= numberList.length; j++) {
        if (j == numberList.length) {
          newNewList.add(double.parse(dNumberList[count].toString()));
          count++;
          continue;
        }
        newNewList.add(double.parse(numberList[i][j].toString()));
      }
      newList.add(newNewList);
    }

    return newList;
  }

  void solve() {
    solutionList.clear();
    List<List<double>> augmented = createAugmentedMatrix();
    rowEchelonForm(augmented);
    printAugmentedMatrix(augmented);
    solveForAnswers(augmented);
    setState(() {});
  }

  void printAnswer(List<List<double>> augmented) {
    List<Text> answers = [];

    for (int i = 0; i < augmented.length; i++) {
      for (int j = 0; j < augmented.length; j++) {
        if (j == augmented.length - 1) {
          Text newText = Text("X${i + 1} = ${augmented[i][j + 1]}");
          answers.add(newText);
        }
      }
    }

    Column newCol = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: answers,
    );
    solutionList.add(newCol);
    setState(() {});
  }

  void rowEchelonForm(List<List<double>> augmentedMatrix) {
    int rowCount = augmentedMatrix.length;
    int columnCount = augmentedMatrix[0].length - 1;
    int lead = 0;
    int steps = 1;

    for (int r = 0; r < rowCount; r++) {
      if (lead >= columnCount) {
        return;
      }

      int i = r;

      while (augmentedMatrix[i][lead] == 0) {
        i++;

        if (i == rowCount) {
          i = r;
          lead++;

          if (lead == columnCount) {
            return;
          }
        }
      }

      List<double> temp = augmentedMatrix[i];
      augmentedMatrix[i] = augmentedMatrix[r];
      augmentedMatrix[r] = temp;

      List<Widget> list = [];
      for (int k = r + 1; k < rowCount; k++) {
        double factor = double.parse(
            (augmentedMatrix[k][lead] / augmentedMatrix[r][lead])
                .toStringAsPrecision(5));
        Padding stepStr = Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "Step #$steps: ",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        );
        String strOne =
            "R${k + 1}C${lead + 1} = 0; R${k + 1} - R${lead + 1} * $factor";
        Text newText = Text(strOne);
        list.add(stepStr);
        list.add(newText);
        // print("R${k + 1}C${lead + 1} = 0; R${k + 1} - R${lead + 1} * $factor");

        for (int j = 0; j <= columnCount; j++) {
          String strN =
              "R${k + 1}C${j + 1} = ${augmentedMatrix[k][j]} - ${double.parse((augmentedMatrix[r][j]).toStringAsPrecision(5))} * $factor = ${double.parse((augmentedMatrix[k][j] - factor * augmentedMatrix[r][j]).toStringAsPrecision(5))}";
          Text textNth = Text(strN);
          // print(
          // "R${k + 1}C${j + 1} = ${augmentedMatrix[k][j]} - ${augmentedMatrix[r][j]} * $factor = ${augmentedMatrix[k][j] - factor * augmentedMatrix[r][j]}");
          list.add(textNth);
          augmentedMatrix[k][j] -= factor * augmentedMatrix[r][j];
          augmentedMatrix[k][j] =
              double.parse(augmentedMatrix[k][j].toStringAsPrecision(5));
        }

        steps++;
      }

      Column newCol = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: list,
      );
      solutionList.add(newCol);
      lead++;
    }

    List<Widget> newList = [];
    for (int i = 0; i < augmentedMatrix.length; i++) {
      double pivot = augmentedMatrix[i][i];

      Padding stepStr = Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          "Step #$steps: ",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      );

      String strOne = "R${i + 1}C${i + 1} = 1; R${i + 1} / $pivot";
      Text newText = Text(strOne);
      newList.add(stepStr);
      newList.add(newText);

      for (int j = i; j < augmentedMatrix[i].length; j++) {
        String strN =
            "R${i + 1}C${j + 1} = ${augmentedMatrix[i][j]} / $pivot = ${double.parse((augmentedMatrix[i][j] / pivot).toStringAsPrecision(5))}";
        Text textNth = Text(strN);
        newList.add(textNth);

        augmentedMatrix[i][j] /= pivot;
        augmentedMatrix[i][j] =
            double.parse(augmentedMatrix[i][j].toStringAsPrecision(2));
      }
      steps++;
    }

    Column newCol = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: newList,
    );
    solutionList.add(newCol);
  }

  void solveForAnswers(List<List<double>> matrix) {
    Map<int, String> equivalents = {
      0: "x",
      1: "y",
      2: "z",
      3: "a",
      4: "b",
      5: "c",
      6: "d",
      7: "e",
      8: "f",
      9: "g",
      10: "h",
      11: "i",
      12: "j",
    };
    Map<String, double> map = {};
    for (int i = matrix.length - 1; i >= 0; i--) {
      List<Widget> list = [];
      String eqStr = "";
      for (int j = matrix.length; j >= 0; j--) {
        if (j == matrix.length) eqStr += "(${matrix[i][j]}";
        if (j == i) {
          eqStr += " / ${matrix[i][j]}";
          break;
        }
        if (matrix[i][j] < 0 && j != matrix.length) {
          eqStr += " + ${matrix[i][j].abs()}${equivalents[j]}";
        }
        if (matrix[i][j] > 0 && j != matrix.length) {
          eqStr += " - ${matrix[i][j]}${equivalents[j]}";
        }
        if (j == i + 1) {
          eqStr += ")";
        }
      }

      // print(eqStr);
      list.add(Text("\n${equivalents[i]} = $eqStr"));
      equivalents.forEach((key, value) {
        eqStr = eqStr.replaceFirst(value, "*(${map[value]})");
      });
      list.add(Text("${equivalents[i]} = $eqStr"));
      // print(eqStr);
      Parser p = Parser();
      Expression exp = p.parse(eqStr);
      double ans = exp.evaluate(EvaluationType.REAL, ContextModel());
      list.add(Text("${equivalents[i]} = ${ans.round()}"));

      map[equivalents[i] as String] = ans;

      Column col = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: list,
      );

      solutionList.add(col);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gauss Elimination"),
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
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
