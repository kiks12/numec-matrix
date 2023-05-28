import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class GaussJordanScreen extends StatefulWidget {
  const GaussJordanScreen({super.key, required this.unknowns});

  final int unknowns;

  @override
  State<GaussJordanScreen> createState() => _GaussJordanScreenState();
}

class _GaussJordanScreenState extends State<GaussJordanScreen> {
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
    reducedRowEchelonForm(augmented);
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

  void reducedRowEchelonForm(List<List<double>> augmentedMatrix) {
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

      double div = augmentedMatrix[r][lead];

      for (int j = 0; j <= columnCount; j++) {
        List<Text> list = [];
        if (j == 0) {
          String str =
              "R${r + 1}C${j + 1} = 1; R${r + 1}C${j + 1} = ${augmentedMatrix[r][j]}/$div = ${augmentedMatrix[r][j] / div}";
          Text newText = Text(str);
          Text step = Text(
            "Step #$steps",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          );
          list.add(step);
          list.add(newText);
          steps++;
          // print(
          // "\nr${r + 1}c${j + 1} = 1; r${r + 1}c${j + 1} = ${augmentedMatrix[r][j]}/$div");
        }
        if (j > 0) {
          String str =
              "R${r + 1}C${j + 1} = ${augmentedMatrix[r][j]}/$div = ${augmentedMatrix[r][j] / div}";
          Text newText = Text(str);
          list.add(newText);
        }
        // print("r${r + 1}c${j + 1} = ${augmentedMatrix[r][j]}/$div");
        Column newColumn = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [...list],
        );
        solutionList.add(newColumn);
        augmentedMatrix[r][j] /= div;
        augmentedMatrix[r][j] =
            double.parse(augmentedMatrix[r][j].toStringAsPrecision(5));
      }

      printAugmentedMatrix(augmentedMatrix);
      // Text augText1 = Text("\n$str");
      // solutionList.add(augText1);

      for (int k = 0; k < rowCount; k++) {
        List<Text> list = [];
        if (k != r) {
          double multiplier = augmentedMatrix[k][lead];

          for (int j = 0; j <= columnCount; j++) {
            if (j == lead) {
              String str =
                  "R${k + 1}C${j + 1} = 0; R${k + 1} - R$lead * $multiplier";
              Text newText = Text(str);
              // print(
              // "\nR${k + 1}C${j + 1} = 0; R${k + 1} - R$lead * $multiplier");
              list.add(newText);
            }
            if (j >= lead) {
              String str =
                  "${augmentedMatrix[k][j]} - ${augmentedMatrix[r][j]} * $multiplier = ${augmentedMatrix[k][j] - multiplier * augmentedMatrix[r][j]}";
              Text newText = Text(str);
              list.add(newText);
              // print("r${k + 1} - $multiplier * ${augmentedMatrix[r][j]}");
            }

            augmentedMatrix[k][j] -= multiplier * augmentedMatrix[r][j];
            augmentedMatrix[k][j] =
                double.parse(augmentedMatrix[k][j].toStringAsPrecision(5));
          }

          Column newCol = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Step #$steps",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              ...list
            ],
          );
          solutionList.add(newCol);

          printAugmentedMatrix(augmentedMatrix);
          steps++;
          // Text augTextN = Text("\n$str");
          // solutionList.add(augTextN);
        }
      }
      lead++;
    }

    printAnswer(augmentedMatrix);
    setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gauss-Jordan Elimination"),
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
