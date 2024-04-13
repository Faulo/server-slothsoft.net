<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:template match="/data">
		<pre>
			<xsl:apply-templates select="*"/>
		</pre>
	</xsl:template>
	
	<xsl:template match="sheet">
		<xsl:apply-templates select="rule"/>
	</xsl:template>
	
	<xsl:template match="rule[@type = 'style']">
		<xsl:value-of select="@selector"/>
		<xsl:text> {
</xsl:text>
		<xsl:apply-templates select="property"/>
		<xsl:text>}
</xsl:text>
	</xsl:template>
	<xsl:template match="property">
		<xsl:text>	</xsl:text>
		<xsl:value-of select="@name"/>
		<xsl:text>: </xsl:text>
		<xsl:value-of select="@value"/>
		<xsl:text>;
</xsl:text>
	</xsl:template>
</xsl:stylesheet>
