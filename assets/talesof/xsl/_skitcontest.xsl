<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0">
	<xsl:variable name="langRegistry" select="//registry/language" />

	<xsl:template match="/data">
		<html>
			<head>
				<title>Tales of Skit Contest</title>
				<style type="text/css"><![CDATA[
.skitRoot {
	padding: 8px;
	margin: 4px;
	display: inline-table;
}
.skitRoot:nth-child(even) {
	background-color: rgba(200, 255, 200, 0.8);
}
.skitRoot:nth-child(odd) {
	background-color: rgba(200, 200, 255, 0.8);
}
img {
	max-width: 8em;
	max-height: 8em;
	display: block;
}
hgroup > * {
	margin: 0.1em 0;
	width: 731px;
}
p {
	width: 731px;
	min-height: 4em;
	white-space: pre-wrap;
}
a.image {
	border: 2px dashed navy;
	margin: 1em;
	display: inline-block;
}
]]>
				</style>
			</head>
			<body>
				<h1>
					<a href="https://www.facebook.com/tales/app_373065719403295">Tales of Skit Contest</a>
					-
					<xsl:value-of select="count(//skit)" />
					Skits
				</h1>
				<dl id="_toc">
					<xsl:for-each select="//lang">
						<xsl:sort select="count(//skit[lang(current()/@xml:lang)])" order="descending" data-type="number" />
						<xsl:variable name="lang" select="@xml:lang" />
						<xsl:variable name="langNode" select="$langRegistry[subtag = $lang]" />
						<xsl:variable name="skitList" select="//skit[lang($lang)]" />
						<dt id="lang-{$lang}">
							<xsl:value-of select="$langNode/description" />
							<code>
								<xsl:value-of select="concat(' [', $lang, ']')" />
							</code>
							<xsl:value-of select="concat(' - ', count($skitList), ' Skits')" />
						</dt>
						<dd>
							<ol>
								<xsl:for-each select="$skitList">
									<xsl:sort select="@votes" order="descending" data-type="number" />
									<li>
										<a href="#skit-{generate-id(.)}">
											<code>
												<xsl:copy-of select="concat(format-number(@votes, '000'), ': ')" />
											</code>
											<xsl:value-of select="title" />
										</a>
									</li>
								</xsl:for-each>
							</ol>
						</dd>
					</xsl:for-each>
				</dl>
				<xsl:for-each select="//lang">
					<xsl:sort select="count(//skit[lang(current()/@xml:lang)])" order="descending" data-type="number" />
					<xsl:variable name="lang" select="@xml:lang" />
					<xsl:for-each select="//skit[lang($lang)]">
						<xsl:sort select="@votes" order="descending" data-type="number" />
						<xsl:apply-templates select=".">
							<xsl:with-param name="pos" select="position()" />
						</xsl:apply-templates>
					</xsl:for-each>
				</xsl:for-each>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="skit">
		<xsl:param name="pos" />
		<div class="skitRoot" id="skit-{generate-id(.)}">
			<hgroup>
				<h3>
					<a href="#lang-{@xml:lang}">⇧</a>
					<code>
						<xsl:copy-of
							select="concat(' Place: ', $pos, '; Votes: ', @votes, '; Shares: ', @shares, '; Language: ', @xml:lang)" />
					</code>
				</h3>
				<h1>
					<a class="fb" href="https://apps.facebook.com/photo_contest_two/?pid={@id}&amp;page_id=171035032926046">
						<xsl:value-of select="title" />
					</a>
				</h1>
				<h2>
					<xsl:value-of select="concat(first_name, ' ', letter, '.')" />
				</h2>
			</hgroup>
			<p>
				<xsl:value-of select="description" />
			</p>
			<xsl:for-each select="link">
				<a href="{@href}" class="image">
					<img src="{@thumb}" />
				</a>
				<!--<iframe src="{@href}"/> -->
			</xsl:for-each>
		</div>
	</xsl:template>
</xsl:stylesheet>