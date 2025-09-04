import json
import random
from faker import Faker
from datetime import date, timedelta

NUMERO_DE_PACIENTES = 25
fake = Faker('pt_BR')


MIOTOMOS = ["C5", "C6", "C7", "C8", "T1", "L2", "L3", "L4", "L5", "S1"]
DERMATOMOS = [
    "C2", "C3", "C4", "C5", "C6", "C7", "C8", "T1", "T2", "T3", "T4", "T5",
    "T6", "T7", "T8", "T9", "T10", "T11", "T12", "L1", "L2", "L3", "L4", "L5",
    "S1", "S2", "S3", "S4-5"
]

NIVEIS_MOTOR = MIOTOMOS + ["C4"]
NIVEIS_SENSORIAL = DERMATOMOS

METAS_GAS_POOL = {
    "membros_superiores": [
        {
            "id": "alimentacao",
            "description": "Alimentar-se de forma independente usando talheres adaptados",
            "levels": [
                "Dependente total para alimentação",
                "Leva o alimento à boca com ajuda máxima",
                "Come alimentos já cortados com supervisão",
                "Usa talher adaptado com independência",
                "Prepara e come uma refeição simples de forma independente"
            ]
        },
        {
            "id": "higiene_facial",
            "description": "Realizar higiene facial (escovar dentes, pentear cabelo)",
            "levels": [
                "Dependente total para higiene facial",
                "Participa minimamente, com ajuda máxima",
                "Realiza a tarefa com ajuda moderada/mínima",
                "Realiza com independência usando adaptações",
                "Realiza de forma independente e segura"
            ]
        }
    ],
    "tronco_transferencias": [
        {
            "id": "transferencia_cama_cr",
            "description": "Realizar transferência da cama para a cadeira de rodas",
            "levels": [
                "Transferido passivamente com guincho ou 2 pessoas",
                "Necessita de ajuda máxima de 1 pessoa",
                "Necessita de ajuda moderada/mínima",
                "Realiza com supervisão para segurança",
                "Realiza de forma independente e segura"
            ]
        },
        {
            "id": "propulsao_cr",
            "description": "Impulsionar a cadeira de rodas em terreno plano",
            "levels": [
                "Incapaz de impulsionar, dependente de terceiros",
                "Impulsiona por 5 metros com dificuldade",
                "Impulsiona por 20 metros de forma contínua",
                "Impulsiona por 50 metros e realiza pequenas curvas",
                "Impulsiona por mais de 100 metros em ambientes internos e externos"
            ]
        }
    ],
    "membros_inferiores": [
         {
            "id": "marcha_paralelas",
            "description": "Deambular com órteses em barras paralelas",
            "levels": [
                "Incapaz de manter-se em pé",
                "Mantém-se em pé com ajuda máxima",
                "Dá 2-3 passos com ajuda máxima",
                "Deambula 10 metros com ajuda mínima/supervisão",
                "Deambula 20 metros de forma independente nas barras"
            ]
        }
    ]
}



def gerar_exame_asia(nome_paciente):
    """Gera um conjunto de dados lógicos para um exame ASIA."""
    
    nivel_lesao = random.choice(NIVEIS_MOTOR)
    escala_asia = random.choice(["A", "B", "C", "D"])
    
    try:
        indice_lesao_motor = MIOTOMOS.index(nivel_lesao)
    except ValueError:
        indice_lesao_motor = -1 
        
    try:
        indice_lesao_sensorial = DERMATOMOS.index(nivel_lesao if nivel_lesao != "C4" else "C4")
    except ValueError:
        indice_lesao_sensorial = 2

    if escala_asia == "A":
        vac, dap = "No", "No"
    elif escala_asia == "B":
        vac, dap = "No", "Yes"
    else:
        vac, dap = "Yes", "Yes"

    exame = { "right": {"motor": {}, "lightTouch": {}, "pinPrick": {}}, "left": {"motor": {}, "lightTouch": {}, "pinPrick": {}} }

    for lado_str in ["right", "left"]:
        for i, miotomo in enumerate(MIOTOMOS):
            if indice_lesao_motor == -1: 
                exame[lado_str]["motor"][miotomo] = str(random.randint(0, 1))
            elif i < indice_lesao_motor:
                exame[lado_str]["motor"][miotomo] = str(random.choice([4, 5]))
            elif i == indice_lesao_motor:
                exame[lado_str]["motor"][miotomo] = str(random.randint(1, 3))
            else: 
                if escala_asia == "A" or escala_asia == "B":
                    exame[lado_str]["motor"][miotomo] = "0"
                elif escala_asia == "C":
                    exame[lado_str]["motor"][miotomo] = str(random.randint(0, 2))
                else: 
                    exame[lado_str]["motor"][miotomo] = str(random.randint(3, 4))
        
        for i, dermatomo in enumerate(DERMATOMOS):
            if i < indice_lesao_sensorial:
                score = "2"
            elif i == indice_lesao_sensorial:
                score = "1"
            else: 
                if escala_asia == "A":
                    score = "0"
                else:
                    score = str(random.randint(0, 1))
            
            if dermatomo == "S4-5" and escala_asia != "A":
                score = "1"
            
            exame[lado_str]["lightTouch"][dermatomo] = score
            exame[lado_str]["pinPrick"][dermatomo] = score

    exam_data = {
        "patientName": nome_paciente,
        "examDate": (date.today() - timedelta(days=random.randint(90, 365))).isoformat(),
        "examinerName": fake.name(),
        "voluntaryAnalContraction": vac,
        "deepAnalPressure": dap,
        "right": {
            "lowestNonKeyMuscleWithMotorFunction": "NT", 
            "motor": exame["right"]["motor"],
            "lightTouch": exame["right"]["lightTouch"],
            "pinPrick": exame["right"]["pinPrick"]
        },
        "left": {
            "lowestNonKeyMuscleWithMotorFunction": "NT", 
            "motor": exame["left"]["motor"],
            "lightTouch": exame["left"]["lightTouch"],
            "pinPrick": exame["left"]["pinPrick"]
        }
    }
    return exam_data, nivel_lesao

