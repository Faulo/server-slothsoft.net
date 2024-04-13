<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns="http://schema.slothsoft.net/farah/sitemap"
	xmlns:sfs="http://schema.slothsoft.net/farah/sitemap"
	xmlns:sfd="http://schema.slothsoft.net/farah/dictionary"
	xmlns:sfm="http://schema.slothsoft.net/farah/module"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="/*">
		<sitemap version="1.0">
			<page name="Minecraft" ref="//slothsoft@slothsoft/pages/minecraft/home" title="Minecraft" module="minecraft" status-active="" status-public="">
				<sfm:param name="chat-duration" value="30"/>
				<page name="News" ref="news" title="News" status-active="" status-public=""/>
				<page name="Chat" ref="shoutbox" title="Chat" status-active="" status-public="">
					<sfm:param name="chat-duration" value="90"/>
				</page>
				<page name="Log" ref="//slothsoft@slothsoft/pages/minecraft/log" title="Server-Log" status-active="" status-public="">
					<xsl:copy-of select="*[@name='sites.log']/sfs:sitemap/sfs:page"/>
				</page>
				<page name="Infos" ref="infos" title="Server-Informationen" status-active="" status-public=""/>
				<page name="Law" ref="law" title="Regeln" status-active="" status-public=""/>
				<page name="Map" title="Map" ext="/Minecraft/Map/index.html" status-active="" status-public=""/>
				<page name="Maps" ref="maps" title="Karten" status-active="" status-public="">
					<page name="Map" title="Current (MapCrafter)" ext="/Minecraft/Map/index.html" status-active="" status-public=""/>
					<page name="Map.2015-11-24" title="2015 (MapCrafter)" ext="/Minecraft/Map.2015-11-24/index.html" status-active="" status-public=""/>
					<page name="Map.2014-05-20" title="2014 (Overviewer)" ext="/Minecraft/Map.2014-05-20/index.html" status-active="" status-public=""/>
					<page name="Map.2013-02-27" title="2013 (Tectonicus)" ext="/Minecraft/Map.2013-02-27/index.html" status-active="" status-public=""/>
					<page name="Map.2012-06-07" title="2012 (Tectonicus)" ext="/Minecraft/Map.2012-06-07/index.html" status-active="" status-public=""/>
					<page name="Map.2011-10-26" title="2011 (Tectonicus)" ext="/Minecraft/Map.2011-10-26/index.html" status-active="" status-public=""/>
				</page>
				<page name="Players" ref="players" title="Spieler" status-active="" status-public=""/>
				<page name="Pics" ref="pics" title="Bildchen" status-active="" status-public=""/>
			</page>
		</sitemap>
	</xsl:template>
</xsl:stylesheet>
				