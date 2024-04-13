// © 2012 Daniel Schulz
//"(╯^_^)╯"	"╯)^_^╯)"
var tableFlip = " ︵╯(^‾^╯)";
var UnicodeMapper = {
	exceptionCodes : {
		normal : {
			"ß" : 0x1E9E,
		},
		italic : {
			h : 0x210E,
			"'" : "′",
			"\"" : "″",
		},
		bold : {
			0 : 0x1D7CE,
			1 : 0x1D7CF,
			2 : 0x1D7D0,
			3 : 0x1D7D1,
			4 : 0x1D7D2,
			5 : 0x1D7D3,
			6 : 0x1D7D4,
			7 : 0x1D7D5,
			8 : 0x1D7D6,
			9 : 0x1D7D7,
		},
		handwriting : {
			g : 0x210A,
			l : 0x2113,
			e : 0x212F,
			o : 0x2134,
			B : 0x212C,
			E : 0x2130,
			F : 0x2131,
			H : 0x210B,
			I : 0x2110,
			L : 0x2112,
			R : 0x211B,
			M : 0x2133,
		},
		fraktur : {
			H : 0x210C,
			I : 0x2111,
			R : 0x211C,
			Z : 0x2128,
			C : 0x212D,
		},
		doublestruck : {
			C : 0x2102,
			H : 0x210D,
			N : 0x2115,
			P : 0x2119,
			Q : 0x211A,
			R : 0x211D,
			Z : 0x2124,
			0 : 0x1D7D8,
			1 : 0x1D7D9,
			2 : 0x1D7DA,
			3 : 0x1D7DB,
			4 : 0x1D7DC,
			5 : 0x1D7DD,
			6 : 0x1D7DE,
			7 : 0x1D7DF,
			8 : 0x1D7E0,
			9 : 0x1D7E1,
		},
		"sans-serif" : {
			0 : 0x1D7E2,
			1 : 0x1D7E3,
			2 : 0x1D7E4,
			3 : 0x1D7E5,
			4 : 0x1D7E6,
			5 : 0x1D7E7,
			6 : 0x1D7E8,
			7 : 0x1D7E9,
			8 : 0x1D7EA,
			9 : 0x1D7EB,
		},
		"sans-serif+bold" : {
			0 : 0x1D7EC,
			1 : 0x1D7ED,
			2 : 0x1D7EE,
			3 : 0x1D7EF,
			4 : 0x1D7F0,
			5 : 0x1D7F1,
			6 : 0x1D7F2,
			7 : 0x1D7F3,
			8 : 0x1D7F4,
			9 : 0x1D7F5,
		},
		monospace : {
			0 : 0x1D7F6,
			1 : 0x1D7F7,
			2 : 0x1D7F8,
			3 : 0x1D7F9,
			4 : 0x1D7FA,
			5 : 0x1D7FB,
			6 : 0x1D7FC,
			7 : 0x1D7FD,
			8 : 0x1D7FE,
			9 : 0x1D7FF,
		},
		Capitals : {
			a : 0x1D00,
			b : 0x0299,
			c : 0x1D04,
			d : 0x1D05,
			e : 0x1D07,
			f : 0xA730,
			g : 0x0262,
			h : 0x029C,
			i : 0x026A,
			j : 0x1D0A,
			k : 0x1D0B,
			l : 0x029F,
			m : 0x1D0D,
			n : 0x0274,
			o : 0x1D0F,
			p : 0x1D18,
			q : 0xA7EE,
			r : 0x0280,
			s : 0xA731,
			t : 0x1D1B,
			u : 0x1D1C,
			v : 0x1D20,
			w : 0x1D21,
			x : 0xA7EF,
			y : 0x028F,
			z : 0x1D22,
		},
		fullwidth : {
			" " : "　",
			"." : "。",
			"!" : "！",
			"?" : "？",
			"," : "、",
			"(" : "（",
			")" : "）",
			"~" : "〜",
		},
	},
	startCodes : {
		normal : [
			0x0061,
			0x0041,
		],
		bold 		: [
			0x1D41A,
			0x1D400,
		],
		italic 		: [
			0x1D44E,
			0x1D434,
		],
		"bold+italic" : [
			0x1D482,
			0x1D468,
		],
		"sans-serif" : [
			0x1D5BA,
			0x1D5A0,
		],
		"sans-serif+bold" : [
			0x1D5EE,
			0x1D5D4,
		],
		"sans-serif+italic" : [
			0x1D622,
			0x1D608,
		],
		"sans-serif+bold+italic" : [
			0x1D656,
			0x1D63C,
		],
		handwriting : [
			0x1D4B6,
			0x1D49C,
		],
		"bold+handwriting" : [
			0x1D4EA,
			0x1D4D0,
		],
		fraktur : [
			0x1D51E,
			0x1D504,
		],
		"bold+fraktur" : [
			0x1D586,
			0x1D56C,
		],
		fullwidth : [
			0xFF41,
			0xFF21,
		],
		monospace : [
			0x1D68A,
			0x1D670,
		],
		doublestruck : [
			0x1D552,
			0x1D538,
		],
		Capitals : [
			0x1D00,
		],
		underlined : [
		],
	},
	outputNodes : undefined,
	init : function() {
		var parentNode, legendNode, childNode, fontType, i, key, val;
		if (!this.initialized) {
			var flipTable = {
				0x0021 : 0x00A1,
				0x0022 : 0x201E,
				0x0026 : 0x214B,
				0x0027 : 0x002C,
				0x0028 : 0x0029,
				0x002E : 0x02D9,
				0x0033 : 0x0190,
				0x0034 : 0x152D,
				0x0036 : 0x0039,
				0x0037 : 0x2C62,
				0x003B : 0x061B,
				0x003C : 0x003E,
				0x003F : 0x00BF,
				0x0041 : 0x2200,
				0x0042 : 0x10412,
				0x0043 : 0x2183,
				0x0044 : 0x25D6,
				0x0045 : 0x018E,
				0x0046 : 0x2132,
				0x0047 : 0x2141,
				0x004A : 0x017F,
				0x004B : 0x22CA,
				0x004C : 0x2142,
				0x004D : 0x0057,
				0x004E : 0x1D0E,
				0x0050 : 0x0500,
				0x0051 : 0x038C,
				0x0052 : 0x1D1A,
				0x0054 : 0x22A5,
				0x0055 : 0x2229,
				0x0056 : 0x1D27,
				0x0059 : 0x2144,
				0x005B : 0x005D,
				0x005F : 0x203E,
				0x0061 : 0x0250,
				0x0062 : 0x0071,
				0x0063 : 0x0254,
				0x0064 : 0x0070,
				0x0065 : 0x01DD,
				0x0066 : 0x025F,
				0x0067 : 0x0183,
				0x0068 : 0x0265,
				0x0069 : 0x0131,
				0x006A : 0x027E,
				0x006B : 0x029E,
				0x006C : 0x0283,
				0x006D : 0x026F,
				0x006E : 0x0075,
				0x0072 : 0x0279,
				0x0074 : 0x0287,
				0x0076 : 0x028C,
				0x0077 : 0x028D,
				0x0079 : 0x028E,
				0x007B : 0x007D,
				0x203F : 0x2040,
				0x2045 : 0x2046,
				0x2234 : 0x2235,
			};
			this.exceptionCodes[tableFlip] = {};
			this.startCodes[tableFlip] = [];
			for (i in flipTable) {
				key = this.fromCodePoint(i);
				val = this.fromCodePoint(flipTable[i]);
				this.exceptionCodes[tableFlip][key] = val;
				this.exceptionCodes[tableFlip][val] = key;
			}
			this.outputNodes = {};
			parentNode = document.getElementsByTagName("fieldset")[0];
			for (fontType in this.startCodes) {
				labelNode = document.createElementNS(NS.HTML, "label");
				childNode = document.createElementNS(NS.HTML, "span");
				childNode.appendChild(document.createTextNode(this.convertWord("Output, " + fontType, fontType)));
				labelNode.appendChild(childNode);
				this.outputNodes[fontType] = document.createElementNS(NS.HTML, "textarea");
				this.outputNodes[fontType].setAttribute("class", "myParagraph");
				labelNode.appendChild(this.outputNodes[fontType]);
				parentNode.appendChild(labelNode);
			}
			
			this.initialized = true;
		}
	},
	typeCharacter : function(inputNode) {
		var text, currentChar, i, fontType, outputNode, outputText, isUpperCase, codePoint;
		this.init();
		inputText = inputNode.value;
		outputText = {};
		
		//initialize output
		for (fontType in this.startCodes) {
			outputText[fontType] = "";
		}
		
		//generate output
		for (fontType in this.startCodes) {
			outputText[fontType] = this.convertWord(inputText, fontType);
		}
		
		//set output
		for (fontType in this.startCodes) {
			if (outputNode = this.outputNodes[fontType]) {
				outputNode.value = outputText[fontType];
			}
		}
	},
	convertWord : function(inputText, fontType) {
		var outputText, currentChar, codePoint, isUpperCase, i;
		outputText = "";
		for (i = 0; i < inputText.length; i++) {
			currentChar = inputText[i];
			if (this.exceptionCodes[fontType] && this.exceptionCodes[fontType][currentChar]) {
				if (typeof(this.exceptionCodes[fontType][currentChar]) === "number") {
					codePoint = this.exceptionCodes[fontType][currentChar];
					currentChar = this.fromCodePoint(codePoint);
				} else {
					currentChar = this.exceptionCodes[fontType][currentChar];
				}
			} else {
				switch (fontType) {
					case "underlined":
						currentChar += "̲";
						break;
					default:
						//letter found!
						if (currentChar.toUpperCase() !== currentChar.toLowerCase()) {
							isUpperCase = currentChar === currentChar.toUpperCase()
								? 1
								: 0;
							if (this.startCodes[fontType][isUpperCase]) {
								codePoint = this.toCodePoint(currentChar);
								codePoint -= this.startCodes.normal[isUpperCase];
								codePoint += this.startCodes[fontType][isUpperCase];
								currentChar = this.fromCodePoint(codePoint);
							}
						}
				}
			}
			outputText += currentChar;
		}
		if (fontType === tableFlip) {
			outputText = this.flipString(outputText);
		}
		return outputText;
	},
	//https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/String/fromCharCode
	fromCodePoint : function() {
        var chars = [], point, offset, units, i;
        for (i = 0; i < arguments.length; ++i) {
            point = arguments[i];
            offset = point - 0x10000;
            units = point > 0xFFFF ? [0xD800 + (offset >> 10), 0xDC00 + (offset & 0x3FF)] : [point];
            chars.push(String.fromCharCode.apply(null, units));
        }
        return chars.join("");
    },
	toCodePoint : function(str) {
		return str.charCodeAt(0);
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