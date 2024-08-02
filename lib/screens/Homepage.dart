import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prova_flutter/screens/scan_devices.dart';
import 'package:prova_flutter/screens/welcome_page.dart'; // Assuming you have a WelcomeScreen for login

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _showConfirmDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Conferma Uscita'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Sei sicuro di voler uscire?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Annulla'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Esci'),
              onPressed: () async {
                await _signOut();
                Navigator.of(context).pop(); // Close the dialog
                // Navigate to WelcomeScreen after signing out
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomeScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _signOut() async {
    await _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.only(top: 70, left: 30, right: 30),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Human Activity Recognition",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.logout, color: Colors.blueGrey),
                  onPressed: _showConfirmDialog, // Changed here
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Text(
                  "Varie Attività",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Expanded(child: Container()),
                Text(
                  "Vedi i dati",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blueGrey,
                  ),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.arrow_forward,
                  size: 20,
                  color: Colors.cyan,
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blueGrey.withOpacity(0.8),
                    Colors.lightBlue.withOpacity(0.9),
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                  topRight: Radius.circular(80),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(5, 10),
                    blurRadius: 20,
                    color: Colors.blueAccent.withOpacity(0.2),
                  ),
                ],
              ),
              child: Container(
                padding: const EdgeInsets.only(left: 20, top: 25, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Trova i dispositivi nelle vicinanze",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Avvia la scansione ora...",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 25),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.timer,
                              size: 20,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "20 secondi",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Expanded(child: Container()),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ScanDevices(),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueGrey,
                                  blurRadius: 10,
                                  offset: Offset(4, 8),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.play_circle_fill,
                              color: Colors.white,
                              size: 60,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  "Attività Svolta",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: (MediaQuery.of(context).size.width - 90) / 2,
                        height: 200,
                        padding: EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 3,
                              offset: Offset(5, 5),
                              color: Colors.lightBlue.withOpacity(0.1),
                            ),
                            BoxShadow(
                              blurRadius: 3,
                              offset: Offset(-5, -5),
                              color: Colors.lightBlue.withOpacity(0.1),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                    image: AssetImage("images/running.jpg"),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Running",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: (MediaQuery.of(context).size.width - 90) / 2,
                        height: 200,
                        padding: EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 3,
                              offset: Offset(5, 5),
                              color: Colors.lightBlue.withOpacity(0.1),
                            ),
                            BoxShadow(
                              blurRadius: 3,
                              offset: Offset(-5, -5),
                              color: Colors.lightBlue.withOpacity(0.1),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                    image: AssetImage("images/walking.jpg"),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Walking",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width - 45,
                    height: 180,
                    padding: EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 3,
                          offset: Offset(5, 5),
                          color: Colors.lightBlue.withOpacity(0.1),
                        ),
                        BoxShadow(
                          blurRadius: 3,
                          offset: Offset(-5, -5),
                          color: Colors.lightBlue.withOpacity(0.1),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: AssetImage("images/stopping.jpg"),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Text(
                            "Stopping",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
