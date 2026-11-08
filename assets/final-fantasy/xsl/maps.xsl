<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sfs="http://schema.slothsoft.net/farah/sitemap" exclude-result-prefixes="sfs">
    <xsl:template match="/*">
        <xsl:variable name="slug" select="*[@name='sites']//sfs:page[@current]/@name" />
        <article class="ff-contain">
            <div class="ff-ui ff-row ff-scroll" style="--ff-scale: 2; --ff-background: transparent; --ff-wrap: wrap; --ff-align: start; --ff-gap: 1em; --ff-scroll-padding: .5em">
                <xsl:apply-templates select="*[@name='maps']/maps//*[@slug = $slug]" />
            </div>
        </article>
    </xsl:template>
    <xsl:template match="group | location">
        <xsl:if test="location">
            <fieldset class="ff-ui ff-panel" style="--ff-scale: 2">
                <legend>
                    <xsl:value-of select="@title" />
                </legend>
                <ul>
                    <xsl:for-each select="location">
                        <li>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:text>/FinalFantasy/I/</xsl:text>
                                    <xsl:for-each select="ancestor-or-self::*[@slug]">
                                        <xsl:value-of select="@slug" />
                                        <xsl:text>/</xsl:text>
                                    </xsl:for-each>
                                </xsl:attribute>
                                <xsl:value-of select="@title" />
                            </a>
                        </li>
                    </xsl:for-each>
                </ul>
            </fieldset>
        </xsl:if>
        <xsl:for-each select="floor">
            <fieldset class="ff-ui ff-panel ff-flush" style="--ff-scale: 2">
                <legend>
                    <xsl:value-of select="@title" />
                </legend>
                <div class="ff-scroll">
                    <img class="ff-pixel-art" src="/slothsoft@final-fantasy/i/gfx/map?map={@map}" alt="{../@title}: {@title}" loading="lazy">
                        <xsl:attribute name="width">
                            <xsl:choose>
                                <xsl:when test="@map='world'">4096</xsl:when>
                                <xsl:otherwise>1024</xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:attribute name="height">
                            <xsl:choose>
                                <xsl:when test="@map='world'">4096</xsl:when>
                                <xsl:otherwise>1024</xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </img>
                </div>
            </fieldset>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
