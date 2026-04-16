import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const NintendoPuzzleMasterApp());
}

// Model for our Nintendo Characters
class NintendoCharacter {
  final String name;
  final String icon; // Used for the left menu
  final String imageUrl; // Used for the puzzle

  NintendoCharacter(this.name, this.icon, this.imageUrl);
}

class NintendoPuzzleMasterApp extends StatelessWidget {
  const NintendoPuzzleMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nintendo Puzzle Master',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: const Color(
          0xFFFFEBCD,
        ), // Soft wood/table color
        fontFamily: 'Comic Sans MS', // Gives it a cute, playful vibe
      ),
      home: const PuzzleScreen(),
    );
  }
}

class PuzzleScreen extends StatefulWidget {
  const PuzzleScreen({super.key});

  @override
  State<PuzzleScreen> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  // Nintendo Character Data
  final List<NintendoCharacter> _characters = [
    NintendoCharacter('Mario', '🍄', 'assests/images/mario.png'),
    NintendoCharacter('Toadette', '🍄', 'assests/images/kinopiko.webp'),
    NintendoCharacter('Shy Guy', '👻', 'assests/images/shyguy.jpeg'),
    NintendoCharacter('Pikachu', '⚡', 'assests/images/pikachu.png'),
    NintendoCharacter(
      'Daisy',
      '🌼',
      'assests/images/Masthead_Daisy.06328198.0a17f5ff.png',
    ),
    NintendoCharacter('DK', '🦍', 'assests/images/donkey.webp'),
  ];

  int _currentIndex = 0;
  late List<int> _tiles;
  bool _isSolved = false;

  @override
  void initState() {
    super.initState();
    _initializePuzzle();
  }

  void _initializePuzzle() {
    _isSolved = false;
    _tiles = [0, 1, 2, 3, 4, 5, 6, 7, 8]; // 8 is the empty space

    // Simulate random valid moves to ensure the puzzle is mathematically solvable
    final random = Random();
    int emptyIndex = 8;
    // Lowered from 150 to 15 to make the puzzle much simpler to solve
    for (int i = 0; i < 15; i++) {
      List<int> validMoves = _getValidMoves(emptyIndex);
      int randomMove = validMoves[random.nextInt(validMoves.length)];
      _tiles[emptyIndex] = _tiles[randomMove];
      _tiles[randomMove] = 8; // 8 is our empty tile indicator
      emptyIndex = randomMove;
    }
    setState(() {});
  }

  List<int> _getValidMoves(int emptyIndex) {
    List<int> moves = [];
    int row = emptyIndex ~/ 3;
    int col = emptyIndex % 3;
    if (row > 0) moves.add(emptyIndex - 3);
    if (row < 2) moves.add(emptyIndex + 3);
    if (col > 0) moves.add(emptyIndex - 1);
    if (col < 2) moves.add(emptyIndex + 1);
    return moves;
  }

  void _onTileTap(int index) {
    if (_isSolved) return;

    int emptyIndex = _tiles.indexOf(8);
    if (_getValidMoves(emptyIndex).contains(index)) {
      setState(() {
        _tiles[emptyIndex] = _tiles[index];
        _tiles[index] = 8;
      });
      _checkWinCondition();
    }
  }

  void _checkWinCondition() {
    bool isWon = true;
    for (int i = 0; i < 9; i++) {
      if (_tiles[i] != i) {
        isWon = false;
        break;
      }
    }
    if (isWon) {
      setState(() {
        _isSolved = true;
      });
    }
  }

  void _nextPicture() {
    if (_currentIndex < _characters.length - 1) {
      setState(() {
        _currentIndex++;
        _initializePuzzle();
      });
    }
  }

