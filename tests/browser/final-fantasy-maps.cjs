// Run in DDEV with the private US ROM configured and the package map assets installed.
const assert = require('node:assert/strict');
const {firefox} = require(process.env.FF_PLAYWRIGHT_MODULE || 'playwright');

(async () => {
    const browser = await firefox.launch({headless: true});
    try {
        const page = await browser.newPage({ignoreHTTPSErrors: true, viewport: {width: 1500, height: 1000}});
        const errors = [];
        page.on('pageerror', error => errors.push(error.message));
        for (const [path, count, size] of [['Dungeons/IceCave/', 3, 1024], ['WorldMap/', 1, 4096]]) {
            await page.goto('https://slothsoft.ddev.site/FinalFantasy/I/' + path);
            await page.evaluate(() => document.fonts.ready);
            const images = page.locator('article.ff-contain img.ff-pixel-art');
            assert.equal(await images.count(), count);
            for (const image of await images.all()) {
                await image.scrollIntoViewIfNeeded();
                await image.evaluate(node => node.decode());
                assert.equal(await image.evaluate(node => node.naturalWidth), size);
                assert.equal(await image.evaluate(node => getComputedStyle(node).imageRendering), 'pixelated');
                assert.ok(await image.evaluate(node => node.getBoundingClientRect().width <= node.closest('fieldset').getBoundingClientRect().width));
            }
            await page.locator('article.ff-contain').scrollIntoViewIfNeeded();
            if (process.env.FF_MAP_SCREENSHOTS) {
                await page.screenshot({path: process.env.FF_MAP_SCREENSHOTS + '/' + (count === 3 ? 'ice-cave' : 'world') + '.png', fullPage: true});
            }
            await page.setViewportSize({width: 600, height: 900});
            for (const image of await images.all()) {
                assert.ok(await image.evaluate(node => Math.abs(node.getBoundingClientRect().width - node.getBoundingClientRect().height) < 1));
                assert.ok(await image.evaluate(node => node.getBoundingClientRect().right <= document.documentElement.clientWidth));
            }
            await page.setViewportSize({width: 1500, height: 1000});
        }
        assert.deepEqual(errors, []);
        console.log('Map pages: PNG dimensions, panels, pixel rendering and responsive layout passed in Firefox.');
    } finally {
        await browser.close();
    }
})().catch(error => {
    console.error(error);
    process.exitCode = 1;
});
