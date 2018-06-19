<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:template match="data">
		<div class="Translator UnicodeMapper">
			<article>
				<h2>Unicode Mapper</h2>
				<label>
					<span>Input your text here...</span>
					<textarea oninput="UnicodeMapper.typeCharacter(this)" autofocus="autofocus"/>
				</label>
				<fieldset class="paintedBox">
					<legend>Unicode'd text</legend>
				</fieldset>
			</article>
			<hr/>
			<article>
				<h2>About</h2>
				<article>
					<h3>v1.0 - 20.12.2012</h3>
					<p>This is a text transformation program that converts letters into various fancy equivalents of the Mighty Unicode.</p>
					<p>
					I was too lazy to check if these exists for Umlaute (or ß or what have you), so only the 26 letters of the ANSI code page are supported.
					</p>
					<p>
					Credit goes to whoever compiled these awesome <a href="http://www.fileformat.info/info/unicode/category/Ll/list.htm" rel="external">lowercase</a> and <a href="http://www.fileformat.info/info/unicode/category/Lu/list.htm" rel="external">uppercase</a> letter lists!
					</p>
					<p>
					... In case you're wondering, I wrote this to allow for a bit more 𝑣𝑎𝑟𝑖𝑒𝑡𝑦 in Twitter or Tumblr posts. :3
					</p>
				</article>
				<article>
					<h3>v1.1 - 23.12.2012</h3>
					<p>Now with support for (some) digits! \o/</p>
					<p>Also, capitals! Though those don't appear to be fully implemented in all browsers. :|</p>
				</article>
				<article>
					<h3>v1.2 - 24.12.2012</h3>
					<p>(╯^_^)╯︵ sdıʃɟǝʃqɐ⊥! Courtesy of <a href="http://www.fileformat.info/convert/text/upside-down-map.htm" rel="external">fileformat.info</a>! :D</p>
				</article>
				<article>
					<h3>v1.3 - 07.02.2013</h3>
					<p>u̲n̲d̲e̲r̲l̲i̲n̲i̲n̲'̲ ̲:̲3̲</p>
				</article>
				<article>
					<h3>v1.4 - 18.09.2015</h3>
					<p>No changes to the code, but I added an FAQ. If you have any questions, hit me up at <a href="mailto:info.slothsoft@gmail.com" rel="author">info.slothsoft@gmail.com</a>!</p>
				</article>
				<article>
					<h3>v1.5 - 29.05.2016</h3>
					<p>Revamped the code, changed the available fonts. Underlining and flipping never really worked all that well anyway.</p>
					<p>The mapping is now done based on an <a href="/getResource.php/slothsoft/unicode-mapper">XML file</a>.</p>
				</article>
				<article>
					<h3>v1.6 - 01.06.2016</h3>
					<p>Brought back underlined text! I had no idea how popular that was. ^^;</p>
				</article>
			</article>
			<article>
				<h2>FAQ</h2>
				<details>
					<summary>Google Chrome can't display these Unicode characters, what's up with that?</summary>
					<div>
						<p>This behavior has been described <a href="http://gschoppe.com/uncategorized/fixing-unicode-support-in-google-chrome/" rel="external">in detail by the peeps at gschoppe.com</a>.</p>
						<p>In short, there's <a href="https://code.google.com/p/chromium/issues/detail?id=42984" rel="external">a bug almost as old as Chrome itself</a> and it makes Chrome mess up Unicode when you don't have a font installed that contains all those nifty Unicode symbols you want to display.</p>
						<p>I did what gschoppe suggested and installed the Code200x fonts, and now Chrome can display these glyphs, tho they look a bit weird:
							<img src="/getResource.php/slothsoft/pics/Unicode.Chrome" alt="Chrome, displaying Unicode with the Code2000 font" />
						</p>
						<p>For comparison, Firefox (which apparently uses an internal fallback font):
							<img src="/getResource.php/slothsoft/pics/Unicode.Firefox" alt="Firefox, displaying Unicode as-is" />
						</p>
						<p>Internet Explorer, incidentally, doesn't need any help to display Unicode either:
							<img src="/getResource.php/slothsoft/pics/Unicode.InternetExplorer" alt="Internet Explorer, displaying Unicode as-is" />
						</p>
						<p>In conclusion, there's nothing you can do to make other people's Chrome see your Unicode messages, but you can at least fix your own Chrome.</p>
					</div>
				</details>
				<br/>
				<details>
					<summary>What about umlauts or other diacritical funstuff, like öäü, êéè, őű?</summary>
					<div>
						<p>These don't exist in the Unicode spec. Most of the glyphs that this tool can output are defined in Unicode code block <a href="http://unicode.org/charts/PDF/U1D400.pdf" rel="external">U1D400</a>, and the Unicode Standard hasn't bothered to include them yet. A glyph like <abbr title="MATHEMATICAL BOLD ITALIC SMALL A WITH DIAERESIS probably"><b><i>ä</i></b></abbr> simply can't be represented in Unicode.*</p>
						<p>I suspect Unicode will eventually support non-English characters 𝔞𝔠𝔯𝔬𝔰𝔰 𝗮𝗹𝗹 𝒻ℴ𝓃𝓉 𝕤𝕥𝕪𝕝𝕖𝕤, but as of now (version 8.0), we're out of luck.</p>
						<p>* That's not entirely true. Using what's known as <a href="http://unicodelookup.com/#COMBINING/1" rel="external">combining</a> glyphs in Unicode, you can create all sorts of stuff:<br/>
ᴀ&#768;𝐚&#769;𝑎&#770;𝒂&#771;𝖺&#838;𝗮&#773;𝒶&#774;𝓪&#775;𝔞&#776;𝕒&#777;<br/>
ß&#768;ß&#769;ß&#770;ß&#771;ß&#838;ß&#773;ß&#774;ß&#775;ß&#776;ß&#777;<br/>
...but that's much less trivial to implement than a simple 1-on-1 lookup, so this tool can't do that.
						</p>
					</div>
				</details>
			</article>
		</div>
	</xsl:template>
</xsl:stylesheet>
