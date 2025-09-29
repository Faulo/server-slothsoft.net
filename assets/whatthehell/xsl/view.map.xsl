<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/2000/svg" xmlns:svg="http://www.w3.org/2000/svg"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink">


	<xsl:template match="map">
		<xsl:param name="x" select="0" />
		<xsl:param name="y" select="0" />
		<g class="map-root" buffer-rendering="static">
			<xsl:apply-templates select="*" />
		</g>
	</xsl:template>

	<xsl:template match="layer">
		<g class="map-layer" buffer-rendering="static">
			<image width="1000" height="500" xlink:href="/slothsoft@whatthehell/static/background-fort" />
			<g id="items" />
		</g>
	</xsl:template>

	<xsl:template match="clicky">
		<g>
			<xsl:apply-templates select="path" />
		</g>
	</xsl:template>

	<xsl:template match="path">
		<path data-tooltip="{../@title}" fill="red" fill-opacity="0.5" stroke="black" stroke-linecap="round"
			stroke-linejoin="round" stroke-opacity="0.8">
			<xsl:attribute name="d">
				<xsl:text>M</xsl:text>
				<xsl:value-of select="coord[1]/@x" />
				<xsl:text> </xsl:text>
				<xsl:value-of select="coord[1]/@y" />
				<xsl:for-each select="coord[position() &gt; 1]">
					<xsl:text>L</xsl:text>
					<xsl:value-of select="@x" />
					<xsl:text> </xsl:text>
					<xsl:value-of select="@y" />
				</xsl:for-each>
				<xsl:text>Z</xsl:text>
			</xsl:attribute>
		</path>
	</xsl:template>
	<!-- <xsl:template match="path[@type='circle']"> <circle data-tooltip="{../@title}" fill="red" opacity="0.5" cx="{@x}" cy="{@y}" 
		r="{@r}"/> </xsl:template> -->
</xsl:stylesheet>