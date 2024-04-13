<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/2005/Atom" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="/*">
		<xsl:variable name="notes" select=".//ul[@class='notes']/li"/>
		<xsl:variable name="host" select="*/*/@host"/>
		<feed>
			<title>Deviantart</title>
			
			<!--<link href="{@host}"/><id><xsl:value-of select="@host"/></id>-->
			<updated><xsl:value-of select="$notes[1]/div/span[@class='ts']/@title"/></updated>
			<!--
			<author>
				<name>Anonymous</name>
			</author>
			-->
			
			<!--<id>urn:uuid:60a76c80-d399-11d9-b93C-0003939e0af6</id>-->
			<xsl:for-each select="$notes">
				<xsl:variable name="date" select="div/span[@class='ts']"/>
				<xsl:variable name="dateAbs">
					<xsl:choose>
						<xsl:when test="contains($date, 'ago')">
							<xsl:value-of select="$date/@title"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$date"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="dateRel">
					<xsl:choose>
						<xsl:when test="contains($date, 'ago')">
							<xsl:value-of select="$date"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$date/@title"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="link" select=".//a[@data-folderid='1']"/>
				<xsl:variable name="sender" select=".//a[@class='u']"/>
				<xsl:variable name="message" select=".//div[@class='note-preview expandable']"/>
				<entry>
					<title>
						<xsl:value-of select="$sender"/>
						<xsl:text>: </xsl:text>
						<xsl:value-of select="$dateRel"/>
					</title>
					<link href="{$host}{$link/@href}"/>
					<id><xsl:value-of select="$link/@href"/></id>
					<updated><xsl:value-of select="$dateAbs"/></updated>
					<summary><xsl:value-of select="substring-before($message, '.')"/> ...</summary>
				</entry>
			</xsl:for-each>
		</feed>
	</xsl:template>
</xsl:stylesheet>