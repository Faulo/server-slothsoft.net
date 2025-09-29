<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/2000/svg" xmlns:svg="http://www.w3.org/2000/svg"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink">


	<xsl:template match="game">
		<xsl:param name="x" select="0" />
		<xsl:param name="y" select="0" />
		<g class="game-root human" buffer-rendering="static">
			<text y="50" x="400" font-size="1.6em">What The Hell, God!?</text>
			<svg id="map" x="200" y="100" clip-path="url(#cp-map)">
				<rect id="frame" width="1000" height="500" y="0" x="0" fill="white" />
			</svg>
		</g>
	</xsl:template>
</xsl:stylesheet>