import pdfplumber
import pandas as pd
import logging
from pathlib import Path
import zipfile
import sys
import csv
from typing import Optional, List

# Configuração de logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s: %(message)s',
    handlers=[logging.FileHandler('pdf_processor.log'), logging.StreamHandler()]
)

class PDFProcessingError(Exception):
    """Exceção personalizada para erros de processamento de PDF."""
    pass

def extrair_tabelas(pdf_path: Path) -> Optional[pd.DataFrame]:
    """Extração de tabelas do PDF com fallback para texto bruto."""
    dados: List[List[str]] = []
    
    try:
        with pdfplumber.open(pdf_path) as pdf:
            logging.info(f"Total de páginas no PDF: {len(pdf.pages)}")
            
            for page_num, page in enumerate(pdf.pages, 1):
                # Tenta extrair tabelas diretamente
                tables = page.extract_tables()
                if tables:
                    for table in tables:
                        for row in table:
                            if row and len(row) >= 3:  # Garante que a linha tem pelo menos 3 colunas
                                dados.append([str(cell).strip() for cell in row[:3]])
                else:
                    # Fallback para texto bruto se não houver tabelas detectadas
                    text = page.extract_text()
                    if text:
                        linhas = text.split('\n')
                        for linha in linhas:
                            partes = linha.split(maxsplit=2)  # Divide em até 3 partes
                            if len(partes) == 3 and partes[0].isdigit():
                                dados.append(partes)
                    else:
                        logging.warning(f"Página {page_num} sem texto ou tabelas extraídas")
        
        if not dados:
            logging.warning("Nenhum dado extraído do PDF")
            return None
        
        # Cria DataFrame com colunas esperadas
        df = pd.DataFrame(dados, columns=["COD", "DESCRICAO", "TIPO"])
        logging.info(f"Total de registros extraídos: {len(df)}")
        return df
    
    except Exception as e:
        logging.error(f"Erro na extração do PDF: {e}")
        raise PDFProcessingError(f"Falha ao extrair dados: {e}")

def processar_dados(df: pd.DataFrame) -> pd.DataFrame:
    """Processamento dos dados extraídos."""
    if df is None or df.empty:
        raise PDFProcessingError("DataFrame vazio")
        
    try:
        # Dicionário de mapeamento de abreviações conforme o rodapé do PDF
        legenda_substituicao = {
            'OD': 'Odontológico',
            'AMB': 'Ambulatorial'
        }
        
        # Limpeza e padronização
        df = df.dropna(subset=['COD', 'DESCRICAO'])  # Remove linhas sem código ou descrição
        df['COD'] = df['COD'].str.strip().str.zfill(4)  # Preenche com zeros à esquerda
        df['DESCRICAO'] = df['DESCRICAO'].str.strip()
        df['TIPO'] = df['TIPO'].str.strip().fillna('')  # Preenche TIPO vazio
        
        # Substituição de abreviações
        df['TIPO_COMPLETO'] = df['TIPO'].map(legenda_substituicao).fillna(df['TIPO'])
        
        # Remove a coluna TIPO original
        return df.drop(columns=['TIPO'])
        
    except Exception as e:
        logging.error(f"Erro no processamento: {e}")
        raise PDFProcessingError(f"Falha no processamento de dados: {e}")

def salvar_csv_e_zip(df: pd.DataFrame, csv_path: Path, zip_path: Path) -> bool:
    """Salva o CSV e compacta em ZIP."""
    try:
        df.to_csv(
            csv_path,
            index=False,
            encoding='utf-8-sig',
            sep=';',
            quotechar='"',
            quoting=csv.QUOTE_MINIMAL
        )
        logging.info(f"CSV salvo em {csv_path}")
        
        with zipfile.ZipFile(zip_path, 'w', zipfile.ZIP_DEFLATED) as zipf:
            zipf.write(csv_path, arcname=csv_path.name)
        logging.info(f"ZIP criado em {zip_path}")
        return True
    except Exception as e:
        logging.error(f"Erro ao salvar CSV/ZIP: {e}")
        return False

def main():
    try:
        base_dir = Path(__file__).resolve().parent
        pdf_path = base_dir.parent / "scraping" / "downloads" / "Anexo_I.pdf"
        output_dir = base_dir / "output"
        output_dir.mkdir(exist_ok=True)
        
        csv_path = output_dir / "Rol_Procedimentos.csv"
        zip_path = base_dir.parent / "Teste_Jhuan_Camargo.zip"

        if not pdf_path.exists():
            raise FileNotFoundError(f"PDF não encontrado: {pdf_path}")

        logging.info("Iniciando processamento do PDF...")
        
        # Pipeline
        df = extrair_tabelas(pdf_path)
        df_final = processar_dados(df)
        salvar_csv_e_zip(df_final, csv_path, zip_path)

        logging.info(f"Processo concluído! Registros processados: {len(df_final)}")
        
    except Exception as e:
        logging.error(f"Erro crítico: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()