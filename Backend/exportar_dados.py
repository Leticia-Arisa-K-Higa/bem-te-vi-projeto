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

    query_asia = """
        SELECT p.nome_completo, a.* FROM avaliacoes_asia a
        JOIN pacientes p ON a.paciente_id = p.id;
    """
    exportar_para_csv(query_asia, "export_avaliacoes_asia.csv")
    
    query_gas = """
        SELECT p.nome_completo, g.* FROM avaliacoes_gas g
        JOIN pacientes p ON g.paciente_id = p.id;
    """
    exportar_para_csv(query_gas, "export_avaliacoes_gas.csv")

    query_metas = "SELECT * FROM metas_gas;"
    exportar_para_csv(query_metas, "export_metas_gas.csv")

    print("\n--- EXPORTAÇÃO FINALIZADA ---")