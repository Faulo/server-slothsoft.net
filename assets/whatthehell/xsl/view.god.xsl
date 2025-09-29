<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/2000/svg" xmlns:svg="http://www.w3.org/2000/svg"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink">


	<xsl:template match="game">
		<xsl:param name="x" select="0" />
		<xsl:param name="y" select="0" />
		<g class="game-root god" buffer-rendering="static">
			<text y="50" x="400" font-size="1.6em">What The Hell, Human?!</text>
			<g id="map" transform="translate(200, 100)">
				<rect id="frame" width="1000" height="500" y="0" x="0" />
				<g class="map-root" buffer-rendering="static">
					<g class="map-layer" buffer-rendering="static">
						<image width="1000" height="500" xlink:href="/slothsoft@whatthehell/static/background-fort" />
						<g id="items" />
					</g>
				</g>
			</g>
		</g>
	</xsl:template>
</xsl:stylesheet>