<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template match="/*">
        <div class="Translator UnicodeMapper">
            <article>
                <h2>Unicode Mapper</h2>
                <label>
                    <span>Input your text here...</span>
                    <textarea autofocus="autofocus" />
                </label>
                <fieldset class="paintedBox">
                    <legend>Unicode'd text</legend>
                </fieldset>
            </article>
            <article>
                <h2 class="heading">About</h2>
                <p>This is a text transformation tool that converts letters and digits into their various fancy equivalents of the mighty Unicode.</p>
                <p>
                    I was too lazy to check if these exists for Umlaute (or ß or what have you), so only the 26 letters of the ANSI code page are supported.
                </p>
                <p>
                    <xsl:text>Credit goes to whoever compiled these awesome </xsl:text>
                    <a href="http://www.fileformat.info/info/unicode/category/Ll/list.htm" rel="external">lowercase</a>
                    <xsl:text> and </xsl:text>
                    <a href="http://www.fileformat.info/info/unicode/category/Lu/list.htm" rel="external">uppercase</a>
                    <xsl:text> letter lists!</xsl:text>
                </p>
                <p>
                    ... In case you're wondering, I wrote this to allow for a bit more 𝑣𝑎𝑟𝑖𝑒𝑡𝑦 in Twitter or Tumblr posts. :3
                </p>
            </article>
            <article>
                <h2 class="heading">Changelog</h2>
                <article>
                    <h3>[1.6.1] - 2025-11-29</h3>
                    <p>Rewrote the code to use JavaScript modules, which briefly broke it in Chrome (and related browsers). Should work everywhere again now. :)</p>
                </article>
                <article>
                    <h3>[1.6.0] - 2016-06-01</h3>
                    <p>Brought back underlined text! I had no idea how popular that was. ^^;</p>
                </article>
                <article>
                    <h3>[1.5.0] - 2016-05-29</h3>
                    <p>Revamped the code, changed the available fonts. Underlining and flipping never really worked all that well anyway.</p>
                    <p>
                        <xsl:text>The mapping is now done based on an </xsl:text>
                        <a href="/slothsoft@slothsoft.net/static/unicode-mapper">XML file</a>
                        <xsl:text>.</xsl:text>
                    </p>
                </article>
                <article>
                    <h3>[1.4.0] - 2015-09-18</h3>
                    <p>
                        <xsl:text>No changes to the code, but I added an FAQ. If you have any questions, hit me up at </xsl:text>
                        <a href="mailto:info.slothsoft@gmail.com" rel="author">info.slothsoft@gmail.com</a>
                        <xsl:text>!</xsl:text>
                    </p>
                </article>
                <article>
                    <h3>[1.3.0] - 2013-02-07</h3>
                    <p>u̲n̲d̲e̲r̲l̲i̲n̲i̲n̲'̲ ̲:̲3̲</p>
                </article>
                <article>
                    <h3>[1.2.0] - 2012-12-24</h3>
                    <p>
                        <xsl:text>(╯^_^)╯︵ sdıʃɟǝʃqɐ⊥! Courtesy of </xsl:text>
                        <a href="http://www.fileformat.info/convert/text/upside-down-map.htm" rel="external">fileformat.info</a>
                        <xsl:text>! :D</xsl:text>
                    </p>
                </article>
                <article>
                    <h3>[1.1.0] - 2012-12-23</h3>
                    <p>Now with support for (some) digits! \o/</p>
                    <p>Also, capitals! Though those don't appear to be fully implemented in all browsers. :|</p>
                </article>
                <article>
                    <h3>[1.0.0] - 2012-12-20</h3>
                    <p>Initial release!</p>
                </article>
            </article>
            <article>
                <h2 class="heading">FAQ</h2>
                <details>
                    <summary>Google Chrome can't display these Unicode characters, what's up with that?</summary>
                    <div>
                        <p>
                            This behavior has been described
                            <a href="http://gschoppe.com/uncategorized/fixing-unicode-support-in-google-chrome/" rel="external">in detail by the peeps at gschoppe.com</a>
                            <xsl:text>.</xsl:text>
                        </p>
                        <p>
                            In short, there's
                            <a href="https://code.google.com/p/chromium/issues/detail?id=42984" rel="external">a bug almost as old as Chrome itself</a>
                            and it makes Chrome mess up Unicode when you don't have a font installed that contains all those nifty Unicode symbols you want to display.
                        </p>
                        <p>
                            I did what gschoppe suggested and installed the Code200x fonts, and now Chrome can display these glyphs, tho they look a bit weird:
                            <img src="/slothsoft@slothsoft.net/static/pics/Unicode.Chrome" alt="Chrome, displaying Unicode with the Code2000 font" />
                        </p>
                        <p>
                            For comparison, Firefox (which apparently uses an internal fallback font):
                            <img src="/slothsoft@slothsoft.net/static/pics/Unicode.Firefox" alt="Firefox, displaying Unicode as-is" />
                        </p>
                        <p>
                            Internet Explorer, incidentally, doesn't need any help to display Unicode either:
                            <img src="/slothsoft@slothsoft.net/static/pics/Unicode.InternetExplorer" alt="Internet Explorer, displaying Unicode as-is" />
                        </p>
                        <p>In conclusion, there's nothing you can do to make other people's Chrome see your Unicode messages, but you can at least fix your own Chrome.</p>
                    </div>
                </details>
                <br />
                <details>
                    <summary>What about umlauts or other diacritical funstuff, like öäü, êéè, őű?</summary>
                    <div>
                        <p>
                            These don't exist in the Unicode spec. Most of the glyphs that this tool can output are defined in Unicode code block
                            <a href="http://unicode.org/charts/PDF/U1D400.pdf" rel="external">U1D400</a>
                            <xsl:text>, and the Unicode Standard hasn't bothered to include them yet. A glyph like </xsl:text>
                            <abbr title="MATHEMATICAL BOLD ITALIC SMALL A WITH DIAERESIS probably">
                                <b>
                                    <i>ä</i>
                                </b>
                            </abbr>
                            simply can't be represented in Unicode.*
                        </p>
                        <p>I suspect Unicode will eventually support non-English characters 𝔞𝔠𝔯𝔬𝔰𝔰 𝗮𝗹𝗹 𝒻ℴ𝓃𝓉 𝕤𝕥𝕪𝕝𝕖𝕤, but as of now (version 8.0), we're out of luck.</p>
                        <p>
                            * That's not entirely true. Using what's known as
                            <a href="http://unicodelookup.com/#COMBINING/1" rel="external">combining</a>
                            glyphs in Unicode, you can create all sorts of stuff:
                            <br />
                            ᴀ&#768;𝐚&#769;𝑎&#770;𝒂&#771;𝖺&#838;𝗮&#773;𝒶&#774;𝓪&#775;𝔞&#776;𝕒&#777;
                            <br />
                            ß&#768;ß&#769;ß&#770;ß&#771;ß&#838;ß&#773;ß&#774;ß&#775;ß&#776;ß&#777;
                            <br />
                            ...but that's much less trivial to implement than a simple 1-on-1 lookup, so this tool can't do that.
                        </p>
                    </div>
                </details>
            </article>
        </div>
    </xsl:template>
</xsl:stylesheet>
