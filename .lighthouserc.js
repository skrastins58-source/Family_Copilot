module.exports = {
  ci: {
    collect: {
      // Flutter web build output directory
      staticDistDir: './build/web',
      // URLs to audit
      url: ['http://localhost:3000'],
      // Lighthouse settings
      numberOfRuns: 3,
      settings: {
        // Skip PWA audits for Flutter web app
        skipAudits: ['installable-manifest', 'splash-screen', 'themed-omnibox'],
        // Custom Chrome flags for Flutter
        chromeFlags: '--no-sandbox --headless --disable-gpu --disable-web-security'
      }
    },
    assert: {
      // Performance thresholds
      assertions: {
        'categories:performance': ['warn', { minScore: 0.7 }],
        'categories:accessibility': ['error', { minScore: 0.9 }],
        'categories:best-practices': ['warn', { minScore: 0.85 }],
        'categories:seo': ['warn', { minScore: 0.8 }]
      }
    },
    upload: {
      // Store results as artifacts
      target: 'temporary-public-storage'
    },
    server: {
      // Development server configuration
      command: 'flutter build web && cd build/web && python3 -m http.server 3000',
      port: 3000,
      waitForPort: 30000,
      waitForHost: 'localhost'
    }
  }
};