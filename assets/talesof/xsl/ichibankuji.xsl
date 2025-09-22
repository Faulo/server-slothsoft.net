<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
	xmlns:html="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="/data/data">
		<html class="kuji">
			<head>
				<title>
					<xsl:value-of select="@name" />
				</title>
				<style type="text/css"><![CDATA[
html.kuji {
	background-color: rgba(255, 255, 0, 0.2);
	padding: 1em;
}
html.kuji > body, html.kuji > body > h1, html.kuji > body > h2 {
	margin: 0;
}
figure {
	display: inline-block;
	margin: 1em;
	text-align: center;
	background-color: white;
	border: 1px solid silver;
	vertical-align: top;
	overflow: hidden;
}
figure.prize {
	display: none;
}
figure.double {
	border-color: red;
}
img, figcaption, a {
	display: block;
	margin: auto;
}
figcaption {
	padding: 0.25em;
	font-size: 1.25em;
	height: 3em;
	width: 400px;
	box-sizing: border-box;
}
.error {
	background: white;
	width: 1024px;
	border: 3px ridge red;
}

]]>
				</style>
			</head>
			<body>
				<h1>
					<a href="{@href}">
						<xsl:value-of select="@name" />
					</a>
				</h1>
				<h2>
					<a href="http://bpnavi.jp/kuji/ssc/search_pref/{@id}/prize">Kuji Store Locator</a>
				</h2>

				<xsl:for-each select="item">
					<xsl:sort select="@name" />
					<figure class="{@type}">
						<a href="{@href}">
							<img src="{@image}" alt="Item???" />
							<figcaption>
								<xsl:value-of select="@name" />
							</figcaption>
						</a>
					</figure>
				</xsl:for-each>

				<xsl:if test="html:*">
					<pre>ERROR D:</pre>
					<div class="error">
						<xsl:copy-of select="html:*" />
					</div>
				</xsl:if>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
