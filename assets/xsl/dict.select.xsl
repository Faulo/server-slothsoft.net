<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sfm="http://schema.slothsoft.net/farah/module">

	<xsl:variable name="langList" select="/*/*[@name = 'language-images']/*/*" />
	<xsl:variable name="currentLang" select="/*/*[@name = 'request']/request/@lang" />

	<xsl:template match="/*">
		<ul class="Dictionary">
			<li>
				<xsl:if test="request/@lang = 'de-de'">
					<xsl:attribute name="data-dictionary-selected" />
				</xsl:if>
				<xsl:call-template name="dict.select.drawLink">
					<xsl:with-param name="lang" select="'de-de'" />
				</xsl:call-template>
			</li>
			<li>
				<xsl:if test="request/@lang = 'en-us'">
					<xsl:attribute name="data-dictionary-selected" />
				</xsl:if>
				<xsl:call-template name="dict.select.drawLink">
					<xsl:with-param name="lang" select="'en-us'" />
				</xsl:call-template>
			</li>
		</ul>
	</xsl:template>

	<xsl:template name="dict.select.drawLink">
		<xsl:param name="lang" />
		<a href="?lang={$lang}" rel="alternate" hreflang="{$lang}" title="language:{$lang}" data-dict="@title">
			<img src="{$langList[@name = $lang]/@href}" alt="{$lang}" />
		</a>
	</xsl:template>
</xsl:stylesheet>