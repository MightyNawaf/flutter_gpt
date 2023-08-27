import 'package:flutter/material.dart';
import 'package:gpt_tuwaiq/services/gpt.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Home());
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final predefinedInterests = [
      'Scuba diving',
      'Horse riding',
      'Football',
      'Swimming',
      'Sky diving',
      'Camping',
      'Hiking'
    ];

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            Material(
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.circular(8),
              elevation: 5,
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: const LinearGradient(
                    colors: [Color.fromARGB(255, 240, 219, 30), Colors.red],
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        if (Data.budget > 0) {
                          Data.budget -= 1000;
                        }
                        setState(() {});
                      },
                      child: const Icon(Icons.remove),
                    ),
                    Text('\$ ${Data.budget}'),
                    InkWell(
                      onTap: () {
                        Data.budget += 1000;
                        setState(() {});
                      },
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 128,
            ),
            for (final interest in predefinedInterests) ...[
              InkWell(
                onTap: () {
                  if (!Data.interests.contains(interest)) {
                    Data.interests.add(interest);
                  } else {
                    Data.interests.remove(interest);
                  }
                  setState(() {});
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Data.interests.contains(interest) ? Colors.blue : Colors.grey),
                      borderRadius: BorderRadius.circular(6)),
                  padding: const EdgeInsets.all(8),
                  child: Text(interest),
                ),
              ),
              const SizedBox(
                height: 8,
              )
            ],
            const SizedBox(
              height: 120,
            ),
            ElevatedButton(
              onPressed: () async {
                final suggestionsList = await GPTService().getSuggestions();
                if (context.mounted) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SuggestionsList(
                      suggestions: suggestionsList,
                    );
                  }));
                }
              },
              child: const Text('View Suggestions! 🔥'),
            ),
          ],
        ),
      ),
    );
  }
}

class SuggestionsList extends StatelessWidget {
  const SuggestionsList({super.key, required this.suggestions});

  final List<Suggestion> suggestions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const Text(
            'Here are our suggestions to you: 🔥',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
          ),
          const SizedBox(
            height: 24,
          ),
          for (final s in suggestions) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.black,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    '${s.city}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('${s.description}'),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            )
          ]
        ],
      ),
    );
  }
}
