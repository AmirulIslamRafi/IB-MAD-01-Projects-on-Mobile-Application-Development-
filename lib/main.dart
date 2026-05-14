import 'package:flutter/material.dart'; // ফ্লাটারের ডিজাইন প্যাকেজ।

void main() {
  runApp(const BMICalculatorApp()); // অ্যাপ রান করার মেইন ফাংশন।
}

class BMICalculatorApp extends StatelessWidget {
  const BMICalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BMI Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const BMICalculatorScreen(),
    );
  }
}

class BMICalculatorScreen extends StatefulWidget {
  const BMICalculatorScreen({super.key});

  @override
  State<BMICalculatorScreen> createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  // ফুট, ইঞ্চি এবং ওজনের জন্য আলাদা তিনটি কন্ট্রোলার
  final TextEditingController _feetController = TextEditingController();
  final TextEditingController _inchesController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  double? _bmiResult; // BMI মান রাখার ভেরিয়েবল
  String _bmiStatus = ""; // ওজনের অবস্থা রাখার ভেরিয়েবল

  // ফুট ও ইঞ্চি থেকে BMI হিসাব করার ফাংশন
  void _calculateBMI() {
    final double? feet = double.tryParse(_feetController.text);
    final double? inches = double.tryParse(_inchesController.text) ?? 0;
    final double? weightKg = double.tryParse(_weightController.text);

    if (feet != null && weightKg != null && feet > 0 && weightKg > 0) {

      // এখানে .toDouble() যোগ করা হয়েছে এরর সমাধানের জন্য
      final double totalInches = ((feet * 12) + inches!).toDouble();

      final double totalCm = totalInches * 2.54;
      final double heightMeters = totalCm / 100;

      setState(() {
        _bmiResult = weightKg / (heightMeters * heightMeters);

        if (_bmiResult! < 18.5) {
          _bmiStatus = "Underweight (কম ওজন)";
        } else if (_bmiResult! >= 18.5 && _bmiResult! < 24.9) {
          _bmiStatus = "Normal (সঠিক ওজন)";
        } else if (_bmiResult! >= 25 && _bmiResult! < 29.9) {
          _bmiStatus = "Overweight (অতিরিক্ত ওজন)";
        } else {
          _bmiStatus = "Obese (স্থূলতা বা অতিরিক্ত চর্বি)";
        }
      });
    } else {
      setState(() {
        _bmiResult = null;
        _bmiStatus = "দয়া করে সঠিক ফুট এবং ওজন ইনপুট দিন";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ফুট এবং ইঞ্চির ইনপুট বক্স দুটি পাশাপাশি দেখানোর জন্য Row ব্যবহার করা হয়েছে
            Row(
              children: [
                // ফুটের ইনপুট বক্স (স্ক্রিনের অর্ধেক জায়গা নেবে)
                Expanded(
                  child: TextField(
                    controller: _feetController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Height (Feet)',
                      hintText: 'যেমন: 5',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.height),
                    ),
                  ),
                ),
                const SizedBox(width: 16), // দুই বক্সের মাঝের গ্যাপ

                // ইঞ্চির ইনপুট বক্স (স্ক্রিনের বাকি অর্ধেক জায়গা নেবে)
                Expanded(
                  child: TextField(
                    controller: _inchesController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Inches',
                      hintText: 'যেমন: 6',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.straighten),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16), // উচ্চতা এবং ওজনের বক্সের মাঝের গ্যাপ

            // ওজনের ইনপুট বক্স
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Weight (ওজন কেজি-তে)',
                hintText: 'যেমন: 65',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.monitor_weight),
              ),
            ),
            const SizedBox(height: 24),

            // হিসাব করার বাটন
            ElevatedButton(
              onPressed: _calculateBMI,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Calculate BMI',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 32),

            // ফলাফল দেখানোর অংশ
            if (_bmiResult != null) ...[
              Text(
                'আপনার BMI: ${_bmiResult!.toStringAsFixed(1)}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const SizedBox(height: 8),
              Text(
                _bmiStatus,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.green),
              ),
            ] else if (_bmiStatus.isNotEmpty) ...[
              Text(
                _bmiStatus,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
