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

echo -e "${YELLOW}Setting up Jupyter Book Assistant submodule...${NC}"

# Initialize and update submodule if needed
if [ ! -f "$SCRIPT_DIR/.git" ]; then
    echo -e "${YELLOW}Initializing submodule...${NC}"
    cd "$REPO_ROOT"
    git submodule update --init --recursive
fi

# Create GitHub Actions workflow directory in parent repository
PARENT_WORKFLOW_DIR="$REPO_ROOT/.github/workflows"
mkdir -p "$PARENT_WORKFLOW_DIR"

# Run initialization script
echo -e "${YELLOW}Running initialization script...${NC}"
"$SCRIPT_DIR/init.sh"

# Configure git for the submodule
echo -e "${YELLOW}Configuring git submodule...${NC}"
cd "$SCRIPT_DIR"
git config core.filemode true
git config core.ignorecase true

# Add remote if not exists
if ! git remote | grep -q "^origin$"; then
    git remote add origin git@github.com:shanemmattner/jupyter-book-assistant.git
fi

# Set up branch tracking
git branch --set-upstream-to=origin/main main

# Build the book for the first time
echo -e "${YELLOW}Building Jupyter Book...${NC}"
cd "$REPO_ROOT/docs/book"

# Activate virtual environment and build book
source "$SCRIPT_DIR/venv/bin/activate"
if ! command -v jupyter-book &> /dev/null; then
    echo -e "${YELLOW}Installing jupyter-book...${NC}"
    pip install jupyter-book
fi
jupyter-book build .

echo -e "${GREEN}Submodule setup complete!${NC}"
echo -e "Your Jupyter Book is ready to use. To make updates:"
echo -e "1. Edit content in docs/book/"
echo -e "2. Run: cd submodules/jupyter-book-assistant && source venv/bin/activate && ./generate_book.sh"
echo -e "\nYour book will be available at: https://$(git config --get remote.origin.url | sed 's/.*github.com[\/:]//' | sed 's/\.git$//')"