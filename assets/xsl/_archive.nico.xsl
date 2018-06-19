<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="/nico">
		<xsl:variable name="fileNode" select="file[@_file]"/>
		<xsl:variable name="videoNode" select="file[@_video]"/>
		<html>
			<head>
				<title>Slothsoft's Nico Nico Stream Thing</title>
				<link rel="icon" type="image/png" href="/getResource.php/slothsoft/favicon"/>
				<meta name="robots" content="noindex"/>
				<style type="text/css"><![CDATA[
html, body {
	height: 100%;
	overflow: hidden;
	margin: 0;
}
body > div {
	display: inline-block;
	vertical-align: top;
	max-height: 100%;
	overflow-y: auto;
	box-sizing: border-box;
}
body > div:first-child {
	padding: 2px 0 0 2px;
	width: 60%;
	max-width: 60%;
}
body > div:last-child {
	width: 40%;
	max-width: 40%;
}
	
video {
	width: 100%;
}
table {
	width: 100%;
	border-spacing: 2px;
	table-layout: fixed;
}
tr:nth-child(even) {
	background-color: rgba(0, 0, 255, 0.15);
}
tr:nth-child(odd) {
	background-color: rgba(0, 0, 255, 0.1);
}
tr.current {
	background-color: rgba(255, 255, 0, 0.7);
}
tr.current time {
	color: navy;
}
td {
	vertical-align: top;
	padding: 0;
}
td:first-child {
	width: 6em;
}
td.lang {
	width: 1.8em;
}
.lang {
	text-align: center;
	vertical-align: middle;
}
.lang img {
	display: block;
	margin: auto;
	width: 1.5em;
}
time {
	font-family: monospace;
	display: block;
	text-align: center;
	cursor: pointer;
	text-decoration: underline;
	color: blue;
}
time:hover {
	background-color: yellow;
}
time::before {
	content: "[";
}
time::after {
	content: "]";
}
p {
	padding: 0 0.25em;
	margin: 0;
	font-size: 0.9em;
	word-wrap: break-word;
}
				]]></style>
				<script type="application/javascript"><![CDATA[
var NicoNico = {
	videoNode : undefined,
	commentList : undefined,
	currenComment : undefined,
	commentInterval : undefined,
	init : function() {
		var nodeList, node, key;
		
		this.commentList = {};
		this.currentComment = false;
		this.videoNode = document.getElementsByTagName("video")[0];
		
		nodeList = document.getElementsByTagName("time");
		for (var i = 0; i < nodeList.length; i++) {
			node = nodeList[i];
			node.addEventListener(
				"click",
				function(eve) {
					NicoNico.setTime(this.getAttribute("datetime"));
				},
				false
			);
		}
		
		nodeList = document.getElementsByTagName("tr");
		for (var i = 0; i < nodeList.length; i++) {
			node = nodeList[i];
			key = node.getAttribute("data-time");
			node._commentTime = parseFloat(key);
			this.commentList[key] = node;
		}
		//console.log(this.commentList);
		
		if (this.commentInterval) {
			window.clearInterval(this.commentInterval);
		}
		if (this.videoNode) {
			this.commentInterval = window.setInterval(
				function() {
					NicoNico.setComment();
				},
				100
			);
		}
	},
	setTime : function(time) {
		try {
			this.videoNode.currentTime = time;
		} catch(e) {
		}
	},
	setComment : function() {
		var key, videoTime, commentNode, commentChanged;
		videoTime = this.videoNode.currentTime;
		console.log(videoTime);
		commentNode = false;
		for (key in this.commentList) {
			commentNode = this.commentList[key];
			if (this.commentList[key]._commentTime >= videoTime) {
				break;
			}
		}
		commentChanged = commentNode !== this.currentComment;
		if (this.currentComment) {
			if (commentChanged) {
				this.currentComment.removeAttribute("class");
			}
		}
		if (commentNode) {
			this.currentComment = commentNode;
		}
		if (this.currentComment) {
			if (commentChanged) {
				this.currentComment.setAttribute("class", "current");
				for (var i = 0; i < 10; i++) {
					if (commentNode.previousSibling) {
						commentNode = commentNode.previousSibling;
					} else {
						break;
					}
				}
				try {
					commentNode.scrollIntoView(true);
				} catch(e) {
				}
			}
		}
	},
};
addEventListener(
	"load",
	function(eve) {
		NicoNico.init();
	},
	false
);
				]]></script>
			</head>
			<body>
				<div>
					<xsl:if test="$videoNode">
						<video src="?download={$videoNode/@id}" title="{$videoNode/@name}" controls="controls" preload="auto"/>
					</xsl:if>
					<xsl:if test="$fileNode">
						<a href="?download={$fileNode/@id}" title="{$fileNode/@name}">
							Download: <xsl:value-of select="$fileNode/@name"/> (<xsl:value-of select="$fileNode/@size-string"/>)
						</a>
					</xsl:if>
				</div>
				<div>
					<!--
					<ul>
						<xsl:for-each select="chat">
							<li>
								<time><xsl:value-of select="@date_relative"/></time>
								<span class="lang">
									<xsl:if test="string-length(@locale)">
										<img alt="{@locale}" src="/getResource.php/slothsoft/lang/{@locale}"/>
									</xsl:if>
								</span>
								<xsl:copy-of select="node()"/>
							</li>
						</xsl:for-each>
					</ul>
					-->
					<table>
						<tbody>
							<xsl:for-each select="packet/chat">
								<xsl:sort select="@date" data-type="number"/>
								<xsl:sort select="@date_usec" data-type="number"/>
								<tr data-time="{@time}">
									<!--<td><time><xsl:value-of select="@date_absolute"/></time></td>-->
									<td title="{@date_string}"><time datetime="{@time}"><xsl:value-of select="@time_string"/></time></td>
									<!--
									<td title="{@locale}" class="lang">
										<xsl:if test="string-length(@locale)">
											<img alt="{@locale}" src="/getResource.php/slothsoft/lang/{@locale}"/>
										</xsl:if>
									</td>
									-->
									<td>
										<xsl:copy-of select="node()"/>
									</td>
								</tr>
							</xsl:for-each>
						</tbody>
					</table>
				</div>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
				