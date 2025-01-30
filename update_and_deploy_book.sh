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

# Function to log messages
log() {
    echo -e "${YELLOW}$1${NC}"
}

# Function to handle errors
error_exit() {
    echo -e "${RED}$1${NC}"
    exit 1
}

# Main deployment function
deploy_jupyter_book() {
    # Step 1: Initialize the environment
    log "Initializing Jupyter Book environment..."
    "$SCRIPT_DIR/init.sh" || error_exit "Initialization failed"

    # Step 2: Activate virtual environment
    log "Activating virtual environment..."
    source "$SCRIPT_DIR/venv/bin/activate" || error_exit "Failed to activate virtual environment"

    # Step 3: Generate Jupyter Book
    log "Generating Jupyter Book..."
    cd "$BOOK_DIR"
    jupyter-book build . || error_exit "Book generation failed"

    # Step 4: Create a new branch for book updates
    log "Creating a new branch for book updates..."
    cd "$SCRIPT_DIR"
    BRANCH_NAME="book-update-$(date +"%Y%m%d-%H%M%S")"
    git checkout -b "$BRANCH_NAME" || error_exit "Failed to create new branch"

    # Step 5: Add and commit generated book files
    log "Committing book updates..."
    git add "$BOOK_DIR/_build"
    git commit -m "Update Jupyter Book: $(date)" || log "No changes to commit"

    # Step 6: Push the new branch
    log "Pushing new branch..."
    git push -u origin "$BRANCH_NAME" || error_exit "Failed to push branch"

    # Step 7: Return to parent repository and update submodule reference
    cd "$REPO_ROOT"
    log "Updating submodule reference..."
    git add "submodules/jupyter-book-assistant"
    git commit -m "Update Jupyter Book Assistant submodule: New book generation" || log "No submodule changes to commit"

    # Step 8: Optional: Create a pull request (requires GitHub CLI)
    if command -v gh &> /dev/null; then
        log "Creating pull request..."
        gh pr create \
            --base main \
            --head "$BRANCH_NAME" \
            --title "Update Jupyter Book" \
            --body "Automated Jupyter Book generation and deployment" || log "Failed to create pull request"
    else
        log "GitHub CLI not found. Skipping pull request creation."
    fi

    echo -e "${GREEN}Jupyter Book deployment complete!${NC}"
    echo -e "${YELLOW}Branch created: $BRANCH_NAME${NC}"
}

# Run the deployment
deploy_jupyter_book