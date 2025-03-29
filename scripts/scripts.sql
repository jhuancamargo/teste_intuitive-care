-- Limpar todas as tabelas existentes
DROP TABLE IF EXISTS demonstracoes_contabeis CASCADE;
DROP TABLE IF EXISTS operadoras_ativas CASCADE;
DROP TABLE IF EXISTS temp_operadoras;
DROP TABLE IF EXISTS temp_demonstracoes;

-- Tabela temporária para operadoras ativas
CREATE TABLE temp_operadoras (
    reg_ans VARCHAR(20),
    cnpj VARCHAR(14),
    razao_social VARCHAR(255),
    nome_fantasia VARCHAR(255),
    modalidade VARCHAR(255),
    logradouro VARCHAR(255),
    numero VARCHAR(20),
    complemento VARCHAR(255),
    bairro VARCHAR(255),
    cidade VARCHAR(255),
    uf VARCHAR(2),
    cep VARCHAR(10),
    ddd VARCHAR(5),
    telefone VARCHAR(20),
    fax VARCHAR(20),
    endereco_eletronico VARCHAR(255),
    representante VARCHAR(255),
    cargo_representante VARCHAR(255),
    regiao_comercializacao VARCHAR(255),
    data_registro_ans VARCHAR(20)
);

-- Tabela temporária para demonstrações contábeis
CREATE TABLE temp_demonstracoes (
    data VARCHAR(20),
    reg_ans VARCHAR(20),
    cd_conta_contabil VARCHAR(20),
    descricao VARCHAR(255),
    vl_saldo_inicial VARCHAR(20),
    vl_saldo_final VARCHAR(20)
);

-- Tabela final para operadoras ativas
CREATE TABLE operadoras_ativas (
    reg_ans VARCHAR(20) PRIMARY KEY,
    cnpj VARCHAR(14),
    razao_social VARCHAR(255) NOT NULL
);

-- Tabela final para demonstrações contábeis
CREATE TABLE demonstracoes_contabeis (
    id SERIAL PRIMARY KEY,
    reg_ans VARCHAR(20) NOT NULL,
    ano INTEGER NOT NULL,
    trimestre VARCHAR(2) NOT NULL,
    eventos_assistencia NUMERIC(15, 2),
    cd_conta_contabil VARCHAR(20),
    descricao VARCHAR(255),
    CONSTRAINT fk_operadora
        FOREIGN KEY (reg_ans) REFERENCES operadoras_ativas(reg_ans),
    CONSTRAINT unique_reg_ans_ano_trimestre
        UNIQUE (reg_ans, ano, trimestre)
);

-- Índices para performance
CREATE INDEX idx_ano_trimestre ON demonstracoes_contabeis (ano, trimestre);
CREATE INDEX idx_reg_ans ON demonstracoes_contabeis (reg_ans);
CREATE INDEX idx_cd_conta_contabil ON demonstracoes_contabeis (cd_conta_contabil);

-- Importação dos dados cadastrais
\copy temp_operadoras FROM 'C:/Users/jenif/Desktop/projeto_estagio/scripts/database/raw_data/Relatorio_cadop.csv' WITH (FORMAT CSV, DELIMITER ';', HEADER TRUE, ENCODING 'UTF8');

INSERT INTO operadoras_ativas (reg_ans, cnpj, razao_social)
SELECT reg_ans, cnpj, razao_social FROM temp_operadoras;

-- Importação de demonstrações contábeis para 2023
\copy temp_demonstracoes FROM 'C:/Users/jenif/Desktop/projeto_estagio/scripts/database/raw_data/1T2023.csv' WITH (FORMAT CSV, DELIMITER ';', HEADER TRUE, ENCODING 'UTF8');
INSERT INTO demonstracoes_contabeis (reg_ans, eventos_assistencia, ano, trimestre, cd_conta_contabil, descricao)
SELECT t.reg_ans,
       CASE WHEN REPLACE(t.vl_saldo_final, ',', '.')::NUMERIC < 0 THEN 0
            ELSE REPLACE(t.vl_saldo_final, ',', '.')::NUMERIC END,
       2023, 'Q1', t.cd_conta_contabil, t.descricao
