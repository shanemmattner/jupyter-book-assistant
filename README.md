# Jupyter Book Assistant

A tool to help create and manage Jupyter Books with automated GitHub Pages deployment. This repository is designed to be used as a submodule in other repositories to easily set up and maintain Jupyter Books.

## Features

- Automated book initialization and setup
- GitHub Actions workflow for continuous deployment
- GitHub Pages integration
- Virtual environment management
- Automated dependency installation

## Using as a Submodule

1. Add this repository as a submodule to your project:
   ```bash
   git submodule add https://github.com/shanemmattner/jupyter-book-assistant.git submodules/jupyter-book-assistant
   ```

2. Initialize and set up the book:
   ```bash
   cd submodules/jupyter-book-assistant
   python3 -m venv venv
   source venv/bin/activate
   pip install ghp-import
   ./setup_submodule.sh
   ```

## Directory Structure

After setup, your repository will have this structure:
```
your-project/
├── docs/
│   └── book/          # Your Jupyter Book content
│       ├── _config.yml        # Book configuration
│       ├── _toc.yml          # Table of contents
│       ├── intro.md          # Landing page
│       ├── markdown.md       # Example markdown file
│       └── notebooks.ipynb   # Example notebook
├── .github/
│   └── workflows/     # GitHub Actions workflows
└── submodules/
    └── jupyter-book-assistant/
```

## Scripts

### setup_submodule.sh
- Initializes the Jupyter Book environment
- Sets up virtual environment
- Installs required dependencies
- Creates initial book structure
- Configures git hooks and GitHub Actions

### generate_book.sh
- Builds the Jupyter Book
- Deploys to GitHub Pages
- Creates/updates gh-pages branch

### init.sh
- Sets up Python virtual environment
- Installs dependencies
- Creates necessary directories
- Configures git hooks

## Configuration

### Book Configuration (_config.yml)
```yaml
title: Your Book Title
author: Your Name
logo: logo.png
execute:
  execute_notebooks: force

repository:
  url: https://github.com/username/repository
  path_to_book: docs/book
  branch: main

html:
  use_issues_button: true
  use_repository_button: true
```

### Table of Contents (_toc.yml)
```yaml
format: jb-book
root: intro
chapters:
- file: markdown
- file: notebooks
```

## GitHub Actions Workflow

The workflow automatically:
1. Builds the book when changes are pushed to docs/book/
2. Deploys to GitHub Pages
3. Handles branch management

## Making Updates

1. Edit content in `docs/book/`:
   - Add/edit markdown files (`.md`)
   - Add/edit Jupyter notebooks (`.ipynb`)
   - Update `_toc.yml` for table of contents
   - Customize `_config.yml` for book settings

2. Build and deploy:
   ```bash
   cd submodules/jupyter-book-assistant
   source venv/bin/activate
   ./generate_book.sh
   ```

## Dependencies

Required Python packages (automatically installed):
- jupyter-book
- ghp-import (for GitHub Pages deployment)
- PyYAML (for configuration)
- GitPython (for git operations)
- Additional packages for Jupyter notebooks and extensions

## Troubleshooting

1. **Missing ghp-import?**
   ```bash
   source venv/bin/activate
   pip install ghp-import
   ```

2. **Build errors?**
   - Check build logs in terminal
   - Verify file references in `_toc.yml`
   - Ensure notebooks can execute

3. **Deployment issues?**
   - Verify GitHub Pages is enabled in repository settings
   - Check GitHub Actions logs
   - Ensure gh-pages branch exists

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

[MIT License](LICENSE)

## Credits

This tool is built on top of:
- [Jupyter Book](https://jupyterbook.org/)
- [GitHub Pages](https://pages.github.com/)
- [ghp-import](https://github.com/c-w/ghp-import)