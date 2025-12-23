<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://schema.slothsoft.net/farah/sitemap" xmlns:sfm="http://schema.slothsoft.net/farah/module" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/*">
        <sitemap version="1.0">
            <xsl:apply-templates select="*[@name='index']/*" />
        </sitemap>
    </xsl:template>

    <xsl:template match="game">
        <xsl:variable name="game" select="@name" />
        <page name="{@title}" ref="pages/{$game}/description" status-active="" status-public="">
            <sfm:param name="game" value="{$game}" />

            <page name="EditorHelp" ref="pages/{$game}/description" status-active="" status-public="" />
            <page name="Downloads" ref="pages/{$game}/description" status-active="" status-public="" />

            <xsl:apply-templates select="mod">
                <xsl:with-param name="game" select="$game" />
            </xsl:apply-templates>

        </page>
    </xsl:template>


    <xsl:template match="mod">
        <xsl:param name="game" />
        <xsl:variable name="mod" select="@name" />
        <page name="{@name}" ref="pages/{$game}/description" status-active="">
            <xsl:if test="not(@hidden)">
                <xsl:attribute name="status-public" />
            </xsl:if>
            <sfm:param name="version" value="{@name}" />

            <page name="SaveEditor" title="SavegameEditor" redirect="https://amber.slothsoft.net/{$game}/{$mod}/SavegameEditor/" status-active="" />

            <!-- <page name="GameEditor" title="GameEditor" ref="pages/{$game}/description" status-active=""> <page name="Dictionaries" title="DictionaryEditor" ref="pages/{$game}/editor" status-active="" status-public=""> <sfm:param name="infosetId" value="lib.dictionaries" /> </page> <page name="Items" 
                title="ItemEditor" ref="pages/{$game}/editor" status-active="" status-public=""> <sfm:param name="infosetId" value="lib.items" /> </page> <page name="NPCs" title="NPCEditor" ref="pages/{$game}/editor" status-active="" status-public=""> <sfm:param name="infosetId" value="lib.npcs" /> </page> <page name="MonsterEditor" 
                title="MonsterEditor" ref="pages/{$game}/editor" status-active="" status-public=""> <sfm:param name="infosetId" value="lib.monsters" /> </page> <page name="Spells" title="SpellEditor" ref="pages/{$game}/editor" status-active="" status-public=""> <sfm:param name="infosetId" value="lib.spells" /> </page> 
                <page name="Places" title="PlaceEditor" ref="pages/{$game}/editor" status-active="" status-public=""> <sfm:param name="infosetId" value="lib.places" /> </page> <page name="Maps" title="MapEditor" ref="pages/{$game}/editor" status-active="" status-public=""> <sfm:param name="infosetId" value="lib.maps" 
                /> </page> <page name="Extra" title="ExtraEditor" ref="pages/{$game}/editor" status-active="" status-public=""> <sfm:param name="infosetId" value="lib.extra" /> </page> </page> -->

            <page name="GameData" title="GameData" ref="pages/{$game}/description" status-active="">
                <page name="ItemList" title="ItemList" redirect="https://amber.slothsoft.net/{$game}/{$mod}/GameData/ItemList/" status-active="" />
                <page name="PCList" title="PCList" redirect="https://amber.slothsoft.net/{$game}/{$mod}/GameData/PCList/" status-active="" />
                <page name="NPCList" title="NPCList" redirect="https://amber.slothsoft.net/{$game}/{$mod}/GameData/NPCList/" status-active="" />
                <page name="MonsterList" title="MonsterList" redirect="https://amber.slothsoft.net/{$game}/{$mod}/GameData/MonsterList/" status-active="" />
                <page name="ClassList" title="ClassList" redirect="https://amber.slothsoft.net/{$game}/{$mod}/GameData/ClassList/" status-active="" />
                <page name="PortraitList" title="PortraitList" redirect="https://amber.slothsoft.net/{$game}/{$mod}/GameData/PortraitList/" status-active="" />
                <page name="Maps2D" title="Maps2D" redirect="https://amber.slothsoft.net/{$game}/{$mod}/GameData/Maps2D/" status-active="" />
                <page name="Maps3D" title="Maps3D" redirect="https://amber.slothsoft.net/{$game}/{$mod}/GameData/Maps3D/" status-active="" />
                <page name="WorldmapLyramion" title="WorldmapLyramion" redirect="https://amber.slothsoft.net/{$game}/{$mod}/GameData/WorldmapLyramion/" status-active="" />
                <page name="WorldmapKire" title="WorldmapKire" redirect="https://amber.slothsoft.net/{$game}/{$mod}/GameData/WorldmapKire/" status-active="" />
                <page name="WorldmapMorag" title="WorldmapMorag" redirect="https://amber.slothsoft.net/{$game}/{$mod}/GameData/WorldmapMorag/" status-active="" />
            </page>

            <!-- <page name="GameResource" title="GameResource" ref="//slothsoft@amber/game-resources/amberdata" status-active=""/> -->
        </page>
    </xsl:template>
</xsl:stylesheet>
				