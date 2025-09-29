<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
	xmlns:html="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="/*">
		<html>
			<head>
				<title>Slothsoft's Video Chat Thing</title>
				<link rel="icon" type="image/png" href="/getResource.php/slothsoft/favicon" />
				<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=yes" />
				<meta name="author" content="Daniel Schulz" />
			</head>
			<body>
				<xsl:for-each select=".//vct">
					<div id="WebRTC" data-vct-room="{@room}" data-template="flex">
						<ul>
							<li class="settings">
								<h1>
									Video Chat Thing powered by
									<a href="http://slothsoft.net/VideoChatThing/">Slothsoft</a>
								</h1>
								<h2>
									Your room ID:
									<a href="./?room={@room}" target="_blank">
										<xsl:value-of select="@room" />
									</a>
								</h2>
								<h2>Users in this room:</h2>
								<div id="WebRTC-user">
								</div>
								<div class="log">
									<h2>Server log:</h2>
									<pre id="WebRTC-log" />
								</div>
							</li>
							<li class="streams">
								<div id="WebRTC-video" />
							</li>
						</ul>
					</div>
				</xsl:for-each>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>