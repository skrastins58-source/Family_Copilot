#!/usr/bin/env node
// LV: Skripts PR komentāriem par testiem un coverage
// EN: Script for PR comments about tests and coverage

const { execSync } = require('child_process');
const fs = require('fs');

const github = require('@actions/github');
const core = require('@actions/core');

async function commentOnPR() {
  const token = process.env.GITHUB_TOKEN;
  const context = github.context;
  
  if (!token) {
    console.log('❌ GITHUB_TOKEN nav pieejams / GITHUB_TOKEN not available');
    return;
  }

  if (!context.payload.pull_request) {
    console.log('ℹ️  Nav PR konteksts / Not a PR context');
    return;
  }

  const octokit = github.getOctokit(token);
  const { owner, repo } = context.repo;
  const prNumber = context.payload.pull_request.number;

  // Collect issue information
  let issues = [];
  let hasIssues = false;

  // Check golden test failures
  const goldenFailed = process.env.GOLDEN_TESTS_FAILED === 'true';
  if (goldenFailed) {
    hasIssues = true;
    issues.push({
      type: 'golden',
      title: '🖼️ Golden testi neizgāja',
      description: 'UI komponenti vizuāli atšķiras no sagaidāmajiem rezultātiem.',
      details: [
        '• Pārbaudiet vai UI izmaiņas ir plānotas',
        '• Ja izmaiņas ir pareizas, atjauniniet golden attēlus: `flutter test --update-goldens`',
        '• Skatiet uploaded artifacts, lai apskatītu atšķirības'
      ]
    });
  }

  // Check coverage failures  
  const coverageFailed = process.env.COVERAGE_FAILED === 'true';
  if (coverageFailed) {
    hasIssues = true;
    
    // Try to read coverage details if available
    let coverageDetails = ['• Pārbaudiet vai visi jaunie komponenti ir testēti'];
    try {
      if (fs.existsSync('coverage_report.txt')) {
        const report = fs.readFileSync('coverage_report.txt', 'utf8');
        const lines = report.split('\\n');
        coverageDetails = lines.filter(line => line.includes('%')).map(line => `• ${line.trim()}`);
      }
    } catch (err) {
      console.log('⚠️  Nevar nolasīt coverage detaļas / Cannot read coverage details');
    }

    issues.push({
      type: 'coverage',
      title: '📊 Code coverage ir zem sliekšņa',
      description: 'Koda pārklājums neatbilst projekta standartiem.',
      details: coverageDetails
    });
  }

  // Check test failures
  const testsFailed = process.env.TESTS_FAILED === 'true';
  if (testsFailed) {
    hasIssues = true;
    issues.push({
      type: 'tests',
      title: '🧪 Unit testi neizgāja',
      description: 'Daži unit testi nav izturējuši validāciju.',
      details: [
        '• Pārbaudiet test output GitHub Actions logā',
        '• Izlabojiet neizgājušos testus',
        '• Pārliecinieties ka jaunie komponenti ir pilnībā testēti'
      ]
    });
  }

  if (!hasIssues) {
    console.log('✅ Nav problēmu, kas prasa komentāru / No issues requiring comment');
    return;
  }

  // Build comment content
  let comment = `## 🚨 Automatizēta kvalitātes pārbaude\\n\\n`;
  comment += `Šis PR satur kvalitātes problēmas, kas jānovērš pirms merge:\\n\\n`;

  issues.forEach((issue, index) => {
    comment += `### ${issue.title}\\n\\n`;
    comment += `${issue.description}\\n\\n`;
    comment += `**Ieteikumi:**\\n`;
    issue.details.forEach(detail => {
      comment += `${detail}\\n`;
    });
    comment += `\\n`;
  });

  comment += `---\\n`;
  comment += `*Šis komentārs tika ģenerēts automātiski ar Family Copilot CI/CD sistēmu* 🤖\\n`;
  comment += `*This comment was generated automatically by Family Copilot CI/CD system* 🤖`;

  try {
    await octokit.rest.issues.createComment({
      owner,
      repo,
      issue_number: prNumber,
      body: comment
    });
    
    console.log(`✅ PR komentārs pievienots successfully / PR comment added successfully`);
  } catch (error) {
    console.error('❌ Kļūda pievienojot komentāru / Error adding comment:', error.message);
  }
}

if (require.main === module) {
  commentOnPR().catch(error => {
    console.error('❌ Script failed:', error);
    process.exit(1);
  });
}

module.exports = { commentOnPR };