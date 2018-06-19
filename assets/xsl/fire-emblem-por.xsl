<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:template match="/data">
		<div class="fire-emblem">
			<style type="text/css"><![CDATA[
.fire-emblem p {
	width: 512px;
	text-align: justify;
}
.fire-emblem table {
	background-color: silver;
}
.fire-emblem table img {
	max-width: 128px;
	max-height: 256px;
}
.fire-emblem thead td, .fire-emblem thead th {
	vertical-align: bottom;
}
.fire-emblem table td, .fire-emblem table th {
	white-space: nowrap;	
	text-align: center;
}
.fire-emblem .Finesse.Base {
	background-color: #5c5;
}
.fire-emblem .Finesse.Promoted {
	background-color: #5a5;
}
.fire-emblem .Brute.Base {
	background-color: #cb5;
}
.fire-emblem .Brute.Promoted {
	background-color: #a50;
}
.fire-emblem .Other {
	background-color: lightblue;
}
			]]></style>
			<h2>About</h2>
			<section>
				<p>The entire cast from Fire Emblem: Path of Radiance.</p>
				<p>These values are the growth chance per level. Startings stats would've been awesome, but alas, I couldn't find them in a neat and orderly table during the 5 minutes I spent looking for them. :'D</p>
				<h3>Credits</h3>
				<ul>
					<li>Hyoushitsu
						<small><a href="http://www.gamefaqs.com/gamecube/920189-fire-emblem-path-of-radiance/faqs/39883">(awesome stat guide)</a></small>
					</li>
					<li>Flux_Blade
						<small><a href="http://www.gamefaqs.com/gamecube/920189-fire-emblem-path-of-radiance/faqs/47709">(awesome support conversations guide)</a></small>
					</li>
					<li>The Fire Emblem Wiki
						<small><a href="http://fireemblem.wikia.com/wiki/Fire_Emblem_Wikia">(awesome wiki)</a></small>
					</li>
				</ul>
			</section>
			<xsl:apply-templates select="*"/>
		</div>
	</xsl:template>
	
	<xsl:template match="*[line]">
		<xsl:variable name="chars" select="line[position() &gt; 1]"/>
		<table>
			<colgroup>
				<col/>
				<xsl:for-each select="$chars">
					<col class="{@classType}"/>
				</xsl:for-each>
			</colgroup>
			<thead>
				<tr>
					<th>Name</th>
					<xsl:for-each select="$chars">
						<th><a href="{@wiki}"><xsl:value-of select="@name"/></a></th>
					</xsl:for-each>
				</tr>
				<tr>
					<th>Picture</th>
					<xsl:for-each select="$chars">
						<td><a href="{@image}"><img src="{@image}"/></a></td>
					</xsl:for-each>
				</tr>
			</thead>
			<tbody>
				<tr>
					<th>Starting Class</th>
					<xsl:for-each select="$chars">
						<td><xsl:value-of select="@className"/></td>
					</xsl:for-each>
				</tr>
				<!--
				<tr>
					<th>Class Type</th>
					<xsl:for-each select="$chars">
						<td><xsl:value-of select="@classType"/></td>
					</xsl:for-each>
				</tr>
				-->
				<xsl:for-each select="line[1]/cell[position() &gt; 1 and position() &lt; 12]">
					<xsl:variable name="pos" select="position()"/>
					<tr>
						<th><xsl:value-of select="@val"/></th>
						<xsl:for-each select="$chars">
							<td>
								<xsl:for-each select="cell[$pos+1]">
									<xsl:value-of select="@val"/>%
									<xsl:if test="@growth and @growth != '?'">
										(<xsl:value-of select="@growth"/>%)
									</xsl:if>
								</xsl:for-each>
							</td>
						</xsl:for-each>
					</tr>
				</xsl:for-each>
				<tr>
					<th>Support Conversations</th>
					<xsl:for-each select="$chars">
						<td>
							<xsl:if test="support">
								<ul>
									<xsl:for-each select="support">
										<li><xsl:value-of select="@with"/></li>
									</xsl:for-each>
								</ul>
							</xsl:if>
						</td>
					</xsl:for-each>
				</tr>
			</tbody>
		</table>
	</xsl:template>
</xsl:stylesheet>