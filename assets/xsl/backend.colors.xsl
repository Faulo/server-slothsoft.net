<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:template match="data">
		<div>
			<style type="text/css"><![CDATA[
#backend-colors table {
	display: inline-table;
}
#backend-colors td:first-child {
	width: 300px;
	font-family: myCode;
}
#backend-colors td input {
	font-family: myCode;
}
#backend-lorem > * {
	display: inline-block;
	margin: 8px 16px;
}
#backend-lorem p {
	max-width: 400px;
}
			]]></style>
			<article>
				<h2>Backend Color Picker</h2>
				<div id="backend-colors"/>
				<div id="backend-lorem">
					<div>
						<h3>normal Box</h3>
						<p>
							Lorem ipsum dolor sit amet, <a href="/">consectetur</a> adipisicing elit, sed do eiusmod tempor <a href="/?NotClicked">incididunt</a> ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. 
						</p>
					</div>
					<fieldset class="paintedBox">
						<legend>painted Box</legend>
						<p>
							Lorem ipsum dolor sit amet, <a href="/">consectetur</a> adipisicing elit, sed do eiusmod tempor <a href="/?NotClicked">incididunt</a> ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. 
						</p>
					</fieldset>
				</div>
				
			</article>
		</div>
	</xsl:template>
</xsl:stylesheet>
