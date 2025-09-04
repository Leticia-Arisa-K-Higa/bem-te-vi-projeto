import json
import requests
import time

BASE_URL = "http://localhost:8000"

with open('dados_exams.json', 'r', encoding='utf-8') as f:
    lista_de_exames = json.load(f)

with open('dados_gas_evaluations.json', 'r', encoding='utf-8') as f:
    lista_de_avaliacoes_gas = json.load(f)

print("--- Enviando Avaliações ASIA ---")
for exame in lista_de_exames:
    try:
        response = requests.post(f"{BASE_URL}/api/v1/exams", json=exame)
        response.raise_for_status()  
        print(f"SUCESSO: Exame para '{exame['patientName']}' enviado. Status: {response.status_code}")
    except requests.exceptions.RequestException as e:
        print(f"ERRO ao enviar exame para '{exame['patientName']}': {e}")
    time.sleep(0.1) 

print("\n--- Enviando Avaliações GAS ---")
for avaliacao in lista_de_avaliacoes_gas:
    try:
        response = requests.post(f"{BASE_URL}/api/v1/gas-evaluations", json=avaliacao)
        response.raise_for_status()
        print(f"SUCESSO: Avaliação GAS para '{avaliacao['patientIdentifier']}' enviada. Status: {response.status_code}")
    except requests.exceptions.RequestException as e:
        print(f"ERRO ao enviar GAS para '{avaliacao['patientIdentifier']}': {e}")
    time.sleep(0.1)

print("\n--- Processo Finalizado ---")