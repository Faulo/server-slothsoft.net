<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:import href="/getTemplate.php/slothsoft/kana"/>
	
	<xsl:template match="/data/data">
		<div class="Translator English">
			<!--
			<article>
				<h2>Introduction</h2>
				
			</article>
			-->
			<xsl:apply-templates select="vocabulary | test | testResult"/>
		</div>
	</xsl:template>
	
	<xsl:template match="vocabulary">
		<article>
			<h2 data-dict="">Vocabulary List</h2>
			<p>
				<xsl:value-of select="count(word)"/>
				<xsl:text> words.</xsl:text>
			</p>
			<table class="translatorForm paintedTable">
				<xsl:call-template name="vocabulary.list"/>
			</table>
		</article>
	</xsl:template>
	
	<xsl:template match="test">
		<article>
			<h2>Vocabulary Test</h2>
			<form action="." method="POST">
				<xsl:call-template name="test.list"/>
				<button type="submit" name="vocab-submit">Check</button>
			</form>
		</article>
	</xsl:template>
	
	<xsl:template match="testResult">
		<article>
			<h2>Test Results!</h2>
			<table class="translatorForm paintedTable input">
				<xsl:call-template name="vocabulary.list"/>
			</table>
			<strong>
				<samp>
					<xsl:value-of select="count(word[@input = .])"/>
					<xsl:text> / </xsl:text>
					<xsl:value-of select="count(word)"/>
				</samp>
				correct!
			</strong>
		</article>
	</xsl:template>
	
	<xsl:template name="vocabulary.list">
		<thead>
			<tr>
				<th>Audio</th>
				<th>Englisch</th>
				<th colspan="2">Deutsch</th>
			</tr>
		</thead>
		<tbody class="output">
			<xsl:for-each select="word/kana/kanji/english">
				<xsl:variable name="pos" select="position()"/>
				<xsl:variable name="player" select="../@player-uri"/>
				<xsl:variable name="kanji" select="../@name"/>
				<xsl:variable name="kana" select="../../@name"/>
				<xsl:variable name="input" select="../../../@input"/>
				<tr>
					<!--<td><iframe src="{../@player-uri}" class="player"/></td>-->
					<td>
						<xsl:call-template name="word.audioPlayer">
							<xsl:with-param name="uri" select="$player"/>
							<xsl:with-param name="remove" select="false()"/>
						</xsl:call-template>
					</td>
					<td>
						<a href="{../@dict-uri}"><xsl:value-of select="$kana"/></a>
					</td>
					<xsl:choose>
						<xsl:when test="$input">
							<xsl:variable name="correct" select="number($input = .)"/>
							<td data-correct="{$correct}"><xsl:value-of select="$input"/></td>
							<td>
								<xsl:if test="not($correct)">
									<xsl:value-of select="."/>
								</xsl:if>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td><xsl:value-of select="."/></td>
							<td/>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
			</xsl:for-each>
		</tbody>
	</xsl:template>
	
	<xsl:template name="test.list">
			<xsl:for-each select="word/kana/kanji">
				<xsl:variable name="pos" select="position()"/>
				<xsl:variable name="id" select="../../@id"/>
				<xsl:variable name="player" select="@player-uri"/>
				<xsl:variable name="kanji" select="@name"/>
				<xsl:variable name="kana" select="../@name"/>
				<fieldset class="paintedBox">
					<legend>Question <xsl:value-of select="$pos"/>/<xsl:value-of select="last()"/></legend>
					<table class="translatorForm">
						<tbody class="input">
							<xsl:if test="string-length($player)">
								<tr>
									<td>
										<xsl:call-template name="word.audioPlayer">
											<xsl:with-param name="uri" select="$player"/>
											<xsl:with-param name="remove" select="false()"/>
										</xsl:call-template>
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="string-length($kanji)">
								<tr>
									<td>
										<xsl:value-of select="$kanji"/>
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="string-length($kana)">
								<tr>
									<td>
										<xsl:value-of select="$kana"/>
									</td>
								</tr>
							</xsl:if>
								
						</tbody>
						<tbody class="output">
							<tr>
								<td>
									<label>
										<input type="radio" name="vocab-test[{$id}]" checked="checked" value=""/>
										<xsl:text> [don't know]</xsl:text>
									</label>
								</td>
							</tr>
							<xsl:for-each select="english">
								<tr>
									<td>
										<label>
											<input type="radio" name="vocab-test[{$id}]" value="{.}"/>
											<xsl:text> </xsl:text>
											<xsl:value-of select="."/>
										</label>
									</td>
								</tr>
							</xsl:for-each>
						</tbody>
					</table>
				</fieldset>
			</xsl:for-each>
	</xsl:template>
	
</xsl:stylesheet>
