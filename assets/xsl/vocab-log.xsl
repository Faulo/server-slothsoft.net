<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:import href="/getTemplate.php/slothsoft/kana"/>
	
	<xsl:template match="/data/data">
		<div>
			<xsl:apply-templates select="testDates">
				<xsl:with-param name="dayCount" select="31"/>
			</xsl:apply-templates>
		</div>
	</xsl:template>
</xsl:stylesheet>