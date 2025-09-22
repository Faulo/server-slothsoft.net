<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="/data">
		<article>
			<h2>Tales of Link - Heroes</h2>
			<xsl:apply-templates select="resource" />
		</article>
	</xsl:template>

	<xsl:template match="resource/heroes">
		<table data-sortable="" class="paintedTable">
			<thead>
				<tr>
					<th>Hero</th>
					<th>Title</th>
					<th>Rarity</th>
					<th>Type</th>
					<!-- <th>Series</th> <th>HP</th> <th>ATK</th> <th>RCV</th> -->
					<th>Leader Skill</th>
					<th>Active Skill</th>
					<th>Cost</th>
				</tr>
			</thead>
			<tbody>
				<xsl:for-each select="character[@Rarity &gt; 3]">
					<xsl:sort select="@Series" />
					<xsl:sort select="@Hero" />
					<xsl:sort select="@Rarity" order="descending" />
					<tr>
						<td>
							<xsl:value-of select="@Hero" />
						</td>
						<td>
							<a href="{@Wiki}" rel="external" target="_blank">
								<xsl:value-of select="@Title" />
							</a>
						</td>
						<td class="number">
							<xsl:value-of select="@Rarity" />
						</td>
						<td>
							<xsl:value-of select="@Type" />
						</td>
						<!-- <td><xsl:value-of select="@Series"/></td> <td><xsl:value-of select="@HP"/></td> <td><xsl:value-of select="@ATK"/></td> 
							<td><xsl:value-of select="@RCV"/></td> -->
						<td>
							<xsl:value-of select="@LeaderSkillDescription" />
						</td>
						<td>
							<xsl:value-of select="@ActiveSkillDescription" />
						</td>
						<td class="number">
							<xsl:value-of select="@ActiveSkillCost" />
						</td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>
</xsl:stylesheet>
