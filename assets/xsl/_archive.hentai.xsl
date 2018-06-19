<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:variable name="icon-up" select="'⇧'"/>
	<xsl:variable name="icon-right" select="'⇨'"/>
	<xsl:variable name="icon-left" select="'⇦'"/>
	
	<xsl:variable name="requestedPage" select="/data/request/page[1]"/>
	
	<xsl:template match="/data/data">
		<html>
			<head>
				<title>Slothsoft Archive - <xsl:value-of select="$requestedPage/@title"/></title>
			</head>
			<body class="hentai">
				<section id="_toc">
					<nav>
						<h1>Slothsoft's Secret <xsl:value-of select="$requestedPage/@title"/></h1>
						<div class="pages">
							<xsl:apply-templates select="page" mode="navi"/>
						</div>
					</nav>
				</section>
				<section id="_list">
					<div class="list">
						<xsl:apply-templates select="folder" mode="list"/>
					</div>
				</section>
				<section>
					<nav>
						<div class="pages">
							<xsl:apply-templates select="page" mode="navi"/>
						</div>
					</nav>
				</section>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="page" mode="navi">
		<a href="{@uri}" class="{@active}"><xsl:value-of select="position()"/></a>
	</xsl:template>
	
	<xsl:template match="folder" mode="list">
		<div id="folder-{@id}">
			<h2>
				<!--
				<a href="#_toc"><xsl:copy-of select="$icon-up"/></a>
				<span><xsl:value-of select="substring-before(@name, ' ')"/></span>
				-->
				<input readonly="readonly" value="{@uri}"/>
				<!--<textarea><xsl:value-of select="@uri"/></textarea>-->
			</h2>
			<xsl:apply-templates select="file[position() &lt; 8 and position() mod 2 = 1]" mode="list"/>
		</div>
	</xsl:template>
	
	<xsl:template match="file" mode="list">
		<a href="{@href}"><img src="{@href}"/></a>
	</xsl:template>
</xsl:stylesheet>
				