<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:llo="http://slothsoft.net">

	
	<xsl:template match="*[kana]" name="kana.table">
		<xsl:param name="kanaList" select="kana[not(@skip)]"/>
		<xsl:param name="drawForm" select="false()"/>
		<xsl:variable name="vowels" select="$kanaList[not(@v = following::kana/@v)]/@v"/>
		<xsl:variable name="consonants" select="$kanaList[not(@c = following::kana/@c)]/@c"/>
		<xsl:if test="$drawForm">
			<script type="application/javascript"><![CDATA[
var KanaTable = {
	checkCol : function(tableCell, checked) {
		var i, j, nodeList,
			table = tableCell.parentNode.parentNode.parentNode.tBodies[0];

		for (i = 0; i < table.rows.length; i++) {
			nodeList = table.rows[i].cells[tableCell.cellIndex].getElementsByTagName("input");
			for (j = 0; j < nodeList.length; j++) {
				nodeList[j].checked = checked;
			}
		}
	},
	checkRow : function(tableCell, checked) {
		var j, nodeList,
			table = tableCell.parentNode;

		nodeList = table.getElementsByTagName("input");
		for (j = 0; j < nodeList.length; j++) {
			nodeList[j].checked = checked;
		}
	},
};
			]]></script>
		</xsl:if>
		<table data-template="kana-table" class="paintedTable">
			<xsl:if test="$drawForm">
				<xsl:attribute name="class">drawForm paintedTable</xsl:attribute>
			</xsl:if>
			<thead>
				<tr>
					<th/>
					<xsl:for-each select="$vowels">
						<xsl:sort select="."/>
						<xsl:variable name="v" select="string(.)"/>
						<th/>
						<xsl:choose>
							<xsl:when test="$drawForm">
								<th>
									<label>
										<input type="checkbox" onclick="KanaTable.checkCol(this.parentNode.parentNode, this.checked)">
											<xsl:if test="$kanaList[@v = $v][@checked]">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
										</input>
									</label>
								</th>
							</xsl:when>
							<xsl:otherwise>
								<th>
									<xsl:value-of select="$v"/>
								</th>
							</xsl:otherwise>
						</xsl:choose>
						<th/>
					</xsl:for-each>
				</tr>
				<tr>
					<th/>
					<xsl:for-each select="$vowels">
						<xsl:sort select="."/>
						<td><abbr title="Hiragana">Hi</abbr></td>
						<td><abbr title="Latin">La</abbr></td>
						<td><abbr title="Katakana">Ka</abbr></td>
					</xsl:for-each>
				</tr>
			</thead>
			<tbody>
				<xsl:for-each select="$consonants">
					<xsl:sort select="."/>
					<xsl:variable name="c" select="string(.)"/>
					<tr>
						<th>
							<xsl:choose>
								<xsl:when test="$drawForm">
									<label>
										<input type="checkbox" onclick="KanaTable.checkRow(this.parentNode.parentNode, this.checked)">
											<xsl:if test="$kanaList[@c = $c][@checked]">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
										</input>
									</label>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$c"/>
								</xsl:otherwise>
							</xsl:choose>
						</th>
						<xsl:for-each select="$vowels">
							<xsl:sort select="."/>
							<xsl:variable name="v" select="string(.)"/>
							<xsl:variable name="kana" select="$kanaList[@c = $c and @v = $v]"/>
							<xsl:choose>
								<xsl:when test="$kana">
									<xsl:choose>
										<xsl:when test="$drawForm">
											<td>
												<label for="kanaList-{$kana/*[1]/@name}">
													<xsl:for-each select="$kana/hiragana">
														<span>
															<xsl:if test="@user-count">
																<xsl:attribute name="title"><xsl:value-of select="@user-count"/>ｘ ☑</xsl:attribute>
															</xsl:if>
															<xsl:value-of select="@name"/>
														</span>
														<br/>
													</xsl:for-each>
												</label>
											</td>
											<td>
												<label>
													<input name="kana[]" value="{$kana/@latin}" type="checkbox" id="kanaList-{$kana/*[1]/@name}">
														<xsl:if test="$kana/@checked">
															<xsl:attribute name="checked">checked</xsl:attribute>
														</xsl:if>
													</input>
												</label>
											</td>
											<td>
												<label for="kanaList-{$kana/*[1]/@name}">
													<xsl:for-each select="$kana/katakana">
														<span>
															<xsl:if test="@user-count">
																<xsl:attribute name="title"><xsl:value-of select="@user-count"/>ｘ ☑</xsl:attribute>
															</xsl:if>
															<xsl:value-of select="@name"/>
														</span>
														<br/>
													</xsl:for-each>
												</label>
											</td>
										</xsl:when>
										<xsl:otherwise>
											<td>
												<xsl:for-each select="$kana/hiragana">
													<xsl:call-template name="word.strokeOrder">
														<xsl:with-param name="text" select="@name"/>
													</xsl:call-template>
													<!--<xsl:value-of select="@name"/>-->
													
												</xsl:for-each>
											</td>
											<td>
												<xsl:value-of select="$kana/@latin"/>
											</td>
											<td>
												<xsl:for-each select="$kana/katakana">
													<xsl:call-template name="word.strokeOrder">
														<xsl:with-param name="text" select="@name"/>
													</xsl:call-template>
													<!--<xsl:value-of select="@name"/>-->
													
												</xsl:for-each>
											</td>
										</xsl:otherwise>
									</xsl:choose>
									
								</xsl:when>
								<xsl:otherwise>
									<td/><td/><td/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>
	
	
	
	<xsl:template name="vocabulary.list">
		<xsl:param name="isTest" select="false()"/>
		<xsl:param name="lang" select="string(descendant-or-self::*[@xml:lang]/@xml:lang)"/>
		<xsl:param name="otherLang" select="string(descendant-or-self::*[@xml:lang][not(lang($lang))]/@xml:lang)"/>
		<xsl:variable name="newId" select="concat('new-', @id)"/>
		<xsl:variable name="topId" select="concat('top-', @id)"/>
		<!--<form method="POST" action=".">-->
			<table class="translatorForm paintedTable vocabularyList">
				<xsl:if test="@name">
					<caption id="{$topId}">
						<a href="#_toc">⇧</a>
						<xsl:text> </xsl:text>
						<a href="#{$topId}"><xsl:value-of select="concat(count(vocable), ' ', @name)"/></a>
					</caption>
				</xsl:if>
				<thead>
					<tr data-dict="html:th/node()">
						<xsl:if test="$lang = 'ja-jp'">
							<th class="strokeColumn">Stroke Order</th>
						</xsl:if>
						<th class="vocabColumn">
							<xsl:if test="string-length($lang)">
								<xsl:value-of select="concat('lang/', $lang)"/>
							</xsl:if>
						</th>
						<th class="vocabColumn">
							<xsl:if test="$isTest">
								<xsl:attribute name="colspan">2</xsl:attribute>
							</xsl:if>
							<xsl:if test="string-length($otherLang)">
								<xsl:value-of select="concat('lang/', $otherLang)"/>
							</xsl:if>
						</th>
						<xsl:if test="//vocabulary[@isPersonal] or $isTest">
							<td class="myTime">☑</td>
						</xsl:if>
					</tr>
				</thead>
				<tbody>
					<!-- [word[lang($lang)]/@player-uri = ''] -->
					<xsl:for-each select="vocable">
						<xsl:variable name="pos" select="position()"/>
						<xsl:variable name="sourceWord" select="word[lang($lang)]"/>
						<xsl:variable name="targetWord" select="word[lang($otherLang)]"/>
						
						<xsl:variable name="user-wrong" select="number(concat('0', $sourceWord/@user-wrong)) + number(concat('0', $targetWord/@user-wrong))"/>
						<xsl:variable name="user-correct" select="number(concat('0', $sourceWord/@user-correct)) + number(concat('0', $targetWord/@user-correct))"/>
						<tr>
							<xsl:if test="$lang = 'ja-jp'">
								<td>
									<xsl:call-template name="word.strokeOrder">
										<xsl:with-param name="text" select="$sourceWord/@name"/>
									</xsl:call-template>
								</td>
							</xsl:if>
							<td>
								<xsl:call-template name="word.complete">
									<xsl:with-param name="word" select="$sourceWord"/>
								</xsl:call-template>
							</td>
							<xsl:choose>
								<xsl:when test="$isTest">
									<td data-correct="{@test-correct}">
										<xsl:call-template name="word.complete">
											<xsl:with-param name="word" select="$targetWord[@test-input]"/>
										</xsl:call-template>
									</td>
									<td>
										<xsl:if test="not(number(@test-correct))">
											<xsl:call-template name="word.complete">
												<xsl:with-param name="word" select="$targetWord[not(@test-input)]"/>
											</xsl:call-template>
										</xsl:if>
									</td>
								</xsl:when>
								<xsl:otherwise>
									<td>
										<xsl:call-template name="word.complete">
											<xsl:with-param name="word" select="$targetWord"/>
										</xsl:call-template>
									</td>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:if test="//vocabulary[@isPersonal] or $isTest">
								<td class="myTime">
									<xsl:if test="$user-correct + $user-wrong">
										<xsl:variable name="correct" select="round(255 div ($user-correct + $user-wrong) * ($user-correct - $user-wrong))"/>
										<xsl:variable name="red" select="255 - $correct"/>
										<xsl:variable name="green" select="$correct"/>
										<xsl:attribute name="style">
											<xsl:value-of select="concat('background-color: rgba(', $red, ', ', $green, ', 0, 0.5)')"/>
										</xsl:attribute>
										<xsl:value-of select="$user-correct"/>
										<xsl:text>/</xsl:text>
										<xsl:value-of select="$user-correct + $user-wrong"/>
									</xsl:if>
								</td>
							</xsl:if>
						</tr>
					</xsl:for-each>
				</tbody>
				<!--
				<xsl:if test="../@saveable">
					<tbody class="newVocable" id="{$newId}">
						<tr>
							<xsl:if test="$lang = 'ja-jp'">
								<td/>
							</xsl:if>
							<td>
								<label>New Word: <input type="text" name="vocab-new[{@name}][0][name]"/></label>
								<label>Ruby Note: <input type="text" name="vocab-new[{@name}][0][note]"/></label>
								<label>Audio URL: <input type="text" name="vocab-new[{@name}][0][audio]"/></label>
							</td>
							<td>
								<label>New Word: <input type="text" name="vocab-new[{@name}][1][name]"/></label>
								<label>Ruby Note: <input type="text" name="vocab-new[{@name}][1][note]"/></label>
								<label>Audio URL: <input type="text" name="vocab-new[{@name}][1][audio]"/></label>
							</td>
							<td>
								<input type="hidden" name="vocab-new[0][0][lang]" value="{$lang}"/>
								<input type="hidden" name="vocab-new[0][1][lang]" value="{$otherLang}"/>
								<button type="submit" name="vocab-new-submit" value="{@name}">☑</button>
							</td>
						</tr>
					</tbody>
				</xsl:if>
				-->
			</table>
		<!--
		</form>
		-->
	</xsl:template>
	
	
	<xsl:template name="word.audioPlayer">
		<xsl:param name="uri"/>
		<xsl:param name="remove" select="true()"/>
		<xsl:if test="string-length($uri)">
			<button type="button" tabindex="1" onclick="Translator.createAudioPlayer(this);" data-player-uri="{$uri}" class="audioPlayer">
				<xsl:if test="$remove">
					<xsl:attribute name="data-player-remove"/>
				</xsl:if>
				<xsl:text>►</xsl:text>
			</button>
			<!--<audio type="audio/mpeg" src="{$uri}" class="audioPlayer" controls="controls" preload="none"/>-->
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="word.strokeOrder">
		<xsl:param name="text"/>
		<xsl:param name="expanded" select="false()"/>
		<xsl:if test="string-length($text)">
			<button class="strokeOrder" tabindex="2" type="button" 
				onclick="if (this.hasAttribute('data-clicked')) this.removeAttribute('data-clicked'); else this.setAttribute('data-clicked', '');">
				<xsl:if test="$expanded">
					<xsl:attribute name="data-clicked"/>
				</xsl:if>
				<xsl:value-of select="$text"/>
			</button>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="word.ruby">
		<xsl:param name="base" select="''"/>
		<xsl:param name="top" select="''"/>
		<xsl:param name="bottom" select="''"/>
		<ruby>
			<xsl:value-of select="$base"/>
			<xsl:choose>
				<xsl:when test="string-length($top)">
					<rp> （</rp>
					<rt><xsl:value-of select="$top"/></rt>
					<rp>） </rp>
				</xsl:when>
				<xsl:otherwise>
					<rt/>
				</xsl:otherwise>
			</xsl:choose>
		</ruby>
	</xsl:template>
	
	<xsl:template name="word.print">
		<xsl:param name="word" select="."/>
		<xsl:call-template name="word.ruby">
			<xsl:with-param name="base" select="string($word/@name)"/>
			<xsl:with-param name="top" select="string($word/@note)"/>
		</xsl:call-template>
		<!--
		<xsl:if test="string-length($word/@note)">
			<div style="margin-bottom: -0.2em;"><xsl:value-of select="$word/@note"/></div>
		</xsl:if>
		<div><xsl:value-of select="$word/@name"/></div>
		-->
	</xsl:template>
	
	<xsl:template name="word.complete">
		<xsl:param name="word" select="/.."/>
		<xsl:param name="lang" select="$word/@xml:lang"/>
		<xsl:param name="audio" select="$word/@player-uri"/>
		<xsl:param name="base" select="$word/@name"/>
		<xsl:param name="top" select="$word/@note"/>
		<xsl:param name="reverse" select="false()"/>
		<xsl:param name="display-audio" select="true()"/>
		<span class="word-complete">
			<xsl:attribute name="xml:lang"><xsl:value-of select="$lang"/></xsl:attribute>
			<xsl:if test="$display-audio and not($reverse)">
				<span class="audioPlayer">
					<xsl:call-template name="word.audioPlayer">
						<xsl:with-param name="uri" select="$audio"/>
						<xsl:with-param name="remove" select="$lang = 'ja-jp'"/>
					</xsl:call-template>
				</span>
			</xsl:if>
			<span>
				<xsl:call-template name="word.ruby">
					<xsl:with-param name="base" select="$base"/>
					<xsl:with-param name="top" select="$top"/>
				</xsl:call-template>
			</span>
			<xsl:if test="$display-audio and $reverse">
				<span class="audioPlayer">
					<xsl:call-template name="word.audioPlayer">
						<xsl:with-param name="uri" select="$audio"/>
						<xsl:with-param name="remove" select="$lang = 'ja-jp'"/>
					</xsl:call-template>
				</span>
			</xsl:if>
		</span>
	</xsl:template>
	
	<xsl:template name="translator.root">
		<article class="TranslatorRoot">
			<h2>Translator</h2>
			<label>
				<span>Input latin transcription (or kana, or kanji) here...</span>
				<textarea oninput="Translator.typeCharacter(this)" autofocus="autofocus"/>
			</label>
			<label>
				<span>Common words only</span>
				<input type="checkbox" class="commonWords" onclick="Translator.translate()" checked="checked"/>
			</label>
			<table class="translatorForm">
				<xsl:call-template name="translator.input"/>
				<xsl:call-template name="translator.output"/>
			</table>
		</article>
	</xsl:template>
	
	<xsl:template name="translator.input">
		<tbody class="input">
			<tr class="latin">
				<th rowspan="3">Input</th>
				<th>Latin</th>
			</tr>
			<tr class="hiragana">
				<th>Hiragana</th>
			</tr>
			<tr class="katakana">
				<th>Katakana</th>
			</tr>
		</tbody>
	</xsl:template>
	
	<xsl:template match="translator/translation" name="translator.output">
		<tbody class="output">
			<tr class="hiragana">
				<th rowspan="4">Output</th>
				<th>Kana</th>
				<xsl:for-each select="word">
					<xsl:variable name="kanaList" select="kana/@name"/>
					<td colspan="{@syllables}" data-parity="{(1 + position()) mod 2}">
						<ul>
							<xsl:for-each select="$kanaList">
								<li>
									<xsl:call-template name="translator.link">
										<xsl:with-param name="kana" select="."/>
									</xsl:call-template>
								</li>
							</xsl:for-each>
						</ul>
					</td>
				</xsl:for-each>
			</tr>
			<tr class="kanji">
				<th>Kanji</th>
				<xsl:for-each select="word">
					<xsl:variable name="kanjiList" select="kana/kanji[string-length(@name) &gt; 0]/@name"/>
					<td colspan="{@syllables}" data-parity="{(1 + position()) mod 2}">
						<ul>
							<xsl:for-each select="$kanjiList">
								<xsl:variable name="pos" select="position()"/>
								<xsl:if test="not(. = $kanjiList[position() &gt; $pos])">
									<li>
										<xsl:call-template name="translator.link">
											<xsl:with-param name="kana" select="."/>
										</xsl:call-template>
									</li>
								</xsl:if>
							</xsl:for-each>
						</ul>
					</td>
				</xsl:for-each>
			</tr>
			<tr class="english">
				<th>English</th>
				<xsl:for-each select="word">
					<td colspan="{@syllables}" data-parity="{(1 + position()) mod 2}">
						<dl>
							<xsl:for-each select="kana/kanji">
								<dt xml:lang="ja-jp">
									<xsl:variable name="player">
										<xsl:choose>
											<xsl:when test="string-length(@name) = 0">
												<xsl:value-of select="../@player-uri"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="@player-uri"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:variable name="base">
										<xsl:choose>
											<xsl:when test="string-length(@name) = 0">
												<xsl:value-of select="../@name"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="@name"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:variable name="top">
										<xsl:choose>
											<xsl:when test="string-length(@name) = 0">
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="../@name"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:call-template name="word.complete">
										<xsl:with-param name="lang" select="'ja-jp'"/>
										<xsl:with-param name="audio" select="$player"/>
										<xsl:with-param name="base" select="$base"/>
										<xsl:with-param name="top" select="$top"/>
										<xsl:with-param name="reverse" select="true()"/>
									</xsl:call-template>
									<!--
									<xsl:variable name="player">
										<xsl:choose>
											<xsl:when test="string-length(@name) = 0">
												<xsl:value-of select="../@player-uri"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="@player-uri"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:call-template name="word.audioPlayer">
										<xsl:with-param name="uri" select="$player"/>
									</xsl:call-template>
									<xsl:value-of select="@name"/>
									<xsl:if test="string-length(@name) = 0">
										<xsl:value-of select="../@name"/>
									</xsl:if>
									-->
								</dt>
								<dd>
									<xsl:copy-of select="english/node()"/>
									<!--
									<ul>
										<xsl:for-each select="english">
											<li><xsl:copy-of select="node()"/></li>
										</xsl:for-each>
									</ul>
									-->
								</dd>
							</xsl:for-each>
						</dl>
					</td>
				</xsl:for-each>
			</tr>
			<tr class="strokeOrder">
				<th>Stroke Order</th>
				<xsl:for-each select="word">
					<td colspan="{@syllables}" data-parity="{(1 + position()) mod 2}">
						<ul>
							<xsl:variable name="charList" select="kana/@name | kana/kanji/@name"/>
							<xsl:for-each select="$charList[string-length(.) &gt; 0]">
								<li>
									<xsl:call-template name="word.strokeOrder">
										<xsl:with-param name="text" select="."/>
									</xsl:call-template>
								</li>
							</xsl:for-each>
						</ul>
					</td>
				</xsl:for-each>
			</tr>
		</tbody>
	</xsl:template>
	
	<xsl:template name="translator.link">
		<xsl:param name="kana" select="string(.)"/>
		<!--
		<xsl:variable name="sourceURI" select="ancestor-or-self::translator/@sourceURI"/>
		-->
		<xsl:variable name="sourceURI" select="'http://jisho.org/search/'"/>
		<a href="{$sourceURI}{$kana}">
			<xsl:value-of select="$kana"/>
		</a>
	</xsl:template>
	
	
	<xsl:template match="test">
		<article class="vocabularyTest" style="display: none">
			<h2>Test</h2>
			<form action=".?{//request/@query}" method="POST" data-vocab-test="{@mode}" data-vocab-type="{@type}" data-vocab-resource="{@resource-uri}" data-vocab-log="{@log-uri}">
				<xsl:copy-of select="@xml:lang"/>
				<xsl:call-template name="test.repository"/>
				<!--
				<xsl:choose>
					<xsl:when test="self::*[lang('ja')]">
						<xsl:call-template name="test.list.ja"/>
					</xsl:when>
				</xsl:choose>
				-->
				<xsl:call-template name="test.list"/>
				<button type="submit" name="vocab-submit" tabindex="1">Proceed</button>
			</form>
		</article>
	</xsl:template>
	
	<xsl:template name="test.repository">
		<xsl:variable name="lang" select="@xml:lang"/>
		<xsl:variable name="mode" select="@mode"/>
		<xsl:variable name="type" select="@type"/>
		
		<xsl:for-each select="repository">
			<div class="display: none;" data-vocab-repository="">
				<xsl:for-each select="word">
					<div class="vocab-table vocabTranslation" style="display: none">
						<xsl:call-template name="test.audioPlayer">
							<xsl:with-param name="word" select="."/>
						</xsl:call-template>
						<label>
							<span class="vocab-table">
								<span><input type="radio" value="{@id}" tabindex="1"
									 disabled="disabled" data-vocab-answer-name="{@name}" data-vocab-answer-note="{@note}"/></span>
								<span>
									<xsl:call-template name="test.wordName">
										<xsl:with-param name="word" select="."/>
										<xsl:with-param name="mode" select="$mode"/>
									</xsl:call-template>
								</span>
							</span>
						</label>
					</div>
				</xsl:for-each>
				<!--
				<xsl:for-each select="word">
					<div class="vocab-table">
						<xsl:call-template name="test.audioPlayer">
							<xsl:with-param name="word" select="."/>
						</xsl:call-template>
						<div>
							<label class="vocabTranslation">
								<span class="vocab-table">
									<span>
										<input type="radio" tabindex="1" disabled="disabled"
											value="{@id}" data-vocab-answer-name="{@name}" data-vocab-answer-note="{@note}"/>
									</span>
									<span>
										<xsl:call-template name="test.wordName">
											<xsl:with-param name="word" select="."/>
											<xsl:with-param name="mode" select="$mode"/>
										</xsl:call-template>
									</span>
								</span>
							</label>
						</div>
					</div>
				</xsl:for-each>
				-->
			</div>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="test.list">
		<xsl:variable name="lang" select="@xml:lang"/>
		<xsl:variable name="mode" select="@mode"/>
		<xsl:variable name="type" select="@type"/>
		
		<xsl:for-each select="vocable">
			<xsl:variable name="word" select="word[lang($lang)]"/>
			<xsl:variable name="wordList" select="word[not(lang($lang))]"/>
			<xsl:variable name="id" select="$word/@id"/>
			
			<article class="paintedBox vocabBox {$type}" data-vocab-id="{$word/@id}">
				<h3>Question <xsl:value-of select="position()"/>/<xsl:value-of select="last()"/></h3>
				<div class="translatorForm vocab-table">
					<div class="input">
						<xsl:copy-of select="($word/@xml:lang)[1]"/>
						<xsl:call-template name="test.element">
							<xsl:with-param name="word" select="$word"/>
							<xsl:with-param name="mode" select="$mode"/>
						</xsl:call-template>
					</div>
					
					<div class="output">
						<xsl:copy-of select="($wordList/@xml:lang)[1]"/>
						<xsl:choose>
							<xsl:when test="$type = 'choice'">
								<xsl:call-template name="test.list.choice"/>
							</xsl:when>
							<xsl:when test="$type = 'typing'">
								<xsl:call-template name="test.list.typing"/>
							</xsl:when>
							<xsl:when test="$type = 'click'">
								<xsl:call-template name="test.list.click"/>
							</xsl:when>
						</xsl:choose>
					</div>
				</div>
			</article>
			<!--
			<article xml:lang="{$lang}" class="paintedBox vocabBox {$type}" data-vocab-id="{$word/@id}">
				<h3>Question <xsl:value-of select="position()"/>/<xsl:value-of select="last()"/></h3>
				<div class="translatorForm">
					<div class="input">
						<div class="vocab-table">
							<xsl:call-template name="test.audioPlayer">
								<xsl:with-param name="word" select="$word"/>
							</xsl:call-template>
							<xsl:call-template name="test.element">
								<xsl:with-param name="word" select="$word"/>
								<xsl:with-param name="mode" select="$mode"/>
							</xsl:call-template>
						</div>
					</div>
					
					<div class="output">
						<xsl:choose>
							<xsl:when test="$type = 'choice'">
								<xsl:call-template name="test.list.choice"/>
							</xsl:when>
							<xsl:when test="$type = 'typing'">
								<xsl:call-template name="test.list.typing"/>
							</xsl:when>
							<xsl:when test="$type = 'click'">
								<xsl:call-template name="test.list.click"/>
							</xsl:when>
						</xsl:choose>
					</div>
				</div>
			</article>
			-->
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="test.element">
		<xsl:param name="word"/>
		<xsl:param name="mode"/>
		<div class="vocabReading">
			<xsl:call-template name="kanji.list.reading">
				<xsl:with-param name="nodeList" select="$word/reading[@type = 'kun']"/>
			</xsl:call-template>
		</div>
		<div class="vocabMeaning">
			<xsl:choose>
				<xsl:when test="$mode = 'words'">
					<xsl:call-template name="test.element.words">
						<xsl:with-param name="word" select="$word"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$mode = 'kanji'">
					<xsl:call-template name="test.element.kanji">
						<xsl:with-param name="word" select="$word"/>
					</xsl:call-template>
				</xsl:when>
			</xsl:choose>
		</div>
		<div class="vocabReading">
			<xsl:call-template name="kanji.list.reading">
				<xsl:with-param name="nodeList" select="$word/reading[@type = 'on']"/>
			</xsl:call-template>
		</div>
		<div class="vocabSpelling">
			<xsl:call-template name="kanji.list.spelling">
				<xsl:with-param name="nodeList" select="$word/radical"/>
			</xsl:call-template>
		</div>
	</xsl:template>
	
	<xsl:template name="test.element.words">
		<xsl:param name="word"/>
		<div class="vocab-table">
			<xsl:call-template name="test.audioPlayer">
				<xsl:with-param name="word" select="$word"/>
			</xsl:call-template>
			<xsl:call-template name="test.wordName">
				<xsl:with-param name="word" select="$word"/>
			</xsl:call-template>
		</div>
	</xsl:template>
	
	<xsl:template name="test.element.kanji">
		<xsl:param name="word"/>
		<xsl:choose>
			<xsl:when test="$word[lang('ja')]">
				<span class="vocab-table">
					<span class="vocabName serif">
						<xsl:value-of select="$word/@name"/>
					</span>
					<span class="vocabStroke kanaStrokeOrder">
						<xsl:value-of select="$word/@name"/>
					</span>
					<span class="vocabName sans">
						<xsl:value-of select="$word/@name"/>
					</span>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$word/@name"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="test.list.choice">
		<xsl:variable name="lang" select="../@xml:lang"/>
		<xsl:variable name="mode" select="../@mode"/>
		<xsl:variable name="type" select="../@type"/>
		
		<xsl:variable name="word" select="word[lang($lang)]"/>
		<xsl:variable name="wordList" select="word[not(lang($lang))]"/>
		<xsl:variable name="id" select="$word/@id"/>
		
		<!--
		<div class="vocab-table">
			<div class="audioPlayer"/>
			<div>
				<label class="vocabTranslation">
					<span class="vocab-table">
						<span><input type="radio" name="vocab-test[{$id}]" checked="checked" value="" tabindex="1"/></span>
						<span data-dict=""><xsl:text> [don't know]</xsl:text></span>
					</span>
				</label>
			</div>
		</div>
		-->
		<input type="radio" name="vocab-test[{$id}]" checked="checked" value="" tabindex="1" style="display: none"/>
		<xsl:for-each select="$wordList">
			<div class="vocab-table vocabTranslation">
				<xsl:call-template name="test.audioPlayer">
					<xsl:with-param name="word" select="."/>
				</xsl:call-template>
				<label>
					<span class="vocab-table">
						<span><input type="radio" name="vocab-test[{$id}]" value="{@id}" tabindex="1"/></span>
						<span>
							<xsl:call-template name="test.wordName">
								<xsl:with-param name="word" select="."/>
								<xsl:with-param name="mode" select="$mode"/>
							</xsl:call-template>
						</span>
					</span>
				</label>
			</div>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="test.list.typing">
		<xsl:variable name="lang" select="../@xml:lang"/>
		<xsl:variable name="mode" select="../@mode"/>
		<xsl:variable name="type" select="../@type"/>
		
		<xsl:variable name="word" select="word[lang($lang)]"/>
		<xsl:variable name="wordList" select="word[not(lang($lang))]"/>
		<xsl:variable name="id" select="$word/@id"/>
		
		<div class="vocab-table vocabTranslation">
			<div class="audioPlayer"/>
			<label>
				<span class="vocab-table">
					<span/>
					<span>
						<input type="text" name="vocab-test[{$id}]" tabindex="1" data-vocab-question="{$id}" autocomplete="off"/>
					</span>
				</span>
			</label>
		</div>
	</xsl:template>
	
	<xsl:template name="test.list.click">
		<xsl:variable name="lang" select="../@xml:lang"/>
		<xsl:variable name="mode" select="../@mode"/>
		<xsl:variable name="type" select="../@type"/>
		
		<xsl:variable name="word" select="word[lang($lang)]"/>
		<xsl:variable name="wordList" select="word[not(lang($lang))]"/>
		<xsl:variable name="id" select="$word/@id"/>
		
		<!--
		<button type="button" name="vocab-test[{$id}]" value="">
			<span data-dict=""><xsl:text> [don't know]</xsl:text></span>
		</button>
		-->
		<xsl:for-each select="$wordList">
			<button type="button" name="{$id}" value="{@id}" class="vocabTranslation">
				<xsl:call-template name="test.wordName">
					<xsl:with-param name="word" select="."/>
					<xsl:with-param name="mode" select="$mode"/>
				</xsl:call-template>
			</button>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="test.audioPlayer">
		<xsl:param name="word"/>
		<div class="audioPlayer">
			<xsl:copy-of select="($word/@xml:lang)[1]"/>
			<xsl:call-template name="word.audioPlayer">
				<xsl:with-param name="uri" select="$word/@player-uri"/>
				<xsl:with-param name="remove" select="$word[lang('ja')]"/>
			</xsl:call-template>
		</div>
	</xsl:template>
	
	<xsl:template name="test.wordName">
		<xsl:param name="word"/>
		<span class="vocabName sans">
			<xsl:choose>
				<xsl:when test="string-length($word/@note)">
					<xsl:call-template name="word.print">
						<xsl:with-param name="word" select="$word"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$word/@name"/>
				</xsl:otherwise>
			</xsl:choose>
		</span>
	</xsl:template>
	
	<xsl:template name="kanji.list.reading">
		<xsl:param name="nodeList"/>
		<xsl:if test="$nodeList">
			<xsl:for-each select="$nodeList">
				<span><xsl:value-of select="@name"/></span>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template name="kanji.list.spelling">
		<xsl:param name="nodeList"/>
		<xsl:if test="$nodeList">
			<xsl:for-each select="$nodeList">
				<span><xsl:value-of select="@name"/></span>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	
	<!-- Test Results -->
	<xsl:template match="test-answer">
		<xsl:variable name="mode" select="@mode"/>
		<div class="translatorForm testAnswer">
			<div class="input">
				<div class="vocab-table">
					<xsl:for-each select="vocable">
						<xsl:variable name="node" select="word[1]"/>
						<xsl:variable name="lang" select="string($node/@xml:lang)"/>
						<div data-correct="{2 - position()}">
							<xsl:attribute name="xml:lang"><xsl:value-of select="$lang"/></xsl:attribute>
							<div class="vocab-table">
								<xsl:call-template name="test.audioPlayer">
									<xsl:with-param name="word" select="$node"/>
								</xsl:call-template>
								<xsl:call-template name="test.wordName">
									<xsl:with-param name="word" select="$node"/>
									<xsl:with-param name="mode" select="$mode"/>
								</xsl:call-template>
							</div>
						</div>
					</xsl:for-each>
				</div>
			</div>
			<div class="output">
				<div class="vocab-table">
					<xsl:for-each select="vocable">
						<xsl:variable name="node" select="word[2]"/>
						<xsl:variable name="lang" select="string($node/@xml:lang)"/>
						<div data-correct="{2 - position()}">
							<xsl:attribute name="xml:lang"><xsl:value-of select="$lang"/></xsl:attribute>
							<div class="vocab-table">
								<xsl:call-template name="test.audioPlayer">
									<xsl:with-param name="word" select="$node"/>
								</xsl:call-template>
								<xsl:call-template name="test.wordName">
									<xsl:with-param name="word" select="$node"/>
									<xsl:with-param name="mode" select="$mode"/>
								</xsl:call-template>
							</div>
						</div>
					</xsl:for-each>
				</div>
			</div>
		</div>
	</xsl:template>
	
	
	<!-- Test Results -->
	<xsl:template match="testResult">
		<article>
			<h2>Test Results!</h2>
			<xsl:call-template name="vocabulary.list">
				<xsl:with-param name="isTest" select="true()"/>
			</xsl:call-template>
			<strong>
				<samp>
					<xsl:value-of select="sum(vocable/@test-correct)"/>
					<xsl:text> / </xsl:text>
					<xsl:value-of select="count(vocable)"/>
				</samp>
				correct!
			</strong>
		</article>
	</xsl:template>
	
	<!-- Test History -->
	<xsl:template match="testDates">
		<xsl:param name="dayCount" select="count(day)"/>
		<!--
		<article class="testDates">
			<h2>Test History</h2>
			<div>
				<xsl:apply-templates select="." mode="svg">
					<xsl:with-param name="dayCount" select="$dayCount"/>
				</xsl:apply-templates>
			</div>
		</article>
		-->
	</xsl:template>
	
	<xsl:template match="testDates" mode="svg">
		<xsl:param name="dayCount" select="count(day)"/>
		<xsl:variable name="dayList" select="day[position() &gt; (count(../day) - $dayCount)]"/>
		<xsl:variable name="minX" select="0"/>
		<xsl:variable name="maxY" select="number(@user-height)"/>
		<xsl:variable name="dayWidth" select="16"/>
		<xsl:variable name="scaleX" select="$dayWidth div 86400"/>
		<xsl:variable name="scaleY" select="1 + 1 * ($maxY &lt; 200)"/>
		<xsl:variable name="width" select="count($dayList) * 86400 * $scaleX"/>
		<xsl:variable name="height" select="$maxY * $scaleY"/>
		
		<xsl:variable name="start" select="number($dayList[1]/@date-stamp)"/>
		<xsl:variable name="end" select="number($dayList[last()]/@date-stamp)"/>
		<svg xmlns="http://www.w3.org/2000/svg"
			width="{$width}px" height="{$height}px" 
			viewBox="0 0 {$width} {$height}"
			class="log-short"
			llo:vocab-log=""
			><!-- 
			width="{$width}px" height="{$height}px" 
			onclick="if (this.style.width) this.style.removeProperty('width'); else this.style.width = this.style.maxWidth;"
			-->
			<g class="online" transform="translate({$width}, 0) scale(-1, 1)">
				<xsl:for-each select="$dayList">
					<xsl:variable name="correct" select="number(concat('0', @user-correct))"/>
					<xsl:variable name="wrong" select="number(concat('0', @user-wrong))"/>
					<xsl:choose>
						<xsl:when test="$correct + $wrong">
							<xsl:variable name="percent" select="100 * $correct div ($correct + $wrong)"/>
							<rect transform="translate({round((@date-stamp - $start) * $scaleX + $dayWidth)}, {$height - $scaleY * ($correct)}) scale(-1, 1)"
								width="{$dayWidth}" height="{$scaleY * $correct}" llo:correct="1"/>
							<rect transform="translate({round((@date-stamp - $start) * $scaleX + $dayWidth)}, {$height - $scaleY * ($correct + $wrong)}) scale(-1, 1)"
								width="{$dayWidth}" height="{$scaleY * $wrong}" llo:correct="0"/>
							<text transform="translate({round((@date-stamp - $start) * $scaleX + $dayWidth * 0.25)}, {round($dayWidth * 0.5)}) rotate(90) scale(-1, 1) "
								font-size="0.8em" font-weight="900">
								<xsl:value-of select="translate(@user-text, ' ', '&#160;')"/>
							</text>
						</xsl:when>
						<xsl:otherwise>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</g>
			<!--
			<g class="axes">
				<path d="M{$minX},{$height} h{$width}"/>
				<path d="M{$minX},{$height} v{-$height}"/>
			</g>
			-->
			<g class="clock" transform="translate({2+$width}, -2) scale(-1, 1)">
				<xsl:for-each select="day[@now] | day[@now]/following-sibling::*[position() mod 7 = 0] | day[@now]/preceding-sibling::*[position() mod 7 = 0]">
					<rect transform="translate({round((@date-stamp - $start) * $scaleX + $dayWidth * 0.5)}, {round($height - $dayWidth * 0.5)}) scale(-1, 1)"
						width="2" height="{$dayWidth}"/>
					<text
						transform="translate({round((@date-stamp - $start) * $scaleX + $dayWidth * 0.5)}, {round($height - $dayWidth * 0.75)}) rotate(30) scale(-1, 1) "
						font-weight="{100 + boolean(@now) * 800}">
						<xsl:value-of select="@date-time"/>
					</text>
				</xsl:for-each>
			</g>
		</svg>
	</xsl:template>
</xsl:stylesheet>
