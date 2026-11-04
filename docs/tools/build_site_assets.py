"""Prepare self-hosted Noto fonts and WebP screenshots for the static site.

Run from any directory with Python packages fonttools, brotli and Pillow:
  python3 docs/tools/build_site_assets.py
Capture the production Flutter workspace before running this script; see WEBSITE.md.
"""
from html.parser import HTMLParser
from pathlib import Path

from fontTools import subset
from fontTools.ttLib import TTFont
from PIL import Image, ImageDraw, ImageFont


ROOT = Path(__file__).resolve().parents[2]
ASSETS = ROOT / 'docs/assets'


class SiteText(HTMLParser):
    def __init__(self):
        super().__init__()
        self.parts = []
        self.title = []
        self.heading = []
        self.in_title = False
        self.in_heading = False

    def handle_data(self, data):
        self.parts.append(data)
        if self.in_title and data.strip():
            self.title.append(data.strip())
        if self.in_heading and data.strip():
            self.heading.append(data.strip())

    def handle_starttag(self, tag, attrs):
        self.parts.extend(value for _, value in attrs if value)
        if tag == 'title':
            self.in_title = True
        if tag == 'h1':
            self.in_heading = True

    def handle_endtag(self, tag):
        if tag == 'title':
            self.in_title = False
        if tag == 'h1':
            self.in_heading = False


def write_font(source, target, codepoints):
    font = TTFont(ROOT / 'dart_edition/assets/fonts' / source)
    options = subset.Options()
    options.flavor = 'woff2'
    options.layout_features = ['*']
    options.name_IDs = ['*']  # Preserve copyright and license information.
    options.name_languages = ['*']
    subsetter = subset.Subsetter(options=options)
    subsetter.populate(unicodes=codepoints)
    subsetter.subset(font)
    font.flavor = 'woff2'
    font.save(ASSETS / 'fonts' / target)
    print(target, (ASSETS / 'fonts' / target).stat().st_size, 'bytes')


def write_social_card(parser):
    card = Image.new('RGB', (1200, 630), '#f3f8f3')
    draw = ImageDraw.Draw(card)
    fonts = ROOT / 'dart_edition/assets/fonts'
    def load_font(name, size, weight):
        font = ImageFont.truetype(str(fonts / name), size)
        axes = font.get_variation_axes()
        font.set_variation_by_axes([
            weight if axis['name'] == b'Weight' else axis['default'] for axis in axes
        ])
        return font
    latin = load_font('NotoSans-Variable.ttf', 32, 500)
    heading = load_font('NotoSansTC-Variable.ttf', 58, 600)
    body = load_font('NotoSansTC-Variable.ttf', 25, 400)
    note = load_font('NotoSansTC-Variable.ttf', 20, 400)
    draw.ellipse((820, 180, 1500, 860), fill='#cce8e1')
    draw.ellipse((880, 240, 1440, 800), outline='#80b5a2', width=1)
    with Image.open(ASSETS / 'app-icon.png') as source:
        logo = source.convert('RGBA').resize((96, 96), Image.Resampling.LANCZOS)
        card.paste(logo, (74, 58), logo)
    draw.text((191, 79), parser.title[0].split(' - ', 1)[0], font=latin, fill='#17221f')
    for index, line in enumerate(parser.heading):
        draw.text((77, 212 + index * 90), line, font=heading,
                  fill='#17221f' if index == 0 else '#006a60')
    draw.text((81, 437), '正文編輯、章節、大綱、角色與時間軸', font=body, fill='#53645e')
    draw.text((81, 535), '開放原始碼  /  本機儲存  /  Apache 2.0', font=note, fill='#006a60')
    card.save(ASSETS / 'social-card.png', optimize=True)


def main():
    parser = SiteText()
    parser.feed((ROOT / 'docs/index.zh-Hant.html').read_text(encoding='utf-8'))
    text = ''.join(parser.parts) + (ASSETS / 'site.js').read_text(encoding='utf-8') + (ASSETS / 'site.css').read_text(encoding='utf-8')
    (ASSETS / 'fonts').mkdir(exist_ok=True)
    latin = set(range(0x0000, 0x0250)) | set(range(0x2000, 0x2070))
    chinese = {ord(c) for c in text if ord(c) >= 0x0250}
    chinese |= set(range(0x3000, 0x3040)) | set(range(0xFF00, 0xFFF0))
    write_font('NotoSans-Variable.ttf', 'NotoSans-latin.woff2', latin)
    write_font('NotoSansTC-Variable.ttf', 'NotoSansTC-site.woff2', chinese)
    write_social_card(parser)
    for path in sorted((ROOT / 'AppPreview/website').glob('*.png')):
        target = ASSETS / 'screenshots' / path.with_suffix('.webp').name
        with Image.open(path) as image:
            image.convert('RGB').save(target, 'WEBP', quality=92, method=6)
        print(target.name, target.stat().st_size, 'bytes')


if __name__ == '__main__':
    main()
