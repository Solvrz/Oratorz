import 'package:flutter/material.dart';

class SetupPage extends StatelessWidget {
  const SetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> data = [
      {
        "name": "United States of America",
        "flag": "",
      },
      {
        "name": "India",
        "flag": "",
      },
      {
        "name": "United Kingdoms",
        "flag": "",
      },
      {
        "name": "France",
        "flag": "",
      },
      {
        "name": "China",
        "flag": "",
      },
      {
        "name": "UAE",
        "flag": "",
      },
      {
        "name": "Canada",
        "flag": "",
      },
      {
        "name": "Germany",
        "flag": "",
      },
      {
        "name": "Japan",
        "flag": "",
      },
    ];

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
                    Card(
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
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Card(
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
                                  padding:
                                      const EdgeInsets.only(top: 12, left: 12),
                                  child: Column(
                                    children: [
                                      Text(
                                        "UN Member States",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                      Expanded(
                                        child: Scrollbar(
                                          child: ListView.separated(
                                            itemBuilder: (context, index) =>
                                                ListTile(
                                              leading: CircleAvatar(
                                                radius: 20,
                                                backgroundColor:
                                                    Colors.grey.shade200,
                                              ),
                                              title: Text(
                                                data[index]["name"]!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6,
                                              ),
                                            ),
                                            separatorBuilder:
                                                (context, index) =>
                                                    const Divider(),
                                            itemCount: data.length,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: Card(
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
