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
.fire-emblem table td, .fire-emblem table th {
	white-space: nowrap;
	vertical-align: bottom;
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
				<p>The entire cast from Fire Emblem: Shadow Dragon.</p>
				<p>The characters are color-coded based on the type of their starting class. Everyone who is <span class="Finesse Base">light green</span> can change into the class of everyone else who is also <span class="Finesse Base">light green</span>, and promote into any of the <span class="Finesse Promoted">dark green</span> classes. <span class="Other">Other</span> classes can neither change nor promote.</p>
				<p>The stats given are the character-specific base stats and their base growth chance per level. To calculate the actual values, the (not here presented) class-specific stats and growth chances need to be added.</p>
				<h3>Credits</h3>
				<ul>
					<li>Juigi <small><a href="http://www.gamefaqs.com/ds/943695-fire-emblem-shadow-dragon/faqs/54527">(awesome stat guide)</a></small></li>
					<li>The Fire Emblem Wiki <small><a href="http://fireemblem.wikia.com/wiki/Fire_Emblem_Wikia">(awesome wiki)</a></small></li>
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
				<tr>
					<th>Class Type</th>
					<xsl:for-each select="$chars">
						<td><xsl:value-of select="@classType"/></td>
					</xsl:for-each>
				</tr>
				<xsl:for-each select="line[1]/cell[position() &gt; 1 and position() &lt; 12]">
					<xsl:variable name="pos" select="position()"/>
					<tr>
						<th><xsl:value-of select="@val"/></th>
						<xsl:for-each select="$chars">
							<td>
								<xsl:for-each select="cell[$pos+1]">
									<xsl:value-of select="@val"/>
									<xsl:if test="@growth and @growth != '?'">
										(<xsl:value-of select="@growth"/>%)
									</xsl:if>
								</xsl:for-each>
							</td>
						</xsl:for-each>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>
</xsl:stylesheet>