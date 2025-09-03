import math
from typing import List, Dict, Any
from models import GasEvaluation

class GasCalculator:
    def __init__(self, evaluation: GasEvaluation):
        self.evaluation = evaluation
        self._calculated_goals: List[Dict[str, Any]] = self._calculate_goal_ponderations()

    def _calculate_goal_ponderations(self) -> List[Dict[str, Any]]:
        calculated_goals = []
        for goal in self.evaluation.goals:
            p1 = float(goal.importance * goal.difficulty)
            p2_peso = p1 ** 2
            
            p3_base = p1 * goal.baseline if goal.baseline is not None else 0.0
            p3 = max(0, p3_base)

            p4_base = p1 * goal.achieved if goal.achieved is not None else 0.0
            p4 = max(0, p4_base) 

            calculated_goals.append({
                "raw_goal": goal,
                "ponderation1": p1,
                "ponderation2_peso": p2_peso,
                "ponderation3_base_ponderada": p3,
                "ponderacao4_alcancado_ponderado": p4,
            })
        return calculated_goals

    def calculate_all(self) -> Dict[str, Any]:
        sum_p1 = sum(g['ponderation1'] for g in self._calculated_goals)
        sum_p2_peso = sum(g['ponderation2_peso'] for g in self._calculated_goals)
        sum_p3_base = sum(g['ponderation3_base_ponderada'] for g in self._calculated_goals)
        sum_p4_alcancado = sum(g['ponderacao4_alcancado_ponderado'] for g in self._calculated_goals)

        fator_probabilistico_sqrt = math.sqrt(sum_p2_peso) if sum_p2_peso > 0 else 0.0

        if fator_probabilistico_sqrt > 0:
            gas_score_base = 50.0 + (10 * sum_p3_base) / fator_probabilistico_sqrt
            gas_score_achieved = 50.0 + (10 * sum_p4_alcancado) / fator_probabilistico_sqrt
        else:
            gas_score_base = 50.0
            gas_score_achieved = 50.0
            
        evolution = gas_score_achieved - gas_score_base

        return {
            "summary": {
                "gasScoreBase": gas_score_base,
                "gasScoreAchieved": gas_score_achieved,
                "evolution": evolution,
                "somatorioP1": sum_p1,
                "somatorioP2": sum_p2_peso,
                "somatorioP3": sum_p3_base,
                "somatorioP4": sum_p4_alcancado,
                "fatorProbabilistico": sum_p2_peso,
                "sqrtFatorProbabilistico": fator_probabilistico_sqrt
            },
            "detailed_goals": self._calculated_goals
        }