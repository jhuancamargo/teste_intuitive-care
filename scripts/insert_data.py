import pandas as pd
import psycopg2
from pathlib import Path

DB_CONFIG = {
    "dbname": "teste_estagio",
    "user": "teste_user",
    "password": "jhuan123",
    "host": "localhost",
    "port": "5432"
}

def create_tables():
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor()
    cur.execute("""
        DROP TABLE IF EXISTS demonstracoes_contabeis;
        CREATE TABLE demonstracoes_contabeis (
            reg_ans VARCHAR(6),
            ano INT,
            trimestre VARCHAR(2),
            cd_conta_contabil VARCHAR(10),
            eventos_assistencia DECIMAL
        );
        DROP TABLE IF EXISTS operadoras_ativas;
        CREATE TABLE operadoras_ativas (
            reg_ans VARCHAR(6),
            razao_social VARCHAR(255)
        );
    """)
    conn.commit()
    cur.close()
    conn.close()

def insert_data():
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor()
    base_dir = Path('/home/teste_intuitive-care/database/raw_data')

    # Inserir demonstracoes_contabeis
    for year in [2023, 2024]:
        for quarter in range(1, 5):
            csv_file = base_dir / f'{quarter}T{year}.csv'
            if csv_file.exists():
                df = pd.read_csv(csv_file, sep=';', encoding='latin1')
                print(f"Colunas em {csv_file}: {df.columns.tolist()}")
                for _, row in df.iterrows():
                    cur.execute("""
                        INSERT INTO demonstracoes_contabeis (reg_ans, ano, trimestre, cd_conta_contabil, eventos_assistencia)
                        VALUES (%s, %s, %s, %s, %s)
                    """, (row['REG_ANS'], year, f'Q{quarter}', row['CD_CONTA_CONTABIL'], row['VL_SALDO_FINAL']))

    # Inserir operadoras_ativas
    operadoras_file = base_dir / 'Relatorio_cadop.csv'
    if operadoras_file.exists():
        df = pd.read_csv(operadoras_file, sep=';', encoding='latin1')
        print(f"Colunas em {operadoras_file}: {df.columns.tolist()}")
        for _, row in df.iterrows():
            cur.execute("""
                INSERT INTO operadoras_ativas (reg_ans, razao_social)
                VALUES (%s, %s)
            """, (row['REGISTRO_ANS'], row['RAZAO_SOCIAL']))

    conn.commit()
    cur.close()
    conn.close()

if __name__ == "__main__":
    create_tables()
    insert_data()