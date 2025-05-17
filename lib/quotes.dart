import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart'; // Import share_plus for sharing quotes

class QuotesPage extends StatefulWidget {
  const QuotesPage({super.key});

  @override
  State<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  final PageController _pageController = PageController();
  final List<String> quotes = [
    "Believe in yourself and all that you are.",
    "Your only limit is your mind.",
    "Don’t watch the clock; do what it does. Keep going.",
    "Success is not final, failure is not fatal: It is the courage to continue that counts.",
    "Hardships often prepare ordinary people for an extraordinary destiny.",
    "Stay focused and never give up.",
    "Small steps every day lead to big results.",
  ];

  Set<int> favoriteIndices = {};
  int _currentPage = 0;

  void toggleFavorite(int index) {
    setState(() {
      if (favoriteIndices.contains(index)) {
        favoriteIndices.remove(index);
      } else {
        favoriteIndices.add(index);
      }
    });
  }

  void shareQuote(String quote) {
    Share.share(quote);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("💬 Quotes"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // PageView
          PageView.builder(
            controller: _pageController,
            itemCount: quotes.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final isFav = favoriteIndices.contains(index);
              return Center(
               child: Padding(
  padding: const EdgeInsets.all(24.0),
  child: Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 800, // Set a max width suitable for web
      ),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        color: Colors.white.withOpacity(0.9),
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.format_quote, size: 40, color: Colors.deepPurple),
              const SizedBox(height: 20),
              Text(
                quotes[index],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontStyle: FontStyle.italic,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: Colors.pink,
                    ),
                    onPressed: () => toggleFavorite(index),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(Icons.share, color: Colors.deepPurple),
                    onPressed: () => shareQuote(quotes[index]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  ),
),

              );
            },
          ),
        ],
      ),
    );
  }
}

