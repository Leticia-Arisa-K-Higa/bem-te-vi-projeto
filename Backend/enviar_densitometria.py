import json
import requests
import time
import random
from datetime import datetime

BASE_URL = "http://localhost:8000"

# Arquivos de origem
ARQUIVO_PACIENTES = 'dados_pacientes.json'     # Lista com os 25 nomes
ARQUIVO_EXEMPLOS = 'dados_densitometria.json'  # Exemplos prontos (opcional)

# --- Função para Gerar Dados Fakes Aleatórios ---
def gerar_densitometria_fake(nome_paciente):
    peso = round(random.uniform(50.0, 90.0), 1)
    altura = round(random.uniform(1.50, 1.90), 2)
    imc = round(peso / (altura * altura), 2)
    data_hoje = datetime.now().strftime("%Y-%m-%d")
    idade_fake = random.randint(25, 70)
    
    # Gera valores aleatórios de BMD
    def rnd_bmd(): return round(random.uniform(0.800, 1.300), 3)

    return {
        "patientName": nome_paciente,
        "examDate": data_hoje,
        "weight": peso,
        "height": altura,
        "imc": imc,
        # Tabelas
        "lumbarRegions": [
            {"regiao": r, "bmd": rnd_bmd()} 
            for r in ['L1', 'L2', 'L3', 'L4', 'L1-L2', 'L1-L3', 'L1-L4', 'L2-L3', 'L2-L4', 'L3-L4']
        ],
        "lumbarTrend": {"data": "2023-01-01", "idade": idade_fake, "bmd": rnd_bmd()},
        
        "bodyRegions": [
            {"regiao": r, "bmd": rnd_bmd()} 
            for r in ['Cabeça', 'Braços', 'Pernas', 'Tronco', 'Costelas', 'Coluna', 'Pelve', 'Total']
        ],
        "bodyTrend": {"data": "2023-01-01", "idade": idade_fake, "bmd": rnd_bmd()},
        
        "compositionTrend": {
            "data": "2023-01-01", 
            "idade": idade_fake, 
            "tecido_percent": round(random.uniform(15.0, 35.0), 1),
            "massa_total": peso, 
            "gordo": round(peso * 0.2, 3), 
            "magro": round(peso * 0.7, 3)
        },
        
        "femurRightRegions": [{"regiao": "Colo", "bmd": rnd_bmd()}, {"regiao": "Total", "bmd": rnd_bmd()}],
        "femurRightTrend": {"data": "2023-01-01", "idade": idade_fake, "bmd": rnd_bmd()},
        
        "femurLeftRegions": [{"regiao": "Colo", "bmd": rnd_bmd()}, {"regiao": "Total", "bmd": rnd_bmd()}],
        "femurLeftTrend": {"data": "2023-01-01", "idade": idade_fake, "bmd": rnd_bmd()}
    }

# --- Início do Processo ---

# 1. Carregar lista de pacientes (Para pegar os nomes reais)
try:
    with open(ARQUIVO_PACIENTES, 'r', encoding='utf-8') as f:
        lista_todos_pacientes = json.load(f)
except FileNotFoundError:
    print(f"ERRO: Arquivo '{ARQUIVO_PACIENTES}' não encontrado. Rode o script anterior primeiro.")
    exit()

# 2. Carregar exemplos prontos (Opcional)
mapa_exemplos = {}
try:
    with open(ARQUIVO_EXEMPLOS, 'r', encoding='utf-8') as f:
        exemplos = json.load(f)
        # Cria um dicionário para busca rápida por nome
        for ex in exemplos:
            mapa_exemplos[ex['patientName']] = ex
except FileNotFoundError:
    print("Aviso: Arquivo de exemplos não encontrado. Gerando tudo aleatoriamente.")

print(f"--- Enviando Densitometria para {len(lista_todos_pacientes)} Pacientes ---")

for p in lista_todos_pacientes:
    nome = p['nome_completo']
    
    # Verifica se já temos um JSON pronto para esse nome, senão gera aleatório
    if nome in mapa_exemplos:
        payload = mapa_exemplos[nome]
        origem = "EXEMPLO"
    else:
        payload = gerar_densitometria_fake(nome)
        origem = "GERADO"

    try:
        response = requests.post(f"{BASE_URL}/api/v1/densitometry", json=payload)
        
        if response.status_code == 201:
            print(f"SUCESSO ({origem}): Exame criado para '{nome}'.")
        else:
            print(f"ERRO ao criar exame para '{nome}': {response.text}")
            
    except requests.exceptions.RequestException as e:
        print(f"ERRO DE CONEXÃO para '{nome}': {e}")
    
    time.sleep(0.1)

print("\n--- Processo Finalizado ---")