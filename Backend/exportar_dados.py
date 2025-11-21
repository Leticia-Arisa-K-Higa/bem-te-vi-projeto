import csv
import psycopg2
from database import get_db_connection

def exportar_para_csv(query, nome_arquivo):
    conn = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        print(f"Executando query para o arquivo {nome_arquivo}...")
        cursor.execute(query)
        
        resultados = cursor.fetchall()
        
        if not resultados:
            print(f"AVISO: Nenhum dado encontrado para {nome_arquivo}.")
            return

        nomes_colunas = [desc[0] for desc in cursor.description]
        
        print(f"Salvando {len(resultados)} registros em {nome_arquivo}...")
        with open(nome_arquivo, 'w', newline='', encoding='utf-8') as arquivo_csv:
            writer = csv.writer(arquivo_csv)
            writer.writerow(nomes_colunas)
            writer.writerows(resultados)
            
        print(f"Arquivo '{nome_arquivo}' salvo com sucesso!")

    except (Exception, psycopg2.DatabaseError) as error:
        print(f"ERRO ao exportar dados: {error}")
    finally:
        if conn:
            cursor.close()
            conn.close()

if __name__ == "__main__":
    print("--- INICIANDO EXPORTAÇÃO DE DADOS ---")

    # --- ASIA ---
    print("\nExportando ASIA...")
    query_asia = """
        SELECT p.nome_completo, a.* FROM avaliacoes_asia a
        JOIN pacientes p ON a.paciente_id = p.id;
    """
    exportar_para_csv(query_asia, "export_avaliacoes_asia.csv")
    
    # --- GAS ---
    print("\nExportando GAS...")
    query_gas = """
        SELECT p.nome_completo, g.* FROM avaliacoes_gas g
        JOIN pacientes p ON g.paciente_id = p.id;
    """
    exportar_para_csv(query_gas, "export_avaliacoes_gas.csv")

    print("\nExportando Metas GAS...")
    query_metas = """
        SELECT p.nome_completo, m.* FROM metas_gas m
        JOIN avaliacoes_gas g ON m.avaliacao_gas_id = g.id
        JOIN pacientes p ON g.paciente_id = p.id;
    """
    exportar_para_csv(query_metas, "export_metas_gas.csv")

    # --- MEEM ---
    print("\nExportando MEEM...")
    query_meem = """
        SELECT p.nome_completo, m.* FROM avaliacoes_meem m
        JOIN pacientes p ON m.paciente_id = p.id;
    """
    exportar_para_csv(query_meem, "export_avaliacoes_meem.csv")

    # --- ELETRODIAGNÓSTICO ---
    print("\nExportando Eletrodiagnóstico (Avaliações)...")
    query_eletro_avaliacoes = """
        SELECT p.nome_completo, e.* FROM avaliacoes_eletrodiagnostico e
        JOIN pacientes p ON e.paciente_id = p.id;
    """
    exportar_para_csv(query_eletro_avaliacoes, "export_avaliacoes_eletro.csv")

    print("\nExportando Eletrodiagnóstico (Medições Musculares)...")
    query_eletro_medicoes = """
        SELECT p.nome_completo, m.* FROM medicoes_musculares m
        JOIN avaliacoes_eletrodiagnostico e ON m.avaliacao_id = e.id
        JOIN pacientes p ON e.paciente_id = p.id;
    """
    exportar_para_csv(query_eletro_medicoes, "export_medicoes_musculares.csv")

    # --- DENSITOMETRIA (DEX) ---
    print("\nExportando Densitometria (Principal)...")
    query_dex_main = """
        SELECT p.nome_completo, d.*
        FROM avaliacoes_densitometria d
        JOIN pacientes p ON d.paciente_id = p.id;
    """
    exportar_para_csv(query_dex_main, "export_densitometria_main.csv")

    print("\nExportando Densitometria (Regiões Detalhadas)...")
    query_dex_regions = """
        SELECT p.nome_completo, r.*
        FROM densitometria_regioes r
        JOIN avaliacoes_densitometria d ON r.avaliacao_id = d.id
        JOIN pacientes p ON d.paciente_id = p.id;
    """
    exportar_para_csv(query_dex_regions, "export_densitometria_regioes.csv")

    print("\nExportando Densitometria (Tendências e Composição)...")
    query_dex_trends = """
        SELECT p.nome_completo, t.*
        FROM densitometria_tendencias t
        JOIN avaliacoes_densitometria d ON t.avaliacao_id = d.id
        JOIN pacientes p ON d.paciente_id = p.id;
    """
    exportar_para_csv(query_dex_trends, "export_densitometria_tendencias.csv")

    print("\n--- EXPORTAÇÃO FINALIZADA ---")