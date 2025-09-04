from fastapi import FastAPI, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
import psycopg2
from models import AnamneseCreate, Exam, GasEvaluation
from asiaCalculator import PraxisIscnsciCalculator
from gasCalculator import GasCalculator
from database import get_db_connection


app = FastAPI(title="Bem-Te-Vi API", version="1.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def read_root():
    return {"Status": "Servidor do Bem-te-vi no ar!"}

@app.post("/api/v1/gas-evaluations", summary="Calcula e Salva uma Avaliação GAS")
def create_gas_evaluation(eval_data: GasEvaluation):
    calculator = GasCalculator(eval_data)
    result = calculator.calculate_all()
    summary = result['summary'] 

    conn = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("SELECT id FROM pacientes WHERE nome_completo = %s;", (eval_data.patientIdentifier,))
        patient = cursor.fetchone()

        if patient:
            patient_id = patient[0]
        else:
            cursor.execute("INSERT INTO pacientes (nome_completo) VALUES (%s) RETURNING id;", (eval_data.patientIdentifier,))
            patient_id = cursor.fetchone()[0]

        cursor.execute(
            """
            INSERT INTO avaliacoes_gas (
                paciente_id, data_planejamento, data_reavaliacao, plano_intervencao, qi,
                gas_score_base_calculado, gas_score_alcancado, evolucao,
                somatorio_p1, somatorio_p2_pesos, somatorio_p3_base, somatorio_p4_alcancado
            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s) RETURNING id;
            """,
            (
                patient_id, eval_data.planningDate, eval_data.revaluationDate,
                eval_data.interventionPlan, eval_data.iq,
                summary['gasScoreBase'], summary['gasScoreAchieved'], summary['evolution'],
                summary['somatorioP1'], summary['somatorioP2'],
                summary['somatorioP3'], summary['somatorioP4']
            )
        )
        avaliacao_id = cursor.fetchone()[0]

        for goal_data in result['detailed_goals']:
            raw_goal = goal_data['raw_goal']

            print("CHAVES DISPONÍVEIS NO DICIONÁRIO:", goal_data.keys())
            
            cursor.execute(
                """
                INSERT INTO metas_gas (
                    avaliacao_gas_id, meta_id_original, descricao, importancia, dificuldade,
                    linha_de_base, alcancado, ponderacao1, ponderacao2_peso,
                    ponderacao3_base_ponderada, ponderacao4_alcancado_ponderado,
                    desc_piora, desc_linha_base, desc_esperado, 
                    desc_melhor_esperado, desc_muito_melhor
                ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);
                """,
                (
                    avaliacao_id, raw_goal.id, raw_goal.description, raw_goal.importance, raw_goal.difficulty,
                    raw_goal.baseline, raw_goal.achieved,
                    goal_data['ponderation1'],
                    goal_data['ponderation2_peso'],
                    goal_data['ponderation3_base_ponderada'],
                    goal_data['ponderacao4_alcancado_ponderado'],
                    raw_goal.level_minus_2, raw_goal.level_minus_1, raw_goal.level_0,
                    raw_goal.level_plus_1, raw_goal.level_plus_2
                )
            )

        conn.commit()
        print(f"SUCESSO: Avaliação GAS ID {avaliacao_id} salva para o Paciente ID {patient_id}.")

    except (Exception, psycopg2.DatabaseError) as error:
        print(f"ERRO DE BANCO DE DADOS: {error}")
        if conn:
            conn.rollback()
        raise HTTPException(status_code=500, detail="Erro ao salvar avaliação GAS no banco de dados.")
    finally:
        if conn:
            cursor.close()
            conn.close()

    return result


@app.post("/api/v1/exams", summary="Calcula e Salva uma Avaliação ASIA")
def create_exam_and_calculate(exam_data: Exam):
    calculator = PraxisIscnsciCalculator(exam_data)
    result = calculator.calculate()

    conn = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("SELECT id FROM pacientes WHERE nome_completo = %s;", (exam_data.patientName,))
        paciente = cursor.fetchone()
        if paciente:
            paciente_id = paciente[0]
        else:
            cursor.execute("INSERT INTO pacientes (nome_completo) VALUES (%s) RETURNING id;", (exam_data.patientName,))
            paciente_id = cursor.fetchone()[0]

        classificacao = result['classification']
        totais = result['totals']
        zpp = classificacao['zoneOfPartialPreservations']
        neuro_levels = classificacao['neurologicalLevels']
        
        cursor.execute(
            """
            INSERT INTO avaliacoes_asia (
                paciente_id, data_exame, nome_examinador, 
                contracao_anal_voluntaria, pressao_anal_profunda,
                lowest_non_key_muscle_right, lowest_non_key_muscle_left,
                nivel_sensorial_direito, nivel_sensorial_esquerdo, nivel_motor_direito, nivel_motor_esquerdo,
                nivel_neurologico_lesao, classificacao_completude, escala_asia,
                zpp_sensorial_direito, zpp_sensorial_esquerdo, zpp_motor_direito, zpp_motor_esquerdo,
                total_uems_direito, total_uems_esquerdo, total_lems_direito, total_lems_esquerdo,
                total_lt_direito, total_lt_esquerdo, total_pp_direito, total_pp_esquerdo
            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            RETURNING id;
            """,
            (
                paciente_id,
                exam_data.examDate,
                exam_data.examinerName,   
                exam_data.voluntaryAnalContraction,
                exam_data.deepAnalPressure,
                exam_data.right.lowestNonKeyMuscleWithMotorFunction,
                exam_data.left.lowestNonKeyMuscleWithMotorFunction,
                neuro_levels['sensoryRight'],
                neuro_levels['sensoryLeft'],
                neuro_levels['motorRight'],
                neuro_levels['motorLeft'],
                classificacao['neurologicalLevelOfInjury'],
                'Completa' if 'C' in classificacao['injuryComplete'] else 'Incompleta', 
                classificacao['asiaImpairmentScale'],
                zpp['sensoryRight'],
                zpp['sensoryLeft'], 
                zpp['motorRight'],
                zpp['motorLeft'],  
                None if totais['upperExtremityRight'] == 'ND' else totais['upperExtremityRight'], 
                None if totais['upperExtremityLeft'] == 'ND' else totais['upperExtremityLeft'],
                None if totais['lowerExtremityRight'] == 'ND' else totais['lowerExtremityRight'], 
                None if totais['lowerExtremityLeft'] == 'ND' else totais['lowerExtremityLeft'],
                None if totais['lightTouchRight'] == 'ND' else totais['lightTouchRight'], 
                None if totais['lightTouchLeft'] == 'ND' else totais['lightTouchLeft'],   
                None if totais['pinPrickRight'] == 'ND' else totais['pinPrickRight'],         
                None if totais['pinPrickLeft'] == 'ND' else totais['pinPrickLeft'],       
            )
        )
        avaliacao_id = cursor.fetchone()[0]

        for miotomo in calculator._motor_levels:
            cursor.execute("INSERT INTO scores_motores (avaliacao_id, miotomo, forca_direita, forca_esquerda) VALUES (%s, %s, %s, %s);", (avaliacao_id, miotomo, exam_data.right.motor.get(miotomo, ''), exam_data.left.motor.get(miotomo, '')))

        for dermatomo in calculator._sensory_levels:
            cursor.execute("INSERT INTO scores_sensoriais (avaliacao_id, dermatomo, tato_leve_direito, tato_leve_esquerdo, picada_direito, picada_esquerdo) VALUES (%s, %s, %s, %s, %s, %s);", (avaliacao_id, dermatomo, exam_data.right.lightTouch.get(dermatomo, ''), exam_data.left.lightTouch.get(dermatomo, ''), exam_data.right.pinPrick.get(dermatomo, ''), exam_data.left.pinPrick.get(dermatomo, '')))
        
        conn.commit()
        print(f"SUCESSO: Avaliação ASIA ID {avaliacao_id} salva no banco de dados para o Paciente ID {paciente_id}.")

    except (Exception, psycopg2.DatabaseError) as error:
        print(f"ERRO DE BANCO DE DADOS: {error}")
        if conn:
            conn.rollback()
        raise HTTPException(status_code=500, detail="Erro interno ao salvar os dados da avaliação ASIA.")
    finally:
        if conn:
            cursor.close()
            conn.close()

    return result

@app.post("/api/v1/anamneses", summary="Salva um novo formulário de Anamnese", status_code=status.HTTP_201_CREATED)
def create_anamnese(anamnese: AnamneseCreate):
    conn = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("SELECT id FROM pacientes WHERE nome_completo = %s;", (anamnese.patientName,))
        paciente = cursor.fetchone()

        if paciente:
            paciente_id = paciente[0]
        else:
            cursor.execute("INSERT INTO pacientes (nome_completo) VALUES (%s) RETURNING id;", (anamnese.patientName,))
            paciente_id = cursor.fetchone()[0]

        sql = """
            INSERT INTO anamneses (
                paciente_id, nome_paciente, celular_paciente, email_paciente,
                data_nascimento, data_exame, comentarios
            ) VALUES (%s, %s, %s, %s, %s, %s, %s)
            RETURNING id;
        """
        
        cursor.execute(sql, (
            paciente_id,
            anamnese.patientName,
            anamnese.patientPhone,
            anamnese.patientEmail,
            anamnese.birthDate,
            anamnese.examDate,
            anamnese.comments
        ))
        
        new_id = cursor.fetchone()[0]
        conn.commit()
        
        print(f"SUCESSO: Anamnese ID {new_id} salva para o Paciente ID {paciente_id}.")

    except (Exception, psycopg2.DatabaseError) as error:
        print(f"ERRO DE BANCO DE DADOS (Anamnese): {error}")
        if conn:
            conn.rollback()
        raise HTTPException(status_code=500, detail="Erro ao salvar anamnese no banco de dados.")
    finally:
        if conn:
            cursor.close()
            conn.close()

    return {"message": "Anamnese salva com sucesso!", "id": new_id, "paciente_id": paciente_id}