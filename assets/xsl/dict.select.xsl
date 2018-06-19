<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:sfm="http://schema.slothsoft.net/farah/module">
	
	<xsl:variable name="langList" select="/*/*[@name = 'language-images']/*/*"/>
	<xsl:variable name="currentLang" select="/*/*[@name = 'request']/request/@lang"/>
	
	<xsl:template match="/*">
		<!--
		<details class="Dictionary">
			<summary>
				<xsl:copy-of select="$langList[@name = concat('lang-', $currentLang)]/*"/>
			</summary>
		-->
			<html:ul class="Dictionary">
				<html:li>
					<xsl:if test="request/@lang = 'de-de'">
						<xsl:attribute name="data-dictionary-selected"/>
					</xsl:if>
					<xsl:call-template name="dict.select.drawLink">
						<xsl:with-param name="lang" select="'de-de'"/>
					</xsl:call-template>
				</html:li>
				<html:li>
					<xsl:if test="request/@lang = 'en-us'">
						<xsl:attribute name="data-dictionary-selected"/>
					</xsl:if>
					<xsl:call-template name="dict.select.drawLink">
						<xsl:with-param name="lang" select="'en-us'"/>
					</xsl:call-template>
				</html:li>
			</html:ul>
		<!--
		</details>
		-->
	</xsl:template>
	
	<xsl:template name="dict.select.drawLink">
		<xsl:param name="lang"/>
		<html:a href="?lang={$lang}" rel="alternate" hreflang="{$lang}" title="language:{$lang}" data-dict="@title">
			<!--<img src="data:{$icon/@type};base64,{$icon/@base64}" alt="language:{$lang}" data-dict="@alt"/>-->
			<!--<img src="/getResource.php/slothsoft/lang-{$lang}" alt="language:{$lang}" data-dict="@alt"/>-->
			<!--<xsl:copy-of select="document($langList[@name = $lang]/@url)"/>-->
			<html:img src="{$langList[@name = $lang]/@href}" alt="{$lang}"/>
		</html:a>
	</xsl:template>
</xsl:stylesheet>