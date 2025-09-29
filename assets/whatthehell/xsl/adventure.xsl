<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/2000/svg"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink">
	<xsl:output method="xml" indent="no" encoding="UTF-8" media-type="application/xml" version="1.0" />




	<xsl:template match="*[@name='adventure']/data">
		<xsl:variable name="config" select="config" />
		<xsl:variable name="mode" select="@mode" />
		<svg version="1.2" baseProfile="tiny" contentScriptType="application/javascript" contentStyleType="text/css"
			preserveAspectRatio="xMidYMid" color-rendering="optimizeSpeed" shape-rendering="optimizeSpeed"
			text-rendering="optimizeSpeed" image-rendering="optimizeSpeed">
			<title>
				Adventure
			</title>
			<desc>
				Adventure Prototyp
			</desc>
			<defs>
				<g id="head">
					<script><![CDATA[
function toggleFullScreen(ele) {
	if ((document.fullScreenElement && document.fullScreenElement !== null) || (!document.mozFullScreen && !document.webkitIsFullScreen)) {
		if (ele.requestFullScreen) {
			ele.requestFullScreen();
		} else if (ele.mozRequestFullScreen) {
			ele.mozRequestFullScreen();
		} else if (ele.webkitRequestFullScreen) {
			ele.webkitRequestFullScreen(Element.ALLOW_KEYBOARD_INPUT);
		}
	} else {
		if (document.cancelFullScreen) {
			document.cancelFullScreen();
		} else if (document.mozCancelFullScreen) {
			document.mozCancelFullScreen();
		} else if (document.webkitCancelFullScreen) {
			document.webkitCancelFullScreen();
		}
	}
}
document.addEventListener(
	"keydown",
	function(eve) {
		if (eve.keyCode == 115) {
			toggleFullScreen(document.documentElement);
		}
	},
	false
);
addEventListener(
	"load",
	function(eve) {
		removeEventListener(
			"load",
			arguments.callee,
			true
		);
		
		var game = new Adventure();
		game.controller.loadView("]]><xsl:value-of select="$mode" /><![CDATA[");
	},
	false
);
					]]></script>
					<style><![CDATA[
/* Filter */
text {
	filter: url(#greyOutline);
}
text[data-highlight]:hover {
	filter: url(#gammaOutline);
}
text[data-highlight]:active {
	filter: url(#clickOutline);
}
.menu-button > rect {
	filter:url(#silverOutline);
	pointer-events: fill;
}
.menu-button > rect:hover + text {
	filter: url(#gammaOutline);
}
.menu-button > rect:active {
	filter:url(#greyOutline);
}
.menu-button > rect:active + text {
	filter: url(#clickOutline);
}
					]]></style>
				</g>
				<clipPath id="cp-map">
					<rect width="1000" height="500" />
				</clipPath>
				<g id="storage">
					<g data-item="sessel">
						<path
							d="m 593.25157,446.25339 c 0.0605,6.66487 0.81602,10.77889 8.24243,10.82829 0.55439,-1.84196 1.59528,-6.10069 1.29293,-11.79799 z" />
						<path
							d="m 643.89145,446.73824 c -0.0605,6.66486 -0.81602,10.77889 -8.24243,10.82829 -0.55439,-1.84195 -1.59528,-6.10069 -1.29293,-11.79799 z" />
						<path
							d="m 620.45357,412.75839 c -6.52257,-0.9395 -18.90448,-2.34009 -23.75758,-1.29293 -4.71247,1.01682 -7.49728,5.08092 -8.08081,9.37374 -0.39916,2.93645 1.13131,6.78788 1.13131,6.78788 9.23532,-4.43646 23.5472,-2.34318 32.32324,-0.16162 -0.65491,-5.16749 -1.4619,-8.31956 -1.61616,-14.70707 z" />
						<path
							d="m 647.06975,379.50592 c 0.24446,6.87811 -8.0808,40.45791 -0.64645,68.0404 -15.7719,-2.15718 -37.14136,-2.05359 -57.05051,1.45454 0,0 -4.7552,-14.5169 -0.16162,-19.0707 7.76884,-7.70158 33.61616,-1.45455 33.61616,-1.45455 0,0 -2.87252,-17.92833 -2.26262,-26.82828 1.42849,-20.84518 17.17749,-25.30979 26.50504,-22.14142 z" />
					</g>

					<g data-item="sofa">
						<path
							d="m 478.98891,447.82669 c -2.16273,1.21279 -0.78234,12.16687 6.91412,11.95469 7.66788,-0.2114 8.75603,-10.90061 6.91412,-12.27778 z" />
						<path
							d="m 553.3157,447.82668 c -2.16272,1.21279 -0.78234,12.16687 6.91413,11.95469 7.66787,-0.2114 8.75602,-10.90061 6.91411,-12.27778 z" />
						<path
							d="m 477.26038,449.44219 91.6121,-0.9693 c 0,0 1.70752,-61.80895 -4.49417,-69.14327 -4.8037,-5.68102 -29.1032,1.78064 -45.64424,1.9006 -18.71281,0.13569 -29.99067,-8.07109 -42.5108,1.00729 -9.46021,6.85961 -0.0976,43.37173 1.03711,67.20468 z" />
						<path
							d="m 478.64322,428.11763 2.41993,21.32456 80.54952,0 -2.76565,-21.97076 c -10.0421,-3.32317 -66.73796,-2.4615 -80.2038,0.6462 z" />
						<path
							d="m 467.58062,417.45535 c -1.27983,19.65851 0.33146,25.80678 1.72851,32.95614 7.87949,3.72952 17.80388,2.45917 20.39667,0.9693 10.1,-18.5679 0.22273,-35.56335 -3.45706,-37.47953 -5.82742,0.26111 -9.53275,-4.43611 -18.66812,3.55409 z" />
						<path
							d="m 574.89682,416.16295 c 1.27981,19.65851 -0.33146,25.80678 -1.72853,32.95614 -7.87949,3.72952 -17.80388,2.45917 -20.39666,0.96931 -10.1,-18.56791 -0.22274,-35.56336 3.45706,-37.47954 5.82742,0.26111 9.53275,-4.43611 18.66813,3.55409 z" />
					</g>
					<g data-item="decke">
						<path
							d="m 505.20254,322.4007 c 2.61148,-0.21658 8.14402,-4.86167 10.66974,-3.85121 -3.8431,0.70663 -6.82183,2.70984 -10.03839,4.35628 l 1.01015,1.51523 c 3.28664,-1.95417 7.04619,-4.37417 10.796,-4.16688 -0.22131,-1.0076 -8.40299,2.73101 -8.77569,4.29315 l 9.65958,-2.84106 c -4.28889,0.0613 -6.81106,2.28197 -9.65958,4.10375 1.86993,0.21157 11.42735,-3.39558 11.42735,-1.32582 l -9.78586,2.20971 1.26269,1.64149 c 3.12136,0.14934 8.89072,-3.39926 11.61676,-1.45209 l -9.97526,2.52539 0.63134,1.70462 c 4.15223,-0.54445 7.42837,-2.09174 11.55363,-1.51522 1.26938,1.15527 -8.73648,1.56982 -11.36422,2.58851 z" />
						<path
							d="m 442.74699,322.96891 c -2.61148,-0.21658 -8.14402,-4.86167 -10.66974,-3.85121 3.8431,0.70663 6.82183,2.70984 10.03839,4.35628 l -1.01015,1.51523 c -3.28664,-1.95417 -7.04619,-4.37417 -10.796,-4.16688 0.22131,-1.0076 8.40299,2.73101 8.77569,4.29315 l -9.65958,-2.84106 c 4.28889,0.0613 6.81106,2.28197 9.65958,4.10375 -1.86993,0.21157 -11.42735,-3.39558 -11.42735,-1.32582 l 9.78586,2.20971 -1.26269,1.64149 c -3.12136,0.14934 -8.89072,-3.39926 -11.61676,-1.45209 l 9.97526,2.52539 -0.63134,1.70462 c -4.15223,-0.54445 -7.42837,-2.09174 -11.55363,-1.51522 -1.26938,1.15527 8.73648,1.56982 11.36422,2.58851 z" />
						<path
							d="m 440.93159,321.51682 c 21.00937,3.02174 42.7994,2.53052 65.15484,-0.50508 l 11.61675,11.61675 c -26.61069,5.2387 -54.40936,7.80443 -86.36804,1.01016 z" />
					</g>

					<g data-item="kissen">
						<path
							d="m 643.7334,708.45633 c -4.55211,9.21632 -12.77852,16.871 -6.69227,30.68339 14.51713,9.12022 27.62652,0.887 31.81981,3.6618 4.49195,-4.7436 0.7006,-24.31969 4.79823,-27.65293 -4.35427,-7.50365 -20.93405,-4.14392 -29.92577,-6.69226 z" />
					</g>

					<g data-item="taschenlampe">
						<path
							d="m 482.97919,251.94256 c 0.36319,1.38698 7.29619,1.4639 7.90265,0.16325 l -0.065,-20.01551 c 0.6629,-0.0526 0.30384,-0.52141 1.18609,-1.23205 l 0.32016,-11.1143 c -0.65799,-1.2607 -8.42514,-2.83175 -10.98541,-0.12627 l 0,11.11167 c -0.0326,1.20847 1.36233,1.21062 1.78943,1.20405 z" />
						<path
							d="m 482.58929,220.30861 c 0.0727,1.79908 8.39766,1.91724 8.48214,-0.0893 -0.0286,-1.22172 -8.38401,-1.51726 -8.48214,0.0893 z" />
						<path
							d="m 489.375,235.93361 0,4.46428 c 0,0 2.87567,0.97948 2.85714,-2.41071 -0.0154,-2.8157 -2.85714,-2.05357 -2.85714,-2.05357 z" />
					</g>

					<g data-item="kakao">
						<path
							d="m 456.25,247.98718 c 0,0 7.81232,-2.16818 9.64286,-5.35715 1.37825,-2.40104 2.0958,-6.72502 -0.17857,-8.30357 -2.74504,-1.90523 -9.46429,3.30357 -9.46429,3.30357 l 0.0893,2.23215 c 0,0 4.96334,-4.29453 7.05357,-2.85715 1.29996,0.89394 0.71999,3.37787 -0.0893,4.73215 -1.40131,2.34498 -7.14286,4.01785 -7.14286,4.01785 z" />
						<path
							d="m 442.85714,234.14789 c 0.0517,1.52653 -2.40384,15.26627 5.17857,17.14286 l 7.5,-0.0893 c 6.16614,-2.76223 4.26157,-15.48417 4.10715,-17.14285 0.23065,-2.87198 -16.77492,-3.30881 -16.78572,0.0893 z" />
						<path
							d="m 445.89286,235.30861 c 2.55952,1.19048 8.60119,1.27976 11.42857,0 -0.20944,-1.63404 -10.95161,-1.58321 -11.42857,0 z" />
						<path
							d="m 451.07143,216.02289 c 0,0 -3.50051,4.00185 -4.46428,7.58929 -1.30894,4.87228 5.03334,11.9432 5.80356,11.25 0,0 1.40552,-1.48507 1.7899,-3.05653 0.43499,-1.77832 -0.40106,-4.18264 -1.1649,-5.24704 -1.09672,-1.52827 -3.73316,-7.41353 -1.96428,-10.53572 z" />
					</g>

				</g>
				<g id="filter">
					<filter id="dropShadow">
						<feMorphology operator="dilate" radius="2" result="background" in="SourceAlpha" />
						<feMerge>
							<feMergeNode in="background" />

							<feMergeNode in="SourceGraphic" />
						</feMerge>
					</filter>
					<filter id="blackOutline">
						<feMorphology operator="dilate" radius="2" in="SourceAlpha" result="Outline" />
						<feMerge>
							<feMergeNode in="Outline" />
							<feMergeNode in="SourceGraphic" />
						</feMerge>
					</filter>
					<filter id="greyOutline">
						<feFlood flood-color="#111" result="color" />
						<feComposite operator="in" in="color" in2="SourceAlpha" result="StrokeAlpha" />
						<feMorphology operator="dilate" radius="2" in="StrokeAlpha" result="Outline" />
						<feMerge>
							<feMergeNode in="Outline" />
							<feMergeNode in="SourceGraphic" />
						</feMerge>
					</filter>
					<filter id="silverOutline">
						<feFlood flood-color="silver" result="color" />
						<feComposite operator="in" in="color" in2="SourceAlpha" result="StrokeAlpha" />
						<feMorphology operator="dilate" radius="2" in="StrokeAlpha" result="Outline" />
						<feMerge>
							<feMergeNode in="Outline" />
							<feMergeNode in="SourceGraphic" />
						</feMerge>
					</filter>
					<filter id="strokeOutline">
						<feComposite operator="in" in="StrokePaint" in2="SourceAlpha" result="StrokeAlpha" />
						<feMorphology operator="dilate" radius="2" in="StrokeAlpha" result="Outline" />
						<feMerge>
							<feMergeNode in="Outline" />
							<feMergeNode in="SourceGraphic" />
						</feMerge>
					</filter>
					<filter id="gammaOutline">
						<feFlood flood-color="#111" result="color" />
						<feComposite operator="in" in="color" in2="SourceAlpha" result="StrokeAlpha" />
						<feMorphology operator="dilate" radius="2" in="StrokeAlpha" result="Outline" />
						<feMerge result="blackOutline">
							<feMergeNode in="Outline" />
							<feMergeNode in="SourceGraphic" />
						</feMerge>
						<feComponentTransfer in="blackOutline">
							<feFuncR type="gamma" amplitude="3" />
							<feFuncG type="gamma" amplitude="3" />
							<feFuncB type="gamma" amplitude="3" />
						</feComponentTransfer>
					</filter>
					<filter id="clickOutline">
						<feFlood flood-color="#111" result="color" />
						<feComposite operator="in" in="color" in2="SourceAlpha" result="StrokeAlpha" />
						<feMorphology operator="dilate" radius="2" in="StrokeAlpha" result="Outline" />
						<feMerge result="blackOutline">
							<feMergeNode in="Outline" />
							<feMergeNode in="SourceGraphic" />
						</feMerge>
						<feComponentTransfer in="blackOutline" result="gammaOutline">
							<feFuncR type="gamma" amplitude="3" />
							<feFuncG type="gamma" amplitude="3" />
							<feFuncB type="gamma" amplitude="3" />
						</feComponentTransfer>
						<feOffset in="gammaOutline" dx="1" dy="1" />
					</filter>
				</g>
			</defs>
			<g id="body" />
			<text id="tooltip" x="100" y="100">
				<xsl:text> </xsl:text>
			</text>
		</svg>
	</xsl:template>
</xsl:stylesheet>