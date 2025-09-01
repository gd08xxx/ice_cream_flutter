import 'package:flutter/material.dart';

// Custom scroll physics for slower transitions
class SlowScrollPhysics extends PageScrollPhysics {
  const SlowScrollPhysics({super.parent});

  @override
  SlowScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return SlowScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 2.5, // Increased mass for slower transitions
        stiffness: 300, // Decreased stiffness for smoother transitions
        damping: 100, // Increased damping for less bouncing
      );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final PageController _pageController = PageController(viewportFraction: 1);
  int _currentIndex = 0;

  final List<Map<String, dynamic>> icecreams = [
    {
      'imagePath': "assets/17.png",
      'bgimg': "assets/13.png",
      'title': "Mango Magic",
      'desc': "Tropical vibes",
      'color': Colors.amberAccent,
    },
    {
      'imagePath': "assets/14.png",
      'bgimg': "assets/9.png",
      'title': "Almond Bliss",
      'desc': "Almond heaven",
      'color': const Color.fromARGB(255, 56, 159, 243),
    },
    {
      'imagePath': "assets/15.png",
      'bgimg': "assets/18.png",
      'title': "Strawberry Swirl",
      'desc': "Fresh & creamy",
      'color': Colors.pinkAccent,
    },
    {
      'imagePath': "assets/16.png",
      'bgimg': "assets/19.png",
      'title': "Choco Delight",
      'desc': "Sweet & chocolaty",
      'color': Colors.brown,
    },
    {
      'imagePath': "assets/11.png",
      'bgimg': "assets/10.png",
      'title': "Blue moon ",
      'desc': "Tropical vibes",
      'color': const Color.fromARGB(255, 90, 64, 240),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 65,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              // Clean Title
              Text(
                'Bliss',
                style: TextStyle(
                  color: Colors.pink.shade600,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  fontFamily: 'Jaya Baru',
                ),
              ),
              const Spacer(),
              // Elegant Search Bar
              Container(
                width: 200,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.pink[25],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.pink.shade100.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(
                    color: Colors.pink.shade600,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(
                      color: Colors.pink.shade300,
                      fontSize: 14,
                      fontFamily: 'Jaya Baru',
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: Colors.pink.shade300,
                      size: 18,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Ice Cream Info Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  icecreams[_currentIndex]['title'],
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                    fontFamily: 'Jaya Baru',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  icecreams[_currentIndex]['desc'],
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.2,
                    fontFamily: 'Jaya Baru',
                  ),
                ),
              ],
            ),
          ),
          // PageView Content with Animation
          Expanded(
            child: AnimatedBuilder(
              animation: _pageController,
              builder: (context, child) {
                return PageView.builder(
                  itemCount: icecreams.length,
                  controller: _pageController,
                  // Add custom physics for slower transitions
                  physics: const SlowScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    // Calculate the offset for animation
                    double offset = 0.0;
                    if (_pageController.position.haveDimensions) {
                      offset = _pageController.page! - index;
                    }

                    // Completely symmetric animation for both directions
                    double absOffset = offset.abs();

                    // Scale: decreases as page moves away from center
                    double scale = 1.0 - (absOffset * 0.3).clamp(0.0, 0.7);

                    // Opacity: sharp cutoff to eliminate slow fades
                    double opacity = absOffset < 0.8
                        ? 1.0 - (absOffset * 1.2)
                        : 0.0;
                    opacity = opacity.clamp(0.0, 1.0);

                    // Translation: symmetric movement
                    double translateX = offset * 120;

                    // Rotation: symmetric 3D effect
                    double rotateY = offset * 0.3;

                    // Ensure completely off-screen pages are invisible
                    if (absOffset > 1.0) {
                      opacity = 0.0;
                      scale = 0.2;
                    }

                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001) // Perspective
                        ..rotateY(rotateY)
                        ..translate(translateX, 0.0)
                        ..scale(scale),
                      child: Opacity(
                        opacity: opacity.clamp(0.0, 1.0),
                        child: SizedBox(
                          height: screenHeight,
                          width: screenWidth,
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              // Container (at bottom)
                              Positioned(
                                bottom: 0,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(100),
                                    topRight: Radius.circular(100),
                                  ),
                                  child: Container(
                                    height: screenHeight * 0.45,
                                    width: screenWidth * 0.94,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          icecreams[index]['color'],
                                          icecreams[index]['color'].withOpacity(
                                            0.7,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Background decoration image
                              Positioned(
                                top: index == 0
                                    ? 0
                                    : index == 1
                                    ? 50
                                    : index == 2
                                    ? -10
                                    : index == 3
                                    ? -20
                                    : 0,
                                right: index == 0
                                    ? -40
                                    : index == 1
                                    ? 10
                                    : index == 2
                                    ? -20
                                    : index == 3
                                    ? -150
                                    : -40,
                                bottom: index == 0
                                    ? 220
                                    : index == 1
                                    ? 110
                                    : index == 2
                                    ? 300
                                    : index == 3
                                    ? 300
                                    : 220,
                                child: Transform.scale(
                                  scale: scale,
                                  child: Opacity(
                                    opacity: opacity.clamp(0.0, 1.0),
                                    child: Image.asset(
                                      icecreams[index]['bgimg'],
                                    ),
                                  ),
                                ),
                              ),
                              // Ice Cream Image (half outside, half inside) with enhanced animation
                              Positioned(
                                top: screenHeight * 0.1,
                                child: Transform.scale(
                                  scale: scale,
                                  child: Transform.translate(
                                    offset: Offset(translateX * 0.5, 0),
                                    child: Opacity(
                                      opacity: opacity.clamp(0.0, 1.0),
                                      child: Image.asset(
                                        icecreams[index]['imagePath'],
                                        height: 600,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}