FROM temp_demonstracoes t
WHERE EXISTS (SELECT 1 FROM operadoras_ativas o WHERE o.reg_ans = t.reg_ans)
AND t.cd_conta_contabil = '41111'
ON CONFLICT ON CONSTRAINT unique_reg_ans_ano_trimestre DO NOTHING;

\copy temp_demonstracoes FROM 'C:/Users/jenif/Desktop/projeto_estagio/scripts/database/raw_data/2t2023.csv' WITH (FORMAT CSV, DELIMITER ';', HEADER TRUE, ENCODING 'UTF8');
INSERT INTO demonstracoes_contabeis (reg_ans, eventos_assistencia, ano, trimestre, cd_conta_contabil, descricao)
SELECT t.reg_ans,
       CASE WHEN REPLACE(t.vl_saldo_final, ',', '.')::NUMERIC < 0 THEN 0
            ELSE REPLACE(t.vl_saldo_final, ',', '.')::NUMERIC END,
       2023, 'Q2', t.cd_conta_contabil, t.descricao
FROM temp_demonstracoes t
WHERE EXISTS (SELECT 1 FROM operadoras_ativas o WHERE o.reg_ans = t.reg_ans)
AND t.cd_conta_contabil = '41111'
ON CONFLICT ON CONSTRAINT unique_reg_ans_ano_trimestre DO NOTHING;

\copy temp_demonstracoes FROM 'C:/Users/jenif/Desktop/projeto_estagio/scripts/database/raw_data/3t2023.csv' WITH (FORMAT CSV, DELIMITER ';', HEADER TRUE, ENCODING 'UTF8');
INSERT INTO demonstracoes_contabeis (reg_ans, eventos_assistencia, ano, trimestre, cd_conta_contabil, descricao)
SELECT t.reg_ans,
       CASE WHEN REPLACE(t.vl_saldo_final, ',', '.')::NUMERIC < 0 THEN 0
            ELSE REPLACE(t.vl_saldo_final, ',', '.')::NUMERIC END,
       2023, 'Q3', t.cd_conta_contabil, t.descricao
FROM temp_demonstracoes t
WHERE EXISTS (SELECT 1 FROM operadoras_ativas o WHERE o.reg_ans = t.reg_ans)
AND t.cd_conta_contabil = '41111'
ON CONFLICT ON CONSTRAINT unique_reg_ans_ano_trimestre DO NOTHING;

\copy temp_demonstracoes FROM 'C:/Users/jenif/Desktop/projeto_estagio/scripts/database/raw_data/4t2023.csv' WITH (FORMAT CSV, DELIMITER ';', HEADER TRUE, ENCODING 'UTF8');
INSERT INTO demonstracoes_contabeis (reg_ans, eventos_assistencia, ano, trimestre, cd_conta_contabil, descricao)
SELECT t.reg_ans,
       CASE WHEN REPLACE(t.vl_saldo_final, ',', '.')::NUMERIC < 0 THEN 0
            ELSE REPLACE(t.vl_saldo_final, ',', '.')::NUMERIC END,
       2023, 'Q4', t.cd_conta_contabil, t.descricao
FROM temp_demonstracoes t
WHERE EXISTS (SELECT 1 FROM operadoras_ativas o WHERE o.reg_ans = t.reg_ans)
AND t.cd_conta_contabil = '41111'
ON CONFLICT ON CONSTRAINT unique_reg_ans_ano_trimestre DO NOTHING;

-- Importação de demonstrações contábeis para 2024
\copy temp_demonstracoes FROM 'C:/Users/jenif/Desktop/projeto_estagio/scripts/database/raw_data/1t2024.csv' WITH (FORMAT CSV, DELIMITER ';', HEADER TRUE, ENCODING 'UTF8');
INSERT INTO demonstracoes_contabeis (reg_ans, eventos_assistencia, ano, trimestre, cd_conta_contabil, descricao)
SELECT t.reg_ans,
       CASE WHEN REPLACE(t.vl_saldo_final, ',', '.')::NUMERIC < 0 THEN 0
            ELSE REPLACE(t.vl_saldo_final, ',', '.')::NUMERIC END,
       2024, 'Q1', t.cd_conta_contabil, t.descricao
