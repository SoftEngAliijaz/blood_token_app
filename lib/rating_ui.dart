import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserRatingUIScreen extends StatefulWidget {
  const UserRatingUIScreen({Key? key}) : super(key: key);

  @override
  _UserRatingUIScreenState createState() => _UserRatingUIScreenState();
}

class _UserRatingUIScreenState extends State<UserRatingUIScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController =
      AnimationController(vsync: this);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showBottomSheet(context);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => MyBottomSheet(),
      isScrollControlled: true,
      transitionAnimationController: _animationController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rating UI'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showBottomSheet(context),
          child: const Text('Show Bottom Sheet'),
        ),
      ),
    );
  }
}

class MyBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double score = 47; // Example score
    bool isApproved = score > 50;

    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[200],
                  child: Text(
                    isApproved ? 'Approved' : 'Not Approved',
                    style: TextStyle(
                        color: isApproved ? Colors.green : Colors.red),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.orange,
                    child: Text(
                      '$score',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.info, color: Colors.white),
                  ),
                ),
                const Positioned(
                  bottom: 0,
                  left: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.purple,
                    child: Icon(Icons.star, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.thumb_up, color: Colors.green, size: 50),
                const SizedBox(width: 10),
                Text(
                  isApproved ? 'Approved' : 'Not Approved',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isApproved ? Colors.green : Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 20),
            InfoRow(
              icon: Icons.warning,
              text: "Not recommended by W.H.O.",
              color: Colors.red,
            ),
            InfoRow(
              icon: FontAwesomeIcons.industry,
              text: "Ultra-processed",
              color: Colors.red,
            ),
            InfoRow(
              icon: Icons.fastfood,
              text: "High in calories",
              color: Colors.red,
            ),
            InfoRow(
              icon: Icons.import_contacts,
              text: "High in salt",
              color: Colors.red,
            ),
            InfoRow(
              icon: Icons.cake,
              text: "High in sugar",
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const InfoRow({required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(color: color),
          ),
        ],
      ),
    );
  }
}
