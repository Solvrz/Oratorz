import 'package:flutter/material.dart';

import './widgets/add_motions_card.dart';
import './widgets/current_motions_card.dart';
import './widgets/future_motions_card.dart';
import '../widgets/header.dart';

class MotionsPage extends StatelessWidget {
  const MotionsPage({super.key});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Expanded(child: Header()),
            const SizedBox(height: 24),
            Row(
              children: [
                Column(
                  children: const [
                    CurrentMotionCard(),
                    FutureMotionsCard(),
                  ],
                ),
                const AddMotionsCard(),
              ],
            ),
          ],
        ),
      );
}
