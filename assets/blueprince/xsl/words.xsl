<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sfm="http://schema.slothsoft.net/farah/module">

    <xsl:template match="/*">
        <div class="WordBuilder">
            <xsl:apply-templates select="sfm:error" mode="sfm:html" />
            <article>
                <h2>About</h2>
                <p>This is a word builder that, given a range of letters, looks up all dictionary words that can be formed by them.</p>
                <p>
                    It's intended to help solve the dreaded
                    <a href="https://blue-prince.fandom.com/wiki/Gallery" rel="external">Gallery</a>
                    puzzle of Blue Prince.
                </p>
                <p>
                    It uses dwyl's
                    <a href="https://github.com/dwyl/english-words" rel="external">List Of English Words</a>
                    to accomplish this.
                </p>
                <xsl:for-each select="*/dictionary">
                    <form action="" method="GET">
                        <h2 class="heading">Input</h2>
                        <ul class="input">
                            <xsl:for-each select="input">
                                <li>
                                    <input type="text" name="letters[]" placeholder="abcefghijklm" value="{.}" />
                                </li>
                            </xsl:for-each>
                        </ul>
                        <button type="submit">Look up words!</button>
                    </form>
                    <xsl:choose>
                        <xsl:when test="word">
                            <h2 class="heading">Result</h2>
                            <table class="output">
                                <thead>
                                    <tr>
                                        <xsl:for-each select="initial">
                                            <th>
                                                <xsl:value-of select="."></xsl:value-of>
                                            </th>
                                        </xsl:for-each>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <xsl:for-each select="initial">
                                            <xsl:variable name="i" select="." />
                                            <td>
                                                <ul>
                                                    <xsl:for-each select="../word[starts-with(., $i)]">
                                                        <li>
                                                            <xsl:value-of select="." />
                                                        </li>
                                                    </xsl:for-each>
                                                </ul>
                                            </td>
                                        </xsl:for-each>
                                    </tr>
                                </tbody>
                            </table>
                        </xsl:when>
                        <xsl:when test="initial">
                            <i>No words found for current input.</i>
                        </xsl:when>
                        <xsl:otherwise>
                            <i>Input letters to start the search.</i>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </article>
        </div>
    </xsl:template>

</xsl:stylesheet>
