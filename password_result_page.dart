import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_v1/password_generate_page.dart';
import 'password_list_page.dart';
class PasswordResultPage extends StatelessWidget {
  String password;

  PasswordResultPage({required this.password});
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
            Text(
              'Password:',
              style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.1),
            ),
            SizedBox(height: 20.0),
              //Display the generated password in a TextField
            TextField(
              controller: TextEditingController(text: password),
              readOnly: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Generated Password',
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: password));
                  },
                  child: Text('Copy'),
                ),
                SizedBox(width: 20.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PasswordGeneratorPage()));
                  },
                  child: Text('ReGenerate'),
                ),
              ],
            ),
            /*
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PasswordListPage()));
              },
              child: Text('Save'),
            ),*/
          ],
        ),
      ),
    );
  }
}
