<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sfm="http://schema.slothsoft.net/farah/module" xmlns:sfx="http://schema.slothsoft.net/farah/xslt">

    <xsl:import href="farah://slothsoft@farah/xsl/module" />
    <xsl:import href="farah://slothsoft@farah/xsl/xslt" />
    <xsl:import href="farah://slothsoft@slothsoft.net/talesof/xsl/melnics.translator" />

    <xsl:output method="xml" cdata-section-elements="style script" />

    <xsl:template match="/*">
        <html class="MelnicsStandalone">
            <head>
                <title>Melnics Translator - Standalone Version</title>
                <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=yes" />
                <meta name="author" content="Daniel Schulz" />
                <xsl:for-each select="sfm:document-info[contains(@href, '/css/')]">
                    <style type="text/css">
                        <xsl:value-of select="text" />
                    </style>
                </xsl:for-each>
                <xsl:for-each select="sfm:document-info[contains(@href, '/fonts/')]">
                    <style type="text/css"><![CDATA[
        @font-face {
            font-family: myMelnics;
            src: local("MelniksFont"),  url('data:font/ttf;base64,]]><xsl:value-of select="base64" /><![CDATA[') format("truetype");
        }
        ]]></style>
                </xsl:for-each>
                <script type="importmap"><![CDATA[
{
  "imports": {]]>
                    <xsl:for-each select="sfm:document-info[starts-with(@name, 'script')]"><![CDATA[
    "]]><xsl:value-of select="@href" /><![CDATA[": "data:application/javascript;base64,]]><xsl:value-of select="sfx:base64-encode()" /><![CDATA[",]]></xsl:for-each><![CDATA[
    "/":"/"
  }
}
        ]]></script>
            </head>
            <body>
                <div class="Translator MelnicsTranslator" id="melnics-translator">
                    <xsl:apply-templates select="sfm:error" mode="sfm:html" />
                    <xsl:call-template name="melnics.translator" />
                    <header>
                        <h1>Melnics Translator - Standalone Version</h1>
                    </header>
                    <article>
                        <h2>Pronunciation</h2>
                        <label>
                            <span>
                                Input latin transcription of spoken Melnics here....
                            </span>
                            <textarea placeholder="baiba!" data-translator-type="melnics" class="input-melnics" autofocus="autofocus" disabled="disabled" />
                        </label>
                        <h2>Meaning</h2>
                        <label>
                            <span>
                                Input English text to be melnicsized here....
                            </span>
                            <textarea placeholder="wow!" data-translator-type="english" class="input-english" disabled="disabled" />
                        </label>
                        <h2>Spelling</h2>
                        <label>
                            <span>
                                Actual Melnics...
                            </span>
                            <textarea placeholder="wow!" class="output-english Melnics" readonly="readonly" disabled="disabled" />
                        </label>
                        <p class="footer">
                            <a href="https://slothsoft.net/Tales/MelnicsTranslator/">Melnics Translator</a>
                            © Daniel Schulz
                        </p>
                    </article>
                </div>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
