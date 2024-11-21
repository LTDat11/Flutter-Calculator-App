import 'package:flutter/material.dart';
import 'package:flutter_app/button_values.dart';

class CaculatorScreen extends StatefulWidget {
  const CaculatorScreen({super.key});

  @override
  State<CaculatorScreen> createState() => _CaculatorScreenState();
}

class _CaculatorScreenState extends State<CaculatorScreen> {
  String number1=""; // . 0-9
  String operand=""; // + - * /
  String number2=""; // . 0-9

  @override
  Widget build(BuildContext context) {
    final sceenSize=MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // output
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "$number1$operand$number2".isEmpty
                        ?"0"
                        :"$number1$operand$number2",
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
            // buttons
            Wrap(
              children: Btn.buttonValues
                  .map(
                      (value) => SizedBox(
                        width:value==Btn.n0
                            ?sceenSize.width/2
                            : (sceenSize.width/4),
                        height: sceenSize.width/5,
                        child: buildButton(value),
                      ),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildButton(String value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
            borderSide: const BorderSide(
                color: Colors.white24,
            ),
            borderRadius: BorderRadius.circular(100),
        ),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
              child: Text(
                value,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                ),
              ),
          ),
        ),
      ),
    );
  }

  Color getBtnColor(value){
    return[Btn.del,Btn.clr].contains(value)
            ?Colors.blueGrey
            :[
          Btn.per,
          Btn.multiply,
          Btn.add,
          Btn.subtract,
          Btn.divide,
          Btn.calculate,
        ].contains(value)
            ?Colors.orange
            :Colors.black87;
  }

  void onBtnTap(String value) {
    if(value==Btn.del){
      delete();
      return;
    }
    if(value==Btn.clr){
      clearAll();
      return;
    }

    if(value==Btn.per){
      convertToPercentage();
      return;
    }

    if(value == Btn.calculate){
      calculate();
      return;
    }
    appendValue(value);
  }

  void appendValue(String value){
    // if is operand and not dot
    if(value!=Btn.dot&&int.tryParse(value)==null){
      // operand pressed
      if(operand.isNotEmpty&&number2.isNotEmpty){
        // todo calculate
      }
      operand = value;
    }
    // assign value to number1
    else if(number1.isEmpty || operand.isEmpty){
      // check if values is dot
      if(value==Btn.dot && number1.contains(Btn.dot)) return;
      if(value==Btn.dot && (number1.isEmpty || number1==Btn.dot)){
        value = "0.";
      }
      number1+=value;
    }
    // assign value to number2
    else if(number2.isEmpty || operand.isNotEmpty){
      // check if values is dot
      if(value==Btn.dot && number2.contains(Btn.dot)) return;
      if(value==Btn.dot && (number2.isEmpty || number2==Btn.dot)){
        value = "0.";
      }
      number2+=value;
    }
    setState(() {});
  }

  void delete() {
    if(number2.isNotEmpty){
      number2=number2.substring(0,number2.length-1);
    }else if(operand.isNotEmpty){
      operand="";
    }else if(number1.isNotEmpty){
      number1=number1.substring(0,number1.length-1);
    }

    setState(() {});
  }

  void clearAll() {
    setState(() {
      number1="";
      operand="";
      number2="";
    });
  }

  void convertToPercentage() {
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {

    }
    if(operand.isNotEmpty){
      //can't convert operand to percentage
      return;
    }

    final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}";
      operand="";
      number2="";
    });
  }

  void calculate() {
    if(number1.isEmpty || operand.isEmpty || number2.isEmpty){
      return;
    }
    final double numb1=double.parse(number1);
    final double numb2=double.parse(number2);

    var result=0.0;
    switch(operand){
      case Btn.add:
        result=numb1+numb2;
        break;
      case Btn.subtract:
        result=numb1-numb2;
        break;
      case Btn.multiply:
        result=numb1*numb2;
        break;
      case Btn.divide:
        result=numb1/numb2;
        break;
    }
    setState(() {
      number1=result.toString();

      if(number1.endsWith(".0")){
        number1=number1.substring(0,number1.length-2);
      }

      operand="";
      number2="";
    });
  }
}
