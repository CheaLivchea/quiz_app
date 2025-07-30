import 'package:flutter/material.dart';
import 'package:quiz_app/views/pages/secondScreen.dart';

// Home Screen
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int counter = 0;
  late TextEditingController nameController;

  @override
  @override
  void initState() {
    super.initState();
    print("🔵 initState: HomeScreen");

    nameController = TextEditingController(); // ✅ initialized

    // Simulate fetching data
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        nameController.text = "Chea Livhcea"; // ✅ safe usage
        print("📦 Fetched name from API");
        setState(() {}); // ✅ triggers rebuild
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("🟡 didChangeDependencies: HomeScreen");
  }

  @override
  void didUpdateWidget(covariant Home oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("🟠 didUpdateWidget: HomeScreen");
  }

  @override
  void deactivate() {
    print("⚪ deactivate: HomeScreen");
    super.deactivate();
  }

  @override
  void dispose() {
    print("🔴 dispose: HomeScreen");
    nameController.dispose(); // clean up the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("🟢 build: HomeScreen");

    return Scaffold(
      appBar: AppBar(title: Text("Lifecycle Demo")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Counter: $counter", style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  counter++;
                });
              },
              child: Text("Increment Counter"),
            ),
            SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SecondScreen()),
                );
              },
              child: Text("Go to Second Screen"),
            ),
          ],
        ),
      ),
    );
  }
}

// Second Screen (to trigger deactivate & dispose of HomeScreen)
