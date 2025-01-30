# Jupyter Book Assistant

## Overview
An automated tool for generating and maintaining Jupyter Books for Git repositories.

## Installation
1. Add as submodule:
   ```bash
   git submodule add [repo-url] docs/book-generator
   ```

2. Initialize:
   ```bash
   cd docs/book-generator
   ./init.sh
   ```

3. Generate book:
   ```bash
   ./generate_book.sh
   ```

## Configuration
Edit `config/config.yaml` to customize the book generation process.

## Features
- Automated book generation
- Git hook integration
- Template-based content
- Customizable configuration

## License
MIT License