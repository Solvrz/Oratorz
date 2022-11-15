import 'package:flutter/material.dart';

import '/config/country_info.dart';

class SetupPage extends StatelessWidget {
  const SetupPage({super.key});

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
                  children: const [
                    LoadCommitteeCard(),
                    SizedBox(height: 12),
                    Expanded(child: NewCommitteeCard(data: COUNTRIES)),
                    SizedBox(height: 36),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              const Expanded(child: CommitteeCard()),
            ],
          ),
        ),
      ),
    );
  }
}

class CommitteeCard extends StatelessWidget {
  const CommitteeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your Committee",
              style: Theme.of(context).textTheme.headline5,
            ),
          ],
        ),
      ),
    );
  }
}

class NewCommitteeCard extends StatelessWidget {
  const NewCommitteeCard({
    Key? key,
    required this.data,
  }) : super(key: key);

  final List<Map<String, String>> data;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Set Up New Committee",
              style: Theme.of(context).textTheme.headline5,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 12, left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "UN Member States",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) => ListTile(
                          leading: CircleAvatar(
                            radius: 20,
                            child: Image.asset(data[index]["flag"]!),
                          ),
                          title: Text(
                            data[index]["name"]!,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: data.length,
                      ),
                    ),
                  ],
                ),
              ),
            )
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
