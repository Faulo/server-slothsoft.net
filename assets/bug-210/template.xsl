<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:exsl="http://exslt.org/common" xmlns:func="http://exslt.org/functions" xmlns:my="my-namespace"
	xmlns:str="http://exslt.org/strings"
	extension-element-prefixes="func">

	

	<xsl:template match="/">
		<xsl:variable name="var">
			<var>value</var>
		</xsl:variable>
		
		<result>
			<my:range>
				<xsl:for-each select="my:range(0, 256, 2)">
					<xsl:value-of select="concat(., ' ')"/>
				</xsl:for-each>
			</my:range>
			<my:range-string>
				<xsl:for-each select="str:split(my:range-string(0, 256, 2))">
					<xsl:value-of select="concat(., ' ')"/>
				</xsl:for-each>
			</my:range-string>
		</result>
	</xsl:template>
	
	<func:function name="my:range">
		<xsl:param name="min" />
		<xsl:param name="max" />
		<xsl:param name="step" select="1"/>
		
		<func:result select="str:split(my:range-string($min, $max, $step))"/>
		
<!-- 		<xsl:choose> -->
<!-- 			<xsl:when test="$min &lt; $max"> -->
<!-- 				<func:result select="str:split($min) | my:range($min + $step, $max, $step)"/> -->
<!-- 			</xsl:when> -->
<!-- 			<xsl:otherwise> -->
<!-- 				<func:result select="str:split($max)"/> -->
<!-- 			</xsl:otherwise> -->
<!-- 		</xsl:choose> -->
	</func:function>
	
	<func:function name="my:range-string">
		<xsl:param name="min" />
		<xsl:param name="max" />
		<xsl:param name="step" select="1"/>
		
		<xsl:choose>
			<xsl:when test="$min &lt; $max">
				<func:result select="concat($min, ' ', my:range-string($min + $step, $max, $step))"/>
			</xsl:when>
			<xsl:otherwise>
				<func:result select="$max"/>
			</xsl:otherwise>
		</xsl:choose>
	</func:function>
</xsl:stylesheet>