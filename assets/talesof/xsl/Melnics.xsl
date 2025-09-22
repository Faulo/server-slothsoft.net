<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sfm="http://schema.slothsoft.net/farah/module">

	<xsl:import href="farah://slothsoft@farah/xsl/module" />

	<xsl:template match="/*">
		<div>
			<xsl:apply-templates select="sfm:error" mode="sfm:html" />
			<xsl:for-each select="*[@name = 'melnics.test']">
				<xsl:apply-templates select="test" />
			</xsl:for-each>
		</div>
	</xsl:template>
	
	<xsl:template match="test">
		<form method="POST" action="." class="melnicsTest" data-dict=".//html:h2/text() | .//html:span/node()"
			data-media="screen">

			<script type="application/javascript"><![CDATA[
addEventListener(
	"load",
	function(eve) {
		scrollTo(0, 0);
	},
	false
);
			]]></script>
			<h2>About</h2>
			<p class="Melnics">
				If you can read this then you are either awesome or your browser does not support the downloading of the MelniksFont
				in either
				<a href="/slothsoft@slothsoft.net/talesof/static/fonts/MelniksFont.ttf">TTF</a>
				,
				<a href="/slothsoft@slothsoft.net/talesof/static/fonts/MelniksFont.otf">OTF</a>
				or
				<a href="/slothsoft@slothsoft.net/talesof/static/fonts/MelniksFont.svg">SVG</a>
				.
			</p>
			<p>
				Credit for the font belongs to
				<a href="http://park10.wakwak.com/~yuki/font.html" rel="external">Yuki Ishimaru</a>
				! \o/
			</p>
			<p>
				The transcription table also exists as
				<a href="../MelnicsTable/">standalone thing</a>
				. /o/
			</p>
			<xsl:for-each select="testResult">
				<h2>Test Results!</h2>
				<table class="results paintedTable">
					<tbody>
						<tr class="Melnics">
							<xsl:for-each select="character">
								<xsl:variable name="correct" select="number(@input = @latin)" />
								<td data-correct="{$correct}">
									<xsl:value-of select="@name" />
								</td>
							</xsl:for-each>
						</tr>
						<tr class="input">
							<xsl:for-each select="character">
								<xsl:variable name="correct" select="number(@input = @latin)" />
								<td data-correct="{$correct}">
									<xsl:value-of select="@input" />
								</td>
							</xsl:for-each>
						</tr>
						<tr>
							<xsl:for-each select="character">
								<xsl:variable name="correct" select="number(@input = @latin)" />
								<td data-correct="{$correct}">
									<xsl:if test="not($correct)">
										<xsl:value-of select="@latin" />
									</xsl:if>
								</td>
							</xsl:for-each>
						</tr>
					</tbody>
				</table>
				<strong>
					<samp>
						<xsl:value-of select="count(character[@input = @latin])" />
						<xsl:text> / </xsl:text>
						<xsl:value-of select="count(character)" />
					</samp>
					<p data-dict=".">correct!</p>
				</strong>
			</xsl:for-each>
			<h2>Melnics Learning Program</h2>
			<label>
				<span>Transcribe these Melnic characters:</span>
				<input type="text" name="testOutput" value="{testOutput/@text}" class="Melnics" />
			</label>
			<label>
				<span>Leave one whitespace between each transcription (e.g. "a b c d"):</span>
				<input type="text" name="testInput" autocomplete="off" autofocus="autofocus" />
			</label>

			<button type="submit" data-dict="">Check</button>
			<hr />
		</form>
		<h2 class="Melnics">The Melnics Alphabet</h2>
		<!-- <dl class="melnicsTable"> <xsl:for-each select="character"> <xsl:variable name="lowerChar" select="@name"/> <xsl:variable 
			name="upperChar" select="translate($lowerChar,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/> <dt class="Melnics"><xsl:value-of 
			select="$lowerChar"/></dt> <dd><xsl:value-of select="$lowerChar"/></dd> <xsl:if test="$lowerChar != $upperChar"> <dt class="Melnics"><xsl:value-of 
			select="$upperChar"/></dt> <dd><xsl:value-of select="$upperChar"/></dd> </xsl:if> </xsl:for-each> </dl> -->
		<table class="melnicsTable" border="1">
			<tbody>
				<xsl:for-each select="character">
					<xsl:variable name="lowerChar" select="@name" />
					<xsl:variable name="upperChar"
						select="translate($lowerChar,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')" />
					<xsl:if test="$lowerChar != $upperChar">
						<tr>
							<td class="Melnics">
								<xsl:value-of select="$lowerChar" />
							</td>
							<td>
								<xsl:value-of select="$lowerChar" />
							</td>
							<td>
								<xsl:value-of select="$upperChar" />
							</td>
							<td class="Melnics">
								<xsl:value-of select="$upperChar" />
							</td>
						</tr>
					</xsl:if>
				</xsl:for-each>
			</tbody>
		</table>
		<table class="melnicsTable" border="1">
			<tbody>
				<xsl:for-each select="character">
					<xsl:variable name="lowerChar" select="@name" />
					<xsl:variable name="upperChar"
						select="translate($lowerChar,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')" />
					<xsl:if test="$lowerChar = $upperChar">
						<tr>
							<td class="Melnics">
								<xsl:value-of select="$lowerChar" />
							</td>
							<td>
								<xsl:value-of select="$lowerChar" />
							</td>
						</tr>
					</xsl:if>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>
</xsl:stylesheet>
