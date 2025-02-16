import 'package:flutter_riverpod/flutter_riverpod.dart';

// A simple provider that manages an integer counter
final counterProvider = StateProvider<int>((ref) => 0);