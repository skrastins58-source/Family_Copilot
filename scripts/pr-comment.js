/**
 * PR Comment Script for Family Copilot
 * Automātiski komentē PR, ja golden testi neiziet vai coverage ir zem sliekšņa
 */

const fs = require('fs');
const path = require('path');

module.exports = async ({github, context, core}) => {
    const { owner, repo } = context.repo;
    const prNumber = context.payload.pull_request?.number;
    
    if (!prNumber) {
        core.info('Not a pull request event, skipping PR comment');
        return;
    }

    let commentBody = '';
    const timestamp = new Date().toISOString();
    
    // Header for the comment
    commentBody += `## 🤖 Automatizēta Kļūdu Ziņošana\n\n`;
    commentBody += `**Laiks:** ${timestamp}\n\n`;
    
    // Check for golden test failures
    const goldenFailures = await checkGoldenTestFailures();
    if (goldenFailures.length > 0) {
        commentBody += `### 🖼️ Golden Testu Kļūdas\n\n`;
        commentBody += `Konstatētas vizuālās regresijas sekojošos testos:\n\n`;
        
        goldenFailures.forEach(failure => {
            commentBody += `- ❌ **${failure.test}**: ${failure.error}\n`;
        });
        
        commentBody += `\n**Risinājums:**\n`;
        commentBody += `1. Pārbaudiet, vai UI izmaiņas ir paredzētas\n`;
        commentBody += `2. Ja izmaiņas ir paredzētas, atjauniniet golden attēlus:\n`;
        commentBody += `   \`\`\`bash\n   ./generate_goldens.sh\n   git add goldens/\n   git commit -m "Update golden images"\n   \`\`\`\n\n`;
    }
    
    // Check for coverage failures
    const coverageFailures = await checkCoverageFailures();
    if (coverageFailures.failed) {
        commentBody += `### 📊 Coverage Problēmas\n\n`;
        commentBody += `Koda pārklājums ir zem noteiktā sliekšņa:\n\n`;
        commentBody += `| Metrika | Pašreizējais | Sliekšņa | Status |\n`;
        commentBody += `|---------|-------------|----------|--------|\n`;
        
        const metrics = ['lines', 'functions', 'branches', 'statements'];
        metrics.forEach(metric => {
            const current = coverageFailures[`${metric}_covered`];
            const threshold = coverageFailures[`${metric}_threshold`];
            const status = current >= threshold ? '✅' : '❌';
            commentBody += `| ${metric.charAt(0).toUpperCase() + metric.slice(1)} | ${current}% | ${threshold}% | ${status} |\n`;
        });
        
        commentBody += `\n**Risinājums:**\n`;
        commentBody += `1. Pievienojiet vairāk testu lai palielinātu pārklājumu\n`;
        commentBody += `2. Pārbaudiet, vai visi kritiskās funkcijas ir testētas\n`;
        commentBody += `3. Palaidiet: \`flutter test --coverage\` lai pārbaudītu lokāli\n\n`;
    }
    
    // Check for general test failures
    const testFailures = await checkTestFailures();
    if (testFailures.length > 0) {
        commentBody += `### 🧪 Testu Kļūdas\n\n`;
        commentBody += `Konstatētas sekojošas testu kļūdas:\n\n`;
        
        testFailures.forEach(failure => {
            commentBody += `- ❌ **${failure.test}**: ${failure.error}\n`;
        });
        
        commentBody += `\n**Risinājums:**\n`;
        commentBody += `1. Palaidiet testus lokāli: \`flutter test\`\n`;
        commentBody += `2. Izlabojiet kļūdas un pārbaūdiet testus vēlreiz\n\n`;
    }
    
    // Add footer with instructions
    if (commentBody.includes('❌')) {
        commentBody += `---\n\n`;
        commentBody += `### 📋 Nākamie Soļi\n\n`;
        commentBody += `1. **Lokālā pārbaude**: Palaidiet testus lokāli lai identificētu problēmas\n`;
        commentBody += `2. **Izlabojiet kļūdas**: Risiniet identificētās problēmas\n`;
        commentBody += `3. **Atkārtojiet**: Push izmaiņas lai aktivizētu CI vēlreiz\n\n`;
        commentBody += `💡 **Palīdzība**: Ja nepieciešama palīdzība, dodieties uz [dokumentāciju](./README.md) vai [GOLDEN_TESTS.md](./GOLDEN_TESTS.md)\n\n`;
        commentBody += `🔄 *Šis komentārs tiks automātiski atjaunināts, kad CI darbības tiks atkārtotas.*`;
        
        // Post the comment
        await github.rest.issues.createComment({
            owner,
            repo,
            issue_number: prNumber,
            body: commentBody
        });
        
        core.info('Posted PR comment with error details');
    } else {
        core.info('No errors found, skipping PR comment');
    }
};

