<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="/data">
		<html>
			<head>
				<title>Slothsoft Music Stuff</title>
				<style type="text/css"><![CDATA[
html {
	overflow-y: scroll;
}
details {
	margin: 1em;
}
summary {
	font-size: 2em;
}
.audio {
	text-align: center;
	margin: 1em;
}
.lyrics {
	display: table;
	width: 100%;
	border-spacing: 1em;
	margin: 0 -1em;
}
.lyrics > * {
	border: 2px silver ridge;
	padding: 0.5em;
	margin: 0.5em;
	vertical-align: top;
	display: table-cell;
	width: 50em;
	white-space: pre-wrap;
	background-color: #f7f7f7;
}
				]]></style>
			</head>
			<body>
				<!--<xsl:copy-of select="."/>-->
				<xsl:apply-templates select="resourceDir[@name = 'music-mp3']"/>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="resourceDir">
		<xsl:variable name="name" select="substring-before(@path, '.')"/> 
		<xsl:variable name="lyricsList" select="//resourceDir[@name = 'music-lyrics']"/>
		<details>
			<summary>
				<xsl:value-of select="$name"/>
			</summary>
			<div class="audio">
				<audio controls="controls" preload="none">
					<source src="{@uri}?dnt=false" type="audio/mpeg"/>
				</audio>
			</div>
			<div class="lyrics">
				<xsl:for-each select="$lyricsList[starts-with(@path, $name)]">
					<pre><xsl:value-of select="."/></pre>
				</xsl:for-each>
			</div>
		</details>
	</xsl:template>
</xsl:stylesheet>
				