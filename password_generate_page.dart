import 'dart:ffi';
import 'package:flutter/material.dart';
import 'password_result_page.dart';
import 'dart:math';
class PasswordGeneratorPage extends StatelessWidget {

  int oddsMod = 0;
  String baseWord = "";
  int length = 0;
  int numOfSpecialCharacters = 0;
  int numOfUppercase = 0;
  int numOfLowercase = 0;
  int wordPosition = 0;
  StringBuffer password = StringBuffer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Generator'),
      ),
      body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputRow('Enter Minimum Password Length:', TextInputType.number, (value) {
              length = int.parse(value);
            }),
            _buildInputRow('Base Word for Password:', TextInputType.text, (value) {
              baseWord = value;
            }),
            _buildInputRow('Minimum Number of Special Characters:', TextInputType.number, (value) {
              numOfSpecialCharacters = int.parse(value);
            }),
            _buildInputRow('Minimum Number of Capital Letters:', TextInputType.number, (value) {
              numOfUppercase = int.parse(value);
            }),
            _buildInputRow('Minimum Number of Lowercase Letters:', TextInputType.number, (value) {
              numOfLowercase = int.parse(value);
            }),
            SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if ((length <= 0  || numOfUppercase < 0  || numOfLowercase < 0  || numOfSpecialCharacters < 0) || baseWord.length < numOfUppercase + numOfLowercase + numOfSpecialCharacters) {
                    Map<int, String> inputBoxes ={
                    numOfSpecialCharacters: "Number of Special Characters",
                    numOfLowercase: "Number of Lowercase Letters",
                    numOfUppercase: "Number of Uppercase Letters",
                    length: "Password Length"
                    };
                    _showAlertDialog(context, inputBoxes);
                  }
                  else{
                  String generatedPassword = generatePasswordWithReplacements(baseWord, length, numOfSpecialCharacters, numOfLowercase, numOfUppercase);
                  oddsMod = 0;
                  wordPosition = 0;
                  password.clear();
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PasswordResultPage(password: generatedPassword)));
                  }
                  },
                child: Text('Generate'),
              ),
            ),
          ],
        ),
      ),
    )
    );
  }

  Widget _buildInputRow(String labelText, TextInputType inputType, void Function(String) onChanged) {
    return Row(
      children: [
        SizedBox(
          width: 150.0,
          child: Text(
            labelText,
            style: TextStyle(fontSize: 16.0),
          ),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: TextField(
            keyboardType: inputType,
            onChanged: onChanged,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  void _showAlertDialog(BuildContext context, Map<int , String> inputBoxes) {
    List<int> keys = inputBoxes.keys.toList();
    List<String> values = inputBoxes.values.toList();

    for(int i = 0; i < 5; i++){
      if(keys[i] < 0){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Alert'),
              content: Text('The value of %s is not acceptable.'.replaceAll('%s', values[i])),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  static final Map<String, List<String>> letterReplacements = {
    'a': ['a','@','/\\','^'],
    'b': ['b','8', '6', '13', '|3'],
    'c': ['c','(', '<', '{','['],
    'd' : ['d','|)', '|}', '|]'],
    'e' : ['e','3'],
    'f' : ['f','|=', '|"', '/"', '/='],
    'g' : ['g','9'],
    'h' : ['h','4', '1-1', '|-|'],
    'i' : ['i','1', ':'],
    'j' : ['j', 'j'],
    'k' : ['k','|<', '\\<', '/<'],
    'l' : ['l', '!', '|', '|_'],
    'm' : ['m','nn', '|\\/|'],
    'n' : ['n','|\\|'],
    'o' : ['o','0', '()', '[]', '{}', '<>'],
    'p' : ['p','/>'],
    'q' : ['q','<\\'],
    'r' : ['r', '1^','|-'],
    's' : ['s','5', '_/-'],
    't' : ['t','7', '+', '-|-'],
    'u' : ['u', '[_]', '(_)', '\\_/', '|_|'],
    'v' : ['v', '\\/'],
    'w' : ['w','uu', 'vv', '\\/\\/'],
    'x' : ['x', '><'],
    'y' : ['y', '\'/'],
    'z' : ['2', '-/_']

    //5n33-/_e
    //sneeze

    //queen
    //   <\u33|\|

    //quality
    //<\u/\|i+y
  };

  // Lists of special characters, lowercase letters, and uppercase letters
  List<String> specialCharacters = ['!', '@', '#', '\$', '%', '^', '&', '*', '[', ']', '{', '}', '(', ')', '\\', '/', '|', '\'', ':', '_', '-', '+', '<', '>'];
  List<String> lowercaseLetters = 'abcdefghijklmnopqrstuvwxyz'.split('');
  List<String> uppercaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
  List<String> extendCharacters = ['#', '\$', '%', '&', '*'];

  // Function to count special characters in a string
  int countSpecialCharacters(String str) {
    return str.split('').where((char) => specialCharacters.contains(char)).length;
  }

  // Function to count lowercase letters in a string
  int countLowercaseLetters(String str) {
    return str.split('').where((char) => lowercaseLetters.contains(char)).length;
  }

  // Function to count uppercase letters in a string
  int countUppercaseLetters(String str) {
    return str.split('').where((char) => uppercaseLetters.contains(char)).length;
  }

  String lCases(String curChar, String nextChar, List<String> replacements){
    Random random = Random();
    String replacement = curChar;
    bool doReplace = probabilityCheck(replacements.length);
    if(!doReplace){
      oddsMod++;
      return curChar;
    }
    String chosenL = replacements[random.nextInt(replacements.length)];
    oddsMod++;

    //sets replacement for the next character after 'l'
    switch(nextChar){
        case "f":
          password.write(chosenL);
          wordPosition++;
          List<String>? nextReplacements = letterReplacements[nextChar];
          if (nextReplacements != null && nextReplacements.isNotEmpty && chosenL.compareTo("l") == 0) {
            replacement = nextReplacements[3 + random.nextInt(nextReplacements.length + 1) - 3];
          }
          else{
            replacement = "f";
          }
          oddsMod++;
      case "h" || "m" || "n" || "r" || "s" || "u" || "z":
        password.write(chosenL);
        wordPosition++;
        List<String>? nextReplacements = letterReplacements[nextChar];
          if (nextReplacements != null && nextReplacements.isNotEmpty && chosenL.compareTo("l") == 0) {
            replacement = nextReplacements[random.nextInt(nextReplacements.length-1)];
          }
          else{
            replacement = nextChar;
          }
          oddsMod++;
      case "i":
        oddsMod = 4;
    }
    return replacement;
  }

  bool probabilityCheck(int replacementLength){
    Random rand = Random();
    bool doReplace = true;
    double chance = 1 - (oddsMod * 0.25 + 0.1);
    if(chance * rand.nextInt(replacementLength) == 0){
      doReplace = false;
    }
    return doReplace;
  }

  String characterCheck(String curChar, String nextChar, List<String> replacements, int numSpecial, int numUpper, int numLower){
      Random random = Random();
      String replacement = curChar;
      bool doReplace = probabilityCheck(replacements.length);

      //checks for double letters, and if true jumps 2 characters
      if(curChar.compareTo(nextChar) == 0){
        if(doReplace) {
          replacement = replacements[random.nextInt(replacements.length)];
          //password.write(replacement);
        }
        else{
          if(numUpper > 0){
            numOfUppercase--;
            curChar = curChar.toUpperCase();
          }
          replacement = curChar;
        }
        password.write(replacement);
        wordPosition++;
        oddsMod = 4;
        return replacement;
      }

      //checks if forced to use char
      if(oddsMod >= 4){
        oddsMod = 0;
        if(numUpper > 0){
          numOfUppercase--;
          curChar = curChar.toUpperCase();
        }
        return curChar;
      }

      //after each case, changes probability
      switch(curChar){
        case "l":
          return lCases(curChar, nextChar, replacements);
        //case "i" || "a" || "e" || "o" || "y" || "u":
          //password.write(vowelCases(curChar, nextChar, replacements));
        case "q":
          if(nextChar == "u"){
            oddsMod++;
            wordPosition++;
            password.write(replacements[random.nextInt(replacements.length)]);
            return "u";
          }
        case "h" || "r" || "m" || "n" || "s" || "u" || "v" || "x" || "z" || "f":
          if(nextChar.compareTo("l") == 0){
            oddsMod = 4;
          }
          if(doReplace){
            oddsMod++;
            return replacements[random.nextInt(replacements.length)];
          }
          else{
            if(numUpper > 0){
              numOfUppercase--;
              curChar = curChar.toUpperCase();
            }
            return curChar;
          }
        case "i" || "a" || "e" || "o" || "y" || "u" || "b" || "c" || "d" || "g" || "j" || "k" || "p" || "t" || "w":
          if(doReplace){
            oddsMod++;
            return replacements[random.nextInt(replacements.length)];
          }
          else{
            if(numUpper > 0){
              numOfUppercase--;
              curChar = curChar.toUpperCase();
            }
            return curChar;
          }
      }
      return replacement;
  }

  String generatePasswordWithReplacements(String baseWord, int length, int numOfSpecialCharacters, int numOfLowercase, int numOfUppercase) {
    Random random = Random();
    String currentChar = " ";
    String nextChar = " ";
    String replacement = " ";

    int numSpecial = 0;
    int numLower = 0;
    int numUpper = 0;

    //loops through each letter
    for (wordPosition = 0; wordPosition < baseWord.length; wordPosition++) {
      //assigns currentChar with next letter from baseWord, then retrieves list of replacements for that letter
      currentChar = baseWord[wordPosition].toLowerCase();
      List<String>? replacements = letterReplacements[currentChar];
      numSpecial = countSpecialCharacters(password.toString());
      numLower = countLowercaseLetters(password.toString());
      numUpper = countUppercaseLetters(password.toString());

      if(!letterReplacements.containsKey(currentChar)){
        password.write(currentChar);
        continue;
      }

      if (replacements != null && replacements.isNotEmpty) {
        //last letter
        if (wordPosition == (baseWord.length - 1)) {
          replacement = currentChar;

          //checks if forced to use char
          if(oddsMod >= 4){
            password.write(currentChar);
            oddsMod = 0;
            continue;
          }
          else if(probabilityCheck(replacements.length)) {
            replacement = replacements[random.nextInt(replacements.length)];
          }
          password.write(replacement);
        }
        else {
          nextChar = baseWord[wordPosition + 1].toLowerCase();
          password.write(characterCheck(currentChar, nextChar, replacements, numOfSpecialCharacters, numOfUppercase, numOfLowercase));
        }
      }
    }

    while(password.length < length){
      if(random.nextInt(10) < 5) {
        password.write(
            extendCharacters[random.nextInt(extendCharacters.length)]);
      }
      else{
        password.write(random.nextInt(9));
      }
    }
    return password.toString();
  }
}
