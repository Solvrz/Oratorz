export interface Parameter {
  id: number;
  title: string;
  maxScore: number;
}

let _nextParameterId = 1;

export function createParameter(
  title: string,
  maxScore: number,
  id?: number,
): Parameter {
  if (id !== undefined) {
    if (id >= _nextParameterId) _nextParameterId = id + 1;
    return { id, title, maxScore };
  }
  return { id: _nextParameterId++, title, maxScore };
}

export interface Scorecard {
  parameters: Parameter[];
  scores: Record<string, number[]>;
}

export function createScorecard(delegates: string[]): Scorecard {
  return {
    parameters: [
      createParameter("GSL", 10),
      createParameter("Mod", 10),
      createParameter("POI", 10),
      createParameter("Chits", 5),
      createParameter("Total", 0),
    ],
    scores: Object.fromEntries(delegates.map((d) => [d, [0, 0, 0, 0]])),
  };
}

export function scorecardFromJson(data: Record<string, unknown>): Scorecard {
  const params = (data.parameters as string[]) ?? [];
  const maxScores = (data.maxScores as number[]) ?? [];
  return {
    parameters: params.map((title, i) =>
      createParameter(title, maxScores[i] ?? 0),
    ),
    scores: Object.fromEntries(
      Object.entries(data.scores as Record<string, number[]>).map(([k, v]) => [
        k,
        [...v],
      ]),
    ),
  };
}

export function scorecardToJson(sc: Scorecard): Record<string, unknown> {
  return {
    parameters: sc.parameters.map((p) => p.title),
    maxScores: sc.parameters.map((p) => p.maxScore),
    scores: sc.scores,
  };
}
