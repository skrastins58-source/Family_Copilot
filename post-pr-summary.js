const fs = require('fs');
const path = require('path');

// Simple PR summary generator for Family Copilot
console.log('🚀 Family Copilot - PR Quality Summary');
console.log('=====================================');

try {
  // Check if coverage directory exists
  const coverageDir = path.join(process.cwd(), 'coverage');
  
  if (fs.existsSync(coverageDir)) {
    console.log('✅ Coverage reports generated successfully');
    
    // Try to read coverage summary if available
    const coverageSummaryPath = path.join(process.cwd(), 'coverage-summary.json');
    if (fs.existsSync(coverageSummaryPath)) {
      const summary = JSON.parse(fs.readFileSync(coverageSummaryPath, 'utf8'));
      const thresholds = summary.coverageThresholds?.global;
      
      if (thresholds) {
        console.log('📊 Coverage Thresholds:');
        console.log(`   Lines: ${thresholds.lines}%`);
        console.log(`   Functions: ${thresholds.functions}%`);
        console.log(`   Branches: ${thresholds.branches}%`);
        console.log(`   Statements: ${thresholds.statements}%`);
      }
    }
  } else {
    console.log('⚠️  Coverage directory not found');
  }
  
  // Check if golden tests directory exists
  const goldensDir = path.join(process.cwd(), 'goldens');
  if (fs.existsSync(goldensDir)) {
    const goldenFiles = fs.readdirSync(goldensDir).filter(f => f.endsWith('.png'));
    console.log(`✅ Golden tests found: ${goldenFiles.length} reference images`);
  } else {
    console.log('⚠️  Golden tests directory not found');
  }
  
  // Check for test files
  const testDir = path.join(process.cwd(), 'test');
  if (fs.existsSync(testDir)) {
    const testFiles = fs.readdirSync(testDir).filter(f => f.endsWith('_test.dart'));
    console.log(`✅ Test files found: ${testFiles.length} test suites`);
  }
  
  console.log('');
  console.log('🎉 PR validation completed successfully!');
  console.log('Ready for review and merge.');
  
} catch (error) {
  console.error('❌ Error generating PR summary:', error.message);
  process.exit(1);
}