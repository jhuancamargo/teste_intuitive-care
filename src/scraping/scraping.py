# src/scraping/scraper.py
import requests
from bs4 import BeautifulSoup
import os
import zipfile
from pathlib import Path
import logging

# Configuração de logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s: %(message)s',
    handlers=[logging.FileHandler('scraper.log'), logging.StreamHandler()]
)

def download_anexos(base_dir: Path = Path.cwd()) -> bool:
    """Baixa os Anexos I e II do site da ANS e os compacta em um ZIP."""
    url = "https://www.gov.br/ans/pt-br/acesso-a-informacao/participacao-da-sociedade/atualizacao-do-rol-de-procedimentos"
    base_url = "https://www.gov.br"
    
    try:
        # Requisição inicial
        logging.info(f"Acessando {url}")
        response = requests.get(url, timeout=10)
        response.raise_for_status()
        soup = BeautifulSoup(response.text, 'html.parser')
        
        # Mapeamento dos anexos
        target_anexos = {
            'Anexo I': 'Anexo_I.pdf',
            'Anexo II': 'Anexo_II.pdf'
        }
        
        # Encontrar links
        anexos_baixados = {}
        for link in soup.find_all('a', href=True):
            for texto, filename in target_anexos.items():
                if texto in link.text and filename not in anexos_baixados:
                    href = link['href']
                    # Converte links relativos em absolutos
                    full_url = href if href.startswith('http') else base_url + href
                    anexos_baixados[filename] = full_url
                    break
        
        if not anexos_baixados:
            logging.error("Nenhum anexo encontrado na página")
            return False
        
        # Diretório de download
        download_dir = base_dir / "downloads"
        download_dir.mkdir(exist_ok=True)
        
        # Download dos arquivos
        for filename, url in anexos_baixados.items():
            logging.info(f"Baixando {filename} de {url}")
            response = requests.get(url, stream=True, timeout=60)
            response.raise_for_status()
            
            file_path = download_dir / filename
            with open(file_path, 'wb') as f:
                for chunk in response.iter_content(chunk_size=8192):
                    if chunk:  # Evita escrever blocos vazios
                        f.write(chunk)
            
            # Verifica se o arquivo foi baixado
            if not file_path.exists() or file_path.stat().st_size == 0:
                logging.error(f"Falha ao baixar {filename}")
                return False
        
        # Compactação
        zip_path = base_dir / "Anexos_Jhuan_Camargo.zip"
        logging.info(f"Compactando arquivos em {zip_path}")
        with zipfile.ZipFile(zip_path, 'w', compression=zipfile.ZIP_DEFLATED) as zipf:
            for filename in anexos_baixados.keys():
                zipf.write(download_dir / filename, filename)
        
        logging.info("Processo concluído com sucesso!")
        logging.info(f"Arquivos salvos em: {download_dir}")
        logging.info(f"ZIP gerado em: {zip_path}")
        return True
        
    except requests.RequestException as e:
        logging.error(f"Erro de rede: {e}")
        return False
    except Exception as e:
        logging.error(f"Erro inesperado: {e}")
        return False

if __name__ == "__main__":
    download_anexos()