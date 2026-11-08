// Run inside DDEV against a host configured with the private US ROM and save.
const assert = require('node:assert/strict');
const {readFile} = require('node:fs/promises');
const {firefox} = require(process.env.FF_PLAYWRIGHT_MODULE || 'playwright');

(async () => {
    const browser = await firefox.launch({headless: true});
    try {
        const page = await browser.newPage({ignoreHTTPSErrors: true, viewport: {width: 1500, height: 1000}});
        const errors = [];
        page.on('pageerror', error => errors.push(error.message));
        const url = process.env.FF_EDITOR_URL || 'https://slothsoft.ddev.site/FinalFantasy/I/SaveEditor/';
        // Playwright's input helpers compare tagName, which rejects prefixed XHTML
        // elements even though Firefox correctly exposes native HTML controls.
        const uploadSave = async (target, buffer) => {
            const input = target.locator('#ff-save');
            if (await input.evaluate(node => Boolean(node.prefix))) {
                await input.evaluate((node, bytes) => {
                    const transfer = new DataTransfer();
                    transfer.items.add(new File([new Uint8Array(bytes)], 'test.sav', {type: 'application/octet-stream'}));
                    node.files = transfer.files;
                    node.dispatchEvent(new Event('change', {bubbles: true}));
                }, [...buffer]);
            } else {
                await input.setInputFiles({name: 'test.sav', mimeType: 'application/octet-stream', buffer});
            }
            await Promise.all([target.waitForNavigation(), target.locator('#ff-upload button').click()]);
        };
        const selectItem = async (select, value) => {
            const index = await select.evaluate((node, value) => [...node.options].findIndex(option => option.value === value), value);
            assert.ok(index >= 0);
            await select.focus();
            await select.press('Home');
            for (let i = 0; i < index; i++) {
                await select.press('ArrowDown');
            }
            await select.press('Enter');
        };
        const setEquipped = async (checkbox, checked) => {
            if (await checkbox.evaluate(node => node.checked) !== checked) {
                await checkbox.click();
            }
        };
        const loadSave = async (target, waitForFont = true) => {
            await target.goto(url);
            await uploadSave(target, await readFile(process.env.FF_SAVE_PATH));
            if (waitForFont) {
                await target.evaluate(() => document.fonts.ready);
            }
        };
        await loadSave(page);
        assert.equal(await page.locator('link[href*="/final-fantasy/css/"]').count(), 0);
        const publicClasses = new Set(['ff-contain', 'ff-ui', 'ff-panel', 'ff-fit', 'ff-row', 'ff-grid',
            'ff-scroll', 'ff-number', 'ff-prose', 'ff-inline-list', 'ff-class-sprite', 'ff-portrait', 'ff-select', 'ff-equipped']);
        const checkContract = async target => {
            const classes = await target.locator('article.ff-contain, article.ff-contain [class]').evaluateAll(nodes => nodes.flatMap(node => [...node.classList]));
            classes.forEach(name => assert.ok(publicClasses.has(name), `Undocumented class ${name}`));
            const declarations = await target.locator('article.ff-contain [style]').evaluateAll(nodes => nodes.flatMap(node => [...node.style]));
            declarations.forEach(name => assert.ok(name.startsWith('--ff-'), `Non-utility styling ${name}`));
        };
        await checkContract(page);
        const downloadSave = async () => {
            const [download] = await Promise.all([
                page.waitForEvent('download'),
                page.locator('#ff-editor button[value=download]').click()
            ]);
            const chunks = [];
            for await (const chunk of await download.createReadStream()) {
                chunks.push(chunk);
            }
            return Buffer.concat(chunks);
        };
        assert.deepEqual(await downloadSave(), await readFile(process.env.FF_SAVE_PATH), 'An unchanged save must round-trip byte for byte');
        const originalItem = await page.locator('#ff-0-weapons-0').evaluate(node => node.value);
        const changedItem = originalItem === '40' ? '1' : '40';
        await selectItem(page.locator('#ff-0-weapons-0'), changedItem);
        const editedSave = await downloadSave();
        await uploadSave(page, editedSave);
        assert.equal(await page.locator('#ff-0-weapons-0').evaluate(node => node.value), changedItem, 'Downloaded equipment changes must survive re-upload');
        await loadSave(page);
        assert.equal(await page.locator('.ff-combobox, .ff-choice').count(), 0);
        assert.equal(await page.locator('select.ff-select:visible').count(), 32);
        assert.equal(await page.locator('.ff-selected-icon, script[src*="item-icons"]').count(), 0);
        assert.equal(await page.locator('fieldset.ff-panel:not(.ff-ui) legend .ff-class-sprite[aria-label]').count(), 4);
        assert.equal(await page.locator('.ff-grid:has(> select) > label').count(), 0);
        const optionWidths = await page.locator('select.ff-select').evaluateAll(selects => selects.map(select => {
            const longest = Math.max(...[...select.options].map(option => [...option.text].length));
            return [select.style.getPropertyValue('--ff-option-width'), `${longest}ch`, select.options[0].text];
        }));
        optionWidths.forEach(([actual, expected, empty]) => {
            assert.equal(actual, expected);
            assert.equal(empty, '');
        });
        const gridShapes = await page.locator('.ff-scroll > .ff-grid').evaluateAll(grids => grids.map(grid => {
            const slots = [...grid.children].map(slot => slot.getBoundingClientRect());
            return [slots.length, new Set(slots.map(slot => slot.left)).size, new Set(slots.map(slot => slot.top)).size,
                slots.every(slot => slot.height === 24), slots[2].top - slots[0].top,
                [...grid.querySelectorAll('select')].every(select => select.getBoundingClientRect().height === 24)];
        }));
        assert.equal(gridShapes.length, 8);
        gridShapes.forEach(shape => assert.deepEqual(shape, [4, 2, 2, true, 24, true]));
        const legendStyles = await page.locator('fieldset.ff-panel:not(.ff-ui)').evaluateAll(characters => characters.map(character => {
            const legend = character.querySelector('legend');
            const css = getComputedStyle(legend);
            return [legend.getBoundingClientRect().left - character.getBoundingClientRect().left, css.borderTopWidth, css.borderTopStyle];
        }));
        legendStyles.forEach(style => assert.deepEqual(style, [0, '2px', 'solid']));
        const party = await page.locator('#ff-editor fieldset').evaluateAll(nodes => nodes.map(node => node.getBoundingClientRect().toJSON()));
        assert.equal(party[0].top, party[1].top, 'Character fieldsets should fill each row before wrapping');
        assert.ok(party[1].left >= party[0].right);
        const commands = await page.locator('#ff-editor button').evaluateAll(nodes => nodes.map(node => node.getBoundingClientRect().toJSON()));
        assert.equal(commands[0].left, commands[1].left);
        assert.ok(commands[1].top >= commands[0].bottom, 'Menu commands should stack vertically');
        const uploadRow = await page.locator('#ff-save, label[for="ff-save"]').evaluateAll(nodes => nodes.map(node => node.getBoundingClientRect().toJSON()));
        assert.ok(uploadRow[1].left >= uploadRow[0].right, 'File label should follow the input on the right');
        const equipped = page.locator('.ff-equipped').first();
        const originallyEquipped = await equipped.evaluate(node => node.checked);
        await setEquipped(equipped, false);
        const markerStyle = () => equipped.evaluate(node => {
            const css = getComputedStyle(node, '::after');
            return [css.content, css.opacity, new FormData(node.form).get(node.name)];
        });
        assert.deepEqual(await markerStyle(), ['"E"', '0.25', null]);
        await equipped.focus();
        await equipped.press('Space');
        assert.deepEqual(await markerStyle(), ['"E"', '1', '1']);
        await setEquipped(equipped, originallyEquipped);
        const select = page.locator('#ff-0-weapons-0');
        assert.equal(await select.locator('option').count(), 41);
        await selectItem(select, '1');
        const font = await select.locator('option[value="1"]').evaluate(node => ({
            family: getComputedStyle(node).fontFamily,
            background: getComputedStyle(node).backgroundColor,
            text: node.textContent,
            loaded: document.fonts.check('16px "Final Fantasy I"')
        }));
        assert.match(font.family, /Final Fantasy I/);
        assert.equal(font.background, 'rgb(0, 0, 252)');
        assert.equal(font.text, 'Wooden\u{1F962}');
        assert.equal(font.loaded, true);
        // Browser rasterization must use the original tile for every Unicode alias,
        // including emoji that could otherwise fall back to a color emoji font.
        const aliasesMatch = await page.evaluate(() => {
            const aliases = [[0x1F5E1, 0xD4], [0x1F528, 0xD5], [0x1F52A, 0xD6],
                [0x1FA93, 0xD7], [0x1FA84, 0xD8], [0x1F962, 0xD9],
                [0x1F9BA, 0xDA], [0x26E8, 0xDB], [0x1FA96, 0xDC],
                [0x1F9E4, 0xDD], [0x1F48D, 0xDE], [0x1F455, 0xDF], [0x1F9F4, 0xE1], [0x2E, 0xC0]];
            const canvas = document.createElement('canvas');
            canvas.width = canvas.height = 64;
            const context = canvas.getContext('2d');
            context.font = '32px "Final Fantasy I"';
            const pixels = code => {
                context.clearRect(0, 0, 64, 64);
                context.fillText(String.fromCodePoint(code), 0, 32);
                return Array.from(context.getImageData(0, 0, 64, 64).data);
            };
            return aliases.every(([code, tile]) => {
                const expected = pixels(0xE000 + tile);
                const actual = pixels(code);
                return expected.some(value => value !== 0) && actual.every((value, index) => value === expected[index]);
            });
        });
        assert.equal(aliasesMatch, true, 'Unicode icons must render the same pixels as their ROM tiles');
        await select.click();
        if (process.env.FF_SCREENSHOT) {
            await page.screenshot({path: process.env.FF_SCREENSHOT});
        }
        await select.press('Escape');
        await selectItem(select, '4');
        assert.equal(await select.evaluate(node => node.value), '4');
        assert.equal(await select.evaluate(node => new FormData(node.form).get(node.name)), '4');
        await select.focus();
        await select.press('End');
        await select.press('Enter');
        assert.equal(await select.evaluate(node => node.value), '40');
        const fallback = await browser.newPage({ignoreHTTPSErrors: true, javaScriptEnabled: false});
        await loadSave(fallback, false);
        assert.equal(await fallback.locator('#ff-0-weapons-0').isVisible(), true);
        assert.equal(await fallback.locator('#ff-0-weapons-0 option[value="1"]').textContent(), 'Wooden\u{1F962}');
        const fallbackEquipped = fallback.locator('.ff-equipped').first();
        await setEquipped(fallbackEquipped, false);
        await fallbackEquipped.press('Space');
        assert.equal(await fallbackEquipped.evaluate(node => node.checked), true);
        // Site copy must stay outside the themed panels; every panel control uses FF typography.
        assert.equal(await page.locator('article.ff-contain > header').count(), 0);
        const controlStyles = await page.locator('.ff-ui').first().evaluate(panel => {
            const nodes = [panel, ...panel.querySelectorAll('label, input, button, select, option')];
            return nodes.map(node => {
                const css = getComputedStyle(node);
                return {font: css.fontFamily, size: css.fontSize, color: css.color, background: css.backgroundColor, shadow: css.textShadow};
            });
        });
        for (const css of controlStyles) {
            assert.match(css.font, /Final Fantasy I/);
            assert.equal(css.size, '16px');
            assert.equal(css.color, 'rgb(252, 252, 252)');
            assert.equal(css.shadow, 'rgb(0, 0, 0) 2px 2px 0px');
        }
        await page.setViewportSize({width: 390, height: 1000});
        assert.ok((await select.boundingBox()).width >= 128, 'The narrow editor must leave room for item names');
        assert.equal(await page.evaluate(() => document.body.scrollWidth <= innerWidth), true);
        assert.equal(await page.locator('.ff-scroll > .ff-grid').first().evaluate(grid => {
            const slots = [...grid.children].map(slot => slot.getBoundingClientRect());
            return new Set(slots.map(slot => slot.left)).size === 2 && new Set(slots.map(slot => slot.top)).size === 2;
        }), true);
        if (process.env.FF_MOBILE_SCREENSHOT) {
            await page.locator('#ff-editor').screenshot({path: process.env.FF_MOBILE_SCREENSHOT});
        }
        const references = await browser.newPage({ignoreHTTPSErrors: true, viewport: {width: 1500, height: 1000}});
        for (const route of ['Weapons', 'Armor', 'Spells']) {
            await references.goto(new URL(`../${route}/`, url).href);
            await references.evaluate(() => document.fonts.ready);
            await checkContract(references);
            assert.equal(await references.evaluate(() => document.body.scrollWidth <= innerWidth), true);
            const panels = references.locator('fieldset.ff-ui.ff-panel');
            const legends = await references.locator('fieldset.ff-ui.ff-panel > legend').allTextContents();
            assert.deepEqual(legends, route === 'Armor' ? ['Body', 'Shield', 'Helmet', 'Gloves'] : route === 'Spells' ? ['White Magic', 'Black Magic'] : ['Weapons']);
            if (process.env.FF_REFERENCE_SCREENSHOT) {
                await references.screenshot({path: process.env.FF_REFERENCE_SCREENSHOT.replace(/\.png$/, `-${route}.png`), fullPage: true});
            }
            for (const panel of await panels.all()) {
                const expectedClasses = route === 'Spells'
                    ? (await panel.locator('legend').textContent()) === 'White Magic' ? [0, 6, 3, 9, 4, 10] : [1, 7, 3, 9, 5, 11]
                    : [0, 6, 1, 7, 2, 8, 3, 9, 4, 10, 5, 11];
                const metrics = await panel.evaluate(node => {
                    const css = getComputedStyle(node);
                    const sprite = getComputedStyle(node.querySelector('.ff-class-sprite'));
                    const cells = [...node.querySelectorAll('th, td, caption, a')];
                    const table = node.querySelector('table');
                    const tableStyle = getComputedStyle(table);
                    const portraits = [...node.querySelector('.ff-row:has(> .ff-portrait)').children];
                    return {
                        size: css.fontSize, line: css.lineHeight, border: css.borderTopWidth,
                        spriteWidth: sprite.width, spriteHeight: sprite.height,
                        spriteBackground: sprite.backgroundSize,
                        classesHeight: node.querySelector('.ff-row:has(> .ff-portrait)').getBoundingClientRect().height,
                        portraitRows: new Set(portraits.map(face => face.getBoundingClientRect().top)).size,
                        portraitCount: portraits.length,
                        cellPadding: [...table.querySelectorAll('th, td')].every(cell => {
                            const style = getComputedStyle(cell);
                            return style.paddingTop === '0px' && style.paddingBottom === '0px' && style.paddingLeft === '0px'
                                && style.paddingRight === (cell.matches(':last-child') ? '0px' : '32px');
                        }),
                        classOrder: portraits.map(face => Number(face.dataset.class)),
                        borderCollapse: tableStyle.borderCollapse,
                        numberAlignment: [...table.querySelectorAll('td.ff-number')].map(cell => getComputedStyle(cell).textAlign),
                        headerStyles: [...table.querySelectorAll('thead th')].map(cell => {
                            const style = getComputedStyle(cell);
                            return [style.fontSize, style.lineHeight, style.textAlign, style.verticalAlign, style.color];
                        }),
                        nameStyles: [...table.querySelectorAll('tbody th')].map(cell => {
                            const style = getComputedStyle(cell);
                            return [style.fontSize, style.textAlign, style.color];
                        }),
                        columnGap: tableStyle.borderSpacing,
                        legendOffset: node.querySelector('legend') ? node.querySelector('legend').getBoundingClientRect().left - node.getBoundingClientRect().left : 0,
                        fieldsetWidth: node.matches('fieldset') ? css.width : null,
                        tableWidth: table.getBoundingClientRect().width,
                        fieldsetInset: parseFloat(css.paddingLeft) + parseFloat(css.paddingRight) + parseFloat(css.borderLeftWidth) + parseFloat(css.borderRightWidth),
                        inlineResists: [...node.querySelectorAll('.ff-inline-list li')].every(item => getComputedStyle(item).display === 'inline'),
                        themedCells: cells.every(cell => {
                            const style = getComputedStyle(cell);
                            const color = cell.matches('thead th') ? 'rgb(164, 228, 252)' : cell.matches('a') ? 'rgb(248, 184, 0)' : 'rgb(252, 252, 252)';
                            return style.fontFamily.includes('Final Fantasy I') && style.color === color && style.textShadow === 'rgb(0, 0, 0) 2px 2px 0px';
                        }),
                        unexpectedShadows: cells.filter(cell => getComputedStyle(cell).textShadow !== 'rgb(0, 0, 0) 2px 2px 0px').map(cell => [cell.tagName, cell.className, getComputedStyle(cell).textShadow]),
                        outsideFont: getComputedStyle(node.closest('article')).fontFamily,
                        outsideBackground: getComputedStyle(node.closest('article')).backgroundColor
                    };
                });
                assert.deepEqual([metrics.size, metrics.line, metrics.border, metrics.spriteWidth, metrics.spriteHeight],
                    ['16px', '24px', '2px', '32px', '24px']);
                assert.equal(metrics.spriteBackground, '256px 48px');
                assert.equal(metrics.classesHeight, 24);
                assert.equal(metrics.portraitRows, 1);
                assert.equal(metrics.portraitCount, expectedClasses.length);
                assert.equal(metrics.cellPadding, true);
                assert.deepEqual(metrics.classOrder, expectedClasses);
                assert.ok(metrics.numberAlignment.length > 0 && metrics.numberAlignment.every(alignment => alignment === 'right'));
                for (const header of metrics.headerStyles) {
                    assert.deepEqual(header, ['16px', '24px', 'center', 'middle', 'rgb(164, 228, 252)']);
                }
                for (const name of metrics.nameStyles) {
                    assert.deepEqual(name, ['16px', 'left', 'rgb(252, 252, 252)']);
                }
                assert.equal(metrics.columnGap, '0px');
                assert.equal(metrics.borderCollapse, 'collapse');
                assert.equal(metrics.legendOffset, 0);
                if (metrics.fieldsetWidth !== null) {
                    assert.ok(parseFloat(metrics.fieldsetWidth) <= metrics.tableWidth + metrics.fieldsetInset + 1);
                }
                assert.equal(metrics.inlineResists, true);
                assert.equal(metrics.themedCells, true, JSON.stringify(metrics.unexpectedShadows));
                assert.doesNotMatch(metrics.outsideFont, /Final Fantasy I/);
                assert.notEqual(metrics.outsideBackground, 'rgb(0, 0, 252)');
                assert.equal(await references.locator('article.ff-contain > header').count(), 0);
                assert.equal(await references.locator('.ff-class-tooltip, .ff-row:has(> .ff-portrait) [tabindex]').count(), 0);
                assert.equal(await references.locator('tbody th > *').count(), 0);
                // Panel typography, cropped portraits and borders scale together.
                await panel.evaluate(node => node.style.setProperty('--ff-scale', '1'));
                const scaled = await panel.evaluate(node => {
                    const css = getComputedStyle(node);
                    const sprite = getComputedStyle(node.querySelector('.ff-class-sprite'));
                    return [css.fontSize, css.lineHeight, css.borderTopWidth, sprite.width, sprite.height, css.textShadow, getComputedStyle(node.querySelector('tbody th')).textShadow];
                });
                assert.deepEqual(scaled, ['8px', '12px', '1px', '16px', '12px', 'rgb(0, 0, 0) 1px 1px 0px', 'rgb(0, 0, 0) 1px 1px 0px']);
            }
            const link = references.locator('.ff-ui a').first();
            if (await link.count()) {
                const linkStyle = () => link.evaluate(node => {
                    const css = getComputedStyle(node);
                    return {color: css.color, decoration: css.textDecorationLine, outline: css.outlineStyle, focus: node.matches(':focus-visible')};
                });
                assert.equal((await linkStyle()).color, 'rgb(248, 184, 0)');
                assert.equal((await linkStyle()).decoration, 'none');
                await link.focus();
                await references.keyboard.press('Tab');
                await references.keyboard.press('Shift+Tab');
                const focused = await linkStyle();
                assert.equal(focused.focus, true);
                assert.equal(focused.color, 'rgb(0, 252, 252)');
                assert.equal(focused.outline, 'solid');
                assert.equal(focused.decoration, 'none');
                await references.locator('fieldset.ff-ui.ff-panel > legend').first().click();
                await link.hover();
                assert.equal((await linkStyle()).color, 'rgb(0, 252, 252)');
                await references.mouse.down();
                assert.equal((await linkStyle()).color, 'rgb(252, 252, 252)');
                await references.mouse.move(0, 0);
                await references.mouse.up();
            }
        }
        if (process.env.FF_REFERENCE_SCREENSHOT) {
            await references.goto(new URL('../Weapons/', url).href);
            await references.evaluate(() => document.fonts.ready);
            await references.screenshot({path: process.env.FF_REFERENCE_SCREENSHOT});
        }
        assert.deepEqual(errors, []);
        console.log('Firefox: save round-trips, native editor, ROM glyphs, form values, no-JavaScript behavior, panel boundaries, palette and scaling passed.');
    } finally {
        await browser.close();
    }
})().catch(error => {
    console.error(error);
    process.exitCode = 1;
});
