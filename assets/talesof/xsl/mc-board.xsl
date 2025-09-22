<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0">
	<xsl:template match="/data">
		<html>
			<head>
				<title>Magic Carta</title>
				<style type="text/css"><![CDATA[
.board {
	font-size: 16px;
	width: 800px;
	height: 600px;
	border: 2px ridge silver;
	background-color: #eee;
}
.background {
	pointer-events: none;
}
.foreground {
	opacity: 0.7;
}
.card {
	width: 10em;
	height: 14em;
	background-color: white;
	position: absolute;
	border: 1px ridge red;
	border-radius: 0.25em;
	overflow: hidden;
-webkit-touch-callout: none;
-webkit-user-select: none;
-khtml-user-select: none;
-moz-user-select: none;
-ms-user-select: none;
user-select: none;
}
.card:hover {
	border-color: blue;
	z-index: 1;
}
.card > * {
	pointer-events: none;
}
.card > img {
	height: 100%;
	display: block;
	margin: auto;
}
.card > q {
	display: block;
	text-align: center;
	position: absolute;
	bottom: 0;
	margin: 1em;
	color: white;
	text-shadow: 	 1px  1px 0px black,
					-1px  1px 0px black,
					 1px -1px 0px black,
					-1px -1px 0px black;
}
				]]></style>
			</head>
			<body>
				<div>
					<div>
						<div class="board">
							<div class="background">
								<xsl:for-each select="//card">
									<div class="card" style="transform: translate({@x}px, {@y}px) rotate({@r}deg);">
										<img src="/getResource.php/talesof/mc-images/{@id}" />
										<q>
											<xsl:value-of select="quote[1]" />
										</q>
									</div>
								</xsl:for-each>
							</div>
							<div class="foreground">
								<xsl:for-each select="//card">
									<div class="card" style="transform: translate({@x}px, {@y}px) rotate({@r}deg);">
										<img src="/getResource.php/talesof/mc-images/{@id}" />
										<q>
											<xsl:value-of select="quote[1]" />
										</q>
									</div>
								</xsl:for-each>
							</div>
						</div>
					</div>
				</div>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>