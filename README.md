slothsoft.net
=============

## Final Fantasy (NES, US)

The `/FinalFantasy/` section embeds the reusable
[`slothsoft/final-fantasy`](https://github.com/Faulo/slothsoft-final-fantasy)
Farah module. It provides `/FinalFantasy/SaveEditor/`, `/FinalFantasy/Weapons/`,
`/FinalFantasy/Armor/` and `/FinalFantasy/Spells/`. The editor currently edits
weapons, armor and equipped flags; reference pages read names, stats and class
permissions from the original US ROM through savegame XML specifications.

The package owns the extraction specifications, domain schema, save editing,
PHP classes and presentation assets. This project owns routing, site layout
and private ROM configuration. The domain namespace is
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