async function checkGoldenTestFailures() {
    const failures = [];
    
    // Check if golden test failure directory exists
    const failureDir = 'test/failures';
    if (fs.existsSync(failureDir)) {
        const failureFiles = fs.readdirSync(failureDir);
        
        failureFiles.forEach(file => {
            if (file.endsWith('.png') || file.endsWith('_diff.png')) {
                failures.push({
                    test: file.replace('_diff.png', '').replace('.png', ''),
                    error: 'Golden test mismatch - UI izmaiņas konstatētas'
                });
            }
        });
    }
    
    // Also check for any golden test specific error patterns in logs
    // This is a fallback method when failure artifacts aren't available
    try {
        const logContent = fs.readFileSync('flutter_test.log', 'utf8');
        const goldenErrorPattern = /Golden.*?mismatch|expectLater.*?matchesGoldenFile.*?failed/gi;
        const matches = logContent.match(goldenErrorPattern);
        
        if (matches) {
            matches.forEach((match, index) => {
                failures.push({
                    test: `golden_test_${index + 1}`,
                    error: 'Golden test comparison failed'
                });
            });
        }
    } catch (e) {
        // Log file might not exist, that's OK
    }
    
    return failures;
}

async function checkCoverageFailures() {
    try {
        // Read coverage results from environment file
        const envFile = 'coverage_results.env';
        if (!fs.existsSync(envFile)) {
            return { failed: false };
        }
        
        const envContent = fs.readFileSync(envFile, 'utf8');
        const envVars = {};
        
        envContent.split('\n').forEach(line => {
            const [key, value] = line.split('=');
            if (key && value) {
                envVars[key.toLowerCase()] = parseFloat(value) || value;
            }
        });
        
        const failedChecks = envVars.coverage_failed_checks || 0;
        
        if (failedChecks > 0) {
            return {
                failed: true,
                lines_covered: envVars.lines_covered || 0,
                functions_covered: envVars.functions_covered || 0,
                branches_covered: envVars.branches_covered || 0,
                statements_covered: envVars.statements_covered || 0,
                lines_threshold: envVars.lines_threshold || 85,
                functions_threshold: envVars.functions_threshold || 90,
                branches_threshold: envVars.branches_threshold || 80,
                statements_threshold: envVars.statements_threshold || 85
            };
        }
    } catch (e) {
        console.log('Could not read coverage results:', e.message);
    }
    
    return { failed: false };
}

async function checkTestFailures() {
    const failures = [];
    
    try {
        // Check for test log files or error patterns
        const logFiles = ['flutter_test.log', 'test.log'];
        
        for (const logFile of logFiles) {
            if (fs.existsSync(logFile)) {
                const logContent = fs.readFileSync(logFile, 'utf8');
                
                // Look for common Flutter test failure patterns
                const errorPatterns = [
                    /FAILED.*?test.*?expected.*?but.*?was/gi,
                    /Test failed.*?Expected.*?Actual/gi,
                    /Exception.*?Test.*?failed/gi
                ];
                
                errorPatterns.forEach(pattern => {
                    const matches = logContent.match(pattern);
                    if (matches) {
                        matches.forEach((match, index) => {
                            failures.push({
                                test: `test_failure_${index + 1}`,
                                error: match.substring(0, 200) + '...' // Truncate long errors
                            });
                        });
                    }
                });
            }
        }
    } catch (e) {
        console.log('Could not read test logs:', e.message);
    }
    
    return failures;
}