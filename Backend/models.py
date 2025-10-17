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


class MuscleMeasurement(BaseModel):
    """Dados de medição para um lado de um músculo."""
    reobase: Optional[float] = None
    accommodation: Optional[float] = None
    chronaxy: Optional[float] = None
    accommodationIndex: Optional[str] = None

class MuscleEvaluation(BaseModel):
    """Agrupa os dados de um músculo específico."""
    muscleName: str
    right: MuscleMeasurement
    left: MuscleMeasurement
    comments: Optional[str] = None

class ElectrodiagnosisCreate(BaseModel):
    """Modelo principal para receber um novo formulário de Eletrodiagnóstico."""
    patientName: str
    examinerName: str
    examDate: str 
    equipmentName: str
    muscles: List[MuscleEvaluation]

class PontosMeem(BaseModel):
    """Agrupa todos os pontos individuais do exame MEEM."""
    orientacaoTemporal: List[int]
    orientacaoEspacial: List[int]
    memoriaImediata: List[int]
    atencaoCalculo: List[int]
    memoriaEvocativa: List[int]
    linguagemNomear: List[int]
    linguagemRepetir: int
    linguagemComandoVerbal: List[int]
    linguagemComandoEscrito: int
    linguagemFrase: int
    linguagemCopia: int

class MeemCreate(BaseModel):
    """Modelo principal para receber um novo formulário MEEM."""
    patientName: str
    examDate: date
    examinerName: Optional[str] = None
    age: int
    escolaridade: str
    pontos: PontosMeem
