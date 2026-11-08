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

            <page name="EditorHelp" redirect="/Ambermoon/" status-active=""  />
            <page name="Downloads" redirect="/Ambermoon/" status-active=""  />

            <xsl:apply-templates select="mod">
                <xsl:with-param name="game" select="$game" />
            </xsl:apply-templates>

        </page>
    </xsl:template>


    <xsl:template match="mod">
        <xsl:param name="game" />
        <xsl:variable name="mod" select="@name" />
        <page name="{@name}" redirect="/Ambermoon/" status-active="">
            <sfm:param name="version" value="{@name}" />

            <page name="SaveEditor" title="SavegameEditor" redirect="/Ambermoon/" status-active="" />

            <page name="GameData" title="GameData" redirect="/Ambermoon/" status-active="">
                <page name="ItemList" title="ItemList" redirect="/Ambermoon/" status-active="" />
                <page name="PCList" title="PCList" redirect="/Ambermoon/" status-active="" />
                <page name="NPCList" title="NPCList" redirect="/Ambermoon/" status-active="" />
                <page name="MonsterList" title="MonsterList" redirect="/Ambermoon/" status-active="" />
                <page name="ClassList" title="ClassList" redirect="/Ambermoon/" status-active="" />
                <page name="PortraitList" title="PortraitList" redirect="/Ambermoon/" status-active="" />
                <page name="Maps2D" title="Maps2D" redirect="/Ambermoon/" status-active="" />
                <page name="Maps3D" title="Maps3D" redirect="/Ambermoon/" status-active="" />
                <page name="WorldmapLyramion" title="WorldmapLyramion" redirect="/Ambermoon/" status-active="" />
                <page name="WorldmapKire" title="WorldmapKire" redirect="/Ambermoon/" status-active="" />
                <page name="WorldmapMorag" title="WorldmapMorag" redirect="/Ambermoon/" status-active="" />
            </page>
         </page>
    </xsl:template>
</xsl:stylesheet>
				