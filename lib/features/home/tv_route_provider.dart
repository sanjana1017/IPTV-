import 'package:flutter/material.dart';
import 'package:iptv_app/features/home/tv_route_model.dart';
import 'package:iptv_app/features/home/tv_route_services.dart';

class TvRouteProvider extends ChangeNotifier {
  List<TvRouteModel> _tvRoutes = [];
  List<TvRouteModel> get tvRoutes => _tvRoutes;

  List<String> _categories = [];
  List<String> get categories => _categories;

  String _searchText = '';

  // Getter and setter for searchText
  String get searchText => _searchText;
  set searchText(String text) {
    _searchText = text;
    notifyListeners();
  }

  Future<void> fetchTvRoutes() async {
    try {
      _tvRoutes = await TvRouteService.fetchTvRoutes();

      // Dynamically categorize routes based on name
      _tvRoutes.forEach((route) {
        if (route.name.contains('News')) {
          route.category = 'News';
        } else if (route.name.contains('Movies')) {
          route.category = 'Movie';
        } else if (route.name.contains('Kids')) {
          route.category = 'Kids';
        } else if (route.name.contains('Sports')) {
          route.category = 'Sports';
        } else if (route.name.contains('Music')) {
          route.category = 'Music';
        } else if (route.name.contains('Documentary')) {
          route.category = 'Documentary';
        } else if (route.name.contains('Comedy')) {
          route.category = 'Comedy';
        } else if (route.name.contains('Business')) {
          route.category = 'Business';
        } else if (route.name.contains('Lifestyle')) {
          route.category = 'Lifestyle';
        } else if (route.name.contains('Shopping')) {
          route.category = 'Shopping';
        } else if (route.name.contains('Religious')) {
          route.category = 'Religious';
        } else if (route.name.contains('International')) {
          route.category = 'International';
        } else if (route.name.contains('Anime')) {
          route.category = 'Anime';
        } else if (route.name.contains('Classic')) {
          route.category = 'Classic TV';
        } else if (route.name.contains('Educational')) {
          route.category = 'Educational';
        } else if (route.name.contains('Entertainment')) {
          route.category = 'Entertainment';
        } else if (route.name.contains('Fashion')) {
          route.category = 'Fashion';
        } else if (route.name.contains('Food')) {
          route.category = 'Food';
        } else if (route.name.contains('Gaming')) {
          route.category = 'Gaming';
        } else if (route.name.contains('Health') ||
            route.name.contains('Wellness')) {
          route.category = 'Health and wellness';
        } else {
          route.category = 'Others';
        }
      });

      _categories = _tvRoutes.map((route) => route.category).toSet().toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching TV routes: $e');
    }
  }

  // Filtered TV routes based on searchText
  List<TvRouteModel> get filteredTvRoutes {
    if (_searchText.isEmpty) {
      return _tvRoutes;
    } else {
      return _tvRoutes
          .where((route) =>
              route.name.toLowerCase().contains(_searchText.toLowerCase()))
          .toList();
    }
  }

  // Filtered TV routes by category
  List<TvRouteModel> filteredTvRoutesByCategory(String category) {
    return _tvRoutes.where((route) => route.category == category).toList();
  }
}
