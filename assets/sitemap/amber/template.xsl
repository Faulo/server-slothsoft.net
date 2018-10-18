<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns="http://schema.slothsoft.net/farah/sitemap"
	xmlns:sfm="http://schema.slothsoft.net/farah/module"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="/*">
		<sitemap version="1.0">
			<xsl:apply-templates select="*[@name='index']/*"/>
		</sitemap>
	</xsl:template>
	
	<xsl:template match="game">
		<xsl:variable name="game" select="@name"/>
		<page name="{@title}" ref="pages/{$game}/description"
			status-active="" status-public="">
			<sfm:param name="game" value="{$game}" />
			
			<page name="EditorHelp" ref="pages/{$game}/description"
				status-active="" status-public="" />
			<page name="Downloads" ref="pages/{$game}/description" status-active="" status-public=""/>
			
			<xsl:apply-templates select="mod"/>
			
			
			<page name="SavegameEditor" title="SavegameEditor"
				redirect="/Ambermoon/Thalion-v1.05-DE/SaveEditor" status-active="" />
			<page name="GamedataEditor" title="GamedataEditor"
				redirect="/Ambermoon/Thalion-v1.05-DE/GameEditor" status-active="" />
			<page name="GameEditor" title="GameEditor"
				redirect="/Ambermoon/Thalion-v1.05-DE/GameEditor" status-active="" />
				
			<page name="ExperienceChart" title="ExperienceChart"
				redirect="/Ambermoon/Thalion-v1.05-DE/GameData/ClassList" status-active="" />
			<page name="ItemList" title="ItemList"
				redirect="/Ambermoon/Thalion-v1.05-DE/GameData/ItemList" status-active="" />
			<page name="PortraitList" title="PortraitList"
				redirect="/Ambermoon/Thalion-v1.05-DE/GameData/PortraitList" status-active="" />
		</page>
	</xsl:template>
	
	
	<xsl:template match="mod">
		<xsl:variable name="game" select="../@name"/>
		<page name="{@name}" ref="pages/{$game}/description"
			status-active="">
			<xsl:if test="not(@hidden)">
				<xsl:attribute name="status-public"/>
			</xsl:if>
			<sfm:param name="version" value="{@name}" />
			<page name="SaveEditor" title="SavegameEditor" ref="pages/{$game}/editor"
				status-active="" status-public="">
				<sfm:param name="infosetId" value="lib.save" />
			</page>
			<page name="GameEditor" title="GameEditor" ref="pages/{$game}/description" status-active="" status-public="">	
				<page name="Dictionaries" title="DictionaryEditor" ref="pages/{$game}/editor"
					status-active="" status-public="">
					<sfm:param name="infosetId" value="lib.dictionaries" />
				</page>
				<page name="Items" title="ItemEditor" ref="pages/{$game}/editor"
					status-active="" status-public="">
					<sfm:param name="infosetId" value="lib.items" />
				</page>
				<page name="NPCs" title="NPCEditor" ref="pages/{$game}/editor"
					status-active="" status-public="">
					<sfm:param name="infosetId" value="lib.npcs" />
				</page>
				<page name="MonsterEditor" title="MonsterEditor" ref="pages/{$game}/editor"
					status-active="" status-public="">
					<sfm:param name="infosetId" value="lib.monsters" />
				</page>
				<page name="Spells" title="SpellEditor" ref="pages/{$game}/editor"
					status-active="" status-public="">
					<sfm:param name="infosetId" value="lib.spells" />
				</page>
				<page name="Places" title="PlaceEditor" ref="pages/{$game}/editor"
					status-active="" status-public="">
					<sfm:param name="infosetId" value="lib.places" />
				</page>
				<page name="Maps" title="MapEditor" ref="pages/{$game}/editor"
					status-active="" status-public="">
					<sfm:param name="infosetId" value="lib.maps" />
				</page>
				<page name="Extra" title="ExtraEditor" ref="pages/{$game}/editor"
					status-active="" status-public="">
					<sfm:param name="infosetId" value="lib.extra" />
				</page>
			</page>
			<page name="GameData" title="GameData" ref="pages/{$game}/description" status-active="" status-public="">			
				<page name="ItemList" title="ItemList" ref="pages/{$game}/resource"
					status-active="" status-public="">
					<sfm:param name="infosetId" value="lib.items" />
				</page>
				<page name="PCList" title="PCList" ref="pages/{$game}/resource"
					status-active="" status-public="">
					<sfm:param name="infosetId" value="lib.pcs" />
				</page>
				<page name="NPCList" title="NPCList" ref="pages/{$game}/resource"
					status-active="" status-public="">
					<sfm:param name="infosetId" value="lib.npcs" />
				</page>
				<page name="MonsterList" title="MonsterList" ref="pages/{$game}/resource"
					status-active="" status-public="">
					<sfm:param name="infosetId" value="lib.monsters" />
				</page>
				<page name="ClassList" title="ClassList" ref="pages/{$game}/resource"
					status-active="" status-public="">
					<sfm:param name="infosetId" value="lib.classes" />
				</page>
				<page name="PortraitList" title="PortraitList" ref="pages/{$game}/resource"
					status-active="" status-public="">
					<sfm:param name="infosetId" value="lib.portraits" />
				</page>
				<page name="Maps2D" title="Maps2D" ref="pages/{$game}/resource"
					status-active="" status-public="">
					<sfm:param name="infosetId" value="lib.maps-2d" />
				</page>
				<page name="Maps3D" title="Maps3D" ref="pages/{$game}/resource"
					status-active="" status-public="">
					<sfm:param name="infosetId" value="lib.maps-3d" />
				</page>
				<page name="WorldmapLyramion" title="WorldmapLyramion" ref="pages/{$game}/resource"
					status-active="" >
					<sfm:param name="infosetId" value="lib.worldmap-lyramion" />
				</page>
				<page name="WorldmapKire" title="WorldKire" ref="pages/{$game}/resource"
					status-active="" status-public="">
					<sfm:param name="infosetId" value="lib.worldmap-kire" />
				</page>
				<page name="WorldmapMorag" title="WorldmapMorag" ref="pages/{$game}/resource"
					status-active="" status-public="">
					<sfm:param name="infosetId" value="lib.worldmap-morag" />
				</page>
			</page>
<!-- 			<page name="GameResource" title="GameResource" ref="//slothsoft@amber/game-resources/amberdata" status-active=""/>			 -->
		</page>
	</xsl:template>
</xsl:stylesheet>
				