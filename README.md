slothsoft.net
=============

## Final Fantasy (NES, US)

The `/FinalFantasy/` section provides an equipment save editor and ROM-backed
`Weapons/`, `Armor/`, and `Spells/` reference pages. `/FinalFantasy/SaveEditor/`
edits all four weapon and armor slots of each character, including equipped flags.
Character status, learned spells, general data, and party items are read-only or
outside the current editor scope.

### Private ROM configuration

Set `FF1_ROM_PATH` to a private, readable original US ROM file in the PHP runtime.
For local development, the default is `Final Fantasy (USA).nes` in the project
root. In DDEV, a configured path must refer to a path inside the web container.
The ROM and root-level saves are ignored by Git. Do not put the ROM in `assets/`
or the public document root; the application publishes extracted reference data,
not the ROM. No emulator or external extraction executable is required.

Only the original US PRG is accepted (SHA-256
`fa456d852372173ea31b192459ba1a2026f779df67793327ba6e132476c1d034`). Header/trainer
length is accounted for separately. Japanese releases, hacks and randomizers are
not supported. Without a configured ROM the reference/editor pages display an
unavailable message; the overview remains accessible.

### Data and editor architecture

`src/FinalFantasy/Rom.php` extracts names, class permissions, equipment stats,
prices, and spell records. `TextCodec` decodes the game's alphabet and represents
equipment glyphs with bracketed labels. Names, including spelling and case, come
from the ROM. The domain namespace is
`http://schema.slothsoft.net/slothsoft.net/final-fantasy`; its versioned schema is
published at `farah://slothsoft@slothsoft.net/schema/final-fantasy/1.0`.
The domain data endpoint is `/final-fantasy/api/data`, with a `view` parameter (`home`, `editor`, `weapons`, `armor`, or `spells`). XSL transforms this document
into the public pages, including the ROM-derived equipment selectors.

`Save` validates and edits 8192-byte battery SRAM through `slothsoft/savegame` and
`assets/final-fantasy/savegame/equipment.xml`. The upstream dependency is pinned
in `composer.lock` on `dev-main`, prepared for savegame 1.5.0 without a tag.
The reusable library handles numeric byte order and masks; FF1 owns checksums,
ROM decoding, equipment rules, and its domain schema. Existing Ambermoon defaults
remain big-endian, with no mask applied.

The HTTP flow is stateless: upload a save, edit equipment, and download a new
save. The original bytes travel in the form as base64 and are validated again
on download; there is no persistent user-save repository. Forms enforce class
permissions, one equipped weapon, and one equipped item per armor category.
Inventory may contain items unusable by that character. Unchanged pre-existing
invalid equipment is preserved.

No-op exports are byte-identical. Changed equipment updates only its slots,
the checksum, and (when the equipped set changes) the cached combat stats that
the original game's equipment menu would update. This includes original byte
overflow and Black Belt/Master rules. Other SRAM bytes are preserved. The
checksum reproduces the game's interleaved 6502 carry accumulation and verifies
the resulting save before returning it.

Reference pages describe implemented US behavior: weapon critical thresholds
use weapon IDs, and ineffective elemental/enemy-category weapon bonuses are
omitted. Armor resistance masks are decoded; item spell links name the spell
cast. Spell pages list levels, schools, prices, and learning permissions, without
claiming that every stored spell effect works as intended.

### Validation and references

Run `ddev exec vendor/bin/phpunit` and
`ddev exec vendor/bin/phpstan analyse --configuration=phpstan.neon.dist --no-progress --error-format=json`.
PHPStan currently covers the new Final Fantasy code. Save tests use synthetic
SRAM and an equipment catalog, so they run without copyrighted fixtures. ROM and
page-content tests additionally exercise a locally supplied original US ROM and
skip intentionally when it is absent. Farah tests check both manifest lookup and
resolved streams/schema validity. No game binaries are distributed in tests.

Format references:

- [Disch's US disassembly, maintained by Entroper](https://github.com/Entroper/FF1Disassembly): banks 0A, 0C, 0D, 0E, 0F and `variables.inc`.
- [Game Tools Collection](https://github.com/RyudoSynbios/game-tools-collection/tree/master/src/lib/templates/final-fantasy/saveEditor): feature and format reference, MIT licensed. The implementation here reads names and equipment data from the ROM.

All extraction/editing code is implemented here; no disassembly binaries or
third-party editor source are bundled.
