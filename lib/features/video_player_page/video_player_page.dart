import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iptv_app/features/home/drawer/custom_drawer.dart';
import 'package:iptv_app/features/home/tv_route_model.dart';
import 'package:iptv_app/features/home/tv_route_provider.dart';
import 'package:iptv_app/features/video_player_page/full_screen_state_provider.dart';
import 'package:lecle_yoyo_player/lecle_yoyo_player.dart';
import 'package:provider/provider.dart';

class VideoPlayerPage extends StatefulWidget {
  final String title;
  final String streamUrl;
  final String imgUrl;

  const VideoPlayerPage({
    super.key,
    required this.title,
    required this.streamUrl,
    required this.imgUrl,
  });

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  bool _isGridView = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<FullScreenState>(
      builder: (context, fullScreenState, _) {
        return Scaffold(
          appBar: !fullScreenState.isFullScreen
              ? AppBar(
                  title: Text(
                    widget.title,
                    style: GoogleFonts.ubuntu(
                      textStyle: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  centerTitle: true,
                  backgroundColor: const Color(0xFF6C63FF),
                  iconTheme: const IconThemeData(
                    color: Colors.white,
                    size: 28,
                  ),
                )
              : null,
          drawer: const CustomDrawer(), // Add the drawer here
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 255, 255, 255),
                  Color(0xFFE8EAF6),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  YoYoPlayer(
                    aspectRatio: 16 / 9,
                    url: widget.streamUrl,
                    videoStyle: const VideoStyle(),
                    videoLoadingStyle: const VideoLoadingStyle(
                      loading: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF6C63FF),
                        ),
                      ),
                    ),
                    onFullScreen: (isFullScreen) {
                      fullScreenState.setFullScreen(isFullScreen);
                    },
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _moreText(),
                        _toggleViewButton(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Consumer<TvRouteProvider>(
                      builder: (context, provider, _) {
                        if (provider.tvRoutes.isEmpty) {
                          provider.fetchTvRoutes();
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF6C63FF),
                            ),
                          );
                        } else {
                          final List<TvRouteModel> randomRoutes =
                              provider.tvRoutes.toList()..shuffle();
                          final firstTenRoutes = randomRoutes.take(10).toList();

                          return _isGridView
                              ? _buildGridView(firstTenRoutes)
                              : _buildListView(firstTenRoutes);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _toggleViewButton() {
    return IconButton(
      icon: Icon(
        _isGridView ? Icons.list : Icons.grid_on,
        size: 30,
        color: const Color(0xFF6C63FF),
      ),
      onPressed: () {
        setState(() {
          _isGridView = !_isGridView;
        });
      },
    );
  }

  Widget _buildListView(List<TvRouteModel> routes) {
    return ListView.builder(
      itemCount: routes.length,
      itemBuilder: (context, index) {
        final route = routes[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.5),
          child: HoverableChannelTile(route: route, isGridView: _isGridView),
        );
      },
    );
  }

  Widget _buildGridView(List<TvRouteModel> routes) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: routes.length,
      itemBuilder: (context, index) {
        final route = routes[index];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPlayerPage(
                title: route.name,
                streamUrl: route.link,
                imgUrl: route.logo,
              ),
            ),
          ),
          child: HoverableChannelTile(route: route, isGridView: _isGridView),
        );
      },
    );
  }

  Padding _moreText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Row(
        children: [
          const Icon(Icons.tv),
          const SizedBox(width: 10),
          Text(
            'More:',
            style: GoogleFonts.ubuntu(
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HoverableChannelTile extends StatefulWidget {
  final TvRouteModel route;
  final bool isGridView;

  const HoverableChannelTile({
    required this.route,
    required this.isGridView,
    Key? key,
  }) : super(key: key);

  @override
  _HoverableChannelTileState createState() => _HoverableChannelTileState();
}

class _HoverableChannelTileState extends State<HoverableChannelTile> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          boxShadow: isHovered
              ? [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(0, 5),
                  ),
                ]
              : [],
          borderRadius: BorderRadius.circular(10),
          border: isHovered
              ? Border.all(
                  color: Colors.red, // Border color on hover
                  width: 1, // Border thickness on hover
                )
              : null,
          color: Colors.white,
        ),
        child: widget.isGridView
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 150, // Adjust size as needed
                  height: 150, // Adjust size as needed
                  child: Image.network(
                    widget.route.logo,
                    fit:
                        BoxFit.contain, // Ensures the image fits within the box
                  ),
                ),
              )
            : ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.route.logo,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  widget.route.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPlayerPage(
                      title: widget.route.name,
                      streamUrl: widget.route.link,
                      imgUrl: widget.route.logo,
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  void _onHover(bool hovering) {
    setState(() {
      isHovered = hovering;
    });
  }
}
