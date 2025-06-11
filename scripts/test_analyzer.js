const axios = require('axios');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

class TestQualityAnalyzer {
  constructor() {
    this.apiKey = process.env.GEMINI_API_KEY;
    this.baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';
  }

  async analyzeTestCoverage() {
    const testDir = path.join(__dirname, '../test');
    const testFiles = this.findTestFiles(testDir);
    
    for (const testFile of testFiles) {
      const testCode = fs.readFileSync(testFile, 'utf8');
      await this.analyzeTestQuality(testFile, testCode);
    }
  }

  async analyzeTestQuality(filePath, testCode) {
    const prompt = `
      Analyze this Flutter test file for quality and completeness:
      
      ${testCode}
      
      Evaluate:
      1. Test coverage completeness
      2. Edge case handling
      3. Test structure and organization
      4. Performance considerations
      5. Best practices adherence
      
      Provide a score (1-10) and specific recommendations for improvement.
    `;

    try {
      const response = await axios.post(`${this.baseUrl}?key=${this.apiKey}`, {
        contents: [{
          parts: [{ text: prompt }]
        }]
      });

      const analysis = response.data.candidates[0].content.parts[0].text;
      console.log(`\n=== Analysis for ${path.basename(filePath)} ===`);
      console.log(analysis);
      
      // Save analysis report
      const reportPath = filePath.replace('.dart', '_analysis.md');
      fs.writeFileSync(reportPath, analysis);
      
    } catch (error) {
      console.error('Error analyzing test:', error.message);
    }
  }

  findTestFiles(dir) {
    let testFiles = [];
    const files = fs.readdirSync(dir);
    
    for (const file of files) {
      const fullPath = path.join(dir, file);
      const stat = fs.statSync(fullPath);
      
      if (stat.isDirectory()) {
        testFiles = testFiles.concat(this.findTestFiles(fullPath));
      } else if (file.endsWith('_test.dart')) {
        testFiles.push(fullPath);
      }
    }
    
    return testFiles;
  }
}

// Run the analyzer
async function main() {
  const analyzer = new TestQualityAnalyzer();
  await analyzer.analyzeTestCoverage();
  console.log('Test quality analysis completed!');
}

if (require.main === module) {
  main().catch(console.error);
}
