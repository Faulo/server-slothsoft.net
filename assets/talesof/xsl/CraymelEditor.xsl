<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sfm="http://schema.slothsoft.net/farah/module" xmlns:sfx="http://schema.slothsoft.net/farah/xslt">

    <xsl:include href="farah://slothsoft@farah/xsl/module" />
    <xsl:include href="farah://slothsoft@farah/xsl/xslt" />

    <xsl:variable name="craymels" select="//craymel" />
    <xsl:variable name="fringeSpells" select="//data/spells" />
    <xsl:variable name="freeCraymels" select="//data/craymels/craymel" />
    <xsl:variable name="mages" select="//data/mage" />

    <xsl:template match="sfm:fragment-info">
        <div>
            <xsl:apply-templates select="sfm:error" mode="sfm:html" />
            <xsl:apply-templates select="sfm:document-info[@name='CraymelEditor']/data" />
        </div>
    </xsl:template>

    <xsl:template match="sfm:error">
        <xsl:apply-templates select="sfm:error" mode="sfm:html" />
    </xsl:template>

    <xsl:template match="data">
        <div class="CraymelEditor">
            <article data-media="screen">
                <h2>About</h2>
                <p>This editor allows you to find useful Craymel Configurations by showing all available Greater Craymels and spells, and which craymel mage they would end up with.</p>
                <p>
                    <xsl:text>Credit for the spell descriptions goes to Rena Chan for their </xsl:text>
                    <a rel="external" href="http://www.gamefaqs.com/ps/526350-tales-of-destiny-ii/faqs/14481">awesome craymel guide</a>
                    <xsl:text>.</xsl:text>
                </p>
            </article>
            <article>
                <h2 class="heading">Craymel Mages</h2>
                <xsl:apply-templates select="." mode="mages" />
            </article>
            <article>
                <h2 class="heading">Spells</h2>
                <xsl:apply-templates select="." mode="spells" />
            </article>
            <article data-media="screen">
                <h2 class="heading">Changelog</h2>
                <article>
                    <h3>[1.2.1] - 2025-11-29</h3>
                    <p>Rewrote the code to use more modern JavaScript features.</p>
                </article>
                <article>
                    <h3>[1.2.0] - 2013-02-16</h3>
                    <p>Shoutbox! \o/</p>
                </article>
                <article>
                    <h3>[1.1.0] - 2012-12-30</h3>
                    <p>Click on a Greater Craymel's name and drag it to another Craymel Cage, then drop it. The list will
                        update accordingly.
                    </p>
                </article>
                <article>
                    <h3>[1.0.0] - 2012-09-08</h3>
                    <p>Initial release!</p>
                </article>
            </article>
        </div>
    </xsl:template>

    <xsl:template match="data" mode="mages">
        <table class="CraymelMages">
            <colgroup>
                <col data-section="free" />
                <xsl:for-each select="$mages">
                    <col span="2" data-section="{@name}" />
                </xsl:for-each>
            </colgroup>
            <thead>
                <tr>
                    <td>
                        <h3>Free Craymels</h3>
                    </td>
                    <xsl:for-each select="$mages">
                        <td colspan="2">
                            <h3>
                                <xsl:value-of select="@name" />
                            </h3>
                        </td>
                    </xsl:for-each>
                </tr>
                <tr>
                    <td></td>
                    <xsl:for-each select="$mages">
                        <td>
                            <h4>Craymel Cage</h4>
                        </td>
                        <td>
                            <h4>Available Spells</h4>
                        </td>
                    </xsl:for-each>
                </tr>
                <tr>
                    <th class="divide">
                        <strong>Craymel</strong>
                        <code>[Element]</code>
                    </th>
                    <xsl:for-each select="$mages">
                        <th class="divide">
                            <strong>Craymel</strong>
                            <code>[Element]</code>
                        </th>
                        <th class="divide">
                            <strong>Name</strong>
                            <code>[TP]</code>
                        </th>
                    </xsl:for-each>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td data-cage="0" class="Cage">
                        <xsl:choose>
                            <xsl:when test="$freeCraymels">
                                <ul>
                                    <xsl:for-each select="$freeCraymels">
                                        <li>
                                            <xsl:apply-templates select="." mode="mages" />
                                        </li>
                                    </xsl:for-each>
                                </ul>
                            </xsl:when>
                            <xsl:otherwise>
                                <small>None D:</small>
                            </xsl:otherwise>
                        </xsl:choose>
                    </td>
                    <xsl:for-each select="$mages">
                        <td data-cage="{position()}" class="Cage">
                            <xsl:choose>
                                <xsl:when test="craymel">
                                    <ul>
                                        <xsl:for-each select="craymel">
                                            <li>
                                                <xsl:apply-templates select="." mode="mages" />
                                            </li>
                                        </xsl:for-each>
                                    </ul>
                                </xsl:when>
                                <xsl:otherwise>
                                    <small>Empty D:</small>
                                </xsl:otherwise>
                            </xsl:choose>
                        </td>
                        <td class="Spells">
                            <xsl:choose>
                                <xsl:when test="position() = 1">
                                    <xsl:apply-templates select="$mages[1]" mode="mages">
                                        <xsl:with-param name="other" select="$mages[2]" />
                                    </xsl:apply-templates>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:apply-templates select="$mages[2]" mode="mages">
                                        <xsl:with-param name="other" select="$mages[1]" />
                                    </xsl:apply-templates>
                                </xsl:otherwise>
                            </xsl:choose>
                        </td>
                    </xsl:for-each>
                </tr>
            </tbody>
        </table>
    </xsl:template>

    <xsl:template match="mage" mode="mages">
        <xsl:param name="other" />
        <ul>
            <xsl:for-each select="spell">
                <li>
                    <xsl:apply-templates select="." mode="mages" />
                </li>
            </xsl:for-each>
            <xsl:for-each select="craymel">
                <xsl:variable name="typeA" select="@type" />
                <xsl:for-each select="$fringeSpells/spell[count(*) = 1][local-name(*[1]) =  $typeA]">
                    <li>
                        <xsl:apply-templates select="." mode="mages">
                            <xsl:with-param name="type" select="../@type" />
                        </xsl:apply-templates>
                    </li>
                </xsl:for-each>
                <xsl:for-each select="$other/craymel">
                    <xsl:variable name="typeB" select="@type" />
                    <xsl:for-each select="$fringeSpells/spell[local-name(*[1]) =  $typeA][local-name(*[2]) =  $typeB]">
                        <li>
                            <xsl:apply-templates select="." mode="mages">
                                <xsl:with-param name="type" select="../@type" />
                            </xsl:apply-templates>
                        </li>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:for-each>
        </ul>
    </xsl:template>

    <xsl:template match="spell" mode="mages">
        <xsl:param name="type" select="@type" />
        <xsl:variable name="craymel" select="$craymels[@type = $type]" />
        <a class="divide">
            <xsl:call-template name="sfx:set-href" />
            <xsl:attribute name="data-element">
				<xsl:value-of select="$craymel/@element" />
			</xsl:attribute>
            <strong>
                <xsl:value-of select="@name" />
            </strong>
            <code>
                <xsl:text>[</xsl:text>
                <xsl:value-of select="@cost" />
                <xsl:text>]</xsl:text>
            </code>
        </a>
    </xsl:template>

    <xsl:template match="craymel" mode="mages">
        <span data-craymel="{@name}" class="divide">
            <xsl:attribute name="data-element">
				<xsl:value-of select="@element" />
			</xsl:attribute>
            <strong>
                <xsl:value-of select="@name" />
            </strong>
            <code>
                <xsl:text>[</xsl:text>
                <xsl:value-of select="@element" />
                <xsl:text>]</xsl:text>
            </code>
        </span>
    </xsl:template>

    <xsl:template match="data" mode="spells">
        <table>
            <thead>
                <tr>
                    <th>Mage</th>
                    <th>Name</th>
                    <th>TP</th>
                    <th class="divide-float">
                        <strong>Craymel&#160;A</strong>
                        <code>[Lvl]</code>
                    </th>
                    <th class="divide-float">
                        <strong>Craymel&#160;B</strong>
                        <code>[Lvl]</code>
                    </th>
                    <th data-media="screen">Description</th>
                </tr>
            </thead>

            <xsl:for-each select="$fringeSpells">
                <xsl:variable name="type" select="@type" />
                <xsl:variable name="craymel" select="$craymels[@type = $type]" />
                <tbody>
                    <xsl:attribute name="data-element">
						<xsl:value-of select="$craymel/@element" />
					</xsl:attribute>
                    <xsl:for-each select="$mages/spell[@type = $craymel/@type] | spell">
                        <xsl:variable name="typeA" select="*[1]" />
                        <xsl:variable name="strA" select="local-name($typeA)" />
                        <xsl:variable name="typeB" select="*[2]" />
                        <xsl:variable name="strB" select="local-name($typeB)" />
                        <xsl:variable name="ownerMage">
                            <xsl:choose>
                                <xsl:when test="parent::mage">
                                    <xsl:value-of select="../@name" />
                                </xsl:when>
                                <xsl:when test="$typeB">
                                    <xsl:if test="$mages[1]/craymel[@type = $strA] and $mages[2]/craymel[@type = $strB]">
                                        <xsl:value-of select="$mages[1]/@name" />
                                    </xsl:if>
                                    <xsl:if test="$mages[2]/craymel[@type = $strA] and $mages[1]/craymel[@type = $strB]">
                                        <xsl:value-of select="$mages[2]/@name" />
                                    </xsl:if>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:if test="$mages[1]/craymel[@type = $strA]">
                                        <xsl:value-of select="$mages[1]/@name" />
                                    </xsl:if>
                                    <xsl:if test="$mages[2]/craymel[@type = $strA]">
                                        <xsl:value-of select="$mages[2]/@name" />
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <tr data-mage="{$ownerMage}">
                            <xsl:call-template name="sfx:set-id" />
                            <td>
                                <xsl:value-of select="$ownerMage" />
                            </td>
                            <th>
                                <xsl:value-of select="@name" />
                            </th>
                            <td class="num">
                                <xsl:value-of select="@cost" />
                            </td>
                            <td class="divide-float">
                                <xsl:apply-templates select="$typeA" mode="spells" />
                            </td>
                            <td class="divide-float">
                                <xsl:apply-templates select="$typeB" mode="spells" />
                            </td>

                            <td data-media="screen">
                                <xsl:value-of select="@desc" />
                            </td>
                        </tr>
                    </xsl:for-each>
                </tbody>
            </xsl:for-each>
        </table>
    </xsl:template>

    <xsl:template match="*" mode="spells">
        <xsl:variable name="craymel" select="$craymels[@type = local-name(current())]" />
        <span>
            <xsl:value-of select="$craymel/@name" />
        </span>
        <code>
            <xsl:text>[</xsl:text>
            <xsl:value-of select="@lvl" />
            <xsl:text>]</xsl:text>
        </code>
    </xsl:template>
</xsl:stylesheet>