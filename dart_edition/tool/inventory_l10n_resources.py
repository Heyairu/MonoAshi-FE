"""Inventory native surfaces and the installed Quill resources without changes.

Run from dart_edition after inventory_l10n.dart:
    python3 tool/inventory_l10n_resources.py
Native entries are review candidates, not approved translations.
"""

import hashlib
import json
from pathlib import Path
import re
from urllib.parse import unquote, urlparse


OUTPUT = Path('../docs/i18n')
QUOTED = re.compile(r'"((?:\\.|[^"\\])*)"')
HUMAN = re.compile(r'[\u3400-\u9fff]|[A-Za-z]{2,}[ ,:]+[A-Za-z]{2,}')


def write_json(name, value):
    (OUTPUT / name).write_text(
        json.dumps(value, ensure_ascii=False, indent=2) + '\n'
    )


def main():
    if not Path('lib').is_dir():
        raise SystemExit('Run from dart_edition/.')
    OUTPUT.mkdir(parents=True, exist_ok=True)
    summary = json.loads((OUTPUT / 'summary.json').read_text())
    current_sources = {
        path.as_posix()
        for root in ['lib', 'packages/material_ribbon/lib']
        for path in Path(root).rglob('*.dart')
        if not path.name.endswith(('.g.dart', '.freezed.dart'))
    }
    if current_sources != {item['path'] for item in summary['files']}:
        raise SystemExit('Dart source file set changed; rerun inventory_l10n.dart')
    for item in summary['files']:
        actual = hashlib.sha256(Path(item['path']).read_bytes()).hexdigest()
        if actual != item['sourceSha256']:
            raise SystemExit('Dart source changed; rerun inventory_l10n.dart: '
                             + item['path'])
    native = []
    paths = set()

    def add(path, text, offset, category, context):
        source = path.read_text(encoding='utf-8-sig')
        native.append({
            'path': path.as_posix(),
            'line': source.count('\n', 0, offset) + 1,
            'text': text,
            'category': category,
            'context': context,
            'status': 'needs_review',
        })

    for root in ['android/app/src/main', 'ios/Runner', 'macos/Runner',
                 'windows/runner', 'linux/runner', 'linux/packaging', 'web']:
        for path in sorted(Path(root).rglob('*')):
            if path.suffix not in {'.kt', '.swift', '.cpp', '.cc', '.rc',
                                   '.plist', '.xib', '.xcconfig', '.xml',
                                   '.desktop', '.html', '.json'}:
                continue
            if any(p in {'ephemeral', 'build', 'generated'} for p in path.parts):
                continue
            paths.add(path)
    paths.add(Path('../nsExec/Installer.nsi'))
    for path in sorted(paths):
        source = path.read_text(encoding='utf-8-sig')
        if path.suffix == '.plist':
            for match in re.finditer(
                r'<key>([^<]+)</key>\s*<string>([^<]*)</string>', source
            ):
                if match[1] in {'CFBundleDisplayName', 'CFBundleName',
                                'CFBundleTypeName', 'UTTypeDescription',
                                'NSLocalNetworkUsageDescription'}:
                    add(path, match[2], match.start(), 'native_metadata', match[1])
        elif path.suffix == '.xib':
            for match in re.finditer(r'\btitle="([^"]+)"', source):
                add(path, match[1], match.start(), 'native_menu', 'title')
        elif path.suffix == '.xcconfig':
            for match in re.finditer(r'^PRODUCT_(NAME|COPYRIGHT)\s*=\s*(.+)$',
                                     source, re.M):
                add(path, match[2], match.start(), 'native_metadata', match[1])
        elif path.suffix == '.desktop':
            for match in re.finditer(r'^(Name|Comment)(?:\[[^\]]+\])?=(.+)$',
                                     source, re.M):
                add(path, match[2], match.start(), 'native_metadata', match[1])
        elif path.name == 'manifest.json':
            data = json.loads(source)
            for key in ['name', 'short_name', 'description']:
                if key in data:
                    add(path, data[key], source.index('"' + key + '"'),
                        'native_metadata', key)
        elif path.suffix == '.rc':
            for match in re.finditer(r'VALUE "(CompanyName|FileDescription|'
                                     r'ProductName|LegalCopyright)", "([^"]+)"',
                                     source):
                add(path, match[2], match.start(), 'native_metadata', match[1])
        elif path.suffix == '.html':
            for match in re.finditer(r'<title>([^<]+)</title>|'
                                     r'<meta name="(description|apple-mobile-web-app-title)" '
                                     r'content="([^"]+)"', source):
                add(path, match[1] or match[3], match.start(),
                    'native_metadata', match[2] or 'title')
        elif path.suffix == '.xml':
            for match in re.finditer(r'android:label="([^"]+)"|'
                                     r'<comment>([^<]+)</comment>', source):
                add(path, match[1] or match[2], match.start(),
                    'native_metadata', 'label_or_mime_description')
        else:
            offset = 0
            for line in source.splitlines(keepends=True):
                if not line.lstrip().startswith(('//', ';', '/*', '*')):
                    for match in QUOTED.finditer(line):
                        if HUMAN.search(match[1]) or (
                            path.suffix == '.nsi' and
                            re.match(r'\s*Section\s', line)
                        ):
                            add(path, match[1], offset + match.start(),
                                'native_review', line.strip())
                offset += len(line)
    write_json('native_inventory.json', {
        'method': 'explicit metadata/title fields and natural language literals',
        'limitation': 'native_review may include logs, build errors or brands',
        'scannedFiles': [p.as_posix() for p in sorted(paths)],
        'entries': native,
    })

    config = json.loads(Path('.dart_tool/package_config.json').read_text())
    package = next(p for p in config['packages'] if p['name'] == 'flutter_quill')
    uri = urlparse(package['rootUri'])
    root = Path(unquote(uri.path)) if uri.scheme == 'file' else (
        Path('.dart_tool') / package['rootUri']
    ).resolve()
    arb_dir = root / 'lib/src/l10n'
    installed_version = re.search(r'^version:\s*(\S+)',
                                   (root / 'pubspec.yaml').read_text(), re.M)[1]
    base = json.loads((arb_dir / 'quill_en.arb').read_text())
    base_keys = {key for key in base if not key.startswith('@')}
    locales = []
    for locale in ['zh', 'zh_TW', 'en', 'en_US', 'ja']:
        arb = json.loads((arb_dir / f'quill_{locale}.arb').read_text())
        keys = {key for key in arb if not key.startswith('@')}
        locales.append({
            'locale': locale, 'keys': len(keys),
            'missingFromEnglishBase': sorted(base_keys - keys),
            'examples': {key: arb.get(key) for key in ['ok', 'copy', 'save']},
        })
    write_json('third_party_inventory.json', {
        'package': 'flutter_quill', 'version': installed_version,
        'versionSource': 'pubspec.yaml and installed package',
        'locales': locales,
        'finding': ('zh-Hant without countryCode selects simplified zh; '
                    'map zh-Hant to zh-TW for the Quill delegate'
                    if installed_version == '11.6.0' else
                    'Re-audit locale lookup for this installed version'),
        'source': 'lib/src/l10n/generated/quill_localizations.dart',
        'status': 'source inspected; runtime locale integration test pending',
    })

    sources = [Path(item['path']) for item in summary['files']]
    sources += list(Path('assets/help').glob('*.json'))
    sources += list(Path('assets/jsons').glob('*.json'))
    sources += list(paths)
    write_json('source_manifest.json', {
        'purpose': 'SHA-256 snapshot; regenerate inventory when inputs change',
        'files': {p.as_posix(): hashlib.sha256(p.read_bytes()).hexdigest()
                  for p in sorted(set(sources))},
    })
    print(f'Native: {len(native)} candidates in {len(paths)} inspected files.')
    print('Quill resource coverage and source snapshot written.')


if __name__ == '__main__':
    main()
