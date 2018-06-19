<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:template match="/data">
		<div class="fire-emblem">
			<xsl:for-each select=".//game">
				<section>
					<h2>All <xsl:value-of select="count(char)"/> characters from <a rel="external" href="{@wiki-uri}">Fire Emblem: <xsl:value-of select="@name"/></a></h2>
					<p>
						<xsl:value-of select="description"/>
					</p>
					<h2>Credits:</h2>
					<ul>
						<xsl:for-each select="credit">
							<li>
								<strong><xsl:value-of select="@author"/></strong>
								<xsl:text> </xsl:text>
								<small><a rel="external" href="{@href}">(<xsl:value-of select="@name"/>)</a></small>
							</li>
						</xsl:for-each>
					</ul>
				</section>
				<xsl:apply-templates select="."/>
			</xsl:for-each>
		</div>
	</xsl:template>
	
	<xsl:template match="game[char]">
		<xsl:variable name="chars" select="char"/>
		<ul class="charList">
			<xsl:for-each select="$chars">
				<li class="paintedBox">
					<xsl:apply-templates select="."/>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	
	<xsl:template match="char">
		<xsl:variable name="charList" select="//char"/>
		<xsl:variable name="dataList" select="data"/>
		<xsl:variable name="supportList" select="support"/>
		<xsl:variable name="statList" select="//stat/@name"/>
		<xsl:variable name="charName" select="$dataList[@key = 'Name']"/>
		<h3 id="character-{$dataList[@key = 'wiki-name']}"><a rel="external" href="{$dataList[@key = 'wiki-href']}"><xsl:value-of select="$charName"/></a></h3>
		<a class="imageContainer" href="{$dataList[@key = 'wiki-image']}"><img src="{$dataList[@key = 'wiki-image']}" alt="Portrait"/></a>
		<table>
			<!--
			<thead>
				<tr>
					<td colspan="3"><a rel="external" href="{$dataList[@key = 'wiki-class-href']}"><xsl:value-of select="$dataList[@key = 'wiki-class-name']"/></a></td>
				</tr>
			</thead>
			-->
			<tbody>
				<xsl:for-each select="$statList">
					<xsl:variable name="base" select="$dataList[@key = current()]"/>
					<xsl:variable name="growth" select="$dataList[@key = concat(current(), '-Growth')]"/>
					<xsl:if test="$base or $growth">
						<tr>
							<th><xsl:value-of select="."/></th>
							<td>
								<xsl:if test="$base">
									<xsl:value-of select="$base"/>
								</xsl:if>
							</td>
							<td>
								<xsl:if test="$growth">
									<xsl:value-of select="$growth"/>%
								</xsl:if>
							</td>
						</tr>
					</xsl:if>
				</xsl:for-each>
			</tbody>
			<xsl:if test="//char[support]">
				<tfoot>
					<tr>
						<th>Support</th>
						<td colspan="2" class="supportList">
							<xsl:if test="not($supportList)">
								<xsl:text>-</xsl:text>
							</xsl:if>
							<xsl:for-each select="$supportList">
								<xsl:if test="position() &gt; 1">
									<xsl:text>, </xsl:text>
								</xsl:if>
								<xsl:variable name="supportChar" select="$charList[data[@key = 'Name'] = current()/@with]"/>
								<a href="#character-{$supportChar/data[@key = 'wiki-name']}"><xsl:value-of select="@with"/></a>
							</xsl:for-each>
						</td>
					</tr>
				</tfoot>
			</xsl:if>
		</table>
	</xsl:template>
</xsl:stylesheet>