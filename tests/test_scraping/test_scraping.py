# tests/test_scraping/test_scraper.py
import unittest
from src.scraping.scraper import download_anexos
import os

class TestScraping(unittest.TestCase):
    def test_download_anexos(self):
        download_anexos()
        self.assertTrue(os.path.exists('Anexos.zip'))
        self.assertTrue(os.path.exists('downloads/Anexo_I.pdf'))
        self.assertTrue(os.path.exists('downloads/Anexo_II.pdf'))