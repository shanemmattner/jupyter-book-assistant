#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Error handling
set -e

# Get the absolute path to the script's directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT="$( cd "$SCRIPT_DIR/../.." && pwd )"
BOOK_DIR="$REPO_ROOT/docs/book"

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Activate virtual environment
echo -e "${YELLOW}Activating virtual environment...${NC}"
if [ ! -d "$SCRIPT_DIR/venv" ]; then
    echo -e "${YELLOW}Creating virtual environment...${NC}"
    python3 -m venv "$SCRIPT_DIR/venv"
fi
source "$SCRIPT_DIR/venv/bin/activate"

# Ensure required packages are installed
echo -e "${YELLOW}Checking dependencies...${NC}"
if ! command_exists jupyter-book; then
    echo -e "${YELLOW}Installing jupyter-book...${NC}"
    pip install jupyter-book
fi

if ! command_exists ghp-import; then
    echo -e "${YELLOW}Installing ghp-import...${NC}"
    pip install ghp-import
fi

# Build the book
echo -e "${YELLOW}Building Jupyter Book...${NC}"
cd "$BOOK_DIR"
jupyter-book build .

# Create gh-pages branch if it doesn't exist
if ! git show-ref --verify --quiet refs/heads/gh-pages; then
    echo -e "${YELLOW}Creating gh-pages branch...${NC}"
    git checkout --orphan gh-pages
    git rm -rf .
    git commit --allow-empty -m "Initial gh-pages commit"
    git checkout main
fi

# Deploy to GitHub Pages
echo -e "${YELLOW}Deploying to GitHub Pages...${NC}"
cd "$BOOK_DIR"
ghp-import -n -p -f _build/html

echo -e "${GREEN}Book generation and deployment complete!${NC}"
echo -e "Your book should be available at: https://$(git config --get remote.origin.url | sed 's/.*github.com[\/:]//' | sed 's/\.git$//')"

# Return to original directory
cd "$SCRIPT_DIR"
