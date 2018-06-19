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
					<xsl:when test="test">
						<p data-dict="">vocab/kanji/test</p>
					</xsl:when>
					<xsl:otherwise>
						<p data-dict="">vocab/kanji/readings</p>
						<p>
							Kanji and their translations are from the awesome dictionary at <a href="{.//vocabulary/@kanji-uri}" rel="external"><xsl:value-of select=".//vocabulary/@kanji-uri"/></a>.
						</p>
						<!--<p data-dict="">vocab/kanji/audio</p>-->
						<p data-dict="">vocab/kanji/stroke</p>
					</xsl:otherwise>
				</xsl:choose>
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
					<xsl:apply-templates select="testDates"/>
					<xsl:apply-templates select="vocabulary"/>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template match="vocabulary">
		<article class="kanjiList" data-vocab-test="kanji">
			<h2>Kanji List</h2>
			<xsl:for-each select="group/vocable">
				<xsl:sort select="sum(word/@user-correct)" data-type="number"/>
				<xsl:sort select="word[1]/@id"/>
				<xsl:variable name="pos" select="position()"/>
				<xsl:variable name="kanjiNode" select="word[1]"/>
				<xsl:variable name="kanjiLang" select="string($kanjiNode/@xml:lang)"/>
				<xsl:variable name="translationNode" select="word[2]"/>
				<xsl:variable name="translationLang" select="string($translationNode/@xml:lang)"/>
				<xsl:variable name="user-wrong" select="sum(word/@user-wrong)"/>
				<xsl:variable name="user-correct" select="sum(word/@user-correct)"/>
				
				<article class="paintedBox vocabBox">
					<xsl:attribute name="xml:lang"><xsl:value-of select="$kanjiLang"/></xsl:attribute>
					<h3>
						<xsl:if test="word/@user-correct">
							<xsl:attribute name="title">
								<xsl:text>☑: </xsl:text>
								<xsl:value-of select="$user-correct"/>
								<xsl:text>/</xsl:text>
								<xsl:value-of select="$user-correct + $user-wrong"/>
							</xsl:attribute>
						</xsl:if>
						<a href="http://jisho.org/kanji/details/{$kanjiNode/@name}" rel="external">
							Kanji <xsl:value-of select="$pos"/>/<xsl:value-of select="last()"/>:
							<xsl:value-of select="$kanjiNode/@name"/>
						</a>
					</h3>
					<div class="translatorForm vocab-table">
						<div class="input">
							<xsl:copy-of select="($kanjiNode/@xml:lang)[1]"/>
							<xsl:call-template name="test.element">
								<xsl:with-param name="word" select="$kanjiNode"/>
								<xsl:with-param name="mode" select="'kanji'"/>
							</xsl:call-template>
							<!--
							<div class="vocab-table">
								<xsl:call-template name="test.audioPlayer">
									<xsl:with-param name="word" select="$kanjiNode"/>
								</xsl:call-template>
								<xsl:call-template name="test.element">
									<xsl:with-param name="word" select="$kanjiNode"/>
									<xsl:with-param name="mode" select="'kanji'"/>
								</xsl:call-template>
							</div>
							-->
						</div>
						
						<div class="output">
							<xsl:copy-of select="($translationNode/@xml:lang)[1]"/>
							<xsl:call-template name="test.element">
								<xsl:with-param name="word" select="$translationNode"/>
								<xsl:with-param name="mode" select="'kanji'"/>
							</xsl:call-template>
							<!--
							<div class="vocab-table">
								<xsl:call-template name="test.audioPlayer">
									<xsl:with-param name="word" select="$translationNode"/>
								</xsl:call-template>
								<xsl:call-template name="test.element">
									<xsl:with-param name="word" select="$translationNode"/>
									<xsl:with-param name="mode" select="'kanji'"/>
								</xsl:call-template>
							</div>
							-->
						</div>
					</div>
				</article>
				<!--
				<div class="paintedBox vocabBox" xml:lang="{$kanjiLang}">
					<table class="translatorForm">
						<caption>
							<a href="http://jisho.org/kanji/details/{$kanjiNode/@name}" rel="external">
								Kanji <xsl:value-of select="$pos"/>/<xsl:value-of select="last()"/>:
								<xsl:value-of select="$kanjiNode/@name"/>
							</a>
						</caption>
						<thead class="input">
							<tr>
								<td>
									<xsl:if test="$user-correct + $user-wrong">
										<span class="myTime" title="☑">
											<xsl:value-of select="$user-correct"/>
											<xsl:text>/</xsl:text>
											<xsl:value-of select="$user-correct + $user-wrong"/>
										</span>
									</xsl:if>
								</td>
								<td class="vocabName sans">
									<xsl:value-of select="$kanjiNode/@name"/>
								</td>
								<td class="vocabName serif">
									<xsl:value-of select="$kanjiNode/@name"/>
								</td>
								<td class="vocabStroke">
									<xsl:call-template name="word.strokeOrder">
										<xsl:with-param name="text" select="$kanjiNode/@name"/>
										<xsl:with-param name="expanded" select="true()"/>
									</xsl:call-template>
								</td>
							</tr>
						</thead>
						<tbody class="input">
							<xsl:call-template name="kanji.list.reading">
								<xsl:with-param name="nodeList" select="$kanjiNode/reading[@type = 'on']"/>
							</xsl:call-template>
							<xsl:call-template name="kanji.list.reading">
								<xsl:with-param name="nodeList" select="$kanjiNode/reading[@type = 'kun']"/>
							</xsl:call-template>
						</tbody>
						<tbody class="output" xml:lang="{$translationLang}">
							<tr>
								<th data-dict=""><xsl:value-of select="concat('lang/', $translationLang)"/></th>
								<td colspan="3">
									<table>
										<tr>
											<xsl:for-each select="$translationNode">
												<td>
													<xsl:value-of select="@name"/>
												</td>
											</xsl:for-each>
										</tr>
									</table>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				-->
			</xsl:for-each>
		</article>
	</xsl:template>
</xsl:stylesheet>