import 'package:flutter/material.dart';

void main() {
  runApp(GreetingApp());
}

class GreetingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Greeting App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData.dark(), // Define dark theme
      debugShowCheckedModeBanner: false,
      home: GreetingScreen(),
    );
  }
}

class GreetingScreen extends StatefulWidget {
  @override
  _GreetingScreenState createState() => _GreetingScreenState();
}

class _GreetingScreenState extends State<GreetingScreen> {
  String _greetingMessage = '';
  String _defaultGreetingMessage = '';
  String _editedGreetingMessage = '';
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _setGreeting();
  }

  void _setGreeting() {
    var now = DateTime.now();
    var hour = now.hour;

    setState(() {
      if (_editedGreetingMessage.isNotEmpty) {
        _greetingMessage = _editedGreetingMessage;
      } else {
        if (hour < 12) {
          _greetingMessage = 'Good Morning';
        } else if (hour < 17) {
          _greetingMessage = 'Good Afternoon';
        } else {
          _greetingMessage = 'Good Evening';
        }
      }
      _defaultGreetingMessage = _greetingMessage;
    });
  }

  void _editGreeting() async {
    final TextEditingController controller = TextEditingController();
    controller.text = _editedGreetingMessage.isNotEmpty ? _editedGreetingMessage : _defaultGreetingMessage;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Greeting Message'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter custom greeting message'),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _editedGreetingMessage = controller.text;
                });
                _setGreeting(); // Update greeting message immediately after editing
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _resetToDefaultGreeting() {
    setState(() {
      _editedGreetingMessage = ''; // Clear edited message
    });
    _setGreeting(); // Set greeting to default
  }

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: _themeMode, // Set theme mode
      darkTheme: ThemeData.dark(), // Define dark theme
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Greeting App',style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.blue,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.edit,),
              onPressed: _editGreeting,
            ),
            IconButton(
              icon: Icon(Icons.settings_backup_restore),
              onPressed: _resetToDefaultGreeting,
            ),
            IconButton(
              icon: Icon(Icons.mode_night_rounded),
              onPressed: _toggleTheme, // Add settings button to toggle theme
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                _greetingMessage,
                style: TextStyle(fontSize: 24.0),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _setGreeting,
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.blue, // Change the text color of the button
                ),// Call _setGreeting to update greeting message
                child: Text('Greet'),

              ),
            ],
          ),
        ),
      ),
    );
  }
}

