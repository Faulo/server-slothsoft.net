<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:template match="/data">
		<div class="fire-emblem">
			<xsl:for-each select=".//game">
				<xsl:variable name="name" select="translate(concat('Fire Emblem: ', @name), ' ', ' ')"/>
				<section class="sectionCredits">
					<h2>All <xsl:value-of select="count(char)"/> characters' relationships from <a rel="external" href="{@wiki-uri}"><xsl:value-of select="$name"/></a></h2>
					<p>
						shipshipship /o/
					</p>
					<p>
						This tool allows you to chart out your very own Fire Emblem fleet o' ships. When you're done setting up Supports you can print them for a semi-pretty reference chart of the chosen relationships. \o/
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
		<xsl:variable name="charList" select="char[support]"/>
		<xsl:variable name="noList" select="char[not(support)]"/>
		
		<section class="sectionShips">
			<h2>Permalink to current setting</h2>
			<div><input class="shipLink"/></div>
			<h2>Currently Shipped: <code class="shipCount">0</code></h2>
			<div class="shipContainer charList"/>
			<h2>Currently Unshipped: <code class="unshipCount"><xsl:value-of select="count($charList)"/></code></h2>
			<div class="unshipContainer charList">
				<xsl:for-each select="$charList">
					<xsl:apply-templates select="." mode="face-anchor"/>
				</xsl:for-each>
			</div>
			<h2>Unshippable: <code><xsl:value-of select="count($noList)"/></code></h2>
			<div class="noshipContainer charList">
				<xsl:for-each select="$noList">
					<xsl:apply-templates select="." mode="face-anchor"/>
				</xsl:for-each>
			</div>
		</section>
		
		<section class="sectionRelationships">
			<h2>Available Relationships:</h2>
			<table class="charList">
				<xsl:for-each select="$charList">
					<xsl:variable name="supportList" select="support"/>
					<tr data-character="{data[@key = 'wiki-name']}">
						<td class="paintedBox">
							<xsl:apply-templates select="."/>
						</td>
						<td class="paintedBox">
							<div class="supportContainer">
								<label>
									<span class="faceContainer small">
										<span>nobody</span>
									</span>
									<input type="radio" value="" name="support-{data[@key = 'wiki-name']}" data-name="{data[@key = 'wiki-name']}" checked="checked"/>
								</label>
								<xsl:for-each select="$supportList">
									<xsl:variable name="supportChar" select="$charList[data[@key = 'Name'] = current()/@with]"/>
									<label>
										<xsl:apply-templates select="$supportChar" mode="face-label"/>
										<input type="radio" value="{$supportChar/data[@key = 'wiki-name']}" name="support-{../data[@key = 'wiki-name']}" data-name="{../data[@key = 'wiki-name']}"/>
									</label>
								</xsl:for-each>
							</div>
						</td>
					</tr>
				</xsl:for-each>
				<xsl:for-each select="$noList">
					<tr data-character="{data[@key = 'wiki-name']}">
						<td class="paintedBox">
							<xsl:apply-templates select="."/>
						</td>
						<td class="paintedBox"/>
					</tr>
				</xsl:for-each>
			</table>
		</section>
	</xsl:template>
	
	<xsl:template match="char" mode="face-link">
		<xsl:variable name="dataList" select="data"/>
		<xsl:variable name="statList" select="//stat/@name"/>
		<xsl:variable name="charName" select="$dataList[@key = 'Name']"/>
		<xsl:variable name="wikiName" select="$dataList[@key = 'wiki-name']"/>
		<a class="faceContainer" href="{$dataList[@key = 'wiki-href']}">
			<img src="{$dataList[@key = 'wiki-image']}" alt="Portrait"/>
			<span><xsl:value-of select="$charName"/></span>
		</a>
	</xsl:template>
	<xsl:template match="char" mode="face-anchor">
		<xsl:variable name="dataList" select="data"/>
		<xsl:variable name="statList" select="//stat/@name"/>
		<xsl:variable name="charName" select="$dataList[@key = 'Name']"/>
		<xsl:variable name="wikiName" select="$dataList[@key = 'wiki-name']"/>
		<a href="#character-{$wikiName}" class="faceContainer small" data-name="{$wikiName}">
			<xsl:if test="$dataList[@key = 'wiki-image']">
				<img src="{$dataList[@key = 'wiki-image']}" alt="Portrait"/>
			</xsl:if>
			<span><xsl:value-of select="$charName"/></span>
		</a>
	</xsl:template>
	<xsl:template match="char" mode="face-label">
		<xsl:variable name="dataList" select="data"/>
		<xsl:variable name="statList" select="//stat/@name"/>
		<xsl:variable name="charName" select="$dataList[@key = 'Name']"/>
		<xsl:variable name="wikiName" select="$dataList[@key = 'wiki-name']"/>
		<span class="faceContainer small" data-name="{$wikiName}">
			<xsl:if test="$dataList[@key = 'wiki-image']">
				<img src="{$dataList[@key = 'wiki-image']}" alt="Portrait"/>
			</xsl:if>
			<span><xsl:value-of select="$charName"/></span>
		</span>
	</xsl:template>
	
	<xsl:template match="char">
		<xsl:variable name="charList" select="//char"/>
		<xsl:variable name="dataList" select="data"/>
		<xsl:variable name="supportList" select="support"/>
		<xsl:variable name="statList" select="//stat/@name"/>
		<xsl:variable name="charName" select="$dataList[@key = 'Name']"/>
		<xsl:variable name="wikiName" select="$dataList[@key = 'wiki-name']"/>
		<h3 id="character-{$wikiName}"><a rel="external" href="{$dataList[@key = 'wiki-href']}"><xsl:value-of select="$charName"/></a></h3>
		<xsl:if test="$dataList[@key = 'wiki-image']">
			<a class="imageContainer" href="{$dataList[@key = 'wiki-image']}"><img src="{$dataList[@key = 'wiki-image']}" alt="Portrait"/></a>
		</xsl:if>
		<!--<a rel="external" href="{$dataList[@key = 'wiki-class-href']}"><xsl:value-of select="$dataList[@key = 'wiki-class-name']"/></a>-->
	</xsl:template>
</xsl:stylesheet>