import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef OnSearchPressed = Function(String keyword);

class SearchTextField extends ConsumerWidget {
  final OnSearchPressed? _onSearchPressed;

  const SearchTextField({Key? key, OnSearchPressed? onSearchPressed})
      : _onSearchPressed = onSearchPressed,
        super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 8),
      child: TextField(
        decoration: const InputDecoration(hintText: 'Please type a query'),
        onSubmitted: _onSearchPressed?.call,
      ),
    );
  }
}
