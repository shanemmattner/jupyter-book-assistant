#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Error handling
set -e

echo -e "${GREEN}Initializing Jupyter Book Assistant...${NC}"

# Check for python3
if ! command_exists python3; then
    echo -e "${RED}Error: python3 not found. Please install Python 3.${NC}"
    exit 1
fi

# Get the absolute path to the script's directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT="$( cd "$SCRIPT_DIR/../.." && pwd )"
BOOK_DIR="$REPO_ROOT/docs/book"

# Create necessary directories
echo -e "${YELLOW}Creating necessary directories...${NC}"
mkdir -p "$SCRIPT_DIR/config/templates"
mkdir -p "$SCRIPT_DIR/src"
mkdir -p "$SCRIPT_DIR/hooks"
mkdir -p "$SCRIPT_DIR/tests"

# Create virtual environment if it doesn't exist
if [ ! -d "$SCRIPT_DIR/venv" ]; then
    echo -e "${YELLOW}Creating virtual environment...${NC}"
    python3 -m venv "$SCRIPT_DIR/venv"
fi

# Activate virtual environment
source "$SCRIPT_DIR/venv/bin/activate"

# Install requirements
echo -e "${YELLOW}Installing requirements...${NC}"
if [ -f "$SCRIPT_DIR/requirements.txt" ]; then
    pip install -r "$SCRIPT_DIR/requirements.txt"
else
    echo -e "${RED}Error: requirements.txt not found${NC}"
    exit 1
fi

# Copy default configuration if it doesn't exist
if [ -f "$SCRIPT_DIR/config/default_config.yaml" ]; then
    echo -e "${YELLOW}Creating default configuration...${NC}"
    cp "$SCRIPT_DIR/config/default_config.yaml" "$SCRIPT_DIR/config/config.yaml"
else
    echo -e "${RED}Error: default_config.yaml not found${NC}"
    exit 1
fi

# Set up git hooks
echo -e "${YELLOW}Setting up git hooks...${NC}"
GIT_DIR="$REPO_ROOT/.git"
if [ -d "$GIT_DIR" ]; then
    mkdir -p "$GIT_DIR/hooks"
    if [ -f "$SCRIPT_DIR/hooks/pre-commit" ]; then
        cp "$SCRIPT_DIR/hooks/pre-commit" "$GIT_DIR/hooks/"
        chmod +x "$GIT_DIR/hooks/pre-commit"
    fi
    if [ -f "$SCRIPT_DIR/hooks/post-receive" ]; then
        cp "$SCRIPT_DIR/hooks/post-receive" "$GIT_DIR/hooks/"
        chmod +x "$GIT_DIR/hooks/post-receive"
    fi
else
    echo -e "${YELLOW}Warning: .git directory not found. Skipping git hooks setup.${NC}"
fi

# Create initial book structure
echo -e "${YELLOW}Creating initial book structure...${NC}"
if [ -d "$BOOK_DIR" ]; then
    echo -e "${YELLOW}Book directory already exists. Skipping initial book creation.${NC}"
else
    if command_exists jupyter-book; then
        jupyter-book create "$BOOK_DIR"
    else
        echo -e "${YELLOW}Warning: jupyter-book command not found. Will be installed via requirements.${NC}"
    fi
fi

# Update configuration with repository information
if [ -f "$SCRIPT_DIR/config/config.yaml" ]; then
    REPO_URL=$(git -C "$REPO_ROOT" config --get remote.origin.url || echo "")
    REPO_BRANCH=$(git -C "$REPO_ROOT" rev-parse --abbrev-ref HEAD || echo "main")
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' "s|repository:\n    url: \"\"|repository:\n    url: \"$REPO_URL\"|" "$SCRIPT_DIR/config/config.yaml"
        sed -i '' "s|branch: \"main\"|branch: \"$REPO_BRANCH\"|" "$SCRIPT_DIR/config/config.yaml"
    else
        # Linux
        sed -i "s|repository:\n    url: \"\"|repository:\n    url: \"$REPO_URL\"|" "$SCRIPT_DIR/config/config.yaml"
        sed -i "s|branch: \"main\"|branch: \"$REPO_BRANCH\"|" "$SCRIPT_DIR/config/config.yaml"
    fi
fi

echo -e "${GREEN}Initialization complete!${NC}"
echo -e "Run './generate_book.sh' to generate your first book."