import 'package:flutter/material.dart';

import '/config/country_info.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  List<String> unselected = COUNTRIES.keys.toList();
  List<String> selected = [];

  @override
  void initState() {
    super.initState();
    unselected.sort((a, b) => COUNTRIES[a]!.compareTo(COUNTRIES[b]!));
  }

  void update(String country, int operation) {
    setState(() {
      if (operation == 1) {
        selected.add(country);
        unselected.remove(country);
      } else if (operation == 2) {
        unselected = COUNTRIES.keys.toList();
        selected = [];
      } else if (operation == 3) {
        //TODO: Start Session
      } else {
        selected.remove(country);
        unselected.add(country);
      }

      unselected.sort((a, b) => COUNTRIES[a]!.compareTo(COUNTRIES[b]!));
      selected.sort((a, b) => COUNTRIES[a]!.compareTo(COUNTRIES[b]!));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Setup Committee",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const LoadCommitteeCard(),
                    const SizedBox(height: 12),
                    Expanded(
                      child: NewCommitteeCard(
                        data: unselected,
                        callback: update,
                      ),
                    ),
                    const SizedBox(height: 36),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              Expanded(child: CommitteeCard(data: selected, callback: update)),
            ],
          ),
        ),
      ),
    );
  }
}

class CommitteeCard extends StatelessWidget {
  const CommitteeCard({super.key, required this.data, required this.callback});

  final List<String> data;
  final Function(String, int) callback;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Your Committee",
              style: Theme.of(context).textTheme.headline5,
            ),
            Text(
              "${data.length} Countries",
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) => ListTile(
                  hoverColor: Colors.grey[100],
                  onTap: () => callback(data[index], 0),
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[400],
                  ),
                  title: Text(
                    COUNTRIES[data[index]]!,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  trailing: Icon(Icons.minimize, color: Colors.grey[400]),
                ),
                separatorBuilder: (context, index) => Divider(
                  indent: 66,
                  thickness: 0.5,
                  height: 6,
                  color: Colors.grey[400],
                ),
                itemCount: data.length,
              ),
            ),
            TextButton(
              onPressed: () => callback("", 2),
              child: const Text("Clear Selection"),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => callback("", 3),
              child: const Text("Start Session"),
            ),
          ],
        ),
      ),
    );
  }
}

class NewCommitteeCard extends StatelessWidget {
  const NewCommitteeCard({
    super.key,
    required this.data,
    required this.callback,
  });

  final List<String> data;
  final Function(String, int) callback;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Set Up New Committee",
              style: Theme.of(context).textTheme.headline5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                "UN Member States",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey[600]),
                  Expanded(
                    child: TextField(
                      cursorColor: Colors.grey[600],
                      decoration: InputDecoration(
                        hintText: "Search",
                        hintMaxLines: 1,
                        hintStyle: Theme.of(context).textTheme.bodyText1,
                        hoverColor: Colors.transparent,
                        fillColor: Colors.transparent,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) => ListTile(
                  hoverColor: Colors.grey[100],
                  onTap: () => callback(data[index], 1),
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[400],
                  ),
                  title: Text(
                    COUNTRIES[data[index]]!,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  trailing: Icon(Icons.add, color: Colors.grey[400]),
                ),
                separatorBuilder: (context, index) => Divider(
                  indent: 66,
                  thickness: 0.5,
                  height: 6,
                  color: Colors.grey[400],
                ),
                itemCount: data.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoadCommitteeCard extends StatelessWidget {
  const LoadCommitteeCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Load Committee",
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    child: const Text("From File"),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextButton(
                    child: const Text("From Template"),
                    onPressed: () {},
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
