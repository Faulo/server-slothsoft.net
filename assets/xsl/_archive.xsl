<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:variable name="chatNode" select="/data/*[@data-cms-name='chat']/*"/>
	<!-- 💾 📺 🎥 📡 📻 ⁇ -->
	<!-- ☇ ♪ ♬ -->
	<xsl:variable name="icon-save" select="'💾'"/>
	<xsl:variable name="icon-show" select="'📺'"/>
	<xsl:variable name="icon-watch" select="'🎥'"/>
	<xsl:variable name="icon-host" select="'☁'"/>
	<xsl:variable name="icon-guest" select="'☂'"/>
	<xsl:variable name="icon-info" select="'⁇'"/>
	<xsl:variable name="icon-bookmark" select="'🔖'"/>
	
	<xsl:variable name="icon-up" select="'⇧'"/>
	<xsl:variable name="icon-right" select="'⇨'"/>
	<xsl:variable name="icon-left" select="'⇦'"/>
	
	<xsl:variable name="request" select="/data/request"/>
	
	
	<xsl:template match="/data/data[@mode = 'toc']">
		<html>
			<head>
				<title>Slothsoft Archive</title>
				<meta name="viewport" content="initial-scale=0.5, width=device-width" />
			</head>
			<body>
				<!--<xsl:copy-of select="$chatNode"/>-->
				
				<div id="_toc">
					<nav>
						<section class="upload">
							<form action="./" method="post" enctype="multipart/form-data">
								<fieldset>
									<legend>Upload</legend>
									<!--
									<legend>
										<xsl:text>Upload - Free space left: </xsl:text>
										<samp>
											<xsl:value-of select="folder/@free-string"/>
										</samp>
									</legend>
									-->
									<input type="file" name="uploads[]" multiple="multiple" accept="*/*" size="32"/>
									<button type="submit">Upload</button>
								</fieldset>
							</form>	
						</section>
						<section class="upload">
							<form action="./" method="post" enctype="multipart/form-data">
								<fieldset>
									<legend>YouTube Download</legend>
									<input type="url" name="youtube-uri" placeholder="http://example.de"/>
									<button type="submit">Download</button>
								</fieldset>
							</form>	
						</section>
						<h1>Slothsoft's Secret Archive</h1>
						<!--
						<xsl:apply-templates select="." mode="navi"/>
						-->
					</nav>
				</div>
				<div id="_list">
					<main>
						<xsl:apply-templates select="folder" mode="list">
							<xsl:with-param name="open" select="true()"/>
						</xsl:apply-templates>
						<!--
						<table class="border paintedTable">
							<thead>
								<tr>
									<th colspan="3">Name</th>
									<th>Size</th>
									<th>Created</th>
									<th>Modified</th>
								</tr>
							</thead>
							<tbody>
								<xsl:apply-templates select="folder"/>
							</tbody>
						</table>
						-->
					</main>
				</div>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="folder" mode="list">
		<xsl:param name="open" select="false()"/>
		<details id="folder-{@id}">
			<xsl:if test="$open">
				<xsl:attribute name="open">open</xsl:attribute>
			</xsl:if>
			<summary><xsl:value-of select="@name"/></summary>
			<div>
				<xsl:apply-templates select="folder" mode="list">
					<!--<xsl:sort select="@title"/>-->
				</xsl:apply-templates>
				<div class="table">
					<xsl:apply-templates select="file" mode="list">
						<!--<xsl:sort select="@title"/>-->
					</xsl:apply-templates>
				</div>
			</div>
		</details>
	</xsl:template>
	<xsl:template match="file" mode="list">
		<div id="file-{@id}">
			<p>
				<xsl:choose>
					<xsl:when test="@isVideo or @isAudio">
						<a href="?watch={@id}&amp;autoplay" title="Watch"><xsl:value-of select="@name"/></a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@name"/>
					</xsl:otherwise>
				</xsl:choose>
			</p>
			<span>
				<a href="?download={@id}" title="Download file"><xsl:copy-of select="$icon-save"/></a>
			</span>
			<span>
				<a href="?show={@id}" title="Show file inline"><xsl:copy-of select="$icon-show"/></a>
			</span>
			<span>
				<xsl:if test="@isVideo or @isAudio">
					<a href="?watch={@id}&amp;autoplay" title="Watch"><xsl:copy-of select="$icon-watch"/></a>
				</xsl:if>
			</span>
			<span>
				<xsl:if test="@isVideo">
					<a href="Host/?watch={@id}" title="Shared Viewing - Host"><xsl:copy-of select="$icon-host"/></a>
				</xsl:if>
			</span>
			<span>
				<xsl:if test="@isVideo">
					<a href="Guest/#watch={@id}" title="Shared Viewing - Guest"><xsl:copy-of select="$icon-guest"/></a>
				</xsl:if>
			</span>
			<span>
				<a href="?info={@id}" title="File Info"><xsl:copy-of select="$icon-info"/></a>
			</span>
			<samp>
				<xsl:value-of select="@size-string"/>
			</samp>
			<time datetime="{@make-utc}">
				<xsl:value-of select="@make-datetime"/>
			</time>
			<time datetime="{@change-utc}">
				<xsl:value-of select="@change-datetime"/>
			</time>
		</div>
	</xsl:template>
	
	<xsl:template match="folder">
		<tr id="folder-{@id}">
			<td><a href="#_toc"><xsl:copy-of select="$icon-up"/></a></td>
			<th colspan="5" data-depth="{count(ancestor::folder)}">
				<a href="#folder-{@id}"><xsl:value-of select="@name"/></a>
			</th>
		</tr>
		<xsl:apply-templates select="folder">
			<!--<xsl:sort select="@title"/>-->
		</xsl:apply-templates>
		<xsl:apply-templates select="file">
			<!--<xsl:sort select="@title"/>-->
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="file">
		<tr id="file-{@id}">
			<td/>
			<td data-depth="{count(ancestor::folder)}">
				<xsl:choose>
					<xsl:when test="@isVideo or @isAudio">
						<a href="?watch={@id}&amp;autoplay" title="Watch"><xsl:value-of select="@name"/></a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@name"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<div class="actions">
					<span>
						<a href="?download={@id}" title="Download file"><xsl:copy-of select="$icon-save"/></a>
					</span>
					<span>
						<a href="?show={@id}" title="Show file inline"><xsl:copy-of select="$icon-show"/></a>
					</span>
					<span>
						<xsl:if test="@isVideo or @isAudio">
							<a href="?watch={@id}&amp;autoplay" title="Watch video"><xsl:copy-of select="$icon-watch"/></a>
						</xsl:if>
					</span>
					<span>
						<xsl:if test="@isVideo or @isAudio">
							<a href="Host/?watch={@id}" title="Shared Viewing - Host"><xsl:copy-of select="$icon-host"/></a>
						</xsl:if>
					</span>
					<span>
						<xsl:if test="@isVideo or @isAudio">
							<a href="Guest/#watch={@id}" title="Shared Viewing - Guest"><xsl:copy-of select="$icon-guest"/></a>
						</xsl:if>
					</span>
					<span>
						<a href="?info={@id}" title="File Info"><xsl:copy-of select="$icon-info"/></a>
					</span>
				</div>
			</td>
			<td class="number">
				<samp>
					<xsl:value-of select="@size-string"/>
				</samp>
			</td>
			<td class="number">
				<time datetime="{@make-utc}">
					<xsl:value-of select="@make-datetime"/>
				</time>
			</td>
			<td class="number">
				<time datetime="{@change-utc}">
					<xsl:value-of select="@change-datetime"/>
				</time>
			</td>
		</tr>
	</xsl:template>
	
	<!-- watch <video> -->
	<xsl:template match="/data/data[@mode = 'watch']">
		<html class="videoRoot">
			<xsl:for-each select=".//file[@current]">
				<xsl:variable name="prevFile" select="preceding-sibling::file[@isVideo or @isAudio][1]"/>
				<xsl:variable name="nextFile" select="following-sibling::file[@isVideo or @isAudio][1]"/>
				<head>
					<title>
						<xsl:value-of select="@title"/>
						<xsl:for-each select="ancestor-or-self::folder">
							<xsl:sort select="position()" order="descending"/>
							<xsl:text> - </xsl:text>
							<xsl:value-of select="@title"/>
						</xsl:for-each>
					</title>
					<meta name="viewport" content="width=device-width, initial-scale=1"/>
				</head>
				<body>
					<section class="videoContainer">
						<video preload="auto" controls="controls" src="?download={@id}&amp;dnt#t={$request/param[@name='time']}">
							<xsl:if test="$request/param[@name='autoplay']">
								<xsl:attribute name="autoplay">autoplay</xsl:attribute>
							</xsl:if>
							<!--<source src="?download={@id}&amp;dnt" type="{@mime}"/>-->
							<track src="?subtitles={@id}&amp;dnt" kind="subtitles" default="default"/>
							<!--
							<xsl:variable name="siblingList" select="../file[@title = current()/@title]"/>
							<xsl:for-each select="$siblingList[@ext = 'vtt']">
								<track src="?download={@id}&amp;dnt" kind="subtitles" default="default"/>
							</xsl:for-each>
							<xsl:for-each select="$siblingList[@ext = 'srt']">
								<track src="?download={@id}&amp;dnt" kind="subtitles"/>
							</xsl:for-each>
							-->
						</video>
					</section>
					<section id="_top" class="videoHeader">
						<header>
							<div>
								<xsl:for-each select="ancestor::folder | .">
									<xsl:if test="position() &gt; 1">
										<!--<xsl:text> » </xsl:text>-->
									</xsl:if>
									<a href=".#folder-{ancestor-or-self::folder[1]/@id}" style="margin-left: {count(ancestor-or-self::folder | .) - 1}em">
										<xsl:value-of select="@name"/>
									</a>
								</xsl:for-each>
								<script type="application/javascript"><![CDATA[
function VideoController(mediaNode) {
	this.mediaNode = mediaNode;
	this.mediaNode.addEventListener(
		"pause",
		this.onPause.bind(this),
		false
	);
	this.mediaNode.addEventListener(
		"mousedown",
		this.onMousedown.bind(this),
		false
	);
	this.mediaNode.addEventListener(
		"click",
		this.onClick.bind(this),
		false
	);
	this.mediaNode.addEventListener(
		"ended",
		this.onEnded.bind(this),
		false
	);
	this.mediaNode.addEventListener(
		"timeupdate",
		this.onTimeupdate.bind(this),
		false
	);
	
	if (this.mediaNode.msRequestFullscreen) {
		this.mediaNode.requestFullscreen = this.mediaNode.msRequestFullscreen;
	}
	if (this.mediaNode.mozRequestFullScreen) {
		this.mediaNode.requestFullscreen = this.mediaNode.mozRequestFullScreen;
	}
	if (this.mediaNode.webkitRequestFullscreen) {
		this.mediaNode.requestFullscreen = this.mediaNode.webkitRequestFullscreen;
	}
	
	if (location.hash === "#autostart") {
		try {
			this.mediaNode.play();
			//this.mediaNode.requestFullscreen();
		} catch (e) {
			console.log(e.message);
		}
	}
	this.mediaNode.focus();
}
VideoController.prototype.onMousedown = function(eve) {
	//eve.preventDefault();
};
VideoController.prototype.onClick = function(eve) {
	//eve.preventDefault();
};
VideoController.prototype.onPause = function(eve) {
	//alert(this.mediaNode.audioTracks);
};
VideoController.prototype.onEnded = function(eve) {
	var aNode;
	if (aNode = document.getElementById("media-next")) {
		location.href = aNode.href; // + "&autoplay";
	}
};
VideoController.prototype.onTimeupdate = function(eve) {
	var aNode;
	if (aNode = document.getElementById("media-bookmark")) {
		aNode.href = location.href + "&time=" + this.mediaNode.currentTime.toFixed(1);
	}
};

addEventListener(
	"load",
	function(eve) {
		var controller;
		controller = new VideoController(document.getElementsByTagName("video")[0]);
		//document.getElementsByTagName("video")
		//VideoController.init();
	},
	false
);
					]]></script>
							</div>
							<div>
								<a href="?download={@id}" class="download"><xsl:value-of select="$icon-save"/> download file</a>
								<a href="?watch={@id}" id="media-bookmark"><xsl:value-of select="$icon-bookmark"/> bookmark position</a>
							</div>
							<hgroup>
								<xsl:for-each select="$prevFile">
									<a href="?watch={@id}&amp;autoplay"><xsl:value-of select="@name"/></a>
									<!--<span><xsl:copy-of select="$icon-left"/></span>-->
								</xsl:for-each>
								
								<h1>
									<xsl:value-of select="@name"/>
									<!--
									<xsl:text> </xsl:text>
									<a href="?download={@id}" class="download"><xsl:value-of select="$icon-save"/></a>
									<xsl:text> </xsl:text>
									<a href="?watch={@id}&amp;autoplay" id="media-bookmark"><xsl:value-of select="$icon-bookmark"/></a>
									-->
								</h1>
								<xsl:for-each select="$nextFile">
									<!--<span><xsl:copy-of select="$icon-right"/></span>-->
									<a href="?watch={@id}&amp;autoplay" id="media-next"><xsl:value-of select="@name"/></a>
								</xsl:for-each>
							</hgroup>
						</header>
					</section>
				</body>
			</xsl:for-each>
		</html>
	</xsl:template>
	
	<xsl:template match="/data/data[@mode = 'chat']">
		<html>
			<head>
				<title>Shared Viewing Chat - Slothsoft Archive</title>
			</head>
			<body>
				<xsl:copy-of select="$chatNode"/>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="/data/data[@mode = 'guest' or @mode = 'host']">
		<xsl:variable name="isGuest" select="@mode = 'guest'"/>
		<html>
			<head>
				<title>Shared Viewing - Slothsoft Archive</title>
			</head>
			<body>
				<section class="unison" data-archive-unison="{@mode}" data-archive-id="archive">
					<div>
						<video preload="auto" controls="controls">
							<track kind="subtitles" default="default"/>
						</video>
						<!--
							<xsl:choose>
								<xsl:when test="@mode = 'host'">
									src="?download={@id}&amp;dnt" <xsl:attribute name="controls">controls</xsl:attribute>
								</xsl:when>
							</xsl:choose>
						</video>
						-->
					</div>
					<div>
						<nav>
							<div>
								<button>↻</button>
							</div>
							<div>
								<select>
									<xsl:if test="$isGuest">
										<xsl:attribute name="disabled">disabled</xsl:attribute>
									</xsl:if>
									<option value=""></option>
									<xsl:for-each select=".//folder[file[@isVideo]]">
										<option value="{@id}">
											<xsl:if test="file[@current]">
												<xsl:attribute name="selected">selected</xsl:attribute>
											</xsl:if>
											<xsl:for-each select="ancestor-or-self::*">
												<xsl:choose>
													<xsl:when test="count(ancestor::*) &lt; 3"/>
													<xsl:when test="count(ancestor::*) = 3">
														<xsl:value-of select="@name"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:text> - </xsl:text>
														<xsl:value-of select="@name"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:for-each>
										</option>
									</xsl:for-each>
								</select>
								<select>
									<xsl:if test="$isGuest">
										<xsl:attribute name="disabled">disabled</xsl:attribute>
									</xsl:if>
									<option value=""></option>
									<xsl:for-each select=".//folder[file[@isVideo]]">
										<optgroup data-archive-folder="{@id}">
											<xsl:attribute name="label">
												<xsl:for-each select="ancestor-or-self::*">
													<xsl:choose>
														<xsl:when test="count(ancestor::*) &lt; 3"/>
														<xsl:when test="count(ancestor::*) = 3">
															<xsl:value-of select="@name"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:text> - </xsl:text>
															<xsl:value-of select="@name"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:for-each>
											</xsl:attribute>
											<xsl:for-each select="file[@isVideo]">
												<option value="{@id}">
													<xsl:if test="@current">
														<xsl:attribute name="selected">selected</xsl:attribute>
													</xsl:if>
													<xsl:value-of select="@name"/>
												</option>
											</xsl:for-each>
										</optgroup>
									</xsl:for-each>
								</select>
							</div>
						</nav>
						<xsl:copy-of select="$chatNode"/>
					</div>
				</section>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="*" mode="navi">
		<xsl:variable name="childPages" select="folder[count(ancestor::folder) &lt; 3]"/>
		<xsl:if test="@id">
			<a href="#folder-{@id}"><xsl:value-of select="@name"/></a>
		</xsl:if>
		<xsl:if test="$childPages">
			<ul>
				<xsl:for-each select="$childPages">
					<li>
						<xsl:apply-templates select="." mode="navi"/>
					</li>
				</xsl:for-each>
			</ul>
		</xsl:if>
	</xsl:template>
	
	
</xsl:stylesheet>
				