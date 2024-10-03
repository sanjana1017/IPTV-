import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:iptv_app/features/home/tv_route_provider.dart';
import 'package:iptv_app/features/video_player_page/video_player_page.dart';
import 'package:iptv_app/features/home/tv_route_model.dart';
import 'package:iptv_app/features/home/drawer/custom_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isGridView = false;
  String? _selectedCategory;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<TvRouteProvider>(context, listen: false);
      provider.fetchTvRoutes();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TvRouteProvider>(context);
    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: _appBar(context),
      drawer: const CustomDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF121212),
              const Color(0xFF3C3C3C),
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      onChanged: (text) {
                        provider.searchText = text;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[800],
                        hintText: 'Search Channel...',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 20,
                        ),
                        suffixIcon: const Icon(Icons.search, color: Colors.green),
                      ),
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: ['All', ...provider.categories].map((category) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategory = category == 'All' ? null : category;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                            decoration: BoxDecoration(
                              color: _selectedCategory == category ||
                                  (_selectedCategory == null && category == 'All')
                                  ? const Color(0xFFB9FF63)
                                  : Colors.grey[700],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                category,
                                style: GoogleFonts.ubuntu(
                                  textStyle: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: _selectedCategory == category ||
                                        (_selectedCategory == null && category == 'All')
                                        ? Colors.black
                                        : Colors.green[300],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Channels',
                        style: GoogleFonts.ubuntu(
                          textStyle: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _isGridView ? Icons.list : Icons.grid_view,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          setState(() {
                            _isGridView = !_isGridView;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              _isGridView
                  ? SliverGrid(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final route = _getFilteredRoutes(provider)[index];
                    return GestureDetector(
                      onTap: () => _navigateToVideoPlayer(route),
                      child: HoverableChannelTile(route: route, isGridView: true),
                    );
                  },
                  childCount: _getFilteredRoutes(provider).length,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _getCrossAxisCount(orientation),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: _getChildAspectRatio(orientation),
                ),
              )
                  : SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final route = _getFilteredRoutes(provider)[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: GestureDetector(
                        onTap: () => _navigateToVideoPlayer(route),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 80, // Increased width
                              height: 80, // Increased height
                              child: HoverableChannelTile(route: route, isGridView: false),
                            ),
                            const SizedBox(width: 15), // Increased space between logo and title
                            Expanded(
                              child: Text(
                                route.name, // Display the channel name
                                style: GoogleFonts.ubuntu(
                                  textStyle: const TextStyle(
                                    fontSize: 18, // Increased font size
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: _getFilteredRoutes(provider).length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<TvRouteModel> _getFilteredRoutes(TvRouteProvider provider) {
    return _selectedCategory == null
        ? provider.filteredTvRoutes
        : provider.filteredTvRoutesByCategory(_selectedCategory!);
  }

  int _getCrossAxisCount(Orientation orientation) {
    final width = MediaQuery.of(context).size.width;

    if (orientation == Orientation.portrait) {
      return width < 800 ? 2 : 3;
    } else {
      return width < 800 ? 4 : 6;
    }
  }

  double _getChildAspectRatio(Orientation orientation) {
    final width = MediaQuery.of(context).size.width;

    if (orientation == Orientation.portrait) {
      return width < 800 ? 1.2 : 1.2;
    } else {
      return 1.2;
    }
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      centerTitle: true,
      backgroundColor: const Color(0xFF121212),
      iconTheme: const IconThemeData(
        color: Colors.green,
        size: 28,
      ),
      title: Text(
        'Netconnect',
        style: GoogleFonts.ubuntu(
          textStyle: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.account_circle),
          onPressed: () {},
        ),
      ],
    );
  }

  void _navigateToVideoPlayer(TvRouteModel route) {
    if (route.link.isEmpty || route.link == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid video URL')),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerPage(
            title: route.name,
            streamUrl: route.link,
            imgUrl: route.logo,
          ),
        ),
      );
    }
  }
}

// HoverableChannelTile widget to display channels with transparent backgrounds
class HoverableChannelTile extends StatelessWidget {
  final TvRouteModel route;
  final bool isGridView;

  const HoverableChannelTile({
    Key? key,
    required this.route,
    required this.isGridView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent, // Ensure the background is transparent
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.5), width: 1), // Optional border
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Semi-transparent overlay to improve logo visibility
            Container(
              color: Colors.grey.withOpacity(0.1), // Dark overlay
            ),
            Image.network(
              route.logo,
              fit: BoxFit.contain, // Ensure the whole logo is visible
              height: isGridView ? 120 : 80, // Maintain height
              width: isGridView ? 120 : 80, // Maintain width
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[800],
                  alignment: Alignment.center,
                  child: const Icon(Icons.error, color: Colors.red),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
