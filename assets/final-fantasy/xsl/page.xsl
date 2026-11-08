<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sf1="http://schema.slothsoft.net/final-fantasy/i" xmlns:exsl="http://exslt.org/common" exclude-result-prefixes="sf1 exsl">
    <!-- D4-E1, retaining the unused E0 tile in the private-use area. -->
    <xsl:variable name="item-glyphs" select="'&#x1F5E1;&#x1F528;&#x1F52A;&#x1FA93;&#x1FA84;&#x1F962;&#x1F9BA;&#x26E8;&#x1FA96;&#x1F9E4;&#x1F48D;&#x1F455;&#xE0E0;&#x1F9F4;'" />
    <xsl:key name="classes" match="sf1:classes/sf1:class" use="@id" />
    <xsl:key name="armor-categories" match="sf1:armor/sf1:item" use="@category" />
    <xsl:key name="spell-schools" match="sf1:spells/sf1:spell" use="@school" />
    <xsl:key name="spells" match="sf1:spells/sf1:spell" use="@id" />
    <xsl:template match="/*">
        <article class="ff-contain">
            <xsl:apply-templates select=".//sf1:final-fantasy" />
        </article>
    </xsl:template>
    <xsl:template match="sf1:final-fantasy">
        <xsl:choose>
            <xsl:when test="@view = 'home'">
                <h2>About</h2>
                <p>This is a savegame editor for the NES version of Final Fantasy (Square 1987).</p>
                <p>There's also a few pages with helpful info about the game's items and spells.</p>
            </xsl:when>
            <xsl:when test="sf1:unavailable">
                <p role="status">
                    <xsl:value-of select="sf1:unavailable" />
                </p>
            </xsl:when>
            <xsl:when test="@view = 'editor'">
                <xsl:call-template name="editor" />
            </xsl:when>
            <xsl:when test="@view = 'weapons'">

                <fieldset class="ff-ui ff-panel" style="--ff-scale: 2">
                    <legend>Weapons</legend>
                    <div class="ff-scroll">
                        <table>
                            <thead>
                                <tr>
                                    <th scope="col">Weapon</th>
                                    <th scope="col">Price</th>
                                    <th scope="col">Damage</th>
                                    <th scope="col">Hit<br />bonus
                                    </th>
                                    <th scope="col">Critical</th>
                                    <th scope="col">Casts</th>
                                    <th scope="col">Classes</th>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each select="sf1:weapons/sf1:weapon">
                                    <tr id="weapon-{@id}">
                                        <th scope="row">
                                            <xsl:call-template name="item-name" />
                                        </th>
                                        <td class="ff-number">
                                            <xsl:value-of select="@price" />
                                        </td>
                                        <td class="ff-number">
                                            <xsl:value-of select="@damage" />
                                        </td>
                                        <td class="ff-number">
                                            <xsl:value-of select="@hit" />
                                        </td>
                                        <td class="ff-number">
                                            <xsl:value-of select="@critical" />
                                        </td>
                                        <td>
                                            <xsl:call-template name="cast" />
                                        </td>
                                        <td>
                                            <xsl:call-template name="classes" />
                                        </td>
                                    </tr>
                                </xsl:for-each>
                            </tbody>
                        </table>
                    </div>
                </fieldset>
            </xsl:when>
            <xsl:when test="@view = 'armor'">
                <xsl:for-each select="sf1:armor/sf1:item[generate-id() = generate-id(key('armor-categories', @category)[1])]">
                    <xsl:sort select="@category" data-type="number" />
                    <fieldset class="ff-ui ff-panel" style="--ff-scale: 2">
                        <legend>
                            <xsl:choose>
                                <xsl:when test="@category=0">Body</xsl:when>
                                <xsl:when test="@category=1">Shield</xsl:when>
                                <xsl:when test="@category=2">Helmet</xsl:when>
                                <xsl:otherwise>Gloves</xsl:otherwise>
                            </xsl:choose>
                        </legend>
                        <div class="ff-scroll">
                            <table>
                                <thead>
                                    <tr>
                                        <th scope="col">Armor</th>
                                        <th scope="col">Price</th>
                                        <th scope="col">Absorb</th>
                                        <th scope="col">Evade<br />penalty
                                        </th>
                                        <th scope="col">Casts</th>
                                        <th scope="col">Classes</th>
                                        <th scope="col">Resists</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <xsl:for-each select="key('armor-categories', @category)">
                                        <tr id="armor-{@id}">
                                            <th scope="row">
                                                <xsl:call-template name="item-name" />
                                            </th>
                                            <td class="ff-number">
                                                <xsl:value-of select="@price" />
                                            </td>
                                            <td class="ff-number">
                                                <xsl:value-of select="@absorb" />
                                            </td>
                                            <td class="ff-number">
                                                <xsl:value-of select="@evade-penalty" />
                                            </td>
                                            <td>
                                                <xsl:call-template name="cast" />
                                            </td>
                                            <td>
                                                <xsl:call-template name="classes" />
                                            </td>
                                            <td>
                                                <xsl:call-template name="resistance" />
                                            </td>
                                        </tr>
                                    </xsl:for-each>
                                </tbody>
                            </table>
                        </div>
                    </fieldset>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="@view = 'spells'">
                <xsl:for-each select="sf1:spells/sf1:spell[generate-id() = generate-id(key('spell-schools', @school)[1])]">
                    <xsl:sort select="@school" order="descending" />
                    <fieldset class="ff-ui ff-panel" style="--ff-scale: 2">
                        <legend>
                            <xsl:choose>
                                <xsl:when test="@school = 'white'">White Magic</xsl:when>
                                <xsl:otherwise>Black Magic</xsl:otherwise>
                            </xsl:choose>
                        </legend>
                        <div class="ff-scroll">
                            <table>
                                <thead>
                                    <tr>
                                        <th scope="col">Spell</th>
                                        <th scope="col">Level</th>
                                        <th scope="col">Price</th>
                                        <th scope="col">Classes</th>
                                        <th scope="col">Effect</th>
                                        <th scope="col">Accuracy</th>
                                        <th scope="col">Element</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <xsl:for-each select="key('spell-schools', @school)">
                                        <tr id="spell-{@id}">
                                            <th scope="row">
                                                <xsl:value-of select="@name" />
                                            </th>
                                            <td class="ff-number">
                                                <xsl:value-of select="@level" />
                                            </td>
                                            <td class="ff-number">
                                                <xsl:value-of select="@price" />
                                            </td>
                                            <td>
                                                <xsl:call-template name="classes" />
                                            </td>
                                            <td class="ff-prose">
                                                <xsl:for-each select="sf1:effect-description/sf1:line">
                                                    <p>
                                                        <xsl:value-of select="." />
                                                    </p>
                                                </xsl:for-each>
                                            </td>
                                            <td class="ff-number">
                                                <xsl:choose>
                                                    <!-- Damage uses accuracy for double damage; status, slow and morale
                                                         effects use it to determine whether they apply. -->
                                                    <xsl:when test="@effect = 1 or @effect = 2 or @effect = 3 or @effect = 4 or @effect = 5">
                                                        <xsl:value-of select="@hit" />
                                                    </xsl:when>
                                                    <xsl:otherwise>-</xsl:otherwise>
                                                </xsl:choose>
                                            </td>
                                            <td>
                                                <xsl:call-template name="resistance">
                                                    <xsl:with-param name="mask" select="number(@element-mask)" />
                                                </xsl:call-template>
                                            </td>
                                        </tr>
                                    </xsl:for-each>
                                </tbody>
                            </table>
                        </div>
                    </fieldset>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="item-name">
        <xsl:choose>
            <xsl:when test="sf1:label">
                <xsl:apply-templates select="sf1:label/node()" mode="item-text" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="@name" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="sf1:icon" mode="item-text">
        <xsl:value-of select="substring($item-glyphs, @glyph - 211, 1)" />
    </xsl:template>
    <xsl:template name="classes">
        <xsl:variable name="allowed" select="sf1:class-ref/@id" />
        <xsl:variable name="school-classes" select="key('spell-schools', @school)/sf1:class-ref/@id" />
        <xsl:variable name="classes" select="ancestor::sf1:final-fantasy/sf1:classes/sf1:class[not($school-classes) or @id = $school-classes or $school-classes = @id + 6 or $school-classes = @id - 6]" />
        <xsl:variable name="verb">
            <xsl:choose>
                <xsl:when test="self::sf1:spell">learn</xsl:when>
                <xsl:otherwise>equip</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <span class="ff-row" style="--ff-gap: .25em">
            <xsl:for-each select="$classes">
                <xsl:sort select="@id mod 6" data-type="number" />
                <xsl:sort select="@id" data-type="number" />
                <xsl:variable name="label">
                    <xsl:value-of select="@name" />
                    <xsl:choose>
                        <xsl:when test="@id = $allowed">
                            <xsl:text>: can </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>: cannot </xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:value-of select="$verb" />
                </xsl:variable>
                <span class="ff-class-sprite ff-portrait" data-class="{@id}" data-allowed="{@id = $allowed}"
                      role="img" aria-label="{$label}">
                    <xsl:attribute name="style">
                        <xsl:text>--ff-sprite: url('/slothsoft@final-fantasy/i/gfx/class?class=</xsl:text>
                        <xsl:value-of select="@id" />
                        <xsl:text>')</xsl:text>
                    </xsl:attribute>
                </span>
            </xsl:for-each>
        </span>
    </xsl:template>
    <xsl:template name="cast">
        <xsl:choose>
            <xsl:when test="@spell != 0">
                <a href="/FinalFantasy/I/Spells/#spell-{@spell}">
                    <xsl:value-of select="key('spells', @spell)/@name" />
                </a>
            </xsl:when>
            <xsl:otherwise>-</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="resistance">
        <xsl:param name="mask" select="number(@resistance-mask)" />
        <xsl:choose>
            <xsl:when test="$mask=0">-</xsl:when>
            <xsl:otherwise>
                <ul class="ff-inline-list">
                    <xsl:if test="$mask mod 2 &gt;=1">
                        <li>Status</li>
                    </xsl:if>
                    <xsl:if test="floor($mask div 2) mod 2 &gt;=1">
                        <li>Poison, Stone</li>
                    </xsl:if>
                    <xsl:if test="floor($mask div 4) mod 2 &gt;=1">
                        <li>Time</li>
                    </xsl:if>
                    <xsl:if test="floor($mask div 8) mod 2 &gt;=1">
                        <li>Death</li>
                    </xsl:if>
                    <xsl:if test="floor($mask div 16) mod 2 &gt;=1">
                        <li>Fire</li>
                    </xsl:if>
                    <xsl:if test="floor($mask div 32) mod 2 &gt;=1">
                        <li>Ice</li>
                    </xsl:if>
                    <xsl:if test="floor($mask div 64) mod 2 &gt;=1">
                        <li>Lightning</li>
                    </xsl:if>
                    <xsl:if test="floor($mask div 128) mod 2 &gt;=1">
                        <li>Earth</li>
                    </xsl:if>
                </ul>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="editor">
        <h2>About</h2>
        <p>Edit a new game immediately, or upload an NES battery save to replace it.</p>
        <p>
            <a href="/FinalFantasy/I/SaveEditor/?user={@user}">Bookmark this save</a>
            to return to it later. Anyone with this link can edit it.
        </p>
        <xsl:if test="sf1:error">
            <p role="alert">
                <strong>
                    <xsl:value-of select="sf1:error" />
                </strong>
            </p>
        </xsl:if>
        <form action="/FinalFantasy/I/SaveEditor/?user={ancestor-or-self::sf1:final-fantasy/@user}" method="post" enctype="multipart/form-data" id="ff-upload" class="ff-ui ff-panel ff-grid" style="--ff-scale: 2; --ff-columns: minmax(0, 1fr); --ff-gap: 0">
            <input type="hidden" name="ff-action" value="upload" />
            <input type="hidden" name="MAX_FILE_SIZE" value="8192" />
            <div class="ff-row" style="--ff-wrap: wrap; --ff-gap: 1em">
                <input id="ff-save" name="ff-save" type="file" accept=".sav,.srm" required="required" />
                <label for="ff-save">.sav File (8 KiB)</label>
            </div>
            <button type="submit">Load save</button>
        </form>
        <xsl:for-each select="sf1:editor">
            <form action="/FinalFantasy/I/SaveEditor/?user={ancestor-or-self::sf1:final-fantasy/@user}" method="post" id="ff-editor" class="ff-ui ff-panel ff-grid" style="--ff-scale: 2; --ff-columns: minmax(0, 1fr)">

                <input type="hidden" name="ff-source" value="{@source}" />
                <div class="ff-row" style="--ff-wrap: wrap; --ff-gap: 1em">
                    <xsl:for-each select="sf1:character">
                        <fieldset class="ff-panel">
                            <legend>
                                <span class="ff-row">
                                    <span>
                                        <xsl:value-of select="@name" />
                                    </span>
                                    <span class="ff-class-sprite" data-class="{@class}" role="img"
                                          aria-label="{key('classes', @class)/@name}">
                                        <xsl:attribute name="style">
                                            <xsl:text>--ff-sprite: url('/slothsoft@final-fantasy/i/gfx/class?class=</xsl:text>
                                            <xsl:value-of select="@class" />
                                            <xsl:text>')</xsl:text>
                                        </xsl:attribute>
                                    </span>
                                </span>
                            </legend>
                            <xsl:for-each select="sf1:weapons | sf1:armor">
                                <h3>
                                    <xsl:choose>
                                        <xsl:when test="self::sf1:weapons">Weapons</xsl:when>
                                        <xsl:otherwise>Armor</xsl:otherwise>
                                    </xsl:choose>
                                </h3>
                                <div class="ff-scroll" style="--ff-scroll-padding: .25em">
                                    <div class="ff-grid" style="--ff-row-gap: 0">
                                        <xsl:apply-templates select="sf1:slot" />
                                    </div>
                                </div>
                            </xsl:for-each>
                        </fieldset>
                    </xsl:for-each>
                </div>
                <div class="ff-grid" style="--ff-columns: minmax(0, 1fr); --ff-gap: 0">
                    <button type="submit" name="ff-action" value="save">Save changes</button>
                    <button type="submit" name="ff-action" value="download">Download edited save</button>
                </div>
            </form>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="sf1:slot">
        <xsl:variable name="kind" select="local-name(..)" />
        <xsl:variable name="character" select="../../@index" />
        <xsl:variable name="selected" select="@id" />
        <xsl:variable name="field" select="concat('equipment[', $character, '][', $kind, '][', @index, ']')" />
        <xsl:variable name="id" select="concat('ff-', $character, '-', $kind, '-', @index)" />
        <xsl:variable name="options">
            <option value="0">
                <xsl:if test="$selected=0">
                    <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
            </option>
            <xsl:for-each select="ancestor::sf1:final-fantasy/*[local-name()=$kind]/*">
                <option aria-label="{@name}" value="{@id}">
                    <xsl:if test="@id=$selected">
                        <xsl:attribute name="selected">selected</xsl:attribute>
                    </xsl:if>
                    <xsl:variable name="text">
                        <xsl:choose>
                            <xsl:when test="sf1:label">
                                <xsl:apply-templates select="sf1:label/node()" mode="item-text" />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@name" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:value-of select="normalize-space($text)" />
                </option>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="option-width">
            <xsl:for-each select="exsl:node-set($options)/*">
                <xsl:sort select="string-length(.)" data-type="number" order="descending" />
                <xsl:if test="position()=1">
                    <xsl:value-of select="string-length(.)" />
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <div class="ff-grid" style="--ff-columns: 1em minmax(0, 1fr); --ff-gap: .5em">
            <input type="checkbox" class="ff-equipped" name="{$field}[equipped]" value="1"
                   aria-label="Equip {../../@name} {$kind} slot {@index+1}">
                <xsl:if test="@equipped=1">
                    <xsl:attribute name="checked">checked</xsl:attribute>
                </xsl:if>
            </input>
            <select class="ff-select" name="{$field}[id]" id="{$id}" aria-label="{../../@name} {$kind} slot {@index+1}">
                <xsl:attribute name="style">
                    <xsl:text>--ff-option-width: </xsl:text>
                    <xsl:value-of select="$option-width" />
                    <xsl:text>ch</xsl:text>
                </xsl:attribute>
                <xsl:copy-of select="$options" />
            </select>
        </div>
    </xsl:template>
</xsl:stylesheet>
