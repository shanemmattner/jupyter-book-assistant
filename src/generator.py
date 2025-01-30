import os
import yaml
from pathlib import Path
from typing import Dict, List, Optional
import logging
from git import Repo
from jupyter_book.commands import build_book

class JupyterBookGenerator:
    def __init__(self, config_path: str = "config/config.yaml"):
        """Initialize the Jupyter Book generator.
        
        Args:
            config_path: Path to the configuration file
        """
        self.config_path = config_path
        self.config = self._load_config()
        self.logger = self._setup_logger()
        
    def _load_config(self) -> Dict:
        """Load configuration from YAML file."""
        with open(self.config_path, 'r') as f:
            return yaml.safe_load(f)
    
    def _setup_logger(self) -> logging.Logger:
        """Set up logging configuration."""
        logging.basicConfig(
            level=logging.INFO,
            format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
        )
        return logging.getLogger('jupyter_book_generator')
    
    def _create_toc(self, chapters: List[Dict]) -> Dict:
        """Create table of contents structure."""
        toc = {
            "format": "jb-book",
            "root": "index",
            "chapters": chapters
        }
        return toc
    
    def _analyze_repository(self) -> List[str]:
        """Analyze repository for documentation-worthy files."""
        repo = Repo(self.config['book']['repository']['path'])
        files = []
        
        # Get all tracked files
        for item in repo.tree().traverse():
            if item.type == 'blob':
                file_path = item.path
                # Skip excluded paths
                if not any(file_path.startswith(excluded) for excluded in self.config['generation']['excluded_paths']):
                    files.append(file_path)
        
        return files
    
    def generate_book(self, output_path: Optional[str] = None) -> None:
        """Generate the Jupyter Book.
        
        Args:
            output_path: Optional path where the book should be generated
        """
        self.logger.info("Starting book generation...")
        
        # Use default output path if none provided
        if output_path is None:
            output_path = os.path.join('..', 'docs')
        
        # Ensure output directory exists
        os.makedirs(output_path, exist_ok=True)
        
        # Create _toc.yml
        toc = self._create_toc(self.config['structure']['chapters'])
        toc_path = os.path.join(output_path, '_toc.yml')
        with open(toc_path, 'w') as f:
            yaml.dump(toc, f)
        
        # Create _config.yml
        config = {
            "title": self.config['book']['title'],
            "author": self.config['book']['author'],
            "logo": self.config['book']['logo'],
            "repository": self.config['book']['repository'],
            "sphinx": self.config['sphinx']['config']
        }
        config_path = os.path.join(output_path, '_config.yml')
        with open(config_path, 'w') as f:
            yaml.dump(config, f)
        
        # Build the book
        try:
            build_book(output_path)
            self.logger.info(f"Book successfully generated at {output_path}")
        except Exception as e:
            self.logger.error(f"Error building book: {str(e)}")
            raise

if __name__ == "__main__":
    generator = JupyterBookGenerator()
    generator.generate_book()