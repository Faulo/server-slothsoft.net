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
					<xsl:apply-templates select="testDates"/>
					<xsl:apply-templates select="vocabulary"/>
				</xsl:otherwise>
			</xsl:choose>
			
			<!--
			<p><span class="kanaStrokeOrder">友達</span>!</p>
			<table class="kanaChart">
				<xsl:for-each select=".//row">
					<tr>
						<xsl:for-each select="kana">
							<th>
								<xsl:value-of select="@name"/>
							</th>
							<td>
								<xsl:value-of select="@latin"/>
							</td>
						</xsl:for-each>
					</tr>
				</xsl:for-each>
			</table>
			-->
		</div>
	</xsl:template>
	
	<xsl:template match="vocabulary">
		<article id="_toc">
			<h2>
				Vocabulary List
				<small>
					<xsl:value-of select="concat(' (', count(group/vocable), ' words)')"/>
				</small>
			</h2>
			<xsl:if test="group[@name]">
				<ul>
					<xsl:for-each select="group">
						<xsl:variable name="id" select="concat('top-', @id)"/>
						<li><a href="#{$id}"><xsl:value-of select="concat(@name, ' (', count(vocable), ')')"/></a></li>
					</xsl:for-each>
				</ul>
			</xsl:if>
			<xsl:for-each select="group">
				<xsl:call-template name="vocabulary.list"/>
			</xsl:for-each>
		</article>
	</xsl:template>
	<!--
	<xsl:template match="test">
		<article class="vocabularyTest">
		<script type="application/javascript"><![CDATA[
addEventListener("load",
	function(eve) {
		var nodeList, i, node;
		if (window.XPath && window.Translator) {
			nodeList = XPath.evaluate(".//*[@class='vocabularyTest']//*[lang('ja')][@data-player-uri]", document);
			for (i = 0; i < nodeList.length; i++) {
				//Translator.createAudioPlayer(nodeList[i]);
			}
		}
		if (node = document.getElementsByTagName("input")[0]) {
			node.focus();
		}
		if (window.jQuery) {
			(function($) {
			  $.fn.nodoubletapzoom = function() {
				  $(this).bind('touchstart', function preventZoom(e) {
					var t2 = e.timeStamp
					  , t1 = $(this).data('lastTouch') || t2
					  , dt = t2 - t1
					  , fingers = e.originalEvent.touches.length;
					$(this).data('lastTouch', t2);
					if (!dt || dt > 500 || fingers > 1) return; // not double-tap

					e.preventDefault(); // double tap - prevent the zoom
					// also synthesize click events we just swallowed up
					$(this).trigger('click').trigger('click');
				  });
			  };
			})(jQuery);
		}
	},
	false
);
			]]></script>
			<h2>Vocabulary Test</h2>
			<form action="." method="POST" data-vocab-test="words">
				<xsl:call-template name="test.list"/>
				<button type="submit" name="vocab-submit">Check</button>
			</form>
		</article>
	</xsl:template>
	-->
</xsl:stylesheet>