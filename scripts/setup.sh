#!/bin/bash

echo "Setting up AI-infused testing environment..."

# Install Node.js dependencies
npm install

# Create test directories
mkdir -p test/ai_generated
mkdir -p test/reports

# Copy environment file
if [ ! -f .env ]; then
    cp .env.example .env
    echo "Please update .env with your Gemini API key"
fi

echo "Setup complete! Don't forget to:"
echo "1. Add your Gemini API key to .env"
echo "2. Add GEMINI_API_KEY to GitHub repository secrets"
echo "3. Run 'npm run generate-tests' to generate AI test cases"
