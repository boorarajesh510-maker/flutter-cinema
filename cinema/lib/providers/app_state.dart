import 'package:flutter/material.dart';
import '../models/movie.dart';

/// Single ChangeNotifier used with Provider for the whole app.
class AppState extends ChangeNotifier {
  String _query = '';
  String _genre = 'All';
  final Set<int> _favs = {};
  final Map<int, List<Review>> _reviews = {};
  ThemeMode themeMode = ThemeMode.dark;
  String? userName, userEmail;

  String get genre => _genre;
  int get favCount => _favs.length;
  int get reviewCount => _reviews.values.fold(0, (a, b) => a + b.length);

  List<Movie> get filtered => movies
      .where((m) =>
          (_genre == 'All' || m.genre == _genre) &&
          m.title.toLowerCase().contains(_query.toLowerCase()))
      .toList();

  List<Movie> get favorites => movies.where((m) => _favs.contains(m.id)).toList();
  Movie get featured => ([...movies]..sort((a, b) => b.rating.compareTo(a.rating))).first;
  bool isFav(int id) => _favs.contains(id);
  List<Review> reviewsFor(int id) => _reviews[id] ?? [];

  void setQuery(String q) { _query = q; notifyListeners(); }
  void setGenre(String g) { _genre = g; notifyListeners(); }

  void toggleFav(int id) {
    _favs.contains(id) ? _favs.remove(id) : _favs.add(id);
    notifyListeners();
  }

  void addReview(int id, Review r) {
    _reviews.putIfAbsent(id, () => []).insert(0, r);
    notifyListeners();
  }

  void toggleTheme() {
    themeMode = themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void login(String name, String email) {
    userName = name.isEmpty ? email.split('@').first : name;
    userEmail = email;
    notifyListeners();
  }

  void logout() { userName = userEmail = null; _favs.clear(); notifyListeners(); }
}
