#!/usr/bin/env dart
// Golden Test Structure Validation Script
// Validates that goldens/ and tests/diff/ directories are properly structured
// and that each golden test has corresponding files

import 'dart:io';
import 'dart:async';

class GoldenTestValidator {
  static const String goldensDir = 'goldens';
  static const String diffDir = 'tests/diff';
  static const String testDir = 'test';
  
  List<String> errors = [];
  List<String> warnings = [];
  List<String> info = [];
  
  /// Main validation function
  Future<bool> validate() async {
    print('🔍 Validating Golden Test Structure...');
    print('=' * 50);
    
    // Check directory structure
    _validateDirectoryStructure();
    
    // Extract golden file references from test files
    final goldenReferences = await _extractGoldenReferences();
    
    // Validate golden files exist
    _validateGoldenFiles(goldenReferences);
    
    // Validate diff files exist for each golden test
    _validateDiffFiles(goldenReferences);
    
    // Validate no orphaned files
    _validateOrphanedFiles(goldenReferences);
    
    // Print results
    _printResults();
    
    return errors.isEmpty;
  }
  
  /// Check that required directories exist
  void _validateDirectoryStructure() {
    final directories = [goldensDir, diffDir, testDir];
    
    for (final dir in directories) {
      final directory = Directory(dir);
      if (!directory.existsSync()) {
        errors.add('Required directory missing: $dir');
      } else {
        info.add('✓ Directory exists: $dir');
      }
    }
  }
  
  /// Extract golden file references from test files
  Future<List<String>> _extractGoldenReferences() async {
    final goldenReferences = <String>[];
    final testFiles = await _getTestFiles();
    
    for (final testFile in testFiles) {
      try {
        final content = await File(testFile).readAsString();
        final matches = RegExp(r"matchesGoldenFile\(['\"](.*?)['\"]\)")
            .allMatches(content);
        
        for (final match in matches) {
          final goldenPath = match.group(1);
          if (goldenPath != null) {
            goldenReferences.add(goldenPath);
            info.add('Found golden reference: $goldenPath in $testFile');
          }
        }
      } catch (e) {
        warnings.add('Could not read test file: $testFile - $e');
      }
    }
    
    if (goldenReferences.isEmpty) {
      warnings.add('No golden test references found in test files');
    }
    
    return goldenReferences;
  }
  
  /// Get all test files
  Future<List<String>> _getTestFiles() async {
    final testFiles = <String>[];
    final testDirectory = Directory(testDir);
    
    if (testDirectory.existsSync()) {
      await for (final entity in testDirectory.list(recursive: true)) {
        if (entity is File && entity.path.endsWith('.dart')) {
          testFiles.add(entity.path);
        }
      }
    }
    
    return testFiles;
  }
  
  /// Validate that all referenced golden files exist
  void _validateGoldenFiles(List<String> goldenReferences) {
    for (final goldenRef in goldenReferences) {
      final goldenFile = File(goldenRef);
      if (!goldenFile.existsSync()) {
        errors.add('Golden file does not exist: $goldenRef');
      } else {
        final stat = goldenFile.statSync();
        if (stat.size == 0) {
          warnings.add('Golden file is empty: $goldenRef');
        } else {
          info.add('✓ Golden file exists: $goldenRef (${stat.size} bytes)');
        }
      }
    }
  }
  
  /// Validate that diff files exist for each golden test
  void _validateDiffFiles(List<String> goldenReferences) {
    for (final goldenRef in goldenReferences) {
      // Convert goldens/filename.png to tests/diff/filename.png
      final fileName = goldenRef.split('/').last;
      final diffPath = '$diffDir/$fileName';
      final diffFile = File(diffPath);
      
      if (!diffFile.existsSync()) {
        errors.add('Diff file missing for golden test: $diffPath');
      } else {
        final stat = diffFile.statSync();
        if (stat.size == 0) {
          info.add('✓ Diff file exists (empty): $diffPath');
        } else {
          info.add('✓ Diff file exists: $diffPath (${stat.size} bytes)');
        }
      }
    }
  }
  
  /// Check for orphaned files (files without corresponding tests)
  void _validateOrphanedFiles(List<String> goldenReferences) {
    _checkOrphanedGoldenFiles(goldenReferences);
    _checkOrphanedDiffFiles(goldenReferences);
  }
  
  void _checkOrphanedGoldenFiles(List<String> goldenReferences) {
    final goldensDirectory = Directory(goldensDir);
    if (!goldensDirectory.existsSync()) return;
    
    final referencedFiles = goldenReferences
        .map((ref) => ref.split('/').last)
        .toSet();
    
    goldensDirectory.listSync().forEach((entity) {
      if (entity is File && entity.path.endsWith('.png')) {
        final fileName = entity.path.split('/').last;
        if (!referencedFiles.contains(fileName)) {
          warnings.add('Orphaned golden file (no test reference): ${entity.path}');
        }
      }
    });
  }
  
  void _checkOrphanedDiffFiles(List<String> goldenReferences) {
    final diffDirectory = Directory(diffDir);
    if (!diffDirectory.existsSync()) return;
    
    final expectedDiffFiles = goldenReferences
        .map((ref) => ref.split('/').last)
        .toSet();
    
    diffDirectory.listSync().forEach((entity) {
      if (entity is File && entity.path.endsWith('.png')) {
        final fileName = entity.path.split('/').last;
        if (!expectedDiffFiles.contains(fileName)) {
          warnings.add('Orphaned diff file (no golden test): ${entity.path}');
        }
      }
    });
  }
  
  /// Print validation results
  void _printResults() {
    print('\n📊 Validation Results:');
    print('=' * 50);
    
    if (info.isNotEmpty) {
      print('\n✅ Information:');
      for (final item in info) {
        print('   $item');
      }
    }
    
    if (warnings.isNotEmpty) {
      print('\n⚠️  Warnings:');
      for (final warning in warnings) {
        print('   $warning');
      }
    }
    
    if (errors.isNotEmpty) {
      print('\n❌ Errors:');
      for (final error in errors) {
        print('   $error');
      }
    }
    
    print('\n📈 Summary:');
    print('   Info: ${info.length}');
    print('   Warnings: ${warnings.length}');
    print('   Errors: ${errors.length}');
    
    if (errors.isEmpty) {
      print('\n🎉 Golden test structure validation PASSED!');
    } else {
      print('\n💥 Golden test structure validation FAILED!');
      print('   Please fix the errors above before proceeding.');
    }
  }
}

Future<void> main(List<String> args) async {
  final validator = GoldenTestValidator();
  final success = await validator.validate();
  
  // Exit with non-zero code if validation failed
  if (!success) {
    exit(1);
  }
}