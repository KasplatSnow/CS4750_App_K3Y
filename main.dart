import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'password_generate_page.dart';
import 'password_list_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PasswordScreen(),
    );
  }
}
class PasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('K3Y'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /*
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PasswordListPage()));
              },
              child: Text('Passwords'),
            ),*/
            Container(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'K3Y',
                style: TextStyle(
                  fontSize: 40.0, // Adjust the font size as needed
                  //fontFamily: 'YourFontName', // Specify your desired font family
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PasswordGeneratorPage()));
              },
              child: Text('Generate'),
            ),
          ],
        ),
      ),
    );
  }
}