  void _prevPicture() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _initializePuzzle();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isWideScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Fancy Title
            Text(
              '🎮 Puzzle Master 🎮',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.pink[300],
                shadows: const [
                  Shadow(
                    color: Colors.white,
                    offset: Offset(2, 2),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Main Content Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Flex(
                  direction: isWideScreen ? Axis.horizontal : Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // LEFT PANEL: Character Selector
                    Expanded(flex: 1, child: _buildLeftPanel()),
                    SizedBox(
                      width: isWideScreen ? 16 : 0,
                      height: isWideScreen ? 0 : 16,
                    ),

                    // RIGHT PANEL: Puzzle Area
                    Expanded(flex: 2, child: _buildRightPanel()),
                  ],
                ),
              ),
            ),

            // Bottom Decorative Stars (matching your image)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star_rounded, color: Colors.yellow[700], size: 50),
                  const SizedBox(width: 10),
                  Icon(Icons.star_rounded, color: Colors.yellow[700], size: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // "Select Multiple Pictures" Pink Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.pink[200],
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text(
              '📁 Select Character',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Loaded ${_characters.length} characters',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          const SizedBox(height: 16),

          // Character Grid
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _characters.length,
              itemBuilder: (context, index) {
                bool isSelected = index == _currentIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = index;
                      _initializePuzzle();
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.pink[50] : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? Colors.pink[300]!
                            : Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _characters[index].imageUrl.startsWith('http')
                            ? Image.network(
                                _characters[index].imageUrl,
                                width: 40,
                                height: 40,
                                fit: BoxFit.contain,
                              )
                            : Image.asset(
                                _characters[index].imageUrl,
                                width: 40,
                                height: 40,
                                fit: BoxFit.contain,
                              ),
                        const SizedBox(height: 4),
                        Text(
                          _characters[index].name,
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected
                                ? Colors.pink[700]
                                : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Current Picture: ${_currentIndex + 1}/${_characters.length}',
            style: TextStyle(
              color: Colors.pink[300],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // The Puzzle Grid
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Calculate exact size of each tile based on the available space
                    double boardSize = constraints.maxWidth;
                    double tileSize = boardSize / 3;

                    return Stack(
                      children: [
                        Container(
                          color: Colors.grey[200],
                        ), // Background for empty slot
                        // Build the 9 tiles
                        ...List.generate(9, (index) {
                          int tileValue = _tiles[index];

                          // If it's the empty slot (8) and we haven't won, show nothing
                          if (tileValue == 8 && !_isSolved)
                            return const SizedBox.shrink();

                          // Where should this tile physically be drawn?
                          int physicalRow = index ~/ 3;
                          int physicalCol = index % 3;

                          // What part of the original image does this tile represent?
                          int originalRow = tileValue ~/ 3;
                          int originalCol = tileValue % 3;

                          return AnimatedPositioned(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            left: physicalCol * tileSize,
                            top: physicalRow * tileSize,
                            width: tileSize,
                            height: tileSize,
                            child: GestureDetector(
                              onTap: () => _onTileTap(index),
                              child: Container(
                                margin: const EdgeInsets.all(
                                  1,
                                ), // Tiny gap between tiles
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                // Magic trick: Splitting the image!
                                child: ClipRect(
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: -originalCol * tileSize,
                                        top: -originalRow * tileSize,
                                        child:
                                            _characters[_currentIndex].imageUrl
                                                .startsWith('http')
                                            ? Image.network(
                                                _characters[_currentIndex]
                                                    .imageUrl,
                                                width: boardSize,
                                                height: boardSize,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.asset(
                                                _characters[_currentIndex]
                                                    .imageUrl,
                                                width: boardSize,
                                                height: boardSize,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),

                        if (_isSolved)
                          Container(
                            color: Colors.white.withOpacity(0.7),
                            child: const Center(
                              child: Text(
                                'SOLVED! 🎉',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pink,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Bottom Navigation Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[400],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: _prevPicture,
                child: const Text('<- Previous'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[300],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: _initializePuzzle,
                child: const Text('🔄 Reset'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[300],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: _nextPicture,
                child: const Text('Next ->'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
