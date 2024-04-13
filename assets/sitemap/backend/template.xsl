<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns="http://schema.slothsoft.net/farah/sitemap"
	xmlns:sfm="http://schema.slothsoft.net/farah/module"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="/*">
		<sitemap version="1.0">
			<sfm:param name="dnt" value="1" scope="global"/>
			<page name="UserLog" title="UserLog" ref="/core/userLog" status-active="">
<!-- 				<sfm:param name="group" type="json" value='{"REQUEST_TURING":"human"}'/> -->
			</page>
			<!--<page name="IPLog" title="IPLog" ref="/core/ipLog" status-active=""/>-->
			<page name="Colors" title="Colors" ref="backend-colors" status-active=""/>
			<page name="PT" title="PT" ref="/pt/backend" status-active=""/>
			<page name="Languages" title="Languages" ref="/core/language-backend" status-active=""/>
			<page name="Fonts-Test" title="Fonts-Test" ref="/dev/fonts-test" status-active=""/>
		</sitemap>
	</xsl:template>
</xsl:stylesheet>
				