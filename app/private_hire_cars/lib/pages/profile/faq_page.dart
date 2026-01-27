import 'package:flutter/material.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key, required this.title});

  final String title;

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _faqs = [
    {
      'question': 'How to book a ride?',
      'answer':
          'To book a ride, simply choose one of the four services, enter your destination, and select a vehicle.',
    },
    {
      'question': 'How do I get loyalty points?',
      'answer':
          'You can earn loyalty points by booking rides through the app.',
    },
    {
      'question': 'How do I get discounts?',
      'answer':
          'Discounts are available through booking online and depends on your loyalty status.',
    },
    {
      'question': 'What payment methods are accepted?',
      'answer':
          'We accept credit cards, debit cards, and mobile payment options.',
    },
    {
      'question': 'How to contact customer support?',
      'answer':
          'You can contact customer support through the app by clicking the profile button and the settings button or by calling our hotline.',
    },
    {
      'question': 'What should I do if I forget something in the car?',
      'answer':
          'Please contact our customer support with details of your ride and the lost item.',
    },
    {
      'question': 'Can I schedule a ride in advance?',
      'answer':
          'Yes, you can schedule rides up to 30 days in advance through the app.',
    },
    {
      'question': 'Are there any cancellation fees?',
      'answer':
          'Cancellation fees may apply depending on the timing of your cancellation.',
    },
    {
      'question': 'How do I update my profile information?',
      'answer':
          'You can update your profile information in the Profile button.',
    },
    {
      'question': 'Is there a loyalty program?',
      'answer':
          'Yes, we offer a loyalty program where you can earn points for each ride.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredFaqs = _faqs.where((faq) {
      final query = _searchController.text.toLowerCase();
      return faq['question']!.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text(widget.title), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// Search bar
            TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search FAQ...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// FAQ list
            Expanded(
              child: ListView.builder(
                itemCount: filteredFaqs.length,
                itemBuilder: (context, index) {
                  final faq = filteredFaqs[index];
                  return ExpansionTile(
                    title: Text(
                      faq['question']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Text(
                          faq['answer']!,
                          style: const TextStyle(fontSize: 18, height: 1.4),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
