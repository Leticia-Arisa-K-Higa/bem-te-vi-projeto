from pydantic import BaseModel, EmailStr
from typing import Dict, Optional, List 
from datetime import date


MotorValues = Dict[str, str]
SensoryValues = Dict[str, str]

class ExamSide(BaseModel):
    motor: MotorValues
    lightTouch: SensoryValues
    pinPrick: SensoryValues
    lowestNonKeyMuscleWithMotorFunction: Optional[str] = None

class Exam(BaseModel):
    patientName: str
    examDate: str 
    examinerName: str
    right: ExamSide
    left: ExamSide
    voluntaryAnalContraction: str
    deepAnalPressure: str


class Goal(BaseModel):
    id: int
    description: str
    importance: int
    difficulty: int
    baseline: Optional[float] = None
    achieved: Optional[float] = None
    
    level_minus_2: Optional[str] = None
    level_minus_1: Optional[str] = None
    level_0: Optional[str] = None
    level_plus_1: Optional[str] = None
    level_plus_2: Optional[str] = None

class GasEvaluation(BaseModel):
    patientIdentifier: str
    planningDate: Optional[date] = None
    revaluationDate: Optional[date] = None
    interventionPlan: Optional[str] = None
    iq: Optional[str] = None
    goals: List[Goal]

class AnamneseCreate(BaseModel):
    patientName: str
    patientPhone: Optional[str] = None
    patientEmail: Optional[EmailStr] = None
    examDate: date
    birthDate: date
    comments: Optional[str] = None