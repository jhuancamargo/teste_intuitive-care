# Processamento e Automação de Dados ANS

![Status](https://img.shields.io/badge/Status-Conclu%C3%ADdo-green)
![Licença](https://img.shields.io/badge/Licen%C3%A7a-MIT-blue)
![Python](https://img.shields.io/badge/Python-3.8+-yellow)
![Vue.js](https://img.shields.io/badge/Vue.js-3.x-green)

Sistema automatizado para coleta, transformação, análise e visualização de dados da **Agência Nacional de Saúde Suplementar (ANS)**, desenvolvido como parte do Teste de Nivelamento da Intuitive Care por **Jhuan Camargo**. Este projeto abrange desde web scraping até uma interface web interativa, hospedada em um servidor em nuvem.

---

## Visão Geral

Este repositório contém uma solução completa para:
- **Coletar** dados públicos da ANS (anexos, demonstrações contábeis e cadastros).
- **Transformar** informações de PDFs em formatos estruturados.
- **Armazenar** e **analisar** dados financeiros em um banco de dados relacional.
- **Apresentar** resultados via API e interface web moderna.

O sistema foi projetado com foco em **robustez**, **eficiência** e **usabilidade**, atendendo aos requisitos do teste e indo além com diferenciais técnicos.

---

## Componentes Principais

### 1. Web Scraper (`scripts/scraping/scraper.py`)
- **Função**: Baixa os Anexos I (Rol de Procedimentos) e II (Diretrizes de Utilização) do portal da ANS.
- **Recursos**:
  - Tratamento de URLs relativas e absolutas.
  - Compactação automática em `Anexos_Jhuan_Camargo.zip`.
  - Logs detalhados para rastreamento.
- **Saída**: Arquivo ZIP com PDFs.

### 2. Processador de PDF (`scripts/pdf_processor.py`)
- **Função**: Extrai e transforma tabelas do Anexo I em dados estruturados.
- **Recursos**:
  - Extração robusta com fallback para texto bruto.
  - Padronização de códigos (preenchimento com zeros à esquerda).
  - Substituição de abreviações (ex.: `OD` → "Odontológico", `AMB` → "Ambulatorial").
- **Saída**: CSV compactado em `Teste_Jhuan_Camargo.zip`.

### 3. Coletor de Dados (`scripts/downloader.py`)
- **Função**: Baixa demonstrações contábeis (2023-2024) e dados cadastrais de operadoras.
- **Recursos**:
  - Download em stream para arquivos grandes.
  - Extração automática de CSVs de arquivos ZIP.
- **Saída**: Arquivos CSV em `scripts/database/raw_data/`.

### 4. Banco de Dados (`scripts/database/`)
- **Função**: Estrutura e analisa dados financeiros.
- **Scripts**:
  - `load_data.sql`: Cria tabelas e importa CSVs.
  - `script.sql`: Queries analíticas (top 10 operadoras por despesas).
- **Recursos**:
  - Índices para performance.
  - Tratamento de duplicatas com `ON CONFLICT`.

### 5. API e Interface Web (`src/`)
- **Backend (`src/api/app.py`)**:
  - Desenvolvido em Flask.
  - Rotas:
    - `/api/top-operadoras/<period>`: Top 10 operadoras por trimestre/ano.
    - `/api/search-operadoras?q=<termo>`: Busca textual em operadoras.
- **Frontend (`src/front/src/App.vue`)**:
  - Desenvolvido em Vue.js.
  - Interface com abas: "Top 10 Operadoras" (dropdown) e "Pesquisar Operadoras" (searchbar).
  - Design responsivo e moderno.

---

## Tecnologias Utilizadas
| **Categoria**         | **Tecnologia**           |
|-----------------------|--------------------------|
| Linguagens            | Python 3.8+, SQL, JavaScript |
| Web Scraping          | `requests`, `BeautifulSoup` |
| Transformação         | `pdfplumber`, `pandas`    |
| Banco de Dados        | PostgreSQL 10+           |
| Backend               | Flask                    |
| Frontend              | Vue.js 3, Axios          |
| Testes                | Postman                  |
| Infraestrutura        | VPS (191.252.111.56), Git |

---

## Instalação e Execução

### Pré-requisitos
- Python 3.8+
- PostgreSQL 10+
- Node.js e npm
- Git
- Postman (opcional)

### Passos
1. **Clone o repositório**:
   ```bash
   git clone https://github.com/jhuancamargo/Teste-Intuitive-Care-VPS.git
   cd Teste-Intuitive-Care-VPS
