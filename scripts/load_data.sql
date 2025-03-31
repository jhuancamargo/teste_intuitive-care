CREATE TABLE IF NOT EXISTS temp_demonstracoes (
    data VARCHAR(20),
    reg_ans VARCHAR(20),
    cd_conta_contabil VARCHAR(20),
    descricao VARCHAR(255),
    vl_saldo_inicial VARCHAR(20),
    vl_saldo_final VARCHAR(20)
);

-- Q1 2023
\copy temp_demonstracoes FROM '/home/teste_intuitive-care/scripts/database/raw_data/1T2023.csv' WITH (FORMAT CSV, DELIMITER ';', HEADER TRUE, ENCODING 'UTF8');
INSERT INTO demonstracoes_contabeis (reg_ans, eventos_assistencia, ano, trimestre, cd_conta_contabil, descricao)
SELECT t.reg_ans,
       CASE WHEN REPLACE(t.vl_saldo_final, ',', '.')::NUMERIC < 0 THEN 0
            ELSE REPLACE(t.vl_saldo_final, ',', '.')::NUMERIC END,
       2023, 'Q1', t.cd_conta_contabil, t.descricao
FROM temp_demonstracoes t
WHERE EXISTS (SELECT 1 FROM operadoras_ativas o WHERE o.reg_ans = t.reg_ans)
AND t.cd_conta_contabil = '41111'
ON CONFLICT ON CONSTRAINT unique_reg_ans_ano_trimestre DO UPDATE SET eventos_assistencia = EXCLUDED.eventos_assistencia;
TRUNCATE temp_demonstracoes;

-- Q2 2023
\copy temp_demonstracoes FROM '/home/teste_intuitive-care/scripts/database/raw_data/2T2023.csv' WITH (FORMAT CSV, DELIMITER ';', HEADER TRUE, ENCODING 'UTF8');
INSERT INTO demonstracoes_contabeis (reg_ans, eventos_assistencia, ano, trimestre, cd_conta_contabil, descricao)
SELECT t.reg_ans,
       CASE WHEN REPLACE(t.vl_saldo_final, ',', '.')::NUMERIC < 0 THEN 0
            ELSE REPLACE(t.vl_saldo_final, ',', '.')::NUMERIC END,
       2023, 'Q2', t.cd_conta_contabil, t.descricao
FROM temp_demonstracoes t
WHERE EXISTS (SELECT 1 FROM operadoras_ativas o WHERE o.reg_ans = t.reg_ans)
AND t.cd_conta_contabil = '41111'
ON CONFLICT ON CONSTRAINT unique_reg_ans_ano_trimestre DO UPDATE SET eventos_assistencia = EXCLUDED.eventos_assistencia;
TRUNCATE temp_demonstracoes;

-- Q3 2023
\copy temp_demonstracoes FROM '/home/teste_intuitive-care/scripts/database/raw_data/3T2023.csv' WITH (FORMAT CSV, DELIMITER ';', HEADER TRUE, ENCODING 'UTF8');
INSERT INTO demonstracoes_contabeis (reg_ans, eventos_assistencia, ano, trimestre, cd_conta_contabil, descricao)
SELECT t.reg_ans,
       CASE WHEN REPLACE(t.vl_saldo_final, ',', '.')::NUMERIC < 0 THEN 0
            ELSE REPLACE(t.vl_saldo_final, ',', '.')::NUMERIC END,
       2023, 'Q3', t.cd_conta_contabil, t.descricao
FROM temp_demonstracoes t
WHERE EXISTS (SELECT 1 FROM operadoras_ativas o WHERE o.reg_ans = t.reg_ans)
AND t.cd_conta_contabil = '41111'
ON CONFLICT ON CONSTRAINT unique_reg_ans_ano_trimestre DO UPDATE SET eventos_assistencia = EXCLUDED.eventos_assistencia;
TRUNCATE temp_demonstracoes;

-- Q4 2023
\copy temp_demonstracoes FROM '/home/teste_intuitive-care/scripts/database/raw_data/4T2023.csv' WITH (FORMAT CSV, DELIMITER ';', HEADER TRUE, ENCODING 'UTF8');
INSERT INTO demonstracoes_contabeis (reg_ans, eventos_assistencia, ano, trimestre, cd_conta_contabil, descricao)
SELECT t.reg_ans,
       CASE WHEN REPLACE(t.vl_saldo_final, ',', '.')::NUMERIC < 0 THEN 0
            ELSE REPLACE(t.vl_saldo_final, ',', '.')::NUMERIC END,
       2023, 'Q4', t.cd_conta_contabil, t.descricao
