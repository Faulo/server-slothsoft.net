<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns="http://schema.slothsoft.net/farah/sitemap"
	xmlns:sfm="http://schema.slothsoft.net/farah/module"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="/*">
		<sitemap version="1.0">
			<page name="secretArchive" title="secretArchive" status-active="">
				<page name="Hentai" ref="archive-hentai" title="Hentai" status-active="">
					<page name="ryuutama.com" ref="archive-hentai" title="ryuutama.com" status-active="">
						<sfm:param name="load-archive" value="ryuutama.com"/>
					</page>
					<page name="readhentaimanga.com" ref="archive-hentai" title="readhentaimanga.com" status-active="">
						<sfm:param name="load-archive" value="readhentaimanga.com"/>
					</page>
					<page name="hentai.ms" ref="archive-hentai" title="hentai.ms" status-active="">
						<sfm:param name="load-archive" value="hentai.ms"/>
					</page>
					<page name="nhentai.net" ref="archive-hentai" title="nhentai.net" status-active="">
						<sfm:param name="load-archive" value="nhentai.net"/>
					</page>
					<page name="pururin.us" ref="archive-hentai" title="pururin.us" status-active="">
						<sfm:param name="load-archive" value="pururin.us"/>
					</page>
				</page>
				<page name="Manga" redirect=".." title="Manga" status-active="">
					<page name="OnePiece" ref="archive-manga" title="OnePiece" status-active="">
						<sfm:param name="load-archive" value="OnePiece"/>
					</page>
				</page>
				<page name="pr0n" ref="archive" title="pr0n" status-active="">
					<sfm:param name="load-archive" value="pr0n"/>
				</page>
				<page name="Files" ref="archive" title="Files" status-active="">
					<sfm:param name="load-archive" value="files"/>
				</page>
				<page name="Misc" ref="archive" title="Misc" status-active="">
					<sfm:param name="load-archive" value="misc"/>
					<page name="Host" ref="archive" title="Host" status-active="">
						<sfm:param name="host" value=""/>
					</page>
					<page name="Guest" ref="archive" title="Guest" status-active="">
						<sfm:param name="guest" value=""/>
					</page>
				</page>
				<page name="Media" ref="archive" title="Media" status-active="">
					<sfm:param name="load-archive" value="media"/>
					<page name="Host" ref="archive" title="Host" status-active="">
						<sfm:param name="host" value=""/>
					</page>
					<page name="Guest" ref="archive" title="Guest" status-active="">
						<sfm:param name="guest" value=""/>
					</page>
				</page>
				<page name="Backup" ref="archive" title="Backup" status-active="">
					<sfm:param name="load-archive" value="backup"/>
					<page name="Host" ref="archive" title="Host" status-active="">
						<sfm:param name="host" value=""/>
					</page>
					<page name="Guest" ref="archive" title="Guest" status-active="">
						<sfm:param name="guest" value=""/>
					</page>
				</page>
				<page name="Ghibli" ref="archive" title="Ghibli" status-active="">
					<sfm:param name="load-archive" value="ghibli"/>
				</page>
				<page name="Chat" ref="archive" title="Chat" status-active="">
					<sfm:param name="chat" value=""/>
				</page>
			</page>
			
			<page name="downloads">
				<sfm:param name="load-archive" value="files"/>
				<page name="TheLegendOfZelda-TheWindWaker-PronounPatcher.zip" ref="archive" status-active="">
					<sfm:param name="download" value="id-0603f914d59ae8de9e1b5ce9381adb13"/>
				</page>
				<page name="tales" status-active="" ref="archive">
					<sfm:param name="load-archive" value="tales"/>
					<!--
					http://slothsoft.net/downloads/tales/livestream.2014-06-20.flv
					http://slothsoft.net/secretArchive/Files/?download=
					-->
					<page name="livestream.2014-06-20" ref="archive" status-active="">
						<sfm:param name="nico" value="id-67eb4988c95bab6cacc7e606339a0a34"/>
					</page>
					<page name="livestream.2014-07-30" ref="archive" status-active="">
						<sfm:param name="nico" value="id-eaae0cd8fb3fcd0574cd52050a456ba2"/>
					</page>
					<page name="livestream.2014-08-22" ref="archive" status-active="">
						<sfm:param name="nico" value="id-dc771a8c6fdfd278873e95eb8939c74a"/>
					</page>
					<page name="livestream.2014-09-31" ref="archive" status-active="">
						<sfm:param name="nico" value="id-66f6bee157c781cf78eb97f2ab1c3c89"/>
					</page>
					<page name="livestream.2014-11-12" ref="archive" status-active="">
						<sfm:param name="nico" value="id-659b9a71f5e395bb76ad0b0706555554"/>
					</page>
					<page name="livestream.2014-11-26" ref="archive" status-active="">
						<sfm:param name="nico" value="id-7ed70f15056d19043285b3b07ae58026"/>
					</page>
					<page name="livestream.2014-12-25" ref="archive" status-active="">
						<sfm:param name="nico" value="id-17aa0649b86353330b8dfead8aea4678"/>
					</page>
				</page>
			</page>
		</sitemap>
	</xsl:template>
</xsl:stylesheet>
				