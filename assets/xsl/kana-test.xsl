<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:import href="/getTemplate.php/slothsoft/kana"/>

	<xsl:template match="*/*[@data-cms-name = 'kana.test']/resource">
		<xsl:variable name="testKana" select="testKana"/>
		<form method="GET" action="." class="kanaTest Japanese">
		<script type="application/javascript"><![CDATA[
addEventListener(
	"load",
	function(eve) {
		scrollTo(0, 0);
	},
	false
);
			]]></script>
			<xsl:for-each select="testResult">
				
				<h2>Test Results!</h2>
				<table class="results paintedTable">
					<tbody>
						<tr>
							<xsl:for-each select="kana">
								<td><xsl:value-of select="@name"/></td>
							</xsl:for-each>
						</tr>
						<tr class="input">
							<xsl:for-each select="kana">
								<td data-correct="{@correct}">
									<xsl:value-of select="@input"/>
								</td>
							</xsl:for-each>
						</tr>
						<tr>
							<xsl:for-each select="kana">
								<td>
									<xsl:if test="not(number(@correct))">
										<xsl:value-of select="@latin"/>
									</xsl:if>
								</td>
							</xsl:for-each>
						</tr>
					</tbody>
				</table>
				<strong>
					<samp>
						<xsl:value-of select="count(kana[@input = @latin])"/>
						<xsl:text> / </xsl:text>
						<xsl:value-of select="count(kana)"/>
					</samp>
					correct!
				</strong>
			</xsl:for-each>
			<xsl:for-each select="data">
				<h2>Kana Learning Program</h2>
				<label>
					<span>Transcribe these Kana:</span>
					<input type="text" name="testKana" readonly="readonly" value="{$testKana/@text}"/>
				</label>
				<!--
				<label>
					<input type="text" readonly="readonly" value="{$testKana/@text}" class="kanaStrokeOrder"/>
				</label>
				<label>
					<input type="text" readonly="readonly" value="{$testKana/@text}" class=""/>
				</label>-->
				
				<label>
					<span>Leave one whitespace between each transcription <small>(e.g. "a ka sa ta")</small>:</span>
					<input type="text" name="testLatin" autocomplete="off" autofocus="autofocus"/>
				</label>
				
				<button type="submit">Check</button>
				
				<h2>Generate a test using these Kana:</h2>
				<div class="floatLeft">
					<label>
						Selected:
						<xsl:value-of select="count(kana[@checked])"/>/<xsl:value-of select="count(kana)"/>
					</label>
					<label>
						Number of Kana:
						<input type="number" value="{$testKana/@kanaCount}" name="kanaCount"/>
					</label>
					<ul>
						<li>
							<label>
								<input type="radio" value="hiragana" name="kanaQuery">
									<xsl:if test="$testKana/@kanaQuery = 'hiragana'">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
								Hiragana
							</label>
						</li>
						<li>
							<label>
								<input type="radio" value="katakana" name="kanaQuery">
									<xsl:if test="$testKana/@kanaQuery = 'katakana'">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
								Katakana
							</label>
						</li>
						<li>
							<label>
								<input type="radio" value="hiragana | katakana" name="kanaQuery">
									<xsl:if test="$testKana/@kanaQuery = 'hiragana | katakana'">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
								Hiragana &amp; Katakana
							</label>
						</li>
					</ul>
				</div>
				<xsl:call-template name="kana.table">
					<xsl:with-param name="kanaList" select="kana"/>
					<xsl:with-param name="drawForm" select="true()"/>
				</xsl:call-template>
			</xsl:for-each>
		</form>
	</xsl:template>
</xsl:stylesheet>
