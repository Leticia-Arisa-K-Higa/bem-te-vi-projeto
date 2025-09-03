import os
import psycopg2
from dotenv import load_dotenv

# Carrega as variáveis do arquivo .env para o ambiente
load_dotenv()

def get_db_connection():
    """Cria e retorna uma nova conexão com o banco de dados."""
    try:
        conn = psycopg2.connect(
            host=os.getenv("DB_HOST"),
            port=os.getenv("DB_PORT"),
            dbname=os.getenv("DB_NAME"),
            user=os.getenv("DB_USER"),
            password=os.getenv("DB_PASSWORD")
        )
        return conn
    except psycopg2.OperationalError as e:
        print(f"ERRO DE CONEXÃO: Não foi possível conectar ao banco de dados PostgreSQL. Verifique suas credenciais no arquivo .env e se o banco está no ar.")
        print(f"Detalhe do erro: {e}")
        raise