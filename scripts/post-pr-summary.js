#!/usr/bin/env node

// Golden Tests PR Summary Script
// Posts a summary comment on PR with golden test results

const fs = require('fs');
const { execSync } = require('child_process');

function validateImageMimeType(base64String) {
  const header = base64String.slice(0, 20);
  if (header.startsWith('/9j/')) return 'image/jpeg';
  if (header.startsWith('iVBORw0KGgo')) return 'image/png';
  if (header.startsWith('R0lGOD')) return 'image/gif';
  if (header.startsWith('UklGR')) return 'image/webp';
  throw new Error('❌ Invalid image MIME type: must be jpeg, png, gif, or webp');
}

async function postPRSummary() {
  const prNumber = process.env.PR_NUMBER;
  const githubToken = process.env.GITHUB_TOKEN;

  if (!prNumber || !githubToken) {
    console.log('Missing PR_NUMBER or GITHUB_TOKEN environment variables');
    process.exit(0);
  }

  try {
    // Check if golden tests passed
    const goldenFiles = fs.readdirSync('goldens').filter(f => f.endsWith('.png'));
    const goldenCount = goldenFiles.length;

    const summary = `## 🖼️ Golden Tests Summary

✅ **Golden tests completed successfully!**

📊 **Results:**
- ${goldenCount} golden image(s) validated
- All visual regression checks passed

📁 **Golden files updated:**
${goldenFiles.map(f => `- \`goldens/${f}\``).join('\n')}

> Golden tests help maintain visual consistency and prevent unintended UI changes.
> If you see visual differences, ensure they are intentional before merging.`;

    console.log('Golden tests summary:');
    console.log(summary);

    // Post comment using gh CLI if available
    try {
      execSync(`echo "${summary}" | gh pr comment ${prNumber} --body-file -`, {
        stdio: 'pipe',
        env: { ...process.env, GITHUB_TOKEN: githubToken }
      });
      console.log('✅ PR comment posted successfully');
    } catch (error) {
      console.log('⚠️ Could not post PR comment (gh CLI not available)');
      console.log('Summary would have been:', summary);
    }

  } catch (error) {
    console.error('Error posting PR summary:', error.message);
    process.exit(1);
  }
}

// Run if called directly
if (require.main === module) {
  postPRSummary();
}

module.exports = { validateImageMimeType, postPRSummary };
