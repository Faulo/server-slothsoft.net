<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sfm="http://schema.slothsoft.net/farah/module"
	xmlns:sfx="http://schema.slothsoft.net/farah/xslt">

	<xsl:import href="farah://slothsoft@farah/xsl/module" />
	<xsl:import href="farah://slothsoft@farah/xsl/xslt" />

	<xsl:output method="xml" cdata-section-elements="style script" />

	<xsl:template match="sfm:document-info" />

	<xsl:template match="sfm:document-info[@name = 'data']">
		<template id="melnics-data">
			<xsl:copy-of select="*" />
		</template>
	</xsl:template>

	<xsl:template match="sfm:document-info[@name = 'script']">
		<script type="importmap"><![CDATA[
{
  "imports": {
    "]]><xsl:value-of select="@href" /><![CDATA[": "data:application/javascript;base64,]]><xsl:value-of select="sfx:base64-encode()" /><![CDATA["
  }
}
        ]]></script>
		<script type="application/javascript"><![CDATA[
document.addEventListener(
    "DOMContentLoaded",
    async () => {
        await import("]]><xsl:value-of select="@href" /><![CDATA[");
    }
);
]]></script>
	</xsl:template>

	<xsl:template match="sfm:document-info[@name = 'css']">
		<style type="text/css">
			<xsl:value-of select="text" />
		</style>
	</xsl:template>

	<xsl:template match="sfm:document-info[@name = 'font']">
		<style type="text/css"><![CDATA[
		@font-face {
		    font-family: myMelnics;
		    src: local("MelniksFont"),  url('data:font/ttf;base64,]]><xsl:value-of select="base64" /><![CDATA[') format("truetype");
		}
		]]></style>
	</xsl:template>

	<xsl:template match="/*">
		<html class="MelnicsStandalone">
			<head>
				<title>Melnics Translator - Standalone Version</title>
				<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=yes" />
				<meta name="author" content="Daniel Schulz" />
				<xsl:apply-templates select="sfm:document-info" />
			</head>
			<body>
				<div class="Translator MelnicsTranslator" id="melnics-translator">
					<xsl:apply-templates select="sfm:error" mode="sfm:html" />
					<header>
						<h1>Melnics Translator - Standalone Version</h1>
					</header>
					<article>
						<h2>Pronunciation</h2>
						<label>
							<span>
								Input latin transcription of spoken Melnics here....
							</span>
							<textarea placeholder="baiba!" data-translator-type="melnics" class="input-melnics" oninput="MelnicsTranslator.typeCharacter(this)" autofocus="autofocus" disabled="disabled" />
						</label>
						<h2>Meaning</h2>
						<label>
							<span>
								Input English text to be melnicsized here....
							</span>
							<textarea placeholder="wow!" data-translator-type="english" class="input-english" oninput="MelnicsTranslator.typeCharacter(this)" disabled="disabled" />
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
