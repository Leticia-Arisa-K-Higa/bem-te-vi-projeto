import requests
import random
import time
import psycopg2
from faker import Faker
from datetime import date, timedelta
from database import get_db_connection  # Importa sua função de conexão

# --- Configurações ---
BASE_URL = "http://localhost:8000"
fake = Faker('pt_BR')

# --- Função 1: Buscar Pacientes Existentes ---

def get_pacientes_existentes():
    """Busca nomes de pacientes existentes no banco."""
    conn = None
    pacientes = []
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # Seleciona apenas o nome completo, que é o identificador usado pela API
        cursor.execute("SELECT nome_completo FROM pacientes;")
        
        resultados = cursor.fetchall()
        
        # Cria uma lista simples de nomes
        pacientes = [row[0] for row in resultados]
        
        print(f"--- Encontrados {len(pacientes)} pacientes existentes no banco. ---")
        return pacientes
    except (Exception, psycopg2.DatabaseError) as error:
        print(f"ERRO FATAL ao buscar pacientes: {error}")
        return []
    finally:
        if conn:
            cursor.close()
            conn.close()

# --- Funções 2: Gerar Dados Aleatórios (Baseado no seu gerador_dados.py) ---

def gerar_dados_meem(nome_paciente):
    """Gera um conjunto de dados lógicos para uma avaliação MEEM."""
    
    pontos = {
        "orientacaoTemporal": [random.randint(0, 1) for _ in range(5)],
        "orientacaoEspacial": [random.randint(0, 1) for _ in range(5)],
        "memoriaImediata": [random.randint(0, 1) for _ in range(3)],
        "atencaoCalculo": [random.randint(0, 1) for _ in range(5)],
        "memoriaEvocativa": [random.randint(0, 1) for _ in range(3)],
        "linguagemNomear": [random.randint(0, 1) for _ in range(2)],
        "linguagemRepetir": random.randint(0, 1),
        "linguagemComandoVerbal": [random.randint(0, 1) for _ in range(3)],
        "linguagemComandoEscrito": random.randint(0, 1),
        "linguagemFrase": random.randint(0, 1),
        "linguagemCopia": random.randint(0, 1)
    }
    
    # Valida o examDate para Pydantic. Pydantic é inteligente e converte
    # string ISO ("AAAA-MM-DD") para o tipo 'date' do models.py.
    meem_data = {
        "patientName": nome_paciente,
        "examDate": (date.today() - timedelta(days=random.randint(30, 90))).isoformat(),
        "examinerName": fake.name(),
        "age": random.randint(20, 75),
        "escolaridade": random.choice(["Analfabeto", "1-3 anos", "4-7 anos", "8+ anos"]),
        "pontos": pontos
    }
    return meem_data

def gerar_dados_eletrodiagnostico(nome_paciente):
    """Gera um conjunto de dados lógicos para um Eletrodiagnóstico."""
    
    musculos_para_teste = ["Tibial Anterior", "Extensor Longo dos Dedos", "Bíceps Braquial", "Tríceps Braquial"]
    musculos_selecionados = random.sample(musculos_para_teste, k=random.randint(2, 3))
    
    medicoes_musculares = []
    for musculo in musculos_selecionados:
        medicao = {
            "muscleName": musculo,
            "right": {
                "reobase": round(random.uniform(0.5, 3.0), 2),
                "accommodation": round(random.uniform(1.1, 1.5), 2),
                "chronaxy": round(random.uniform(0.1, 0.9), 2),
                # --- CORREÇÃO APLICADA AQUI ---
                "accommodationIndex": str(round(random.uniform(1.0, 1.3), 2))
            },
            "left": {
                "reobase": round(random.uniform(0.5, 3.0), 2),
                "accommodation": round(random.uniform(1.1, 1.5), 2),
                "chronaxy": round(random.uniform(0.1, 0.9), 2),
                # --- CORREÇÃO APLICADA AQUI ---
                "accommodationIndex": str(round(random.uniform(1.0, 1.3), 2))
            },
            "comments": fake.sentence()
        }
        medicoes_musculares.append(medicao)
        
    # O examDate no models.py do Eletrodiagnóstico espera uma 'str', 
    # então .isoformat() está perfeito.
    eletro_data = {
        "patientName": nome_paciente,
        "examDate": (date.today() - timedelta(days=random.randint(30, 90))).isoformat(),
        "examinerName": fake.name(),
        "equipmentName": random.choice(["NeuroMaster 3000", "EMG-v2", "BioEletro Plus"]),
        "muscles": medicoes_musculares
    }
    return eletro_data

# --- Função 3: Enviar Dados para a API ---

def enviar_dados_api(endpoint, data, tipo_avaliacao, nome_paciente):
    """Envia um único conjunto de dados para a API."""
    try:
        url = f"{BASE_URL}{endpoint}"
        response = requests.post(url, json=data)
        response.raise_for_status()  
        print(f"  SUCESSO: {tipo_avaliacao} para '{nome_paciente}' enviado.")
    except requests.exceptions.RequestException as e:
        # Aprimorado para mostrar o erro 422
        if e.response is not None:
             print(f"  ERRO ({e.response.status_code}) ao enviar {tipo_avaliacao} para '{nome_paciente}': {e}")
             # Se for um erro 422, imprime os detalhes da validação
             if e.response.status_code == 422:
                 print(f"    DETALHES DA VALIDAÇÃO: {e.response.json().get('detail')}")
        else:
             print(f"  ERRO ao enviar {tipo_avaliacao} para '{nome_paciente}': {e}")
    
    # Pausa curta para não sobrecarregar a API
    time.sleep(0.1)

# --- Execução Principal ---

if __name__ == "__main__":
    print("Iniciando script para popular MEEM e Eletrodiagnóstico...")
    
    # 1. Buscar pacientes
    lista_de_pacientes = get_pacientes_existentes()
    
    if not lista_de_pacientes:
        print("Nenhum paciente encontrado. Script finalizado.")
        exit()
        
    print("\nIniciando geração e envio de dados para cada paciente...")
    
    # 2. Iterar sobre cada paciente, gerar e enviar os dados
    for i, nome_paciente in enumerate(lista_de_pacientes, 1):
        print(f"\nProcessando Paciente {i}/{len(lista_de_pacientes)}: {nome_paciente}")
        
        # Gerar e Enviar MEEM
        dados_meem = gerar_dados_meem(nome_paciente)
        enviar_dados_api("/api/v1/meem-evaluations", dados_meem, "Avaliação MEEM", nome_paciente)
        
        # Gerar e Enviar Eletrodiagnóstico
        dados_eletro = gerar_dados_eletrodiagnostico(nome_paciente)
        enviar_dados_api("/api/v1/electrodiagnosis", dados_eletro, "Eletrodiagnóstico", nome_paciente)

    print("\n" + "="*50)
    print("--- Processo Finalizado ---")
    print(f"Novos dados de MEEM e Eletrodiagnóstico foram enviados para {len(lista_de_pacientes)} pacientes.")
    print("="*50)
