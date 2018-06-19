<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="/data">
		<xsl:variable name="pcs" select=".//data[part]"/>
		<html>
			<head>
				<title>Slothsoft's Computers</title>
				<style type="text/css"><![CDATA[
[data-price="1"] {
	text-shadow: 0px 0px 10px red,  0px 0px 10px red,  0px 0px 10px red,  0px 0px 10px red;
}
[data-price="0"] {
	text-shadow: 0px 0px 10px yellow,  0px 0px 10px yellow,  0px 0px 10px yellow,  0px 0px 10px yellow;
}			
[data-price="-1"] {
	text-shadow: 0px 0px 10px green,  0px 0px 10px green,  0px 0px 10px green,  0px 0px 10px green;
}			
tbody > tr {
	border-bottom: 1px dotted silver;
}
fieldset {
	margin: 8px 0px;
}
details {
	padding: 0px 4px;
}
td details > ul > li {
	display: inline-block;
	width: 80px;
}
td details > ul {
	padding: 0;
}
td th {
	text-align: right;
}
table[id] {
	background-color: #eee;
	width: 100%;
}
table[id] > * > tr > * {
	padding: 0.25em 0.5em;
	background-color: #eef;
}
table[id], table[id] > * > tr > * {
	border: 1px solid gray;
}
.part-details {
	width: 256px;
}
.part-name {
	width: 160px;
}
.part-power {
	width: 64px;
}
.part-type, .part-price {
	width: 96px;
}
body {
	padding: 2em;
}
caption {
	text-align: left;
}
				]]></style>
			</head>
			<body>
				<h1>Computerübersicht</h1>
				<details>
					<summary>Computer:</summary>
					<ul>
						<xsl:for-each select="$pcs">
							<xsl:variable name="id" select="translate(@name, ' ', '_')"/>
							<li>
								<a href="#{$id}">
									<xsl:value-of select="@name"/>
								</a>
							</li>
						</xsl:for-each>
					</ul>
				</details>
				<hr/>
				<xsl:apply-templates select="$pcs"/>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="data">
		<xsl:variable name="id" select="translate(@name, ' ', '_')"/>
		<!--
		<fieldset id="{$id}">
			<legend>
				<strong><a href="#{$id}"><xsl:value-of select="@name"/></a></strong>
			</legend>
			-->
			<table id="{$id}">
				<caption><h2><a href="#{$id}"><xsl:value-of select="@name"/></a></h2></caption>
				<thead>
					<tr>
						<th class="part-type">Part</th>
						<th class="part-name">Name</th>
						<th class="part-details">Properties</th>
						<th class="part-power">Power</th>
						<th class="part-price">Price</th>
						<th class="part-history">Price History</th>
					</tr>
				</thead>
				<tfoot>
					<tr>
						<td/>
						<td/>
						<td/>
						<td><xsl:value-of select="sum(*/@tdp)"/>&#160;W</td>
						<th><xsl:value-of select="format-number(sum(*/@price), '0.00')"/>&#160;€</th>
						<th title="Tatsächlich bezahlter Preis">(<xsl:value-of select="format-number(sum(@final-price), '0.00')"/>&#160;€)</th>
					</tr>
				</tfoot>
				<tbody>
					<xsl:for-each select="part">
						<tr>
							<th><xsl:value-of select="@type"/></th>
							<td>
								<xsl:choose>
									<xsl:when test="@href">
										<a href="{@href}">
											<xsl:value-of select="@name"/>
										</a>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="@name"/>
									</xsl:otherwise>
								</xsl:choose>
							</td>
							<td>
								<xsl:apply-templates select="."/>
								
							</td>
							<td class="number"><xsl:value-of select="@tdp"/>&#160;W</td>
							<td class="number">
								<xsl:choose>
									<xsl:when test="@price-uri">
										<a href="{@price-uri}">
											<xsl:value-of select="format-number(@price, '0.00')"/>&#160;€
										</a>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="format-number(@price, '0.00')"/>&#160;€
									</xsl:otherwise>
								</xsl:choose>
							</td>
							<td>
								<xsl:if test="price">
									<details>
										<summary>
											<xsl:value-of select="count(price)"/>
											<xsl:text> Preise:</xsl:text>
										</summary>
										<ul>
											<xsl:for-each select="price">
												<xsl:variable name="prev" select="preceding-sibling::price[1]"/>
												<xsl:if test="number(@price) != number($prev/@price)">
													<li title="{@date}" class="number">
														<xsl:choose>
															<xsl:when test="@price &gt; ../@price">
																<xsl:attribute name="data-price">1</xsl:attribute>
															</xsl:when>
															<xsl:when test="@price &lt; ../@price">
																<xsl:attribute name="data-price">-1</xsl:attribute>
															</xsl:when>
															<xsl:otherwise>
																<xsl:attribute name="data-price">0</xsl:attribute>
															</xsl:otherwise>
														</xsl:choose>
														
														<xsl:value-of select="format-number(@price, '0.00')"/>&#160;€
													</li>
												</xsl:if>
											</xsl:for-each>
										</ul>
									</details>
								</xsl:if>
							</td>
						</tr>
					</xsl:for-each>
				</tbody>
			</table>
			<!--
		</fieldset>
		-->
	</xsl:template>
	
	<xsl:template match="part">
		<ul>
			<xsl:for-each select="properties/@*">
				<li><xsl:value-of select="name()"/>: <xsl:value-of select="."/></li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	
	<xsl:template match="part[@type='RAM']">
		<table>
			<tr>
				<th>Größe:</th>
				<td><xsl:value-of select="properties/@size"/></td>
			</tr>
			<tr>
				<th>Typ:</th>
				<td><xsl:value-of select="properties/@type"/></td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="part[@type='HDD']">
		<table>
			<tr>
				<th>Größe:</th>
				<td><xsl:value-of select="properties/@size"/></td>
			</tr>
		</table>
	</xsl:template>
	
	<xsl:template match="part[@type='Chassis']">
		<table>
			<tr>
				<th>Größe:</th>
				<td><xsl:value-of select="properties/@size"/></td>
			</tr>
			<tr>
				<th>Netzteil:</th>
				<td><xsl:value-of select="properties/@psu"/></td>
			</tr>
		</table>
	</xsl:template>
	
	<xsl:template match="part[@type='CPU']">
		<table>
			<tr>
				<th>Taktfrequenz:</th>
				<td><xsl:value-of select="properties/@frequency"/></td>
			</tr>
			<tr>
				<th>Kerne:</th>
				<td><xsl:value-of select="properties/@cores"/></td>
			</tr>
			<!--
			<tr>
				<th>Level 2 Cache:</th>
				<td><xsl:value-of select="properties/@cache-l2"/></td>
			</tr>
			<tr>
				<th>Level 3 Cache:</th>
				<td><xsl:value-of select="properties/@cache-l3"/></td>
			</tr>
			-->
		</table>
	</xsl:template>
	<xsl:template match="part[@type='Mainboard']">
		<table>
			<tr>
				<th>Sockel:</th>
				<td><xsl:value-of select="properties/@socket"/></td>
			</tr>
			<tr>
				<th>RAM-Typ:</th>
				<td><xsl:value-of select="properties/@ram"/></td>
			</tr>
			<tr>
				<th>Form-Faktor:</th>
				<td><xsl:value-of select="properties/@form"/></td>
			</tr>
		</table>
	</xsl:template>
	
	<xsl:template match="part[@type='GPU']">
		<table>
			<tr>
				<th>Taktfrequenz:</th>
				<td><xsl:value-of select="properties/@frequency"/></td>
			</tr>
			<tr>
				<th>RAM:</th>
				<td><xsl:value-of select="properties/@memory"/></td>
			</tr>
			<!--
			<tr>
				<th>Level 2 Cache:</th>
				<td><xsl:value-of select="properties/@cache-l2"/></td>
			</tr>
			<tr>
				<th>Level 3 Cache:</th>
				<td><xsl:value-of select="properties/@cache-l3"/></td>
			</tr>
			-->
		</table>
	</xsl:template>
	<xsl:template match="part[@type='PSU']">
		<table>
			<tr>
				<th>Leistung:</th>
				<td><xsl:value-of select="properties/@power"/></td>
			</tr>
		</table>
	</xsl:template>
	
	
	<xsl:template match="part[@type='Audio']">
		<table>
			<tr>
				<th>Lautsprecher:</th>
				<td><xsl:value-of select="properties/@channels"/></td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="part[@type='Scanner']|part[@type='Multiding']">
		<table>
			<tr>
				<th>Scanverfahren:</th>
				<td><xsl:value-of select="properties/@scan-type"/></td>
			</tr>
			<tr>
				<th>Scanauflösung:</th>
				<td><xsl:value-of select="properties/@scan-resolution"/></td>
			</tr>
		</table>
	</xsl:template>
</xsl:stylesheet>
