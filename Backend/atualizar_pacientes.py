import json
import requests
import time

BASE_URL = "http://localhost:8000"
ARQUIVO_DADOS = 'dados_pacientes.json'

try:
    with open(ARQUIVO_DADOS, 'r', encoding='utf-8') as f:
        lista_pacientes = json.load(f)
except FileNotFoundError:
    print(f"Erro: Arquivo '{ARQUIVO_DADOS}' não encontrado.")
    exit()

print(f"--- Iniciando Atualização de {len(lista_pacientes)} Pacientes ---")

for paciente in lista_pacientes:
    nome = paciente.get('nome_completo')
    try:
        response = requests.put(f"{BASE_URL}/api/v1/patients/update-by-name", json=paciente)
        if response.status_code == 200:
            print(f"SUCESSO: '{nome}' atualizado.")
        elif response.status_code == 404:
            print(f"AVISO: '{nome}' não encontrado no banco.")
        else:
            print(f"ERRO '{nome}': {response.text}")
    except Exception as e:
        print(f"ERRO CONEXÃO '{nome}': {e}")
    time.sleep(0.1)

print("\n--- Finalizado ---")