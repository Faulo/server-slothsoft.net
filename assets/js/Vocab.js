window.Vocab = {
	repositoryNodeList : undefined,
	repositoryTextList : undefined,
	repositoryNoteList : undefined,
	init : function() {
		var nodeList, i, node, id, test;
		/*
		if (window.XPath && window.Translator) {
			nodeList = XPath.evaluate(".//*[lang('ja')][@data-player-uri]", document);
			for (i = 0; i < nodeList.length; i++) {
				Translator.createAudioPlayer(nodeList[i]);
			}
		}
		//*/
		if (window.XPath) {
			if (node = XPath.evaluate(".//html:input[@type = 'text']", document)[0]) {
				//node.focus();
			}
			
			this.repositoryNodeList = {};
			this.repositoryTextList = {};
			this.repositoryNoteList = {};
			nodeList = XPath.evaluate(".//*[@data-vocab-repository]", document);
			for (i = 0; i < nodeList.length; i++) {
				node = nodeList[i];
				this.initRepository(node);
			}
			//alert(JSON.stringify(this.repositoryTextList));
			
			nodeList = XPath.evaluate(".//html:input[@data-vocab-question]", document);
			if (nodeList.length) {
				for (i = 0; i < nodeList.length; i++) {
					node = nodeList[i];
					node._vocab = this;
					node._vocabRepositoryNodeList = {};
					node._vocabParentNode = XPath.evaluate("ancestor::*[@class='output'][1]", node)[0];
					for (id in this.repositoryNodeList) {
						node._vocabRepositoryNodeList[id] = false;
					}
					node.addEventListener(
						"focus",
						function(eve) {
							var parentNode = XPath.evaluate("ancestor::html:article[1]", this)[0];
							if (parentNode) {
								//parentNode.scrollIntoView(true, "smooth");
							}
						},
						false
					);
					node.addEventListener(
						"keyup",
						function(eve) {
							this._vocab.typeQuestion(this);
						},
						false
					);
				}
				//nodeList[0].focus();
			}
			if (node = XPath.evaluate(".//*[@data-vocab-test]//*[@tabindex][not(@disabled)]", document)[0]) {
				//node.focus();
			}
			nodeList = XPath.evaluate(".//html:form[@data-vocab-test]", document);
			for (i = 0; i < nodeList.length; i++) {
				node = nodeList[i];
				test = new VocabTest();
				test.init(node);
			}
		}
	},
	initRepository : function(repositoryNode) {
		var nodeList, node, i, id, uri;
		nodeList = XPath.evaluate("*", repositoryNode);
		for (i = 0; i < nodeList.length; i++) {
			node = nodeList[i];
			id = XPath.evaluate("string(.//@value)", node);
			this.repositoryNodeList[id] = node;
			this.repositoryTextList[id] = this.sanitizeString(XPath.evaluate("string(.//@data-vocab-answer-name)", node));
			this.repositoryNoteList[id] = this.sanitizeString(XPath.evaluate("string(.//@data-vocab-answer-note)", node));
		}
	},
	typeQuestion : function(inputNode) {
		var questionValue, id, nodeList, node, i;
		
		questionValue = inputNode.value;
		
		nodeList = this.getMatchingNodes(questionValue);
		
		if (this.countList(nodeList) > 20) {
			//wenn zu viele, auf === matching umsteigen
			nodeList = this.getExactNode(questionValue);
		}
		//alle gefundenen anzeigen
		//erst alle nicht gefundenen deaktivieren
		for (id in inputNode._vocabRepositoryNodeList) {
			if (node = inputNode._vocabRepositoryNodeList[id]) {
				if (!nodeList[id]) {
					this.hideNode(node);
				}
			}
		}
		//jetzt alle neu gefundenen hinzufügne
		for (id in nodeList) {
			node = nodeList[id];
			if (inputNode._vocabRepositoryNodeList[id]) {
				node = inputNode._vocabRepositoryNodeList[id];
			} else {
				node = this.appendMatchingNode(inputNode, node);
				inputNode._vocabRepositoryNodeList[id] = node;
			}
			this.showNode(node);
		}
		for (id in nodeList) {
			inputNode._vocabRepositoryNodeList[id]._vocabInputNode.checked = true;
			break;
		}
		nodeList = this.getExactNode(questionValue);
		for (id in nodeList) {
			inputNode._vocabRepositoryNodeList[id]._vocabInputNode.checked = true;
			break;
		}
	},
	getExactNode : function(questionValue) {
		var answerValue, retList, id;
		retList = {};
		questionValue = this.sanitizeString(questionValue);
		for (id in this.repositoryTextList) {
			answerValue = this.repositoryTextList[id];
			if (answerValue.length && answerValue === questionValue) {
				retList[id] = this.repositoryNodeList[id];
			}
		}
		for (id in this.repositoryNoteList) {
			answerValue = this.repositoryNoteList[id];
			if (answerValue.length && answerValue === questionValue) {
				retList[id] = this.repositoryNodeList[id];
			}
		}
		return retList;
	},
	getMatchingNodes : function(questionValue) {
		var answerValue, retList, id;
		retList = {};
		questionValue = this.sanitizeString(questionValue);
		for (id in this.repositoryTextList) {
			answerValue = this.repositoryTextList[id];
			if (answerValue.length && this.matches(answerValue, questionValue)) {
				retList[id] = this.repositoryNodeList[id];
			}
		}
		for (id in this.repositoryNoteList) {
			answerValue = this.repositoryNoteList[id];
			if (answerValue.length && this.matches(answerValue, questionValue)) {
				retList[id] = this.repositoryNodeList[id];
			}
		}
		/*
		if (Translator) {
			var hiraganaValue, katakanaValue;
			hiraganaValue = Translator.toHiragana(questionValue);
			katakanaValue = Translator.toKatakana(questionValue);
			for (id in this.repositoryTextList) {
				answerValue = id;
				if (this.matches(answerValue, hiraganaValue) || this.matches(answerValue, katakanaValue)) {
					retList[id] = this.repositoryNodeList[id];
				}
			}
		}
		//*/
		return retList;
	},
	appendMatchingNode : function(inputNode, repositoryNode) {
		var retNode, name;
		name = inputNode.getAttribute("name");
		retNode = repositoryNode.cloneNode(true);
		retNode._vocabInputNode = XPath.evaluate(".//html:input", retNode)[0];
		retNode._vocabInputNode.name = name;
		
		inputNode._vocabParentNode.appendChild(retNode);
		return retNode;
	},
	sanitizeString : function(str) {
		return ("" + str).toLowerCase().trim().split(",").join(" ").split("　").join(" ");
	},
	matches : function(hackstack, needle) {
		var ret, strList, str, i;
		ret = true;
		strList = needle.split(" ");
		//hackstack = " " + hackstack;
		for (i = 0; i < strList.length; i++) {
			str = strList[i];
			if (str.length) {
				//str = " " + str;
				if (hackstack.indexOf(str) === -1) {
					ret = false;
					break;
				}
			}
		}
		return ret;
	},
	countList : function(list) {
		var ret = 0, i;
		for (i in list) {
			ret++;
		}
		return ret;
	},
	showNode : function(node) {
		node.style.removeProperty("display");
		node._vocabInputNode.disabled = false;
	},
	hideNode : function(node) {
		node.style.display = "none";
		node._vocabInputNode.disabled = true;
	},
};

addEventListener(
	"load",
	function(eve) {
		Vocab.init();
	},
	false
);