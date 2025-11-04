<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sfm="http://schema.slothsoft.net/farah/module">

	<xsl:import href="farah://slothsoft@farah/xsl/module" />

	<xsl:template match="/*">
		<div class="Translator MelnicsTranslator">
			<xsl:apply-templates select="sfm:error" mode="sfm:html" />
			<script type="module"><![CDATA[
import DOM from "/slothsoft@farah/js/DOM";
import Translator from "/slothsoft@slothsoft.net/talesof/js/MelnicsTranslator";

DOM
    .loadDocumentAsync("/slothsoft@slothsoft.net/talesof/static/Melnics")
    .then(dataDoc => {
        window.MelnicsTranslator = new Translator(document.querySelector(".MelnicsTranslator"), dataDoc);
    });
]]></script>
			<article>
				<h2>Melnics Translator</h2>
				<label>
					<span>
						<em>Pronunciation:</em>
						Input latin transcription of spoken Melnics here....
					</span>
					<textarea placeholder="baiba!" data-translator-type="melnics" class="input-melnics" oninput="MelnicsTranslator.typeCharacter(this)" autofocus="autofocus" />
				</label>
				<label>
					<span>
						<em>Meaning:</em>
						Input English text to be melnicsized here....
					</span>
					<textarea placeholder="wow!" data-translator-type="english" class="input-english" oninput="MelnicsTranslator.typeCharacter(this)" />
				</label>
				<label>
					<span>
						<em>Spelling:</em>
						Actual Melnics...
					</span>
					<textarea placeholder="wow!" class="output-english Melnics" readonly="readonly" />
				</label>
			</article>
			<hr />
			<article>
				<h2>About</h2>
				<article>
					<h3>[1.0.3] - 2025-11-04</h3>
					<p>
						<xsl:text>I've gotten multiple requests for an offline version of this tool, so I put together a </xsl:text>
						<a href="Standalone/">single-page version</a>
						<xsl:text>. It's still HTML, just without all the networking.</xsl:text>
					</p>
					<p>
						<xsl:text>To use it, either right-click on the link and use "save target as", or open the page and find "save page as" somewhere in your browser's menus. Either way, it should come out as a single file called "transformation.xhtml".</xsl:text>
					</p>
					<p>Have fun!</p>
				</article>
				<article>
					<h3>[1.0.2] - 2025-10-25</h3>
					<p>
						<xsl:text>Some of you have asked for a copy of the Melnics font that is used here. I can't tell where I got it from anymore sadly, but if you want to use it yourself, you can just use my copy:</xsl:text>
					</p>
					<p>
						<xsl:text>📥 </xsl:text>
						<a href="/slothsoft@slothsoft.net/talesof/static/fonts/MelniksFont.ttf">MelniksFont.ttf</a>
					</p>
					<p>
						<small>
							<xsl:text>(I'm pretty sure the font was distributed freely when I got it; if YOU are the owner of that copyright and want to chat about my usage of your intellectual property, hit me up at </xsl:text>
							<a href="mailto:info.slothsoft@gmail.com">info.slothsoft@gmail.com</a>
							<xsl:text>!)</xsl:text>
						</small>
					</p>
				</article>
				<article>
					<h3>[1.0.1] - 2025-03-22</h3>
					<p>
						<xsl:text>I finally noticed the complaints in chat, and restored the translator to its former glory. Sorry about that.</xsl:text>
					</p>
					<p>
						<xsl:text>I'm glad that somebody is getting some enjoyment out of this though! Thank you so much for letting me know!</xsl:text>
					</p>
				</article>
				<article>
					<h3>[1.0.0] - 2013-08-24</h3>
					<p>
						<a href="http://aselia.wikia.com/wiki/Melnics" rel="external">Melnics</a>
						<xsl:text>, or, as some like to call it, </xsl:text>
						<a href="/slothsoft@slothsoft.net/talesof/static/Londau" rel="external">Londau</a>
						<xsl:text>, is the language used by some folks in Tales of Eternia and Tales of Xillia.</xsl:text>
					</p>
					<p>
						<xsl:text>The "spoken Melnics" must be given as Hepburn-transcribed Japanese, with the exception that </xsl:text>
						<q>ヅ</q>
						<xsl:text> is written as </xsl:text>
						<q>dzu</q>
						<xsl:text>.</xsl:text>
					</p>
					<p>
						Also, the Melnics sequence
						<q>ne</q>
						must be written as
						<q>ne</q>
						when they mean
						<q>ネ</q>
						, and as
						<q>n'e</q>
						when they mean
						<q>ンエ</q>
						.
					</p>
					<p>
						Example Input:
						<br />
						<q>Ufu yaiodin din'edzuumugu tiausu, yaio aenun tiii towaa fudinn tiutoun.</q>
					</p>
				</article>
			</article>
		</div>
	</xsl:template>

	<xsl:template match="translator/translation" name="translator.output">
		<tbody class="output">
			<tr class="hiragana">
				<th rowspan="4">Output</th>
				<th>Kana</th>
				<xsl:for-each select="word">
					<td colspan="{@syllables}" data-parity="{(1 + position()) mod 2}">
						<ul>
							<xsl:for-each select="kana">
								<li>
									<xsl:call-template name="translator.link">
										<xsl:with-param name="kana" select="@name" />
										<!--<xsl:with-param name="player" select="@player-uri"/> -->
									</xsl:call-template>
								</li>
							</xsl:for-each>
						</ul>
					</td>
				</xsl:for-each>
			</tr>
			<tr class="kanji">
				<th>Kanji</th>
				<xsl:for-each select="word">
					<td colspan="{@syllables}" data-parity="{(1 + position()) mod 2}">
						<ul>
							<xsl:for-each select="kana/kanji[string-length(@name) &gt; 0]">
								<li>
									<xsl:call-template name="translator.link">
										<xsl:with-param name="kana" select="@name" />
										<!--<xsl:with-param name="player" select="@player-uri"/> -->
									</xsl:call-template>
								</li>
							</xsl:for-each>
						</ul>
					</td>
				</xsl:for-each>
			</tr>
			<tr class="english">
				<th>English</th>
				<xsl:for-each select="word">
					<td colspan="{@syllables}" data-parity="{(1 + position()) mod 2}">
						<dl>
							<xsl:for-each select="kana/kanji">
								<dt xml:lang="ja-jp">
									<xsl:variable name="player">
										<xsl:choose>
											<xsl:when test="string-length(@name) = 0">
												<xsl:value-of select="../@player-uri" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="@player-uri" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:variable name="base">
										<xsl:choose>
											<xsl:when test="string-length(@name) = 0">
												<xsl:value-of select="../@name" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="@name" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:variable name="top">
										<xsl:choose>
											<xsl:when test="string-length(@name) = 0">
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="../@name" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<!-- <xsl:call-template name="word.complete"> <xsl:with-param name="lang" select="'ja-jp'" /> <xsl:with-param name="audio" select="$player" /> <xsl:with-param name="base" select="$base" /> <xsl:with-param 
										name="top" select="$top" /> </xsl:call-template> -->
									<!-- <xsl:variable name="player"> <xsl:choose> <xsl:when test="string-length(@name) = 0"> <xsl:value-of select="../@player-uri"/> </xsl:when> <xsl:otherwise> <xsl:value-of select="@player-uri"/> 
										</xsl:otherwise> </xsl:choose> </xsl:variable> <xsl:call-template name="word.audioPlayer"> <xsl:with-param name="uri" select="$player"/> </xsl:call-template> <xsl:value-of select="@name"/> <xsl:if test="string-length(@name) 
										= 0"> <xsl:value-of select="../@name"/> </xsl:if> -->
								</dt>
								<dd>
									<xsl:copy-of select="english/node()" />
									<!-- <ul> <xsl:for-each select="english"> <li><xsl:copy-of select="node()"/></li> </xsl:for-each> </ul> -->
								</dd>
							</xsl:for-each>
						</dl>
					</td>
				</xsl:for-each>
			</tr>
			<tr class="strokeOrder">
				<th>Stroke Order</th>
				<xsl:for-each select="word">
					<td colspan="{@syllables}" data-parity="{(1 + position()) mod 2}">
						<ul>
							<xsl:variable name="charList" select="kana/@name | kana/kanji/@name" />
							<xsl:for-each select="$charList[string-length(.) &gt; 0]">
								<li>
									<!-- <xsl:call-template name="word.strokeOrder"> <xsl:with-param name="text" select="." /> </xsl:call-template> -->
								</li>
							</xsl:for-each>
						</ul>
					</td>
				</xsl:for-each>
			</tr>
		</tbody>
	</xsl:template>

	<xsl:template name="translator.link">
		<xsl:param name="kana" select="string(.)" />
		<xsl:param name="player" select="/.." />
		<xsl:variable name="sourceURI" select="/*/*/@sourceURI" />
		<xsl:variable name="playerURI" select="/*/*/@playerURI" />
		<xsl:if test="$player">
			<!-- <a href="{$player}">►</a> <xsl:text> </xsl:text> -->
			<iframe src="{$player}" class="player" />
		</xsl:if>
		<a href="{$sourceURI}{$kana}">
			<xsl:value-of select="$kana" />
		</a>
	</xsl:template>

</xsl:stylesheet>
