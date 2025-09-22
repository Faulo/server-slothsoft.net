<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="/*">
		<div>
			<p data-media="screen">
				Taken from
				<a rel="external" href="http://aselia.wikia.com/wiki/ToG_-_Magic_Carta">Aselia</a>
				, reformatted as printable checkbox-list.
				<br />
				At 65% zoom it fits nicely on 2 pages.
			</p>
			<table class="MagicCarta paintedTable">
				<thead>
					<tr>
						<td />
						<th>#</th>
						<th>Character</th>
						<th>Method of Acquisition</th>
						<th>Primary Quote</th>
						<th>Secondary Quote</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each select=".//card">
						<tr>
							<td>☐</td>
							<td class="number">
								<xsl:value-of select="@no" />
							</td>
							<td>
								<xsl:value-of select="@name" />
							</td>
							<td>
								<xsl:value-of select="@where" />
							</td>
							<td>
								<xsl:value-of select="@quote-1" />
							</td>
							<td>
								<xsl:value-of select="@quote-2" />
							</td>

						</tr>
					</xsl:for-each>
				</tbody>
			</table>
		</div>
	</xsl:template>
</xsl:stylesheet>
