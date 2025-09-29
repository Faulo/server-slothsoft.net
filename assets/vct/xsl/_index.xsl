<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="/*">
		<html>
			<head>
				<title>Slothsoft's WebRTC Thing</title>
				<style type="text/css"><![CDATA[
html {
	background-color: black;
}
html, body {
	margin: 0;
}
video {
	min-width: 640px;
	min-height: 480px;
}
button {
	min-width: 320px;
	min-height: 240px;
	background-color: white;
	white-space: pre-wrap;
}
pre {
	background-color: silver;
	margin: 0;
	padding: 0.5em;
}
pre > * {
	display: block;
}
pre > *.message {
	color: blue;
}
pre > *.error {
	color: red;
}
pre > *.credits {
	color: yellow;
}
body {
	
}
#WebRTC-video {
}
#WebRTC-video > * {
	display: inline-block;
	vertical-align: top;
}
			]]></style>
			</head>
			<body>
				<div id="WebRTC-video" />
				<pre id="WebRTC-log">
					<em class="credits">
						WebRTC thing powered by
						<a href="http://slothsoft.net/VideoChatThing/">Slothsoft</a>
					</em>
				</pre>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>