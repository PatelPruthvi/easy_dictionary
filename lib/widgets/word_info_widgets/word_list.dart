import 'package:flutter/material.dart';

class WordList extends StatelessWidget {
  const WordList({
    super.key,
    required this.title,
    required this.words,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String title;
  final List<String> words;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return words.isEmpty
        ? Container()
        : Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: backgroundColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontFamily: 'Varela',
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Wrap(
                    spacing: 10,
                    children: words.map((word) {
                      return Chip(
                        labelStyle: const TextStyle(
                            fontFamily: 'Varela',
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 5),
                        label: Text(word),
                        side: const BorderSide(color: Colors.transparent),
                        backgroundColor: foregroundColor,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
  }
}
