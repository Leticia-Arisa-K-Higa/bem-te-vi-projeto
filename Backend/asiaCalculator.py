from typing import Optional, Dict, List
from models import Exam, ExamSide, MotorValues, SensoryValues


class _NeurologicalLevels:
    def __init__(self, motorRight: str, motorLeft: str, sensoryRight: str, sensoryLeft: str):
        self.motorRight = motorRight
        self.motorLeft = motorLeft
        self.sensoryRight = sensoryRight
        self.sensoryLeft = sensoryLeft


class PraxisIscnsciCalculator:
    _sensory_levels = ['C2', 'C3', 'C4', 'C5', 'C6', 'C7', 'C8', 'T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10', 'T11', 'T12', 'L1', 'L2', 'L3', 'L4', 'L5', 'S1', 'S2', 'S3', 'S4_5']
    _motor_levels = ['C5', 'C6', 'C7', 'C8', 'T1', 'L2', 'L3', 'L4', 'L5', 'S1']
    _uems_levels = ['C5', 'C6', 'C7', 'C8', 'T1']
    _lems_levels = ['L2', 'L3', 'L4', 'L5', 'S1']

    def __init__(self, exam: Exam):
        self.exam = exam

    def calculate(self) -> dict:
        neurological_levels = self._determine_neurological_levels()

        if neurological_levels.motorRight == 'S1' and neurological_levels.sensoryRight == 'INT':
            neurological_levels.motorRight = 'INT'

        if neurological_levels.motorLeft == 'S1' and neurological_levels.sensoryLeft == 'INT':
            neurological_levels.motorLeft = 'INT'

        nli = self._determine_neurological_level_of_injury(neurological_levels)
        is_complete = self._is_injury_complete()
        ais_grade = self._determine_ais_grade(is_complete, nli, neurological_levels)
        zpp = self._determine_zone_of_partial_preservations(is_complete, nli)
        totals = self._calculate_totals()

        return {
            "classification": {
                "neurologicalLevels": {
                    "sensoryRight": neurological_levels.sensoryRight,
                    "sensoryLeft": neurological_levels.sensoryLeft,
                    "motorRight": neurological_levels.motorRight,
                    "motorLeft": neurological_levels.motorLeft,
                },
                "neurologicalLevelOfInjury": nli,
                "injuryComplete": 'C' if is_complete else 'IN',
                "asiaImpairmentScale": ais_grade,
                "zoneOfPartialPreservations": zpp,
            },
            "totals": totals,
        }

    def _get_numeric_value(self, value: Optional[str]) -> Optional[int]:
        if not value or value.upper().startswith('NT'):
            return None
        try:
            return int(value.replace('*', ''))
        except (ValueError, TypeError):
            return 0

    def _determine_neurological_levels(self) -> _NeurologicalLevels:
        sensory_right = self._determine_sensory_level(self.exam.right.lightTouch, self.exam.right.pinPrick)
        sensory_left = self._determine_sensory_level(self.exam.left.lightTouch, self.exam.left.pinPrick)

        return _NeurologicalLevels(
            sensoryRight=sensory_right,
            sensoryLeft=sensory_left,
            motorRight=self._determine_motor_level(self.exam.right.motor, sensory_right),
            motorLeft=self._determine_motor_level(self.exam.left.motor, sensory_left),
        )

    def _determine_sensory_level(self, lt: SensoryValues, pp: SensoryValues) -> str:
        lowest_normal_level = None
        for level in reversed(self._sensory_levels):
            lt_value = self._get_numeric_value(lt.get(level))
            pp_value = self._get_numeric_value(pp.get(level))

            if lt_value == 2 and pp_value == 2:
                all_above_normal = True
                for i in range(self._sensory_levels.index(level)):
                    upper_level = self._sensory_levels[i]
                    if self._get_numeric_value(lt.get(upper_level)) != 2 or self._get_numeric_value(pp.get(upper_level)) != 2:
                        all_above_normal = False
                        break
                if all_above_normal:
                    lowest_normal_level = level
                    break

        if lowest_normal_level == 'S4_5':
            return 'INT'
        
        return lowest_normal_level or 'NA'

    def _determine_motor_level(self, motor_values: MotorValues, sensory_level: str) -> str:
        if sensory_level not in self._motor_levels:
            return sensory_level

        last_level_with_3_or_more = None
        for level in reversed(self._motor_levels):
            value = self._get_numeric_value(motor_values.get(level))
            if value is not None and value >= 3:
                all_above_normal = True
                for i in range(self._motor_levels.index(level)):
                    upper_level = self._motor_levels[i]
                    if self._get_numeric_value(motor_values.get(upper_level)) != 5:
                        all_above_normal = False
                        break
                if all_above_normal:
                    last_level_with_3_or_more = level
                    break
        
        return last_level_with_3_or_more or sensory_level

    def _determine_neurological_level_of_injury(self, levels: _NeurologicalLevels) -> str:
        all_levels = [levels.sensoryRight, levels.sensoryLeft, levels.motorRight, levels.motorLeft]
        most_rostral_index = float('inf')
        
        for level in all_levels:
            if level and level != 'NA' and 'INT' not in level:
                clean_level = level.replace('*', '')
                try:
                    index = self._sensory_levels.index(clean_level)
                    if index < most_rostral_index:
                        most_rostral_index = index
                except ValueError:
                    continue
        
        if most_rostral_index == float('inf'):
            return 'INT' if any('INT' in l for l in all_levels if l) else 'NA'
        
        return self._sensory_levels[most_rostral_index]

    def _is_injury_complete(self) -> bool:
        s4_5_lt_r = self._get_numeric_value(self.exam.right.lightTouch.get('S4_5', '0'))
        s4_5_pp_r = self._get_numeric_value(self.exam.right.pinPrick.get('S4_5', '0'))
        s4_5_lt_l = self._get_numeric_value(self.exam.left.lightTouch.get('S4_5', '0'))
        s4_5_pp_l = self._get_numeric_value(self.exam.left.pinPrick.get('S4_5', '0'))

        no_sacral_scores = s4_5_lt_r == 0 and s4_5_pp_r == 0 and s4_5_lt_l == 0 and s4_5_pp_l == 0

        has_no_sacral_sensation = self.exam.deepAnalPressure == 'No'
        has_no_sacral_motor = self.exam.voluntaryAnalContraction == 'No'

        return no_sacral_scores and has_no_sacral_sensation and has_no_sacral_motor


    def _is_motor_no_preserved_more_than_3_levels_below(self, neuro_levels: _NeurologicalLevels) -> bool:

        found_at_least_on_testable_muscle = False

        for side in ['right', 'left']:
            motor_values = getattr(self.exam, side).motor
            motor_level_str = getattr(neuro_levels, f'motor{side.capitalize()}')

            if not motor_level_str or motor_level_str in ['NA', 'INT']:
                continue

            try:
                motor_level_index = self._motor_levels.index(motor_level_str)
            except ValueError:
                continue

            for i in range(motor_level_index + 1, len(self._motor_levels)):
                level_to_check = self._motor_levels[i]
                value = self._get_numeric_value(motor_values.get(level_to_check))
                
                if value is None:
                    continue

                found_at_least_on_testable_muscle = True
                if value >= 3:
                    return False
        return found_at_least_on_testable_muscle
    

    def _proportion_key_muscles_ge3(self, neuro_levels: _NeurologicalLevels) -> float:
        key_muscles_below = []

        for side in ['right', 'left']:
            motor_values = getattr(self.exam, side).motor
            motor_level_str = getattr(neuro_levels, f'motor{side.capitalize()}')

            if not motor_level_str or motor_level_str in ['NA', 'INT']:
                continue

            try:
                motor_level_index = self._motor_levels.index(motor_level_str)
            except ValueError:
                continue

            for i in range(motor_level_index + 1, len(self._motor_levels)):
                level_to_check = self._motor_levels[i]
                value = self._get_numeric_value(motor_values.get(level_to_check))
                if value is not None:
                    key_muscles_below.append(value)

        if not key_muscles_below:
            return 0.0

        count_ge3 = sum(1 for v in key_muscles_below if v >= 3)
        return count_ge3 / len(key_muscles_below)


    def _determine_ais_grade(self, is_complete: bool, nli: str, neuro_levels: _NeurologicalLevels) -> str:
        if is_complete:
            return 'A'

        s4_5_lt_r = self._get_numeric_value(self.exam.right.lightTouch.get('S4_5', '0'))
        s4_5_pp_r = self._get_numeric_value(self.exam.right.pinPrick.get('S4_5', '0'))
        s4_5_lt_l = self._get_numeric_value(self.exam.left.lightTouch.get('S4_5', '0'))
        s4_5_pp_l = self._get_numeric_value(self.exam.left.pinPrick.get('S4_5', '0'))

        has_sacral_motor = self.exam.voluntaryAnalContraction == 'Yes'
        has_sacral_sensation = self.exam.deepAnalPressure == 'Yes'

        sensory_preserved = (
            (s4_5_lt_l > 0 or s4_5_pp_l > 0) or
            (s4_5_lt_r > 0 or s4_5_pp_r > 0) or
            has_sacral_sensation
        )

        has_motor_below = not self._is_motor_no_preserved_more_than_3_levels_below(neuro_levels)

        if sensory_preserved and not has_sacral_motor and not has_motor_below:
            return 'B'

        prop_ge3 = self._proportion_key_muscles_ge3(neuro_levels)

        if has_motor_below and prop_ge3 < 0.5:
            return 'C'

        if has_motor_below and prop_ge3 >= 0.5:
            return 'D'

        if sensory_preserved and has_sacral_motor and not has_motor_below and prop_ge3 == 1.0:
            return 'E'

        return 'ND'


    def _determine_zone_of_partial_preservations(self, is_complete: bool, nli: str) -> dict:
        
        s4_5_lt_r = self._get_numeric_value(self.exam.right.lightTouch.get('S4_5', '0'))
        s4_5_pp_r = self._get_numeric_value(self.exam.right.pinPrick.get('S4_5', '0'))
        s4_5_lt_l = self._get_numeric_value(self.exam.left.lightTouch.get('S4_5', '0'))
        s4_5_pp_l = self._get_numeric_value(self.exam.left.pinPrick.get('S4_5', '0'))
        
        has_s4_5_sensation = s4_5_lt_r > 0 or s4_5_pp_r > 0 or s4_5_lt_l > 0 or s4_5_pp_l > 0
        has_dap = self.exam.deepAnalPressure == 'Yes'
        sacral_sensation_is_present = has_s4_5_sensation or has_dap

        vac_is_present = self.exam.voluntaryAnalContraction == 'Yes'

        if vac_is_present and sacral_sensation_is_present:
            return {
                "sensoryRight": "", "sensoryLeft": "",
                "motorRight": "", "motorLeft": ""
            }


        # --- Sensory ZPP ---
        def zpp_sensorial(side: ExamSide) -> Optional[str]:
            last_partial = None
            for level in self._sensory_levels:
                lt = self._get_numeric_value(side.lightTouch.get(level, '0'))
                pp = self._get_numeric_value(side.pinPrick.get(level, '0'))
                if (lt is not None and lt > 0) or (pp is not None and pp > 0):
                    last_partial = level
            return last_partial

        # --- Motor ZPP ---
        def zpp_motora(side_motor: MotorValues) -> Optional[str]:
            last_partial = None
            for level in self._motor_levels:
                val = self._get_numeric_value(side_motor.get(level))
                if val is not None and val > 0:
                    last_partial = level
            return last_partial

        sensory_r = zpp_sensorial(self.exam.right)
        sensory_l = zpp_sensorial(self.exam.left)
        motor_r = zpp_motora(self.exam.right.motor)
        motor_l = zpp_motora(self.exam.left.motor)

        return {
            "sensoryRight": sensory_r or "N/A",
            "sensoryLeft": sensory_l or "N/A",
            "motorRight": motor_r or "N/A",
            "motorLeft": motor_l or "N/A"
        }



    def _calculate_totals(self) -> dict:
        def _add_scores(scores: Dict[str, Optional[str]]) -> int | str:
            values = list(scores.values())
            if any(v and v.upper().startswith('NT') for v in values):
                return 'ND'
            return sum(self._get_numeric_value(v) for v in values)

        return {
            "upperExtremityRight": _add_scores({k: v for k, v in self.exam.right.motor.items() if k in self._uems_levels}),
            "upperExtremityLeft": _add_scores({k: v for k, v in self.exam.left.motor.items() if k in self._uems_levels}),
            "lowerExtremityRight": _add_scores({k: v for k, v in self.exam.right.motor.items() if k in self._lems_levels}),
            "lowerExtremityLeft": _add_scores({k: v for k, v in self.exam.left.motor.items() if k in self._lems_levels}),
            "lightTouchRight": _add_scores(self.exam.right.lightTouch),
            "lightTouchLeft": _add_scores(self.exam.left.lightTouch),
            "pinPrickRight": _add_scores(self.exam.right.pinPrick),
            "pinPrickLeft": _add_scores(self.exam.left.pinPrick),
        }