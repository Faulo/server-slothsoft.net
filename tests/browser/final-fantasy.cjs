// Run inside DDEV against a host configured with the private US ROM and save.
const assert = require('node:assert/strict');
const {firefox} = require(process.env.FF_PLAYWRIGHT_MODULE || 'playwright');

(async () => {
    const browser = await firefox.launch({headless: true});
    try {
        const page = await browser.newPage({ignoreHTTPSErrors: true, viewport: {width: 1500, height: 1000}});
        const errors = [];
        page.on('pageerror', error => errors.push(error.message));
        const url = process.env.FF_EDITOR_URL || 'https://slothsoft.ddev.site/FinalFantasy/I/SaveEditor/';
        const loadSave = async (target, waitForFont = true) => {
            await target.goto(url);
            await target.locator('#ff-save').setInputFiles(process.env.FF_SAVE_PATH);
            await Promise.all([target.waitForNavigation(), target.getByRole('button', {name: 'Load save'}).click()]);
            if (waitForFont) {
                await target.evaluate(() => document.fonts.ready);
            }
        };
        await loadSave(page);
        assert.equal(await page.locator('.ff-combobox, .ff-choice').count(), 0);
        assert.equal(await page.locator('.ff-item-picker select:visible').count(), 32);
        const select = page.locator('#ff-0-weapons-0');
        assert.equal(await select.locator('option').count(), 41);
        await select.selectOption('1');
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
                [0x1F9E4, 0xDD], [0x1F48D, 0xDE], [0x1F455, 0xDF], [0x1F9F4, 0xE1]];
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
        await select.selectOption('4');
        assert.equal(await select.inputValue(), '4');
        assert.equal(await select.evaluate(node => new FormData(node.form).get(node.name)), '4');
        await select.focus();
        await select.press('End');
        await select.press('Enter');
        assert.equal(await select.inputValue(), '40');
        const fallback = await browser.newPage({ignoreHTTPSErrors: true, javaScriptEnabled: false});
        await loadSave(fallback, false);
        assert.equal(await fallback.locator('#ff-0-weapons-0').isVisible(), true);
        assert.equal(await fallback.locator('#ff-0-weapons-0 option[value="1"]').textContent(), 'Wooden\u{1F962}');
        // Site copy must stay outside the themed panels; every panel control uses FF typography.
        assert.equal(await page.locator('article.final-fantasy > header').count(), 0);
        const controlStyles = await page.locator('.ff-ui').first().evaluate(panel => {
            const nodes = [panel, ...panel.querySelectorAll('label, input, button, select, option')];
            return nodes.map(node => {
                const css = getComputedStyle(node);
                return {font: css.fontFamily, size: css.fontSize, color: css.color, background: css.backgroundColor};
            });
        });
        for (const css of controlStyles) {
            assert.match(css.font, /Final Fantasy I/);
            assert.equal(css.size, '16px');
            assert.equal(css.color, 'rgb(252, 252, 252)');
        }
        await page.setViewportSize({width: 390, height: 1000});
        assert.ok((await select.boundingBox()).width >= 128, 'The narrow editor must leave room for item names');
        assert.equal(await page.evaluate(() => document.body.scrollWidth <= innerWidth), true);
        const references = await browser.newPage({ignoreHTTPSErrors: true, viewport: {width: 1500, height: 1000}});
        for (const route of ['Weapons', 'Armor', 'Spells']) {
            await references.goto(new URL(`../${route}/`, url).href);
            await references.evaluate(() => document.fonts.ready);
            const panel = references.locator('.ff-ui.ff-table');
            const metrics = await panel.evaluate(node => {
                const css = getComputedStyle(node);
                const sprite = getComputedStyle(node.querySelector('.ff-class-sprite'));
                const cells = [...node.querySelectorAll('th, td, caption, a')];
                return {
                    size: css.fontSize, line: css.lineHeight, border: css.borderTopWidth,
                    spriteWidth: sprite.width, spriteHeight: sprite.height,
                    themedCells: cells.every(cell => {
                        const style = getComputedStyle(cell);
                        return style.fontFamily.includes('Final Fantasy I') && style.color === 'rgb(252, 252, 252)';
                    }),
                    outsideFont: getComputedStyle(node.closest('article')).fontFamily,
                    outsideBackground: getComputedStyle(node.closest('article')).backgroundColor
                };
            });
            assert.deepEqual([metrics.size, metrics.line, metrics.border, metrics.spriteWidth, metrics.spriteHeight],
                ['16px', '24px', '2px', '32px', '48px']);
            assert.equal(metrics.themedCells, true);
            assert.doesNotMatch(metrics.outsideFont, /Final Fantasy I/);
            assert.notEqual(metrics.outsideBackground, 'rgb(0, 0, 252)');
            assert.equal(await references.locator('article.final-fantasy > header').count(), 0);
            assert.equal(await references.locator('tbody th > *').count(), 0);
            // Verify that changing the multiplier scales font, sprite and borders together.
            await panel.evaluate(node => node.style.setProperty('--ff-scale', '1'));
            const scaled = await panel.evaluate(node => {
                const css = getComputedStyle(node);
                const sprite = getComputedStyle(node.querySelector('.ff-class-sprite'));
                return [css.fontSize, css.lineHeight, css.borderTopWidth, sprite.width, sprite.height];
            });
            assert.deepEqual(scaled, ['8px', '12px', '1px', '16px', '24px']);
        }
        if (process.env.FF_REFERENCE_SCREENSHOT) {
            await references.goto(new URL('../Weapons/', url).href);
            await references.evaluate(() => document.fonts.ready);
            await references.screenshot({path: process.env.FF_REFERENCE_SCREENSHOT});
        }
        assert.deepEqual(errors, []);
        console.log('Firefox: native editor, ROM glyphs, form values, no-JavaScript behavior, panel boundaries, palette and scaling passed.');
    } finally {
        await browser.close();
    }
})().catch(error => {
    console.error(error);
    process.exitCode = 1;
});
