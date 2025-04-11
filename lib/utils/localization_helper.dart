import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:who_most_likely_to/providers/language_provider.dart';

String getLocalizedText(BuildContext context, Map<String, String> texts) {
  final languageProvider = Provider.of<LanguageProvider>(
    context,
    listen: false,
  );
  return texts[languageProvider.currentLanguage] ?? texts['en']!;
}

String getLocalizedQuestion(
  BuildContext context,
  Map<String, String> question,
) {
  return getLocalizedText(context, question);
}

String getLocalizedCategoryName(
  BuildContext context,
  Map<String, dynamic> category,
) {
  return getLocalizedText(context, category['name']);
}

String getLocalizedCategoryDescription(
  BuildContext context,
  Map<String, dynamic> category,
) {
  return getLocalizedText(context, category['description']);
}
