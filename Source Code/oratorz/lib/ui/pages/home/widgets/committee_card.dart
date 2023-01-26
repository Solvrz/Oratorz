import 'package:flutter/material.dart';
import 'package:get/utils.dart';

class CommitteeCard extends StatefulWidget {
  const CommitteeCard({
    Key? key,
    required this.code,
  }) : super(key: key);

  final String code;

  @override
  State<CommitteeCard> createState() => _CommitteeCardState();
}

class _CommitteeCardState extends State<CommitteeCard> {
  final Map<String, Color> colors = {
    "AIPPM": const Color.fromRGBO(233, 55, 10, 0.7),
    "ASEAN": const Color.fromRGBO(237, 41, 57, 0.7),
    "AU": const Color.fromRGBO(192, 162, 101, 0.7),
    "ECOSOC": const Color.fromRGBO(214, 157, 54, 0.7),
    "EU": const Color.fromRGBO(0, 58, 148, 1),
    "G20": const Color.fromRGBO(83, 106, 125, 0.7),
    "NATO": const Color.fromRGBO(0, 36, 125, 0.7),
    "UNGA": const Color.fromRGBO(36, 134, 205, 0.7),
    "UNHCR": const Color.fromRGBO(115, 110, 176, 0.7),
    "UNHRC": const Color.fromRGBO(25, 113, 177, 0.85),
    "UNICEF": const Color.fromRGBO(71, 136, 200, 0.7),
    "UNSC": const Color.fromRGBO(115, 197, 255, 0.7),
    "WHO": const Color.fromRGBO(7, 152, 255, 0.7),
    "Custom": const Color(0xff0d1520),
  };

  final double scaleFactor = 1.05;

  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      onHover: (val) => setState(() => hovering = val),
      hoverColor: Colors.transparent,
      child: SizedBox(
        height: 180 * (hovering ? 1.05 : 1),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut,
              width: 260 * (hovering ? scaleFactor : 1),
              decoration: BoxDecoration(
                color: colors[widget.code],
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  if (hovering)
                    BoxShadow(
                      color: Colors.grey.shade300,
                      offset: const Offset(2, 2),
                      blurRadius: 3,
                      spreadRadius: 2,
                    ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Positioned(
                      right: -100,
                      child: Image.asset(
                        "logos/${widget.code}.png",
                        height: 185,
                        opacity: const AlwaysStoppedAnimation(0.4),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.code,
                              style: context.textTheme.headline5!
                                  .copyWith(color: Colors.white),
                            ),
                            Text(
                              "18 Delegates",
                              style: context.textTheme.bodyText1!
                                  .copyWith(color: Colors.white),
                            ),
                            const Spacer(),
                            Text(
                              "CCS MUN",
                              style: context.textTheme.headline6!
                                  .copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedContainer(
              margin: const EdgeInsets.only(left: 12),
              width: hovering ? 50 : 0,
              height: 180 * (hovering ? scaleFactor : 0),
              duration: const Duration(milliseconds: 100),
              child: AnimatedOpacity(
                opacity: hovering ? 1 : 0,
                duration: const Duration(milliseconds: 100),
                child: const _EditOptions(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditOptions extends StatelessWidget {
  const _EditOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              hoverColor: Colors.transparent,
              onTap: () {},
              child: const Icon(Icons.edit, size: 26),
            ),
            Divider(
              color: Colors.grey.shade400,
            ),
            InkWell(
              hoverColor: Colors.transparent,
              onTap: () {},
              child: const Icon(Icons.star_border, size: 26),
            ),
            Divider(
              color: Colors.grey.shade400,
            ),
            InkWell(
              hoverColor: Colors.transparent,
              onTap: () {},
              child: Icon(Icons.delete, color: Colors.red.shade400, size: 26),
            ),
          ],
        ),
      ),
    );
  }
}
