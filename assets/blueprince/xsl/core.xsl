<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sfm="http://schema.slothsoft.net/farah/module">

	<xsl:template match="/*">
		<div class="NumericCore">
			<xsl:apply-templates select="sfm:error" mode="sfm:html" />
			<article>
				<h2>About</h2>
				<p>This is a numeric core builder that, given 4 numbers, calculates their numeric core.</p>
				<p>Even the concept of numeric cores is a spoiler, so no more context will be given.</p>
				<xsl:for-each select="*/core">
					<form action="" method="GET">
						<h2 class="heading">Input as 4 numbers</h2>

						<xsl:for-each select="input">
							<input type="number" size="3" name="numbers[]" value="{.}" />
						</xsl:for-each>

						<button type="submit">Look up core!</button>
					</form>
					<form action="" method="GET">
						<h2 class="heading">Input as word</h2>
						<input type="text" size="4" name="word" value="{word}" />
						<button type="submit">Look up core!</button>
					</form>
					<xsl:choose>
						<xsl:when test="result">
							<h2 class="heading">Result</h2>
							<textarea readonly="readonly">
								<xsl:value-of select="result" />
								<xsl:text> = </xsl:text>
								<xsl:value-of select="result/@letter" />
							</textarea>
						</xsl:when>
						<xsl:otherwise>
							<i>Input numbers to start the calculation.</i>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</article>
		</div>
	</xsl:template>

</xsl:stylesheet>
