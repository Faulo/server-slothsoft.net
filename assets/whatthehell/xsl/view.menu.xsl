<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/2000/svg" xmlns:svg="http://www.w3.org/2000/svg"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink">


	<xsl:template match="menu">
		<xsl:param name="x" select="0" />
		<xsl:param name="y" select="0" />
		<xsl:param name="lineHeight" select="20" />
		<xsl:param name="lineWidth" select="175" />
		<svg buffer-rendering="static">
			<xsl:attribute name="width">
				<xsl:value-of select="@width" />
			</xsl:attribute>
			<xsl:if test="@id">
				<xsl:attribute name="data-menu">
					<xsl:value-of select="@id" />
				</xsl:attribute>
			</xsl:if>
			<!-- <xsl:attribute name="transform"> <xsl:text>translate(</xsl:text> <xsl:value-of select="$x"/> <xsl:text>,</xsl:text> 
				<xsl:value-of select="$y"/> <xsl:text>)</xsl:text> </xsl:attribute> <rect width="400" height="400" fill="silver"/> -->
			<xsl:for-each select="title">
				<text text-anchor="middle" x="50%" class="green" font-size="0.95em" text-decoration="underline">
					<xsl:attribute name="y">
						<xsl:value-of select="$lineHeight * position() + 30" />
					</xsl:attribute>
					<xsl:value-of select="." />
				</text>
			</xsl:for-each>
			<xsl:for-each select="button">
				<g class="menu-button">
					<xsl:attribute name="transform">
						<xsl:text>translate(0,</xsl:text>
						<xsl:value-of select="2 * $lineHeight * position() + 100" />
						<xsl:text>)</xsl:text>
					</xsl:attribute>
					<!--<rect width="200" height="{$lineHeight / 2}" fill="white" x="50%" transform="translate(100, {$lineHeight / 4})"/> -->
					<rect fill="white" x="50%" data-action="{@action}">
						<xsl:attribute name="width">
							<xsl:value-of select="$lineWidth" />
						</xsl:attribute>
						<xsl:attribute name="height">
							<xsl:value-of select="$lineHeight + 4" />
						</xsl:attribute>
						<xsl:attribute name="transform">
							<xsl:text>translate(-</xsl:text>
							<xsl:value-of select="$lineWidth div 2" />
							<xsl:text>,-</xsl:text>
							<xsl:value-of select="$lineHeight" />
							<xsl:text>)</xsl:text>
						</xsl:attribute>
					</rect>
					<text text-anchor="middle" x="50%" class="cyan" font-size="0.90em">
						<xsl:value-of select="@title" />
					</text>
				</g>
			</xsl:for-each>

		</svg>
	</xsl:template>

</xsl:stylesheet>