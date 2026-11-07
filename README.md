slothsoft.net
=============

## Final Fantasy (NES, US)

The `/FinalFantasy/I/` section consumes XML and assets from the reusable
[`slothsoft/final-fantasy`](https://github.com/Faulo/slothsoft-final-fantasy)
Farah module. It provides `/FinalFantasy/I/SaveEditor/`, `/FinalFantasy/I/Weapons/`,
`/FinalFantasy/I/Armor/` and `/FinalFantasy/I/Spells/`. The editor currently edits
weapons, armor and equipped flags; reference pages read names, stats and class
permissions from the original US ROM through savegame XML specifications.

Reference tables show every class sprite, dimming classes without equip/learn
permission. The package generates transparent eight-pose PNG sheets from the ROM
at `/slothsoft@final-fantasy/i/gfx/class?class=0` (class IDs 0–11); CSS selects the
standing pose. No extracted graphics are bundled with either project.
Item names are plain Unicode text. Standalone selected-item previews use
`/slothsoft@final-fantasy/i/gfx/items`.
ROM/save names use the original menu font, generated as TrueType at
`/slothsoft@final-fantasy/i/font`. This includes equipment options, character and
class names, spells and cast links. All text and controls inside FF panels use
the same white-on-blue ROM typography; surrounding headings and prose retain
the site styling.

The package owns the extraction specifications, domain schema, save editing,
PHP classes, utility CSS and standalone HTML examples. This project owns the
actual HTML in `assets/final-fantasy/xsl/page.xsl`, its links and form actions,
page layout CSS, preview JavaScript and private ROM configuration. Its manifest
transforms the package's XML data API directly; no package HTML pages are embedded.
The package CSS uses base sizes of 8px for text and 24px for sprite height; the
site sets `--ff-scale: 2` on each panel for 16px text and 48px sprite height.
Borders and spacing scale with the font, and line height is 150%. The domain namespace is
`http://schema.slothsoft.net/final-fantasy/i`; the schema is published at
`farah://slothsoft@final-fantasy/schema/i/1.0`.

Set `FF1_ROM_PATH` to a private readable original US ROM in the PHP runtime.
For local development, the default is `Final Fantasy (USA).nes` in this project
root. `src/bootstrap.php` passes this host configuration to
`Slothsoft\FinalFantasy\Configuration::setRomPath('i', $path)`. In DDEV, the
configured path must be inside the web container. The package itself has no
default ROM location. ROMs and root-level saves are ignored by Git; do not put
them in public document roots or assets. Without a readable ROM the overview
remains accessible and reference/editor pages display an unavailable message.

The new package is required as `dev-main` through its Git repository until a
release is published. The site also explicitly allows `slothsoft/savegame:dev-main`
while the scoped variable-resolution support is prepared as savegame 1.6.0.

Run `ddev exec vendor/bin/phpunit` for site and public-page integration checks,
and `ddev exec vendor/bin/phpstan analyse --configuration=phpstan.neon.dist --no-progress --error-format=json`
for the integration bootstrap. ROM-dependent tests skip when a local ROM is
absent. Binary parser, editor, schema and asset tests live in the package.

The Firefox integration check is `tests/browser/final-fantasy.cjs`. Run it in
DDEV with Playwright's Firefox installed (`ddev exec npx --yes --package=playwright playwright install --with-deps firefox`). Set
`FF_PLAYWRIGHT_MODULE` to the installed module, `FF_SAVE_PATH` to a private save,
and optionally `FF_EDITOR_URL` and `FF_SCREENSHOT`. It checks the native editor,
Unicode ROM glyphs, panel boundaries, palette and scaling. Screenshots omit
native dropdown popups; those still require visual confirmation in Firefox.
