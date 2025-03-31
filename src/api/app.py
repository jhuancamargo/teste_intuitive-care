from flask import Flask, jsonify, request
import psycopg2
from psycopg2.extras import RealDictCursor

app = Flask(__name__)

def get_db_connection():
    return psycopg2.connect(
        dbname="teste_estagio",
        user="teste_user",
        password="jhuan123",
        host="localhost"
    )

# Rota existente para top operadoras
@app.route('/api/top-operadoras/<period>', methods=['GET'])
def get_top_operadoras(period):
    conn = get_db_connection()
    cur = conn.cursor(cursor_factory=RealDictCursor)
    if period in ['2023', '2024']:
        query = """
            SELECT o.razao_social, SUM(d.eventos_assistencia) AS total_despesas
            FROM demonstracoes_contabeis d
            JOIN operadoras_ativas o ON d.reg_ans = o.reg_ans
            WHERE d.ano = %s
            GROUP BY o.reg_ans, o.razao_social
            ORDER BY total_despesas DESC
            LIMIT 10;
        """
        cur.execute(query, (period,))
    else:
        trimestre, ano = period.split('-')
        query = """
            SELECT o.razao_social, SUM(d.eventos_assistencia) AS total_despesas
            FROM demonstracoes_contabeis d
            JOIN operadoras_ativas o ON d.reg_ans = o.reg_ans
            WHERE d.trimestre = %s AND d.ano = %s
            GROUP BY o.reg_ans, o.razao_social
            ORDER BY total_despesas DESC
            LIMIT 10;
        """
        cur.execute(query, (trimestre.upper(), ano))
    result = cur.fetchall()
    cur.close()
    conn.close()
    return jsonify(result)

# Nova rota de busca textual
@app.route('/api/search-operadoras', methods=['GET'])
def search_operadoras():
    search_term = request.args.get('q', '').lower()
    conn = get_db_connection()
    cur = conn.cursor(cursor_factory=RealDictCursor)
    query = """
        SELECT reg_ans, cnpj, razao_social
        FROM operadoras_ativas
        WHERE LOWER(razao_social) LIKE %s
        ORDER BY razao_social
        LIMIT 10;
    """
    cur.execute(query, (f'%{search_term}%',))
    result = cur.fetchall()
    cur.close()
    conn.close()
    return jsonify(result)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)