<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="/getTemplate.php/slothsoft/kana"/>
	
	<xsl:template match="/data/data">
		<div>
			<article class="about">
				<h2>About</h2>
				<xsl:choose>
					<xsl:when test="test and .//*[lang('ja')]">
						<p data-dict="">vocab/ja/test</p>
					</xsl:when>
					<xsl:when test="vocabulary[@isPersonal]">
						<p data-dict="">vocab/slothsoft/list</p>
					</xsl:when>
					<xsl:when test="vocabulary[@isJLPT]">
						<p>
							A vocabulary list taken from the awesome JLPT archive at <a href="http://www.tanos.co.uk/jlpt" rel="external">www.tanos.co.uk</a>.
						</p>
						<p>
							Due to the way the audio samples are accessed it's unlikely that a sample will be available when the Kanji is missing. Can't do anything about that. :/
						</p>
					</xsl:when>
				</xsl:choose>
				<xsl:if test=".//*[lang('ja')]">
					<p data-dict="">vocab/ja/rubyplugin</p>
				</xsl:if>
			</article>
			<xsl:choose>
				<xsl:when test="test or testResult">
					<xsl:apply-templates select="testResult"/>
					<xsl:apply-templates select="testDates">
						<xsl:with-param name="dayCount" select="31"/>
					</xsl:apply-templates>
					<xsl:apply-templates select="test"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="testDates">
						<xsl:with-param name="dayCount" select="31"/>
					</xsl:apply-templates>
					<xsl:apply-templates select="vocabulary"/>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>
	
	<xsl:template match="vocabulary">
		<xsl:variable name="langList" select="group[1]/vocable[1]/word/@xml:lang"/>
		<form action="." method="GET" class="vocabTest">
			<h2>Test Settings</h2>
			<fieldset class="paintedBox">
				<legend>Language</legend>
				<label>
					<img src="/getResource.php/slothsoft/lang/{$langList[1]}"/>
					<span><input type="radio" name="test-language" value="{$langList[1]}"/></span>
					<span>
						<span data-dict="">lang/<xsl:value-of select="$langList[1]"/></span>
						<span> ➟ </span>
						<span data-dict="">lang/<xsl:value-of select="$langList[2]"/></span>
					</span>
				</label>
				<label>
					<img src="/getResource.php/slothsoft/lang/{$langList[2]}"/>
					<span><input type="radio" name="test-language" value="{$langList[2]}"/></span>
					<span>
						<span data-dict="">lang/<xsl:value-of select="$langList[2]"/></span>
						<span> ➟ </span>
						<span data-dict="">lang/<xsl:value-of select="$langList[1]"/></span>
					</span>
				</label>
			</fieldset>
			<fieldset class="paintedBox">
				<legend>Type of Test</legend>
				<label>
					<img src="/getResource.php/slothsoft/pics/vocab.choice"/>
					<span><input type="radio" name="test-type" value="choice"/></span>
					<span>Multiple Choice - Desktop</span>
				</label>
				<label>
					<img src="/getResource.php/slothsoft/pics/vocab.click"/>
					<span><input type="radio" name="test-type" value="click"/></span>
					<span>Multiple Choice - Mobile</span>
				</label>
				<label>
					<img src="/getResource.php/slothsoft/pics/vocab.typing"/>
					<span><input type="radio" name="test-type" value="typing"/></span>
					<span>Free Text Answers</span>
				</label>
			</fieldset>
			<button type="submit">Generate Test</button>
		</form>
	</xsl:template>
</xsl:stylesheet>