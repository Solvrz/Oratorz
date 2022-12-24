import 'package:flutter/material.dart';

import './widgets/add_motions_card.dart';
import './widgets/current_motions_card.dart';
import './widgets/future_motions_card.dart';
import '../widgets/header.dart';

class MotionsPage extends StatelessWidget {
  const MotionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Header(),
          const SizedBox(height: 24),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: const [
                    CurrentMotionCard(),
                    SizedBox(height: 12),
                    FutureMotionsCard(),
                  ],
                ),
                const SizedBox(width: 36),
                const AddMotionsCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
