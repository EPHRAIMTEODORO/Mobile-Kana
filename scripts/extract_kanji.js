const fs = require('fs');
const path = require('path');

// Read the TypeScript kanji file
const tsFilePath = '../Learn-Kana/data/kanji.ts';
let tsContent = fs.readFileSync(tsFilePath, 'utf8');

// Clean up the TypeScript to make it parseable as JavaScript
tsContent = tsContent
  .replace(/import\s+.*?from\s+['"].*?['"];?\s*/g, '') // Remove imports
  .replace(/export\s+/g, '')  // Remove export keywords
  .replace(/:\s*KanjiCharacter\[\]/g, '')  // Remove type annotations
  .replace(/:\s*KanjiGradeSection\[\]/g, '');  // Remove type annotations

// Extract grade sections using eval (safe since we control the source)
function extractGradeKanji(gradeName) {
  console.log(`\n🔍 Extracting ${gradeName}...`);
  
  try {
    // Create a safe evaluation context
    const context = {};
    
    // Find and extract just this grade's array
    const startRegex = new RegExp(
      `const ${gradeName}Kanji\\s*=\\s*\\[`,
      'm'
    );
    
    const startMatch = tsContent.match(startRegex);
    if (!startMatch) {
      console.error(`❌ Could not find ${gradeName}Kanji array start`);
      return [];
    }
    
    const startIndex = startMatch.index + startMatch[0].length;
    
    // Find the matching closing bracket by counting brackets
    let bracketCount = 1;
    let endIndex = startIndex;
    let inString = false;
    let stringChar = null;
    let escaped = false;
    
    while (bracketCount > 0 && endIndex < tsContent.length) {
      const char = tsContent[endIndex];
      
      if (escaped) {
        escaped = false;
        endIndex++;
        continue;
      }
      
      if (char === '\\') {
        escaped = true;
        endIndex++;
        continue;
      }
      
      if ((char === '"' || char === "'") && !inString) {
        inString = true;
        stringChar = char;
      } else if (char === stringChar && inString) {
        inString = false;
        stringChar = null;
      }
      
      if (!inString) {
        if (char === '[') bracketCount++;
        if (char === ']') bracketCount--;
      }
      
      endIndex++;
    }
    
    if (bracketCount !== 0) {
      console.error(`❌ Could not find matching closing bracket for ${gradeName}Kanji`);
      return [];
    }
    
    // Extract the array content
    const arrayContent = tsContent.substring(startMatch.index, endIndex);
    
    // Evaluate it safely
    const code = `(function() { ${arrayContent}; return ${gradeName}Kanji; })()`;
    const kanjiList = eval(code);
    
    console.log(`✅ Extracted ${kanjiList.length} kanji from ${gradeName}`);
    return kanjiList;
    
  } catch (e) {
    console.error(`❌ Error parsing ${gradeName}: `, e.message);
    console.error(e.stack);
    return [];
  }
}

// Convert to Dart format
function convertToDart(kanjiList, gradeEnum) {
  // Helper to escape strings for Dart
  const escapeDart = (str) => {
    return str
      .replace(/\\/g, '\\\\')  // Escape backslashes first
      .replace(/'/g, "\\'")     // Escape single quotes
      .replace(/\n/g, '\\n')    // Escape newlines
      .replace(/\r/g, '\\r')    // Escape carriage returns
      .replace(/\t/g, '\\t');   // Escape tabs
  };
  
  // Use camelCase for variable name (grade1Kanji, juniorHighKanji)
  const varName = gradeEnum === 'juniorHigh' ? 'juniorHighKanji' : `${gradeEnum}Kanji`;
  
  let dartCode = `import '../../models/kanji_character.dart';\nimport '../../models/kanji_example.dart';\nimport '../../models/kanji_enums.dart';\n\n`;
  dartCode += `const List<KanjiCharacter> ${varName} = [\n`;
  
  kanjiList.forEach((kanji, index) => {
    dartCode += `  KanjiCharacter(\n`;
    dartCode += `    character: '${escapeDart(kanji.character)}',\n`;
    dartCode += `    meanings: [${kanji.meanings.map(m => `'${escapeDart(m)}'`).join(', ')}],\n`;
    dartCode += `    onyomi: [${kanji.onyomi.map(r => `'${escapeDart(r)}'`).join(', ')}],\n`;
    dartCode += `    kunyomi: [${kanji.kunyomi.map(r => `'${escapeDart(r)}'`).join(', ')}],\n`;
    dartCode += `    examples: [\n`;
    kanji.examples.forEach(ex => {
      dartCode += `      KanjiExample(word: '${escapeDart(ex.word)}', reading: '${escapeDart(ex.reading)}', meaning: '${escapeDart(ex.meaning)}'),\n`;
    });
    dartCode += `    ],\n`;
    dartCode += `    grade: KanjiGrade.${gradeEnum},\n`;
    dartCode += `    strokeCount: ${kanji.strokeCount},\n`;
    if (kanji.jlptLevel) {
      const jlptMap = { 'N5': 'JlptLevel.n5', 'N4': 'JlptLevel.n4', 'N3': 'JlptLevel.n3', 'N2': 'JlptLevel.n2', 'N1': 'JlptLevel.n1' };
      dartCode += `    jlptLevel: ${jlptMap[kanji.jlptLevel] || 'null'},\n`;
    }
    if (kanji.frequency) {
      dartCode += `    frequency: ${kanji.frequency},\n`;
    }
    dartCode += `  )${index < kanjiList.length - 1 ? ',' : ''}\n`;
  });
  
  dartCode += `];\n`;
  return dartCode;
}

// Extract all grades
const grades = [
  { name: 'grade1', enum: 'grade1', count: 80, filename: 'grade1_kanji' },
  { name: 'grade2', enum: 'grade2', count: 160, filename: 'grade2_kanji' },
  { name: 'grade3', enum: 'grade3', count: 200, filename: 'grade3_kanji' },
  { name: 'grade4', enum: 'grade4', count: 200, filename: 'grade4_kanji' },
  { name: 'grade5', enum: 'grade5', count: 185, filename: 'grade5_kanji' },
  { name: 'grade6', enum: 'grade6', count: 181, filename: 'grade6_kanji' },
  { name: 'juniorHigh', enum: 'juniorHigh', count: 1134, filename: 'junior_high_kanji' }
];

const allKanjiData = {};
let totalCount = 0;

console.log('🎌 Starting Kanji Extraction...\n');

grades.forEach(grade => {
  const kanjiList = extractGradeKanji(grade.name);
  allKanjiData[grade.enum] = kanjiList;
  totalCount += kanjiList.length;
  
  // Convert to Dart and save
  const dartCode = convertToDart(kanjiList, grade.enum);
  const filename = grade.filename || `${grade.enum}_kanji`;
  const outputPath = path.join(__dirname, '..', 'lib', 'data', 'kanji', `${filename}.dart`);
  fs.writeFileSync(outputPath, dartCode, 'utf8');
  console.log(`💾 Saved ${kanjiList.length} kanji to ${filename}.dart`);
  
  if (kanjiList.length !== grade.count) {
    console.log(`⚠️  Expected ${grade.count} but got ${kanjiList.length}`);
  }
});

// Print summary
console.log('\n📊 EXTRACTION SUMMARY:');
console.log('═══════════════════════════════════════');
grades.forEach(grade => {
  const count = allKanjiData[grade.enum].length;
  const status = count === grade.count ? '✅' : '⚠️';
  console.log(`${status} ${grade.enum.padEnd(15)} ${count.toString().padStart(4)} / ${grade.count.toString().padStart(4)} kanji`);
});
console.log('═══════════════════════════════════════');
console.log(`📚 Total kanji extracted: ${totalCount}`);
console.log(`🎯 Expected total: 2,140 (80+160+200+200+185+181+1,134)`);
console.log(`${totalCount === 2140 ? '✅' : '❌'} Status: ${totalCount === 2140 ? 'COMPLETE - ALL KANJI EXTRACTED!' : 'INCOMPLETE'}`);
console.log('\n🎉 Extraction complete! Check lib/data/kanji/ directory\n');
