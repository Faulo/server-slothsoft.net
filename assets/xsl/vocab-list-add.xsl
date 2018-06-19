<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:import href="/getTemplate.php/slothsoft/kana"/>
	
	<xsl:template match="/data/data">
		<div class="Translator">
			<script type="application/javascript"><![CDATA[
addEventListener(
	"load",
	function(eve) {
		scrollTo(0, 0);
	},
	false
);
			]]></script>
			
			<xsl:call-template name="vocab.add"/>
			
			<xsl:choose>
				<xsl:when test=".//*[lang('ja')]">
					<xsl:call-template name="translator.root"/>
				</xsl:when>
			</xsl:choose>
		</div>
	</xsl:template>
	
	<xsl:template name="vocab.add">
		<xsl:param name="lang" select="string(descendant-or-self::*[@xml:lang]/@xml:lang)"/>
		<xsl:param name="otherLang" select="string(descendant-or-self::*[@xml:lang][not(lang($lang))]/@xml:lang)"/>	
		<article>
			<h2>Add Word To List</h2>
			<form method="POST" action="." class="vocab-list-add-form">
				<label>Category: <xsl:call-template name="vocab.selectCategory"/></label>
				<table class="translatorForm paintedTable vocabularyList">
					<thead>
						<tr data-dict="html:th/node()">
							<th>
								<xsl:if test="string-length($lang)">
									<xsl:value-of select="concat('lang/', $lang)"/>
								</xsl:if>
							</th>
							<th>
								<xsl:if test="string-length($otherLang)">
									<xsl:value-of select="concat('lang/', $otherLang)"/>
								</xsl:if>
							</th>
							<th/>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td class="newVocable">
								<label>New Word: <input type="text" name="vocab-new[0][0][name]"/></label>
								<label>Ruby Note: <input type="text" name="vocab-new[0][0][note]"/></label>
								<label>Audio URL: <input type="text" name="vocab-new[0][0][audio]"/></label>
							</td>
							<td class="newVocable">
								<label>New Word: <input type="text" name="vocab-new[0][1][name]"/></label>
								<label>Ruby Note: <input type="text" name="vocab-new[0][1][note]"/></label>
								<label>Audio URL: <input type="text" name="vocab-new[0][1][audio]"/></label>
							</td>
							<td>
								<input type="hidden" name="vocab-new[0][0][lang]" value="{$lang}"/>
								<input type="hidden" name="vocab-new[0][1][lang]" value="{$otherLang}"/>
								<button type="submit">☑</button>
							</td>
						</tr>
					</tbody>
				</table>
			</form>
		</article>
	</xsl:template>
	
	<xsl:template name="vocab.selectCategory">
		<select name="vocab-new-submit" required="required">
			<option/>
			<xsl:for-each select=".//group">
				<option><xsl:value-of select="@name"/></option>
			</xsl:for-each>
		</select>
	</xsl:template>
</xsl:stylesheet>
