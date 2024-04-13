<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:import href="/getTemplate.php/slothsoft/kana"/>

	<xsl:template match="data[not(translator)]">
		<div class="Translator Japanese">
			<script type="application/javascript"><![CDATA[
addEventListener(
	"load",
	function(eve) {
		scrollTo(0, 0);
	},
	false
);
			]]></script>
			
			<xsl:call-template name="translator.root"/>
			<hr/>
			<article>
				<h2>About</h2>
				<article>
					<h3>v1.0 - 20.08.2012</h3>
					<p>This translator is intended to look up Japanese words by their pronunciation. It does so using the excellent dictionary at <a href="http://jisho.org" rel="external">jisho.org</a>.</p>
					<p>To input words, write their latin transcription based on the <a href="../KanaTable/">Hepburn Romanization</a>. Multiple words, separated by space, can be searched simultaneously.</p>
				</article>
				<article>
					<h3>v1.1 - 19.10.2012</h3>
					<p>Thanks to the awesome font from <a href="https://sites.google.com/site/nihilistorguk/" rel="external">nihilistorguk</a> you can see the correct stroke order for the Japanese characters by clicking on the buttons in the last row. (Might take a while for them to appear if you don't have <a href="/getResource.php/slothsoft/fonts/KanjiStrokeOrders">their 17 MB font</a> installed on your system.)
					</p>
				</article>
				<article>
					<h3>v1.2 - 05.12.2012</h3>
					<p>
						Thanks to whoever runs <a href="http://www.csse.monash.edu.au/~jwb/cgi-bin/wwwjdic.cgi?1C" rel="external">www.csse.monash.edu.au</a> you can now hear the Japanese words read aloud, with the little play button in the English row. They don't have sound samples for every word, though.
					</p>
					<p>
						To prevent unnecessary connections to the sound sample server I wrapped the Flash player inside a button. The first click at ► now merely loads the player, the second will play the file.
					</p>
				</article>
				<article>
					<h3>v1.3 - 12.12.2012</h3>
					<p>
						Fixed a couple bugs, searching is now both more exhaustive and faster.
					</p>
					<p>
						It's now possible to input kanji or kana (or whatever) directly. So you could enter, for instance, <samp>tomodachi</samp>, <samp>ともだち</samp>, <samp>友だち</samp> or even <samp>友dachi</samp>.
					</p>
					<p>
						In the katakana row, double vowels will be auto-replaced with vowel + chōonpu.
					</p>
				</article>
				<article>
					<h3>v1.4 - 16.01.2013</h3>
					<p>
						HTML 5 Ruby!
					</p>
					<p data-dict="">vocab/ja/rubyplugin</p>
					<!--
					<p>
						If your browser is Firefox and can't render the 
						<xsl:call-template name="word.ruby">
							<xsl:with-param name="base" select="'振り仮名'"/>
							<xsl:with-param name="top" select="'furigana'"/>
						</xsl:call-template>
						properly, <a href="https://addons.mozilla.org/de/firefox/addon/html-ruby/" >there's a plugin</a> for that.
					</p>
					-->
				</article>
				<article>
					<h3>v1.5 - 22.01.2013</h3>
					<p>
						Slight changes with inputting chōonpu, now both <samp>~</samp> and <samp>-</samp> are supported.
					</p>
				</article>
				<article>
					<h3>v1.6 - 31.01.2014</h3>
					<p>
						HTML5 <code>&lt;audio&gt;</code>! Instead of that abominable Flash. Still many thanks <a href="http://www.csse.monash.edu.au/~jwb/cgi-bin/wwwjdic.cgi?1C" rel="external">www.csse.monash.edu.au</a>!! uwu
					</p>
					<p>
						<small>As per my tests, Safari doesn't support <code>&lt;audio&gt;</code> and/or MP3, sorry about that; <del>that's what you get for using that one I guess.</del></small>
					</p>
				</article>
			</article>
			<article>
				<h2>Usage Examples</h2>
				<table class="translatorForm">	
					<thead>
						<tr>
							<th>Input</th>
							<th>To search for</th>
							<th>Stroke Order</th>
							<th>Audio</th>
						</tr>
					</thead>
					<tbody class="input" xml:lang="ja-jp">
						<tr>
							<td data-parity="0"><samp>tomodachi</samp></td>
							<td>
								<xsl:call-template name="word.ruby">
									<xsl:with-param name="base" select="'友達'"/>
									<xsl:with-param name="top" select="'ともだち'"/>
								</xsl:call-template>
							</td>
							<td>
								<xsl:call-template name="word.strokeOrder">
									<xsl:with-param name="text" select="'友達'"/>
									<xsl:with-param name="expanded" select="true()"/>
								</xsl:call-template>
							</td>
							<td class="audioPlayer">
								<xsl:call-template name="word.audioPlayer">
									<xsl:with-param name="uri" select="'http://assets.languagepod101.com/dictionary/japanese/audiomp3.php?kana=ともだち&amp;kanji=友達'"/>
									<xsl:with-param name="remove" select="true()"/>
								</xsl:call-template>
							</td>
						</tr>
						<tr>
							<td data-parity="0"><samp>kitte</samp></td>
							<td>
								<xsl:call-template name="word.ruby">
									<xsl:with-param name="base" select="'切手'"/>
									<xsl:with-param name="top" select="'きって'"/>
								</xsl:call-template>
							</td>
							<td>
								<xsl:call-template name="word.strokeOrder">
									<xsl:with-param name="text" select="'切手'"/>
								</xsl:call-template>
							</td>
							<td class="audioPlayer">
								<xsl:call-template name="word.audioPlayer">
									<xsl:with-param name="uri" select="'http://assets.languagepod101.com/dictionary/japanese/audiomp3.php?kana=きって&amp;kanji=切手'"/>
									<xsl:with-param name="remove" select="true()"/>
								</xsl:call-template>
							</td>
						</tr>
						<tr>
							<td data-parity="0"><samp>kun'yomi</samp></td>
							<td>
								<xsl:call-template name="word.ruby">
									<xsl:with-param name="base" select="'訓読み'"/>
									<xsl:with-param name="top" select="'くんよみ'"/>
								</xsl:call-template>
							</td>
							<td>
								<xsl:call-template name="word.strokeOrder">
									<xsl:with-param name="text" select="'訓読み'"/>
								</xsl:call-template>
							</td>
							<td class="audioPlayer">
								<xsl:call-template name="word.audioPlayer">
									<xsl:with-param name="uri" select="'http://assets.languagepod101.com/dictionary/japanese/audiomp3.php?kana=くんよみ&amp;kanji=訓読み'"/>
									<xsl:with-param name="remove" select="true()"/>
								</xsl:call-template>
							</td>
						</tr>
						<tr>
							<td data-parity="0"><samp>ra-men</samp> or <samp>raamen</samp></td>
							<td>
								<xsl:call-template name="word.ruby">
									<xsl:with-param name="base" select="'拉麺'"/>
									<xsl:with-param name="top" select="'ラーメン'"/>
								</xsl:call-template>
							</td>
							<td>
								<xsl:call-template name="word.strokeOrder">
									<xsl:with-param name="text" select="'拉麺'"/>
								</xsl:call-template>
							</td>
							<td class="audioPlayer">
								<xsl:call-template name="word.audioPlayer">
									<xsl:with-param name="uri" select="'http://assets.languagepod101.com/dictionary/japanese/audiomp3.php?kana=ラーメン&amp;kanji='"/>
									<xsl:with-param name="remove" select="true()"/>
								</xsl:call-template>
							</td>
						</tr>
					</tbody>
				</table>
			</article>
			
		</div>
	</xsl:template>
	
	
	
</xsl:stylesheet>
