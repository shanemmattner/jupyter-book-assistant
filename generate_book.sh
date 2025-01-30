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

# Activate virtual environment
echo -e "${YELLOW}Activating virtual environment...${NC}"
source "$SCRIPT_DIR/venv/bin/activate"

# Generate Jupyter Book
echo -e "${YELLOW}Generating Jupyter Book...${NC}"
cd "$BOOK_DIR"
jupyter-book build .

# Create a new branch for the book updates
echo -e "${YELLOW}Creating a new branch for book updates...${NC}"
cd "$SCRIPT_DIR"
BRANCH_NAME="book-update-$(date +"%Y%m%d-%H%M%S")"
git checkout -b "$BRANCH_NAME"

# Add generated book files
echo -e "${YELLOW}Adding generated book files...${NC}"
git add "$BOOK_DIR/_build"

# Commit changes
echo -e "${YELLOW}Committing book updates...${NC}"
git commit -m "Update Jupyter Book: $(date)"

# Push the new branch
echo -e "${YELLOW}Pushing new branch...${NC}"
git push -u origin "$BRANCH_NAME"

# Return to the parent repository
cd "$REPO_ROOT"

# Update submodule reference
echo -e "${YELLOW}Updating submodule reference...${NC}"
git add "submodules/jupyter-book-assistant"
git commit -m "Update Jupyter Book Assistant submodule: New book generation"

echo -e "${GREEN}Jupyter Book generation complete!${NC}"
echo -e "${YELLOW}Branch created: $BRANCH_NAME${NC}"
