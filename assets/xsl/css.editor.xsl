<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:template match="/data">
		<div>
			<xsl:call-template name="propertyForm">
				<xsl:with-param name="title" select="'Schriftfarbe'"/>
				<xsl:with-param name="property" select="'color'"/>
			</xsl:call-template>
			<xsl:call-template name="propertyForm">
				<xsl:with-param name="title" select="'Hintergrundfarbe'"/>
				<xsl:with-param name="property" select="'background-color'"/>
			</xsl:call-template>
			<!--
			<xsl:call-template name="propertyForm">
				<xsl:with-param name="title" select="'Rahmenfarbe'"/>
				<xsl:with-param name="property" select="'border-color'"/>
			</xsl:call-template>
			-->
		</div>
	</xsl:template>
	
	<xsl:template name="propertyForm">
		<xsl:param name="title"/>
		<xsl:param name="property"/>
		<xsl:param name="propertyList" select=".//property[@name = $property]"/>
		<table class="paintedTable">
			<thead>
				<tr>
					<th colspan="2"><xsl:value-of select="$title"/></th>
				</tr>
				<tr>
					<th colspan="2"><code><xsl:value-of select="$property"/></code></th>
				</tr>
			</thead>
			<tbody>
				<xsl:for-each select="$propertyList">
					<tr>
						<td><xsl:value-of select="../@selector"/></td>
						<td>
							<input type="text" value="{@value}"
								onkeyup="Backend.setColor(this)"
								data-css-selector="{../@selector}"
								data-css-property="{@name}"/>
						</td>
					</tr>
				</xsl:for-each>
			</tbody>
				
		</table>
	</xsl:template>
	
	<xsl:template match="rule[@type = 'style']">
		<dt>
			<xsl:value-of select="@selector"/>
		</dt>
		<dd>
			<ul>
				<xsl:apply-templates select="property"/>
			</ul>
		</dd>
	</xsl:template>
	<xsl:template match="property">
		<li>
			<label>
				<span><xsl:value-of select="@name"/></span>
				<input type="text" value="{@value}"/>
			</label>
		</li>
	</xsl:template>
</xsl:stylesheet>
