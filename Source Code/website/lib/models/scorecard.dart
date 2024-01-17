import './committee.dart';

class Parameter {
  late int id;
  String title;
  int maxScore;

  static int _id = 1;

  Parameter(this.title, this.maxScore, {int? id}) {
    if (id != null) {
      this.id = id;

      if (id >= _id) {
        _id = id + 1;
      }
    } else {
      this.id = _id++;
    }
  }

  @override
  String toString() => "$title ($maxScore)";
}

class Scorecard {
  late List<Parameter> parameters;
  late Map<String, List<double>> scores;

  Scorecard(Committee committee) {
    parameters = [
      Parameter("GSL", 10),
      Parameter("Mod", 10),
      Parameter("POI", 10),
      Parameter("Chits", 5),
      Parameter("Total", 0),
    ];

    scores = {
      for (final String delegate in committee.delegates) delegate: [0, 0, 0, 0],
    };
  }

  Scorecard.fromJson(Map<String, dynamic> data) {
    parameters = List.generate(
      data["parameters"].length,
      (index) => Parameter(
        data["parameters"][index],
        data["maxScores"][index],
      ),
    );

    scores = Map<String, List<double>>.from(
      data["scores"].map<String, List<double>>(
        (key, value) =>
            MapEntry<String, List<double>>(key, value.cast<double>()),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "parameters": parameters.map<String>((e) => e.title).toList(),
      "maxScores": parameters.map<int>((e) => e.maxScore).toList(),
      "scores": scores,
    };
  }
}
