const axios = require('axios');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

class AITestGenerator {
  constructor() {
    this.apiKey = process.env.GEMINI_API_KEY;
    this.baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';
  }

  async analyzeCode(filePath) {
    const code = fs.readFileSync(filePath, 'utf8');
    const prompt = `
      Analyze this Dart/Flutter code and generate comprehensive test cases:
      
      ${code}
      
      Generate test cases that cover:
      1. Unit tests for all public methods
      2. Edge cases and error handling
      3. Widget tests for UI components
      4. Integration test scenarios
      5. Performance test considerations
      
      Return only valid Dart test code using flutter_test package.
    `;

    try {
      const response = await axios.post(`${this.baseUrl}?key=${this.apiKey}`, {
        contents: [{
          parts: [{ text: prompt }]
        }]
      });

      return response.data.candidates[0].content.parts[0].text;
    } catch (error) {
      console.error('Error generating tests:', error.message);
      return null;
    }
  }

  async generateTestsForProject() {
    const libDir = path.join(__dirname, '../lib');
    const testDir = path.join(__dirname, '../test/ai_generated');
    
    if (!fs.existsSync(testDir)) {
      fs.mkdirSync(testDir, { recursive: true });
    }

    const dartFiles = this.findDartFiles(libDir);
    
    for (const file of dartFiles) {
      console.log(`Generating tests for: ${file}`);
      const testCode = await this.analyzeCode(file);
      
      if (testCode) {
        const relativePath = path.relative(libDir, file);
        const testFileName = relativePath.replace('.dart', '_test.dart');
        const testFilePath = path.join(testDir, testFileName);
        
        const testFileDir = path.dirname(testFilePath);
        if (!fs.existsSync(testFileDir)) {
          fs.mkdirSync(testFileDir, { recursive: true });
        }
        
        const cleanTestCode = this.cleanGeneratedCode(testCode);
        fs.writeFileSync(testFilePath, cleanTestCode);
        console.log(`Generated: ${testFilePath}`);
      }
      
      // Rate limiting
      await new Promise(resolve => setTimeout(resolve, 1000));
    }
  }

  findDartFiles(dir) {
    let dartFiles = [];
    const files = fs.readdirSync(dir);
    
    for (const file of files) {
      const fullPath = path.join(dir, file);
      const stat = fs.statSync(fullPath);
      
      if (stat.isDirectory()) {
        dartFiles = dartFiles.concat(this.findDartFiles(fullPath));
      } else if (file.endsWith('.dart')) {
        dartFiles.push(fullPath);
      }
    }
    
    return dartFiles;
  }

  cleanGeneratedCode(code) {
    // Remove markdown formatting and ensure proper imports
    let cleaned = code.replace(/```dart/g, '').replace(/```/g, '');
    
    if (!cleaned.includes("import 'package:flutter_test/flutter_test.dart';")) {
      cleaned = "import 'package:flutter_test/flutter_test.dart';\n" + cleaned;
    }
    
    return cleaned;
  }
}

// Run the generator
async function main() {
  const generator = new AITestGenerator();
  await generator.generateTestsForProject();
  console.log('AI test generation completed!');
}

main().catch(console.error);
