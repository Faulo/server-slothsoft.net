slothsoft.net
=============

## Final Fantasy (NES, US)

The `/FinalFantasy/I/` section consumes XML and assets from the reusable
[`slothsoft/final-fantasy`](https://github.com/Faulo/slothsoft-final-fantasy)
Farah module. The overview is at `/FinalFantasy/`, and `/FinalFantasy/I/` redirects
to the editor. It provides `/FinalFantasy/I/SaveEditor/`, `/FinalFantasy/I/Weapons/`,
`/FinalFantasy/I/Armor/` and `/FinalFantasy/I/Spells/`. The editor currently edits
weapons, armor and equipped flags; reference pages read names, stats and class
permissions from the original US ROM through savegame XML specifications.

The editor gives each character a framed name-and-class-sprite legend. Weapons
and armor each use a 2×2 grid, with native checkboxes rendered as E markers that
dim when unequipped. Slot numbers remain in accessible control names only.
Equipment rows are 24px tall at 2×, including the select borders, with no vertical
gap between rows. Item glyphs appear only within the option text. Select widths
use the longest rendered option in ch, plus padding, borders and space for the
native dropdown arrow. The empty equipment option has no text.
The editor follows the game menu: upload, a full user-ID bookmark link, and
Save/Download commands form the left column; character panels form a two-by-two
block on the right. The columns and character panels wrap on narrow screens.
Commands use native form association to submit the equipment from the left menu.
The ROM hand marks hover/focus, including the file chooser; its .sav label follows
the input on the right when space permits.
Narrow screens scroll each equipment grid horizontally to keep item names legible.
Scroll containers reserve .25em for native control focus outlines.

Equipment tables show every class sprite, dimming classes without equip
permission. Magic tables show only class/upgrade pairs with at least one learner
in that school, determined from the ROM. This keeps Fighter/Knight for White Magic
and Thief/Ninja for Black Magic; each row still dims classes unable to learn that
particular spell. The package generates transparent eight-pose PNG sheets from the ROM
at `/slothsoft@final-fantasy/i/gfx/class?class=0` (class IDs 0–11); CSS selects the
standing pose. No extracted graphics are bundled with either project.
Item names are plain Unicode text; the editor does not add separate icon previews.
ROM/save names use the original menu font, generated as TrueType at
`/slothsoft@final-fantasy/i/font`. This includes equipment options, character and
class names, spells and cast links. All text and controls inside FF panels use
the same white-on-blue ROM typography; surrounding headings and prose retain
the site styling.

The package owns the extraction specifications, domain schema, save editing,
PHP classes, utility CSS and standalone HTML examples. This project owns the
actual HTML in `assets/final-fantasy/xsl/page.xsl`, its links and form actions,
layout composition and private ROM configuration. Its manifest
transforms the package's XML data API directly; no package HTML pages are embedded.
All FF presentation comes from the package's fourteen public utilities and
semantic HTML defaults. Templates supply documented custom properties for
scale, grid tracks, gaps, sprite URLs and option widths. No site-specific FF
stylesheet is loaded. The retired `/final-fantasy/css/default` asset remains as
an empty compatibility resource. See the package's `doc/design-system.md` for
the contract. `ff-contain` bounds the outer article without theming it.

The package CSS uses base sizes of 8px for text and 24px for sprite height; the
site sets `--ff-scale: 2` on each panel for 16px text and 48px sprite height.
Column headings keep the panel's 2× (16px) text, centered horizontally and
vertically, in pale blue (NES $31) to distinguish them from gold links. Body name
cells remain white and left-aligned.
The Classes column uses 2× sprites cropped to their top half, arranged in one
24px row of 12 faces (six for magic) to match the text's line height, pairing each class with
its upgrade. Tables fit their content, with no vertical cell padding, 2ch spacing
between columns, continuous row borders, and right-aligned numbers. Spells are
grouped into White Magic and Black Magic fieldsets; armor into Body, Shield,
Helmet, and Gloves fieldsets; weapons into a Weapons fieldset. Armor's Resists
column follows Classes at the right edge. Each group fits its table and has an aligned bordered
label like the game menu. Class portraits have accessible labels without tooltips.
Spell tables include an Effect column from the package's ROM-derived descriptions,
including damage ranges, field-healing ranges, targets, buffs, debuffs and utility
spells. Target restrictions get their own paragraph; cancellation notes are omitted.
Accuracy and Element follow Effect. Accuracy shows the raw ROM hit bonus for
damage, status, slow and morale effects; spells that ignore accuracy display "-".
For damage spells, Accuracy affects the double-damage roll.
Element decodes the ROM element mask, displaying "-" for non-elemental spells.
Ineffective US-version spells remain identified as such in Effect.
Multiword column headings wrap at spaces. Resistances appear inline, separated by
the ROM font's comma glyph; the combined resistance reads "Poison, Stone".
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

Production stores the private ROM at `/var/www/data/private/final-fantasy-i-us.nes`
in the persistent `slothsoft_farah-data` volume. Set `FF1_ROM_PATH` on the
`slothsoft_frontend` service to that path, including when redeploying the stack.
The web document root is `/var/www/html`; the ROM is outside it and is not part
of the application image or Jenkins publication.

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
The check also supports production's XHTML output and verifies unchanged saves
round-trip byte for byte, and equipment changes survive download and re-upload.

The FF editor creates a random user ID on opening a fresh page. Its form actions
and bookmark link retain `?user=...`; revisiting that URL loads the stored save.
Save changes and downloads persist edits, while uploads replace that user's save.
Files live privately under `ServerEnvironment::getDataDirectory()` at
`slothsoft/final-fantasy/i/users`. The URL is the access key; no account is required.
A fresh editor starts with the ROM's default party (Fighter, Thief, Black Belt,
Red Mage), blank names, initial stats, flags, gold and empty inventory. These
initial tables are extracted through the savegame manifest; no save is bundled.
