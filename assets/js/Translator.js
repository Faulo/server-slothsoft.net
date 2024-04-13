// © 2012 Daniel Schulz

var Translator = {
	initialized : false,
	drawNode : undefined,
	dataDoc : undefined,
	templateDoc : undefined,
	formTable : undefined,
	formNodes : {
		"input" : undefined,
		"output" : undefined,
		"latin" : undefined,
		"hiragana" : undefined,
		"katakana" : undefined,
		"kanji" : undefined,
		"english" : undefined,
	},
	inputWords : [],
	commonCheck : undefined,
	//kana : [],
	translateRequest : undefined,
	translateQuery : "/getData.php/lang/translate",
	translateTimeout : 0,
	wsList : ["　"],
	copyList : ["。", "！", "？", "、", "（", "）", "｢", "｣", "〔", "〕"],
	regexList : {
		char3 	: /^(.{3})(.*)$/,
		char2 	: /^(.{2})(.*)$/,
		char1 	: /^(.{1})(.*)$/,
		ws 		: /^(\s+)(.*)$/,
		dash 	: /^(')(.*)$/,
		nomatch : /^(.)(.*)$/,
	},
	hiraganaList : undefined,
	katakanaList : undefined,
	init : function() {
		if (!this.initialized) {
			var dataDoc,
				templateDoc,
				nodeList, i,
				kana, latin;
			
			this.dataDoc = DOM.loadDocument("/getResource.php/slothsoft/kana");
			
			this.hiraganaList = {};
			nodeList = this.dataDoc.getElementsByTagName("hiragana");
			for (i = 0; i < nodeList.length; i++) {
				latin = nodeList[i].parentNode.getAttribute("latin");
				kana = nodeList[i].getAttribute("name");
				if (!this.hiraganaList[latin]) {
					this.hiraganaList[latin] = kana;
				}
			}
			
			this.katakanaList = {};
			nodeList = this.dataDoc.getElementsByTagName("katakana");
			for (i = 0; i < nodeList.length; i++) {
				latin = nodeList[i].parentNode.getAttribute("latin");
				kana = nodeList[i].getAttribute("name");
				if (!this.katakanaList[latin]) {
					this.katakanaList[latin] = kana;
				}
			}
			
			this.drawNode = document.getElementsByClassName("TranslatorRoot")[0];
			if (this.drawNode) {
				this.commonCheck = this.drawNode.getElementsByClassName("commonWords")[0];
				this.outputTable = this.drawNode.getElementsByClassName("translatorForm")[0];
				if (this.outputTable) {
					for (i in this.formNodes) {
						this.formNodes[i] = this.outputTable.getElementsByClassName(i)[0];
					}
				}
				
				this.templateDoc = DOM.loadDocument("/getTemplate.php/slothsoft/kana-translator");
				/*
				nodeList = this.dataDoc.getElementsByTagName("kana");
				for (i = 0; i < nodeList.length; i++) {
					this.kana[i] = nodeList[i];
				}
				//*/
				
				this.translateRequest = new XMLHttpRequest();
				
				this.initialized = true;
			}
		}
		return this.initialized;
	},
	translateLater : function() {
		if (this.translateTimeout) {
			window.clearTimeout(this.translateTimeout);
			this.translateTimeout = 0;
		}
		this.translateTimeout = window.setTimeout(
			this.translateCall,
			1000,
			this
		);
	},
	translateCall : function(translator) {
		translator.translate();
	},
	translate : function() {
		if (this.init()) {
			if (this.inputWords.length) {
				if (this.translateRequest) {
					this.translateRequest.abort();
				}
				this.drawNode.setAttribute("data-status", "busy");
				this.translateRequest = new XMLHttpRequest();
				this.translateRequest.translator = this;
				this.translateRequest.open("POST", this.translateQuery, true);
				this.translateRequest.addEventListener(
					"load",
					this.translateResponse,
					false
				);
				this.translateRequest.send(
					JSON.stringify({
						source : "ja",
						target : "en",
						sentence : this.inputWords,
						options : {
							commonOnly : !!this.commonCheck.checked,
						},
					})
				);
			}
		}
	},
	translateResponse : function(eve) {
		if (this.responseXML) {
			this.translator.translateDraw(this.responseXML);
		} else {
			alert(this.responseText);
		}
		this.translator.translateRequest = undefined;
		this.translator.drawNode.removeAttribute("data-status");
	},
	translateDraw : function(dataDoc) {
		var drawNode = XSLT.transformToNode(dataDoc, this.templateDoc, document);
		this.formNodes.output.parentNode.replaceChild(
			drawNode,
			this.formNodes.output
		);
		this.formNodes.output = drawNode;
	},
	typeCharacter : function(inputNode) {
		if (this.init()) {
			var match, input, key, found, inputKey, kana, stopLoop;
			this.clearOutput();
			input = inputNode.value;
			input = input.toLowerCase();
			input = input.split("\n").join(" ").split("\r").join(" ");
			this.inputWords = [{ latin : [], hiragana : [], katakana : []}];
			inputKey = 0;
			do {
				found = false;
				for (key in this.regexList) {
					if (match = this.regexList[key].exec(input)) {
						stopLoop = false;
						switch(key) {
							case "ws":
								inputKey++;
								this.inputWords[inputKey] = { latin : [], hiragana : [], katakana : []};
								//fallthrough!
							case "dash":
								found = true;
								input = match[2];
								stopLoop = true;
								break;
							default:
								kana = key === "nomatch"
									? match[1]
									: this.findKana(match[1]);
								if (kana) {
									if (this.inArray(kana, this.copyList) || this.inArray(kana, this.wsList)) {
										inputKey++;
										this.inputWords[inputKey] = { latin : [], hiragana : [], katakana : []};
										stopLoop = true;
										input = match[2];
										if (this.inArray(kana, this.wsList)) {
											found = true;
										} else {
											found = this.appendLatin(
												match[1],
												inputKey,
												this.inputWords[inputKey].latin[this.inputWords[inputKey].latin.length - 1]
											);
											for (kana in found) {
												this.inputWords[inputKey][kana].push("");
											}										
										}
									} else {
										found = this.appendLatin(
											match[1],
											inputKey,
											this.inputWords[inputKey].latin[this.inputWords[inputKey].latin.length - 1]
										);
										input = match[2];
										for (kana in found) {
											this.inputWords[inputKey][kana].push(found[kana]);
										}
										stopLoop = true;
									}
								}
								break;
						}
						if (stopLoop) {
							break;
						}
					}
				}
			} while (found);
			
			this.translateLater();
		}
	},
	clearOutput : function() {
		var nodeList;
		nodeList = this.outputTable.getElementsByTagName("td");
		while (nodeList.length) {
			nodeList[0].parentNode.removeChild(nodeList[0]);
		}
	},
	findKana : function(latin, key) {
		var query, kana,
			ret = false;
		latin = latin.split("\"").join("");
		query = 'string(//kana[@latin = "' + latin + '"]/' + (key ? key : '*') + '[1]/@name)';
		//kana = this.dataDoc.evaluate(query, this.dataDoc, null, XPathResult.STRING_TYPE, null).stringValue;
		kana = XPath.evaluate(query, this.dataDoc);
		if (kana !== "") {
			ret = kana;
		} else if (key) {
			ret = this.findKana(latin);
		}
		return ret;
	},
	appendLatin : function(latin, inputKey, previousLatin) {
		var kanaList, kana, node, key,
			ret = {};
		if (this.isVowel(latin) && (previousLatin && latin === previousLatin[previousLatin.length-1])) {
			previousLatin = "~";
		} else {
			previousLatin = latin;
		}
		kanaList = {
			latin : latin,
			hiragana : this.findKana(latin, "hiragana"),
			katakana : this.findKana(previousLatin, "katakana"),
		};
		for (key in kanaList) {
			kana = kanaList[key]
				? kanaList[key]
				: latin;
			node = document.createElement("td");
			node.setAttribute("data-parity", inputKey % 2);
			node.appendChild(document.createTextNode(kana));
			this.formNodes[key].appendChild(node);
			ret[key] = kana;
			//this.appendKana(res);
		}
		/*
		if (ret) {
			node = document.createElement("td");
			node.setAttribute("data-parity", inputKey % 2);
			node.appendChild(document.createTextNode(latin));
			this.formNodes.latin.appendChild(node);
		}
		//*/
		return ret;
	},
	isVowel : function(testChar) {
		return {
			a : true,
			e : true,
			i : true,
			u : true,
			o : true,
		}[testChar];
	},
	toHiragana : function(text) {
		return this.stringTranslate(text, this.hiraganaList);
	},
	toKatakana : function(text) {
		return this.stringTranslate(text, this.katakanaList);
	},
	createAudioPlayer : function(ele) {
		if (ele.hasAttribute("data-player-uri")) {
			var dataDoc, dataNode, uri;
			uri = ele.getAttribute("data-player-uri");
			dataDoc = ele.ownerDocument;
			
			if (ele.lastChild.nodeType === ele.ELEMENT_NODE) {
				ele.lastChild.pause()
				ele.lastChild.currentTime = 0;
				ele.lastChild.play();
			} else {
				dataNode = dataDoc.createElementNS(NS.HTML, "audio");
				dataNode.setAttribute("src", uri);
				dataNode.setAttribute("type", "audio/mpeg");
				dataNode.setAttribute("class", "audioPlayer");
				dataNode.setAttribute("autoplay", "autoplay");
				//dataNode.setAttribute("controls", "controls");
				dataNode.setAttribute("tabindex", "1");
				dataNode.addEventListener(
					"loadstart",
					function(eve) {
						this.parentNode.setAttribute("data-playing", "");
					},
					false
				);
				dataNode.addEventListener(
					"play",
					function(eve) {
						this.parentNode.setAttribute("data-playing", "");
					},
					false
				);
				dataNode.addEventListener(
					"pause",
					function(eve) {
						this.parentNode.removeAttribute("data-playing");
					},
					false
				);
				//ele.parentNode.replaceChild(dataNode, ele);
				ele.appendChild(dataNode);
			}
			/*
			if (uri.indexOf("mp3") === -1) {
				var dataDoc, dataNode;
				dataDoc = ele.ownerDocument;
				dataNode = dataDoc.createElementNS(NS.HTML, "object");
				dataNode.setAttribute("data", uri);
				dataNode.setAttribute("type", "application/x-shockwave-flash");
				dataNode.setAttribute("class", "audioPlayer");
				dataNode.setAttribute("play", "true");
				dataNode.setAttribute("loop", "false");
				if (ele.hasAttribute("data-player-remove")) {
					ele.parentNode.replaceChild(dataNode, ele);
				} else {
					ele.parentNode.appendChild(dataNode);
				}
			}
			//*/
		}
	},
	stringTranslate : function(text, list) {
		var key, val, input, candidate;
		ret = "";
		input = text;
		while (input.length) {
			candidate = "";
			for (key in list) {
				if (key !== " " && input.indexOf(key) === 0 && key.length > candidate.length) {
					candidate = key;
				}
			}
			if (candidate === "") {
				candidate = input[0];
				val = input[0];
			} else {
				val = list[candidate];
			}
			ret += val;
			input = input.substr(candidate.length);
		}
		return ret;
	},
	inArray : function(item, arr) {
		var i;
		for (i = 0; i < arr.length; i++) {
			if (item === arr[i]) return true;
		}
		return false;
	},
};

addEventListener(
	"load",
	function(eve) {
		Translator.init();
		
	},
	false
);