def gerar_avaliacao_gas(nome_paciente, nivel_lesao):
    """Gera um conjunto de dados lógicos para uma avaliação GAS."""
    
    metas_escolhidas = []
    if nivel_lesao.startswith("C"):
        metas_escolhidas.extend(random.sample(METAS_GAS_POOL["membros_superiores"], k=random.randint(1,2)))
        metas_escolhidas.extend(random.sample(METAS_GAS_POOL["tronco_transferencias"], k=1))
    elif nivel_lesao.startswith("T"):
        metas_escolhidas.extend(random.sample(METAS_GAS_POOL["tronco_transferencias"], k=random.randint(1,2)))
    else:
        metas_escolhidas.extend(random.sample(METAS_GAS_POOL["membros_inferiores"], k=1))
        metas_escolhidas.extend(random.sample(METAS_GAS_POOL["tronco_transferencias"], k=1))

    goals_data = []
    for i, meta_template in enumerate(metas_escolhidas):
        baseline = random.choice([-2, -1])
        achieved = min(baseline + random.randint(1, 2), 2) 
        
        goal = {
            "id": i + 1,
            "description": meta_template["description"],
            "importance": random.randint(3, 5),
            "difficulty": random.randint(3, 5),
            "baseline": baseline,
            "achieved": achieved,
            "level_minus_2": meta_template["levels"][0],
            "level_minus_1": meta_template["levels"][1],
            "level_0": meta_template["levels"][2],
            "level_plus_1": meta_template["levels"][3],
            "level_plus_2": meta_template["levels"][4]
        }
        goals_data.append(goal)
        
    planning_date = date.today() - timedelta(days=random.randint(100, 120))
    revaluation_date = planning_date + timedelta(days=90)
    
    gas_data = {
      "patientIdentifier": nome_paciente,
      "planningDate": planning_date.isoformat(),
      "revaluationDate": revaluation_date.isoformat(),
      "interventionPlan": "Plano de reabilitação intensiva com fisioterapia e terapia ocupacional.",
      "iq": str(random.randint(90, 115)),
      "goals": goals_data
    }
    
    return gas_data


if __name__ == "__main__":
    lista_de_exames_asia = []
    lista_de_avaliacoes_gas = []

    print(f"Gerando {NUMERO_DE_PACIENTES} conjuntos de dados...")

    for _ in range(NUMERO_DE_PACIENTES):
        nome = fake.name()
        
        exame_asia, nivel_lesao_gerado = gerar_exame_asia(nome)
        lista_de_exames_asia.append(exame_asia)
        
        avaliacao_gas = gerar_avaliacao_gas(nome, nivel_lesao_gerado)
        lista_de_avaliacoes_gas.append(avaliacao_gas)

    output = {
        "exams": lista_de_exames_asia,
        "gas_evaluations": lista_de_avaliacoes_gas
    }

    print("\n" + "="*50)
    print("DADOS GERADOS COM SUCESSO")
    print("="*50 + "\n")
    
    with open('dados_exams.json', 'w', encoding='utf-8') as f:
        json.dump(lista_de_exames_asia, f, indent=2, ensure_ascii=False)
    
    with open('dados_gas_evaluations.json', 'w', encoding='utf-8') as f:
        json.dump(lista_de_avaliacoes_gas, f, indent=2, ensure_ascii=False)
        
    print("Os dados foram salvos nos arquivos 'dados_exams.json' e 'dados_gas_evaluations.json'")