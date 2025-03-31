import requests
from pathlib import Path
import logging
import zipfile
from bs4 import BeautifulSoup

# Configuração de logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s: %(message)s',
    handlers=[logging.FileHandler('downloader.log'), logging.StreamHandler()]
)

def download_rol_procedimentos(base_dir: Path = Path.cwd()) -> None:
    """Baixa os PDFs dos Anexos I e II do Rol de Procedimentos e compacta em ZIP."""
    url = "https://www.gov.br/ans/pt-br/acesso-a-informacao/participacao-da-sociedade/atualizacao-do-rol-de-procedimentos"
    download_dir = base_dir / "scraping" / "downloads"
    download_dir.mkdir(parents=True, exist_ok=True)

    try:
        # Faz o scraping da página
        logging.info(f"Acessando {url}")
        response = requests.get(url, timeout=60)
        response.raise_for_status()
        soup = BeautifulSoup(response.text, 'html.parser')

        # Procura links para PDFs (ajuste conforme a estrutura da página)
        pdf_urls = {}
        for link in soup.find_all('a', href=True):
            href = link['href']
            if 'anexo_i' in href.lower():
                pdf_urls["Anexo_I"] = href
            elif 'anexo_ii' in href.lower():
                pdf_urls["Anexo_II"] = href

        if not pdf_urls:
            logging.error("Nenhum PDF encontrado na página")
            return

        # Baixa os PDFs
        for name, url in pdf_urls.items():
            if not url.startswith('http'):
                url = f"https://www.gov.br{url}"  # Corrige URLs relativas
            pdf_path = download_dir / f"{name}.pdf"
            logging.info(f"Baixando {url}")
            response = requests.get(url, stream=True, timeout=60)
            response.raise_for_status()
            with open(pdf_path, 'wb') as f:
                for chunk in response.iter_content(chunk_size=8192):
                    f.write(chunk)
            logging.info(f"Baixado: {pdf_path}")

        # Compacta em ZIP
        zip_path = base_dir / "Anexos.zip"
        with zipfile.ZipFile(zip_path, 'w', zipfile.ZIP_DEFLATED) as zipf:
            for pdf in download_dir.glob("*.pdf"):
                zipf.write(pdf, pdf.name)
        logging.info(f"Compactado: {zip_path}")

    except requests.RequestException as e:
        logging.error(f"Erro de rede ao baixar PDFs: {e}")
        raise
    except Exception as e:
        logging.error(f"Erro inesperado ao processar PDFs: {e}")
        raise

def download_files(base_dir: Path = Path.cwd()) -> None:
    """Baixa demonstrações contábeis (2023-2024) e dados cadastrais das operadoras."""
    base_urls = {
        "demonstracoes": "https://dadosabertos.ans.gov.br/FTP/PDA/demonstracoes_contabeis/",
        "operadoras": "https://dadosabertos.ans.gov.br/FTP/PDA/operadoras_de_plano_de_saude_ativas/"
    }
    
    download_dir = base_dir / "database" / "raw_data"
    download_dir.mkdir(parents=True, exist_ok=True)
    
    try:
        # Demonstrações contábeis (2023 e 2024)
        logging.info("Baixando demonstrações contábeis dos últimos 2 anos...")
        for year in [2023, 2024]:
            for quarter in range(1, 5):
                file_name = f"{quarter}T{year}.zip"
                file_url = f"{base_urls['demonstracoes']}{year}/{file_name}"
                file_path = download_dir / file_name
                
                logging.info(f"Baixando {file_url}")
                response = requests.get(file_url, stream=True, timeout=60)
                if response.status_code == 200:
                    with open(file_path, 'wb') as f:
                        for chunk in response.iter_content(chunk_size=8192):
                            f.write(chunk)
                    logging.info(f"Arquivo {file_name} baixado com sucesso")
                    
                    with zipfile.ZipFile(file_path, 'r') as zip_ref:
                        csv_files = [f for f in zip_ref.namelist() if f.endswith('.csv')]
                        if not csv_files:
                            logging.error(f"Nenhum arquivo .csv encontrado em {file_name}")
                            continue
                        csv_name = csv_files[0]
                        zip_ref.extract(csv_name, download_dir)
                        logging.info(f"Arquivo {csv_name} extraído com sucesso")
                else:
                    logging.warning(f"Arquivo {file_url} não encontrado (status: {response.status_code})")
        
        # Dados cadastrais das operadoras
        logging.info("Baixando dados cadastrais das operadoras...")
        operadoras_file = "Relatorio_cadop.csv"
        operadoras_url = f"{base_urls['operadoras']}{operadoras_file}"
        operadoras_path = download_dir / operadoras_file
        
        logging.info(f"Baixando {operadoras_url}")
        response = requests.get(operadoras_url, stream=True, timeout=60)
        response.raise_for_status()
        with open(operadoras_path, 'wb') as f:
            for chunk in response.iter_content(chunk_size=8192):
                f.write(chunk)
        logging.info("Dados cadastrais baixados com sucesso")
        
        logging.info(f"Downloads concluídos! Arquivos salvos em {download_dir}")
    
    except requests.RequestException as e:
        logging.error(f"Erro de rede: {e}")
        raise
    except Exception as e:
        logging.error(f"Erro inesperado: {e}")
        raise

if __name__ == "__main__":
    base_dir = Path("/home/teste_intuitive-care")
    download_rol_procedimentos(base_dir)
    download_files(base_dir)