import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const PineappleFrameApp());
}

class PineappleFrameApp extends StatelessWidget {
  const PineappleFrameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pineapple Picture Frame',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
        useMaterial3: true,
      ),
      home: const PictureFrameScreen(),
    );
  }
}

class PictureFrameScreen extends StatefulWidget {
  const PictureFrameScreen({super.key});

  @override
  State<PictureFrameScreen> createState() => _PictureFrameScreenState();
}

class _PictureFrameScreenState extends State<PictureFrameScreen> {
  final List<String> imageUrls = [
    'https://pineapple-frame-images.s3.us-east-2.amazonaws.com/IMG_1815.JPG',
    'https://pineapple-frame-images.s3.us-east-2.amazonaws.com/Snapchat-1478783425.jpg',
    'https://pineapple-frame-images.s3.us-east-2.amazonaws.com/Snapchat-416689822.jpg',
    'https://pineapple-frame-images.s3.us-east-2.amazonaws.com/Snapchat-991091801.jpg',
  ];

  int currentIndex = 0;
  Timer? timer;
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    startImageRotation();
  }

  void startImageRotation() {
    timer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (!isPaused) {
        setState(() {
          currentIndex = (currentIndex + 1) % imageUrls.length;
        });
      }
    });
  }

  void togglePause() {
    setState(() {
      isPaused = !isPaused;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade100,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('assets/pineapple_border.png'),
              fit: BoxFit.fill,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              child: Image.network(
                imageUrls[currentIndex],
                key: ValueKey<int>(currentIndex),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.broken_image, size: 100, color: Colors.grey),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: togglePause,
        backgroundColor: Colors.orangeAccent,
        icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
        label: Text(isPaused ? 'Resume' : 'Pause'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}