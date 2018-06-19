<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns			= "http://www.w3.org/2000/svg"
	xmlns:xsl		= "http://www.w3.org/1999/XSL/Transform"
	xmlns:xlink		= "http://www.w3.org/1999/xlink">
		
	<xsl:key name="param" match="/data/request/param" use="@name"/>
		
	<xsl:template match="/*">
		<xsl:variable name="text" select="key('param', 'text')"/>
		<xsl:variable name="color" select="key('param', 'color')"/>
		
		<svg version="1.2" baseProfile="tiny"			
			contentScriptType="application/javascript"
			contentStyleType="text/css"
			preserveAspectRatio="xMidYMid"
			
			color-rendering="optimizeSpeed"
			shape-rendering="optimizeSpeed"
			text-rendering="optimizeSpeed"
			image-rendering="optimizeSpeed"
			>
			<title>
				Writing
			</title>
			<defs>
				<g id="filter">
					<filter id="blackOutline">
						<feMorphology operator="dilate" radius="1"
							in="SourceAlpha"
							result="Outline"/>
						<feMerge>
							<feMergeNode in="Outline"/>
							<feMergeNode in="SourceGraphic"/>
						</feMerge>
					</filter>
					<!--
					<filter id="dropShadow">
						<feMorphology operator="dilate" radius="2" result="background" in="SourceAlpha"/>
						<feMerge>
							<feMergeNode in="background"/>
							
							<feMergeNode in="SourceGraphic"/>
						</feMerge>
					</filter>
					<filter id="greyOutline">
						<feFlood flood-color="#111" result="color"/>
						<feComposite operator="in"
							in="color"
							in2="SourceAlpha"
							result="StrokeAlpha"/>
						<feMorphology operator="dilate" radius="2"
							in="StrokeAlpha"
							result="Outline"/>
						<feMerge>
							<feMergeNode in="Outline"/>
							<feMergeNode in="SourceGraphic"/>
						</feMerge>
					</filter>
					<filter id="silverOutline">
						<feFlood flood-color="silver" result="color"/>
						<feComposite operator="in"
							in="color"
							in2="SourceAlpha"
							result="StrokeAlpha"/>
						<feMorphology operator="dilate" radius="2"
							in="StrokeAlpha"
							result="Outline"/>
						<feMerge>
							<feMergeNode in="Outline"/>
							<feMergeNode in="SourceGraphic"/>
						</feMerge>
					</filter>
					<filter id="strokeOutline">
						<feComposite operator="in"
							in="StrokePaint"
							in2="SourceAlpha"
							result="StrokeAlpha"/>
						<feMorphology operator="dilate" radius="2"
							in="StrokeAlpha"
							result="Outline"/>
						<feMerge>
							<feMergeNode in="Outline"/>
							<feMergeNode in="SourceGraphic"/>
						</feMerge>
					</filter>
					<filter id="gammaOutline">
						<feFlood flood-color="#111" result="color"/>
						<feComposite operator="in"
							in="color"
							in2="SourceAlpha"
							result="StrokeAlpha"/>
						<feMorphology operator="dilate" radius="2"
							in="StrokeAlpha"
							result="Outline"/>
						<feMerge result="blackOutline">
							<feMergeNode in="Outline"/>
							<feMergeNode in="SourceGraphic"/>
						</feMerge>
						<feComponentTransfer in="blackOutline">
							<feFuncR type="gamma" amplitude="3"/>
							<feFuncG type="gamma" amplitude="3"/>
							<feFuncB type="gamma" amplitude="3"/>
						</feComponentTransfer>
					</filter>
					<filter id="clickOutline">
						<feFlood flood-color="#111" result="color"/>
						<feComposite operator="in"
							in="color"
							in2="SourceAlpha"
							result="StrokeAlpha"/>
						<feMorphology operator="dilate" radius="2"
							in="StrokeAlpha"
							result="Outline"/>
						<feMerge result="blackOutline">
							<feMergeNode in="Outline"/>
							<feMergeNode in="SourceGraphic"/>
						</feMerge>
						<feComponentTransfer in="blackOutline" result="gammaOutline">
							<feFuncR type="gamma" amplitude="3"/>
							<feFuncG type="gamma" amplitude="3"/>
							<feFuncB type="gamma" amplitude="3"/>
						</feComponentTransfer>
						<feOffset in="gammaOutline" dx="1" dy="1"/>
					</filter>
					-->
				</g>
			</defs>
			<xsl:if test="$text">
				<style><![CDATA[
/* Filter */
#writing {
	filter: url(#blackOutline);
	font-size: 16px;
	font-family: monospace;
	text-anchor: start;
	dominant-baseline: hanging;
	font-weight: bold;
	transform: scale(2);
}
/*
#writing:hover {
	filter: url(#gammaOutline);
}
*/
				]]></style>
				<text id="writing" x="0.5em" y="0">
					<xsl:if test="$color">
						<xsl:attribute name="fill"><xsl:value-of select="$color"/></xsl:attribute>
					</xsl:if>
					<xsl:value-of select="$text"/>
				</text>
			</xsl:if>
		</svg>
	</xsl:template>
</xsl:stylesheet>