<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns="http://schema.slothsoft.net/farah/sitemap"
	xmlns:sfm="http://schema.slothsoft.net/farah/module"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="/*">
		<sitemap version="1.0">
			<page name="Japanese" title="Japanese" ref="kana-home" status-active="" status-public="">
				<page name="Translator" title="Translator" ref="kana-translator" status-active="" status-public=""/>
				<page name="KanaTable" title="Hepburn Romanization" ref="kana-table" status-active="" status-public=""/>
				<page name="KanaTest" title="Kana Test" ref="kana-test" status-active="" status-public=""/>
				<page name="JLPT" title="JLPT" status-active="" status-public="" redirect="/Japanese">
					<page name="N5" title="N5" status-active="" status-public="" ref="kana-home">
						<sfm:param name="jlpt-level" value="5"/>
						<page name="VocabularyList" title="Vocabulary List" ref="kana-vocab" status-active="" status-public=""/>
						<page name="VocabularyTest" title="Vocabulary Test" ref="vocab-words-test" status-active="" status-public="">
							<page name="*" redirect=".." status-active=""/>
						</page>
						<page name="KanjiList" title="Kanji List" ref="vocab-kanji" status-active="" status-public=""/>
						<page name="KanjiTest" title="Kanji Test" ref="vocab-kanji-test" status-active="" status-public="">
							<page name="*" redirect=".." status-active=""/>
						</page>
					</page>
					<page name="N4" title="N4" status-active="" status-public="" ref="kana-home">
						<sfm:param name="jlpt-level" value="4"/>
						<page name="VocabularyList" title="Vocabulary List" ref="kana-vocab" status-active="" status-public=""/>
						<page name="VocabularyTest" title="Vocabulary Test" ref="vocab-words-test" status-active="" status-public="">
							<page name="*" redirect=".." status-active=""/>
						</page>
						<page name="KanjiList" title="Kanji List" ref="vocab-kanji" status-active="" status-public=""/>
						<page name="KanjiTest" title="Kanji Test" ref="vocab-kanji-test" status-active="" status-public="">
							<page name="*" redirect=".." status-active=""/>
						</page>
					</page>
					<page name="N3" title="N3" status-active="" status-public="" ref="kana-home">
						<sfm:param name="jlpt-level" value="3"/>
						<page name="VocabularyList" title="Vocabulary List" ref="kana-vocab" status-active="" status-public=""/>
						<page name="VocabularyTest" title="Vocabulary Test" ref="vocab-words-test" status-active="" status-public="">
							<page name="*" redirect=".." status-active=""/>
						</page>
						<page name="KanjiList" title="Kanji List" ref="vocab-kanji" status-active="" status-public=""/>
						<page name="KanjiTest" title="Kanji Test" ref="vocab-kanji-test" status-active="" status-public="">
							<page name="*" redirect=".." status-active=""/>
						</page>
					</page>
					<page name="N2" title="N2" status-active="" status-public="" ref="kana-home">
						<sfm:param name="jlpt-level" value="2"/>
						<page name="VocabularyList" title="Vocabulary List" ref="kana-vocab" status-active="" status-public=""/>
						<page name="VocabularyTest" title="Vocabulary Test" ref="vocab-words-test" status-active="" status-public="">
							<page name="*" redirect=".." status-active=""/>
						</page>
						<page name="KanjiList" title="Kanji List" ref="vocab-kanji" status-active="" status-public=""/>
						<page name="KanjiTest" title="Kanji Test" ref="vocab-kanji-test" status-active="" status-public="">
							<page name="*" redirect=".." status-active=""/>
						</page>
					</page>
					<page name="N1" title="N1" status-active="" status-public="" ref="kana-home">
						<sfm:param name="jlpt-level" value="1"/>
						<page name="VocabularyList" title="Vocabulary List" ref="kana-vocab" status-active="" status-public=""/>
						<page name="VocabularyTest" title="Vocabulary Test" ref="vocab-words-test" status-active="" status-public="">
							<page name="*" redirect=".." status-active=""/>
						</page>
						<page name="KanjiList" title="Kanji List" ref="vocab-kanji" status-active="" status-public=""/>
						<page name="KanjiTest" title="Kanji Test" ref="vocab-kanji-test" status-active="" status-public="">
							<page name="*" redirect=".." status-active=""/>
						</page>
					</page>
				</page>
				<page name="PersonalStudies" title="Personal Studies" status-active="" status-public="" redirect="/">
					<page name="Daniel" title="Daniel" status-active="" status-public="" ref="kana-home">
						<sfm:param name="vocab-resource" value="slothsoft/japanese-faulo"/>
						<page name="VocabularyList" title="Vocabulary List" ref="kana-vocab" status-active="" status-public="">
						</page>
						<page name="VocabularyTest" title="Vocabulary Test" ref="vocab-words-test" status-active="" status-public="">
							<page name="*" redirect=".." status-active=""/>
						</page>
						<page name="KanjiList" title="Kanji List" ref="vocab-kanji" status-active="" status-public="">
						</page>
						<page name="KanjiTest" title="Kanji Test" ref="vocab-kanji-test" status-active="" status-public="">
							<page name="*" redirect=".." status-active=""/>
						</page>
						<page name="Grammar" title="Grammar" ref="vocab-verbs" status-active="" status-public=""/>
					</page>
				</page>
			</page>
			
			
			<page name="PersonalStudies" title="Personal Studies" status-active="" redirect="/">
				<sfm:param name="test-saveable" value="1"/>
				<page name="Daniel" title="Daniel" status-active="" status-public="" ref="kana-home">
					<sfm:param name="vocab-resource" value="slothsoft/japanese-faulo"/>
					<page name="VocabularyList" title="Vocabulary List" ref="kana-vocab" status-active="" status-public="">
						<page name="Add" title="Add Word" ref="vocab-list-add" status-active="" status-public=""/>
					</page>
					<page name="VocabularyTest" title="Vocabulary Test" ref="vocab-words-test" status-active="" status-public="">
						<page name="*" redirect=".." status-active=""/>
					</page>
					<page name="KanjiList" title="Kanji List" ref="vocab-kanji" status-active="" status-public="">
					</page>
					<page name="KanjiTest" title="Kanji Test" ref="vocab-kanji-test" status-active="" status-public="">
						<page name="*" redirect=".." status-active=""/>
					</page>
					<page name="Grammar" title="Grammar" ref="vocab-verbs" status-active="" status-public=""/>
					<!--
					<page name="Mobile" title="Mobile Pages" redirect="KanjiJaEn" status-active="" status-public="">
						<sfm:param name="test-type" value="click"/>
						<page name="VocabJaDe" title="Vocab Test Japanese-German" ref="kana-vocab-mobile" status-active="" status-public="">
							<sfm:param name="test-language" value="ja-jp"/>
						</page>
						<page name="VocabDeJa" title="Vocab Test German-Japanese" ref="kana-vocab-mobile" status-active="" status-public="">
							<sfm:param name="test-language" value="de-de"/>
						</page>
						<page name="KanjiJaEn" title="Kanji Test Japanese-English" ref="vocab-kanji-mobile" status-active="" status-public="">
							<sfm:param name="test-language" value="ja-jp"/>
						</page>
						<page name="KanjiEnJa" title="Kanji Test English-Japanese" ref="vocab-kanji-mobile" status-active="" status-public="">
							<sfm:param name="test-language" value="en-us"/>
						</page>
					</page>
					-->
					<page name="Finnish" title="Finnish" ref="kana-vocab" status-active="" status-public="">
						<sfm:param name="vocab-resource" value="slothsoft/finnish-faulo"/>
						<page name="Add" title="Add Word" ref="vocab-list-add" status-active="" status-public=""/>
					</page>
				</page>
				<page name="Julia" title="Julia" status-active="" status-public="" redirect="VocabularyList">
					<sfm:param name="vocab-resource" value="slothsoft/english-julia"/>
					<page name="VocabularyList" title="Vocabulary List" ref="kana-vocab" status-active="" status-public=""/>
					<page name="VocabularyTest" title="Vocabulary Test" ref="vocab-words-test" status-active="" status-public="">
						<page name="*" redirect=".." status-active=""/>
					</page>
					<!--
					<page name="VocabularyTest" title="Vocabulary Test" redirect="English-German" status-active="" status-public="">
						<page name="English-German" title="English-German" ref="kana-vocab" status-active="" status-public="">
							<sfm:param name="test-language" value="en-us"/>
						</page>
						<page name="English-German-Plus" title="English-German-Plus" ref="kana-vocab" status-active="" status-public="">
							<sfm:param name="test-language" value="en-us"/>
							<sfm:param name="test-type" value="typing"/>
						</page>
						<page name="German-English" title="German-English" ref="kana-vocab" status-active="" status-public="">
							<sfm:param name="test-language" value="de-de"/>
						</page>
						<page name="German-English-Plus" title="German-English-Plus" ref="kana-vocab" status-active="" status-public="">
							<sfm:param name="test-language" value="de-de"/>
							<sfm:param name="test-type" value="typing"/>
						</page>
					</page>
					-->
				</page>
			</page>
		</sitemap>
	</xsl:template>
</xsl:stylesheet>
				