<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://schema.slothsoft.net/farah/sitemap" xmlns:sfm="http://schema.slothsoft.net/farah/module" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="/*">
		<sitemap version="1.0">
			<page name="Tales" title="Tales" ref="/pages/tales/tales-home" status-active="" status-public="">
				<page name="CraymelEditor" title="Craymel Editor" ref="/pages/tales/craymelEditor" status-active="" status-public="" />
				<page name="MelnicsTable" title="MelnicsTable" ref="/pages/tales/melnicsTable" status-active="" status-public="" redirect="/Tales/" />
				<page name="MelnicsTest" title="Melnics Test" ref="/pages/tales/melnicsTest" status-active="" status-public="" redirect="/Tales/" />
				<page name="MelnicsTranslator" title="MelnicsTranslator" ref="/pages/tales/melnicsTranslator" status-active="" status-public="" />

				<page name="MagicCarta" title="Magic Carta List" ref="/pages/tales/carta-list" status-active="" status-public="" />
			</page>



			<page name="TalesOfEternia" title="Tales of Eternia" redirect="/Tales" status-active="">
				<page name="CraymelEditor" title="Craymel Editor" redirect="/Tales/CraymelEditor" status-active="" />
				<page name="MelnicsTable" title="MelnicsTable" redirect="/Tales/MelnicsTable" status-active="" />
				<page name="MelnicsTest" title="Melnics Test" redirect="/Tales/MelnicsTest" status-active="" />
				<page name="MelnicsTranslator" title="MelnicsTranslator" redirect="/Tales/MelnicsTranslator" status-active="" />
			</page>
			<page name="TalesOfGraces" title="Tales of Graces" redirect="/Tales" status-active="">
				<page name="MagicCarta" title="Magic Carta List" redirect="/Tales/MagicCarta" status-active="" />
			</page>
		</sitemap>
	</xsl:template>
</xsl:stylesheet>
				