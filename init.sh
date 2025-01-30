#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}Initializing Jupyter Book Assistant...${NC}"

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo -e "${YELLOW}Creating virtual environment...${NC}"
    python -m venv venv
fi

# Activate virtual environment
source venv/bin/activate

# Install requirements
echo -e "${YELLOW}Installing requirements...${NC}"
pip install -r requirements.txt

# Create necessary directories
mkdir -p config/templates
mkdir -p src
mkdir -p hooks
mkdir -p tests

# Copy default configuration if it doesn't exist
if [ ! -f "config/config.yaml" ]; then
    echo -e "${YELLOW}Creating default configuration...${NC}"
    cp config/default_config.yaml config/config.yaml
fi

# Set up git hooks
echo -e "${YELLOW}Setting up git hooks...${NC}"
cp hooks/pre-commit ../.git/hooks/
cp hooks/post-receive ../.git/hooks/
chmod +x ../.git/hooks/pre-commit
chmod +x ../.git/hooks/post-receive

# Create initial book structure
echo -e "${YELLOW}Creating initial book structure...${NC}"
jupyter-book create ../docs

# Update configuration with repository information
REPO_URL=$(git config --get remote.origin.url)
REPO_BRANCH=$(git rev-parse --abbrev-ref HEAD)
sed -i "s|repository:\n    url: \"\"|repository:\n    url: \"$REPO_URL\"|" config/config.yaml
sed -i "s|branch: \"main\"|branch: \"$REPO_BRANCH\"|" config/config.yaml

echo -e "${GREEN}Initialization complete!${NC}"
echo -e "Run './generate_book.sh' to generate your first book."