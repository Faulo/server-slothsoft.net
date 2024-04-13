<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:import href="/getTemplate.php/slothsoft/kana"/>
	
	<xsl:template match="/data">
		<div class="Translator">
			<article class="Grammar">
				<h2>Grammar</h2>
				<xsl:apply-templates select="*"/>
			</article>
		</div>
	</xsl:template>
	
	<xsl:template match="*[conjugationGroup]">
		<xsl:variable name="formList" select="form"/>
		<article>
			<h3><xsl:value-of select="count(.//conjugation)"/> Verbs</h3><!--[not(contains(translation, '[höflich]'))]-->
			<table class="translatorForm paintedTable vocabularyList">
				<thead>
					<tr>
						<th/>
						<xsl:for-each select="$formList">
							<th data-dict=""><xsl:value-of select="concat('vocab/form/', @name)"/></th>
						</xsl:for-each>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each select="conjugationGroup">
						
						<xsl:for-each select="conjugation">
							<xsl:variable name="wordList" select="word"/>
							<tr>
								<xsl:if test="position() = 1">
									<th rowspan="{last()}" data-dict="node()">
										<xsl:value-of select="concat('vocab/type/', ../@type)"/>
									</th>
								</xsl:if>
								<td>
									<xsl:call-template name="word.complete">
										<xsl:with-param name="word" select="word[1]"/>
									</xsl:call-template>
								</td>
								<xsl:for-each select="$formList[position() &gt; 1]">
									<td>
										<xsl:call-template name="word.complete">
											<xsl:with-param name="word" select="$wordList[@form = current()/@name]"/>
											<xsl:with-param name="display-audio" select="false()"/>
										</xsl:call-template>
									</td>
								</xsl:for-each>
							</tr>
						</xsl:for-each>
					</xsl:for-each>
				</tbody>
			</table>
		</article>
	</xsl:template>
	
	<xsl:template match="verbList">
		<article>
			<h3><xsl:value-of select="count(.//verb)"/> Verbs</h3><!--[not(contains(translation, '[höflich]'))]-->
			<table class="translatorForm paintedTable vocabularyList">
				<thead>
					<tr>
						<td rowspan="2" colspan="1">Verb</td>
						<th colspan="2">imperfective</th>
						<th colspan="2">perfective</th>
					</tr>
					<tr>
						<th>positive</th>
						<th>negative</th>
						<th>positive</th>
						<th>negative</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each select="verbGroup">
						<xsl:for-each select="verb">
							<tr>
								<xsl:if test="position() = 1">
									<td rowspan="{last()}">
										<div class="kanjiName serif">
											<a href="http://jisho.org/kanji/details/{../@base-kanji}"><xsl:value-of select="../@base-kanji"/></a>
										</div>
										<div>
											<xsl:call-template name="word.strokeOrder">
												<xsl:with-param name="text" select="../@base-kanji"/>
											</xsl:call-template>
										</div>
									</td>
								</xsl:if>
								<!--<th><xsl:value-of select="translation"/></th>-->
								<td>
									<xsl:apply-templates select="form[@aspect = 'imperfective'][@polarity = '+']"/>
								</td>
								<td>
									<xsl:apply-templates select="form[@aspect = 'imperfective'][@polarity = '-']"/>
								</td>
								<td>
									<xsl:apply-templates select="form[@aspect = 'perfective'][@polarity = '+']"/>
								</td>
								<td>
									<xsl:apply-templates select="form[@aspect = 'perfective'][@polarity = '-']"/>
								</td>
							</tr>
						</xsl:for-each>
					</xsl:for-each>
				</tbody>
			</table>
		</article>
	</xsl:template>
	<xsl:template match="form">
		<xsl:choose>
			<xsl:when test="string-length(@name-kanji)">
				<xsl:call-template name="word.ruby">
					<xsl:with-param name="base" select="@name-kanji"/>
					<xsl:with-param name="top" select="@name-kana"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="word.ruby">
					<xsl:with-param name="base" select="@name-kana"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
</xsl:stylesheet>
