<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns="http://schema.slothsoft.net/farah/sitemap"
	xmlns:sfm="http://schema.slothsoft.net/farah/module"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="/*">
		<sitemap version="1.0">
			<page name="FireEmblem" title="Fire Emblem" ref="fire-emblem-home" status-active="" status-public="">
				<page name="RekkaNoKen" title="Rekka No Ken" redirect="/FireEmblem/TheBlazingBlade" status-active="">
					<sfm:param name="game" value="bs"/>
					<page name="Characters" title="Characters" redirect="/FireEmblem/TheBlazingBlade/Characters" status-active=""/>
					<page name="Relationships" title="Relationships" redirect="/FireEmblem/TheBlazingBlade/Relationships" status-active=""/>
				</page>
				<page name="TheBlazingBlade" title="The Blazing Blade" redirect="Characters" status-active="" status-public="">
					<sfm:param name="game" value="bs"/>
					<page name="Characters" title="Characters" ref="fire-emblem-cast" status-active="" status-public=""/>
					<page name="Relationships" title="Relationships" ref="fire-emblem-breeding" status-active="" status-public=""/>
				</page>
				<page name="TheSacredStones" title="The Sacred Stones" redirect="Characters" status-active="" status-public="">
					<sfm:param name="game" value="ss"/>
					<page name="Characters" title="Characters" ref="fire-emblem-cast" status-active="" status-public=""/>
					<page name="Relationships" title="Relationships" ref="fire-emblem-breeding" status-active="" status-public=""/>
				</page>
				<page name="PathOfRadiance" title="Path of Radiance" redirect="Characters" status-active="" status-public="">
					<sfm:param name="game" value="por"/>
					<page name="Characters" title="Characters" ref="fire-emblem-cast" status-active="" status-public=""/>
					<page name="Relationships" title="Relationships" ref="fire-emblem-breeding" status-active="" status-public=""/>
				</page>
				<page name="RadiantDawn" title="Radiant Dawn" redirect="Characters" status-active="" status-public="">
					<sfm:param name="game" value="rd"/>
					<page name="Characters" title="Characters" ref="fire-emblem-cast" status-active="" status-public=""/>
				</page>
				<page name="ShadowDragon" title="Shadow Dragon" redirect="Characters" status-active="" status-public="">
					<sfm:param name="game" value="sd"/>
					<page name="Characters" title="Characters" ref="fire-emblem-cast" status-active="" status-public=""/>
				</page>
				<page name="Awakening" title="Awakening" redirect="Characters" status-active="" status-public="">
					<sfm:param name="game" value="aw"/>
					<page name="Characters" title="Characters" ref="fire-emblem-cast" status-active="" status-public=""/>
					<page name="Relationships" title="Relationships" ref="fire-emblem-breeding" status-active="" status-public=""/>
				</page>
				<page name="Fates" title="Fates" redirect="Characters" status-active="" status-public="">
					<sfm:param name="game" value="if"/>
					<page name="Characters" title="Characters" ref="fire-emblem-cast" status-active="" status-public=""/>
					<page name="Relationships" title="Relationships" ref="fire-emblem-breeding" status-active="" status-public=""/>
				</page>
			</page>
		</sitemap>
	</xsl:template>
</xsl:stylesheet>
				