# Processamento e automação de Dados ANS

Sistema automatizado para coleta, transformação e análise de dados da Agência Nacional de Saúde Suplementar.

##  Componentes Principais

### 1. Processador de PDF (`pdf_processor.py`)
- Extrai tabelas do **Anexo I** (Rol de Procedimentos)
- Funcionalidades:
  - Fallback para extração de texto bruto
  - Padronização de códigos (4 dígitos com zeros à esquerda)
  - Substituição automática de abreviações (OD → Odontológico)
- Saída: CSV estruturado em `Teste_[Nome].zip` como solcidado no PDF pela companhia

### 2. Web Scraper (`scraping.py`)
- Baixa automaticamente:
  - Anexo I (Rol de Procedimentos)
  - Anexo II (Diretrizes de Utilização)
- Recursos:
  - Tratamento de URLs relativas
  - Compactação em ZIP
  - Logs detalhados (adicionado para transparência)

### 3. Coletor de Dados (`downloader.py`)
- Downloads automáticos de:
  - Demonstrações contábeis trimestrais (2023-2024)
  - Dados cadastrais de operadoras (`Relatorio_cadop.csv`)
- Features:
  - Stream de arquivos grandes
  - Extração automática de CSVs

##  Instalação
```bash
git clone https://github.com/seu-usuario/repositorio.git <<< atenção para alteração!
cd repositorio
pip install -r requirements.txt
```

## Execução
- Baixar Anexos I/II
python src/scraping/scraper.py

- Processar PDF
python src/pdf_processor.py

- Coletar dados adicionais
python src/downloader.py

## Saídas Esperadas
- Arquivo	Descrição
- Anexos_[Nome].zip	PDFs baixados do portal ANS
- Teste_[Nome].zip	CSV processado do Anexo I
- database/raw_data/	Dados financeiros e cadastrais em CSV
