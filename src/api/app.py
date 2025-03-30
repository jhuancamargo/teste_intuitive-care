from flask import Flask, jsonify
import psycopg2
from psycopg2.extras import RealDictCursor

app = Flask(__name__)

# Configuração do banco de dados (ajuste a senha)
DB_CONFIG = {
    "dbname": "teste_estagio",
    "user": "postgres",
    "password": "jhuan123",  # Substitua pela sua senha do PostgreSQL
    "host": "localhost",
    "port": "5432"
}

def get_db_connection():
    return psycopg2.connect(**DB_CONFIG, cursor_factory=RealDictCursor)

@app.route('/api/top-operadoras/q4-2024', methods=['GET'])
def get_top_operadoras_q4_2024():
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("""
            SELECT o.razao_social, SUM(d.eventos_assistencia) AS total_despesas
            FROM demonstracoes_contabeis d
            JOIN operadoras_ativas o ON d.reg_ans = o.reg_ans
            WHERE d.ano = 2024 AND d.trimestre = 'Q4'
            AND d.cd_conta_contabil = '41111'
            GROUP BY o.reg_ans, o.razao_social
            ORDER BY total_despesas DESC
            LIMIT 10;
        """)
        result = cur.fetchall()
        cur.close()
        conn.close()
        return jsonify(result)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)