<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:template match="/data">
		<article>
			<h2>Introduction</h2>
			<p>These pages were created by Daniel in an attempt to enter the learning of Japanese.</p>
			<p>So far, there's <a href="{//page[@name='Translator']/@uri}">a translator</a> that uses the latin transcription of furigana, <a href="{//page[@name='KanaTest']/@uri}">a testing program</a> to learn the correct reading of Hiragana and Katakana, and <a href="{//page[@name='KanaTable']/@uri}/">the transcription table</a> that is used in both.
			</p>
			<p>
			Oh, and some vocabulary lists, most prominently the 5 levels of the <a rel="external" href="http://en.wikipedia.org/wiki/JLPT">Japanese Language Proficiency Test</a>, complete with a testing tool if you want to see how much Japanese you can speak. /o/
			</p>
		</article>
	</xsl:template>
	
</xsl:stylesheet>