FROM temp_demonstracoes t
WHERE EXISTS (SELECT 1 FROM operadoras_ativas o WHERE o.reg_ans = t.reg_ans)
AND t.cd_conta_contabil = '41111'
ON CONFLICT ON CONSTRAINT unique_reg_ans_ano_trimestre DO NOTHING;

\copy temp_demonstracoes FROM 'C:/Users/jenif/Desktop/projeto_estagio/scripts/database/raw_data/2t2024.csv' WITH (FORMAT CSV, DELIMITER ';', HEADER TRUE, ENCODING 'UTF8');
INSERT INTO demonstracoes_contabeis (reg_ans, eventos_assistencia, ano, trimestre, cd_conta_contabil, descricao)
SELECT t.reg_ans,
       CASE WHEN REPLACE(t.vl_saldo_final, ',', '.')::NUMERIC < 0 THEN 0
            ELSE REPLACE(t.vl_saldo_final, ',', '.')::NUMERIC END,
       2024, 'Q2', t.cd_conta_contabil, t.descricao
FROM temp_demonstracoes t
WHERE EXISTS (SELECT 1 FROM operadoras_ativas o WHERE o.reg_ans = t.reg_ans)
AND t.cd_conta_contabil = '41111'
ON CONFLICT ON CONSTRAINT unique_reg_ans_ano_trimestre DO NOTHING;

\copy temp_demonstracoes FROM 'C:/Users/jenif/Desktop/projeto_estagio/scripts/database/raw_data/3t2024.csv' WITH (FORMAT CSV, DELIMITER ';', HEADER TRUE, ENCODING 'UTF8');
INSERT INTO demonstracoes_contabeis (reg_ans, eventos_assistencia, ano, trimestre, cd_conta_contabil, descricao)
SELECT t.reg_ans,
       CASE WHEN REPLACE(t.vl_saldo_final, ',', '.')::NUMERIC < 0 THEN 0
            ELSE REPLACE(t.vl_saldo_final, ',', '.')::NUMERIC END,
       2024, 'Q3', t.cd_conta_contabil, t.descricao
FROM temp_demonstracoes t
WHERE EXISTS (SELECT 1 FROM operadoras_ativas o WHERE o.reg_ans = t.reg_ans)
AND t.cd_conta_contabil = '41111'
ON CONFLICT ON CONSTRAINT unique_reg_ans_ano_trimestre DO NOTHING;

\copy temp_demonstracoes FROM 'C:/Users/jenif/Desktop/projeto_estagio/scripts/database/raw_data/4t2024.csv' WITH (FORMAT CSV, DELIMITER ';', HEADER TRUE, ENCODING 'UTF8');
INSERT INTO demonstracoes_contabeis (reg_ans, eventos_assistencia, ano, trimestre, cd_conta_contabil, descricao)
SELECT t.reg_ans,
       CASE WHEN REPLACE(t.vl_saldo_final, ',', '.')::NUMERIC < 0 THEN 0
            ELSE REPLACE(t.vl_saldo_final, ',', '.')::NUMERIC END,
       2024, 'Q4', t.cd_conta_contabil, t.descricao
FROM temp_demonstracoes t
WHERE EXISTS (SELECT 1 FROM operadoras_ativas o WHERE o.reg_ans = t.reg_ans)
AND t.cd_conta_contabil = '41111'
ON CONFLICT ON CONSTRAINT unique_reg_ans_ano_trimestre DO NOTHING;

-- Limpar tabelas temporárias
DROP TABLE temp_operadoras;
DROP TABLE temp_demonstracoes;

-- Queries analíticas
SELECT o.razao_social, SUM(d.eventos_assistencia) AS total_despesas
FROM demonstracoes_contabeis d
JOIN operadoras_ativas o ON d.reg_ans = o.reg_ans
WHERE d.ano = 2024 AND d.trimestre = 'Q4'
GROUP BY o.reg_ans, o.razao_social
ORDER BY total_despesas DESC
LIMIT 10;

SELECT o.razao_social, SUM(d.eventos_assistencia) AS total_despesas
FROM demonstracoes_contabeis d
JOIN operadoras_ativas o ON d.reg_ans = o.reg_ans
WHERE d.ano = 2024
GROUP BY o.reg_ans, o.razao_social
ORDER BY total_despesas DESC
LIMIT 10;