<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns="http://schema.slothsoft.net/farah/sitemap"
	xmlns:sfs="http://schema.slothsoft.net/farah/sitemap"
	xmlns:sfd="http://schema.slothsoft.net/farah/dictionary"
	xmlns:sfm="http://schema.slothsoft.net/farah/module"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 
	<xsl:template match="/*">
		<domain 
			name="slothsoft.net"
			vendor="slothsoft"
			module="slothsoft.net"
			ref="home" status-active="" status-public=""
			sfd:languages="de-de en-us">
			
			<page name="AboutUs" ref="about-us" title="About us" status-active="" status-public=""/>
			<page name="Shoutboxes" ref="chat-list" title="Shoutboxes" status-active="" status-public=""/>
			<xsl:apply-templates select="*[@name='minecraft']"/>
			<xsl:apply-templates select="*[@name='tales']"/>
			<xsl:apply-templates select="*[@name='fire-emblem']"/>
			<xsl:apply-templates select="*[@name='dragon-age']"/>
			<xsl:apply-templates select="*[@name='amber']"/>
			<xsl:apply-templates select="*[@name='vocab']"/>
			<page name="MissingSloth" ref="missingSloth" title="Missing Sloth" status-active=""/>
			<page name="VideoChatThing" ref="vct-home" module="webrtc" title="VideoChatThing" status-active="" status-public="">
				<page name="Room" ref="vct-room" title="Room" status-active=""/>
			</page>
			<page name="WhatTheHell" title="What The Hell" module="whatthehell" ref="faq" status-active="" status-public="">
				<page name="Game" title="Game" ref="game" status-active="" status-public=""/>
			</page>
			<page name="HeartbeatForAll" title="Heartbeat For All" ref="heartbeat-for-all" status-active="" status-public="">
				<page name="Game" title="Game" ext="/getResource.php/slothsoft/unity/HeartbeatForAll" status-active="" status-public=""/>
				
			</page>
			<page name="UnicodeMapper" title="Unicode Text Converter" ref="unicode-mapper" status-active="" status-public=""/>
			<page name="Imprint" title="Impressum" ref="imprint" status-active="" status-public=""/>
			
			
			<xsl:apply-templates select="*[@name='downloads']"/>
		</domain>
	</xsl:template>
	
	<xsl:template match="sfs:sitemap">
		<xsl:copy-of select="*"/>
	</xsl:template>
</xsl:stylesheet>