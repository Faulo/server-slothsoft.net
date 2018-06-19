// © 2012 Daniel Schulz
//"(╯^_^)╯"	"╯)^_^╯)"
var tableFlip = " ︵╯(^‾^╯)";
var UnicodeMapper = {
	fontList : {},
	outputNodes : undefined,
	unicodeDocument : undefined,
	unicodeURI : "/getResource.php/slothsoft/unicode-mapper",
	init : function() {
		var fontNodeList, fontNode, labelNode, spanNode, i, nodeList, j, key, val, font, fontName;
		if (!this.initialized) {
			this.fontList = {};
			
			this.unicodeDocument = DOM.loadDocument(this.unicodeURI);
			if (this.unicodeDocument) {
				fontNodeList = this.unicodeDocument.getElementsByTagName("font");
				for (i = 0; i < fontNodeList.length; i++) {
					fontNode = fontNodeList[i];
					fontName = fontNode.getAttribute("name");
					font = {};
					nodeList = fontNode.getElementsByTagName("letter");
					for (j = 0; j < nodeList.length; j++) {
						key = nodeList[j].getAttribute("source");
						val = nodeList[j].getAttribute("target");
						font[key] = val;
					}
					this.fontList[fontName] = font;
				}
			}
			
			this.outputNodes = {};
			fontNode = document.getElementsByTagNameNS(NS.HTML, "fieldset")[0];
			for (fontName in this.fontList) {
				labelNode = document.createElementNS(NS.HTML, "label");
				spanNode = document.createElementNS(NS.HTML, "span");
				spanNode.appendChild(document.createTextNode(this.convertWord("Output, " + fontName, fontName)));
				labelNode.appendChild(spanNode);
				this.outputNodes[fontName] = document.createElementNS(NS.HTML, "textarea");
				this.outputNodes[fontName].setAttribute("class", "myParagraph");
				labelNode.appendChild(this.outputNodes[fontName]);
				fontNode.appendChild(labelNode);
			}
			
			this.initialized = true;
			
			this.typeCharacter(document.getElementsByTagNameNS(NS.HTML, "textarea")[0]);
		}
	},
	typeCharacter : function(inputNode) {
		var text, currentChar, i, fontType, outputNode, outputText, isUpperCase, codePoint, inputText;
		this.init();
		inputText = inputNode.value;
		outputText = {};
		
		//initialize output
		for (fontType in this.fontList) {
			outputText[fontType] = "";
		}
		
		//generate output
		for (fontType in this.fontList) {
			outputText[fontType] = this.convertWord(inputText, fontType);
		}
		
		//set output
		for (fontType in this.fontList) {
			if (outputNode = this.outputNodes[fontType]) {
				outputNode.value = outputText[fontType];
			}
		}
	},
	convertWord : function(inputText, fontType) {
		var outputText, currentChar;
		outputText = "";
		for (var i = 0; i < inputText.length; i++) {
			currentChar = inputText[i];
			if (this.fontList[fontType] && this.fontList[fontType][currentChar]) {
				currentChar = this.fontList[fontType][currentChar];
			}
			//Special stuff
			switch (fontType) {
				case "underlined-single":
					currentChar += "̲";
					break;
				case "underlined-double":
					currentChar += "͇";
					break;
				case "strikethrough-single":
					currentChar += "̶";
					break;
				case "crosshatch":
					currentChar += "̷";
					break;
			}
			outputText += currentChar;
		}
		/*
		if (fontType === tableFlip) {
			outputText = this.flipString(outputText);
		}
		//*/
		return outputText;
	},
	flipString : function(str) {
		var ret, i;
		ret = "";
		for (i = str.length - 1; i >= 0; i--) {
			ret += str[i];
		}
		return ret;
	},
};

addEventListener(
	"load",
	function(eve) {
		UnicodeMapper.init();
	},
	false
);