FROM temp_demonstracoes t
WHERE EXISTS (SELECT 1 FROM operadoras_ativas o WHERE o.reg_ans = t.reg_ans)
AND t.cd_conta_contabil = '41111'
ON CONFLICT ON CONSTRAINT unique_reg_ans_ano_trimestre DO UPDATE SET eventos_assistencia = EXCLUDED.eventos_assistencia;
TRUNCATE temp_demonstracoes;

-- Q1 2024
\copy temp_demonstracoes FROM '/home/teste_intuitive-care/scripts/database/raw_data/1T2024.csv' WITH (FORMAT CSV, DELIMITER ';', HEADER TRUE, ENCODING 'UTF8');
INSERT INTO demonstracoes_contabeis (reg_ans, eventos_assistencia, ano, trimestre, cd_conta_contabil, descricao)
SELECT t.reg_ans,
       CASE WHEN REPLACE(t.vl_saldo_final, ',', '.')::NUMERIC < 0 THEN 0
            ELSE REPLACE(t.vl_saldo_final, ',', '.')::NUMERIC END,
       2024, 'Q1', t.cd_conta_contabil, t.descricao
FROM temp_demonstracoes t
WHERE EXISTS (SELECT 1 FROM operadoras_ativas o WHERE o.reg_ans = t.reg_ans)
AND t.cd_conta_contabil = '41111'
ON CONFLICT ON CONSTRAINT unique_reg_ans_ano_trimestre DO UPDATE SET eventos_assistencia = EXCLUDED.eventos_assistencia;
TRUNCATE temp_demonstracoes;

-- Q2 2024
\copy temp_demonstracoes FROM '/home/teste_intuitive-care/scripts/database/raw_data/2T2024.csv' WITH (FORMAT CSV, DELIMITER ';', HEADER TRUE, ENCODING 'UTF8');
INSERT INTO demonstracoes_contabeis (reg_ans, eventos_assistencia, ano, trimestre, cd_conta_contabil, descricao)
SELECT t.reg_ans,
       CASE WHEN REPLACE(t.vl_saldo_final, ',', '.')::NUMERIC < 0 THEN 0
            ELSE REPLACE(t.vl_saldo_final, ',', '.')::NUMERIC END,
       2024, 'Q2', t.cd_conta_contabil, t.descricao
FROM temp_demonstracoes t
WHERE EXISTS (SELECT 1 FROM operadoras_ativas o WHERE o.reg_ans = t.reg_ans)
AND t.cd_conta_contabil = '41111'
ON CONFLICT ON CONSTRAINT unique_reg_ans_ano_trimestre DO UPDATE SET eventos_assistencia = EXCLUDED.eventos_assistencia;
TRUNCATE temp_demonstracoes;

-- Q3 2024
\copy temp_demonstracoes FROM '/home/teste_intuitive-care/scripts/database/raw_data/3T2024.csv' WITH (FORMAT CSV, DELIMITER ';', HEADER TRUE, ENCODING 'UTF8');
INSERT INTO demonstracoes_contabeis (reg_ans, eventos_assistencia, ano, trimestre, cd_conta_contabil, descricao)
SELECT t.reg_ans,
       CASE WHEN REPLACE(t.vl_saldo_final, ',', '.')::NUMERIC < 0 THEN 0
            ELSE REPLACE(t.vl_saldo_final, ',', '.')::NUMERIC END,
       2024, 'Q3', t.cd_conta_contabil, t.descricao
FROM temp_demonstracoes t
WHERE EXISTS (SELECT 1 FROM operadoras_ativas o WHERE o.reg_ans = t.reg_ans)
AND t.cd_conta_contabil = '41111'
ON CONFLICT ON CONSTRAINT unique_reg_ans_ano_trimestre DO UPDATE SET eventos_assistencia = EXCLUDED.eventos_assistencia;
TRUNCATE temp_demonstracoes;

-- Q4 2024
\copy temp_demonstracoes FROM '/home/teste_intuitive-care/scripts/database/raw_data/4T2024.csv' WITH (FORMAT CSV, DELIMITER ';', HEADER TRUE, ENCODING 'UTF8');
INSERT INTO demonstracoes_contabeis (reg_ans, eventos_assistencia, ano, trimestre, cd_conta_contabil, descricao)
SELECT t.reg_ans,
       CASE WHEN REPLACE(t.vl_saldo_final, ',', '.')::NUMERIC < 0 THEN 0
            ELSE REPLACE(t.vl_saldo_final, ',', '.')::NUMERIC END,
       2024, 'Q4', t.cd_conta_contabil, t.descricao
FROM temp_demonstracoes t
WHERE EXISTS (SELECT 1 FROM operadoras_ativas o WHERE o.reg_ans = t.reg_ans)
AND t.cd_conta_contabil = '41111'
ON CONFLICT ON CONSTRAINT unique_reg_ans_ano_trimestre DO UPDATE SET eventos_assistencia = EXCLUDED.eventos_assistencia;

DROP TABLE temp_demonstracoes;