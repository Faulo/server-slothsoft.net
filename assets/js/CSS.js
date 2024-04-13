var CSS = {
	ruleTypeList : [
		"unknown",
		"style",
		"charset",
		"import",
		"media",
		"fontface",
		"page",
	],
	init : function() {
	},
	asNode : function(cssObject, doc) {
		var tagName, retNode, i, key, val, node, list;
		tagName = "unknown";
		if (cssObject instanceof CSSRule) {
			tagName = "rule";
		}
		if (cssObject instanceof CSSRule) {
			tagName = "rule";
		}
		retNode = doc.createElement(tagName);
		if (cssObject instanceof CSSRule) {
			retNode.setAttribute("code", cssObject.cssText);
			retNode.setAttribute("type", this.ruleTypeList[cssObject.type]);
		}
		if (cssObject instanceof CSSStyleRule) {
			retNode.setAttribute("selector", cssObject.selectorText);
			for (i = 0; i < cssObject.style.length; i++) {
				key = cssObject.style[i];
				val = cssObject.style.getPropertyValue(key);
				node = doc.createElement("property");
				node.setAttribute("name", key);
				node.setAttribute("value", val);
				if (list = /rgb\((\d+), (\d+), (\d+)\)/.exec(val)) {
					node.setAttribute("value", "#" + parseInt(list[1]).toString(16) + parseInt(list[2]).toString(16) + parseInt(list[3]).toString(16));
				}
				retNode.appendChild(node);
				
			}
		}
		return retNode;
	},
	getStyleRuleList : function() {
		var i, j, sheet, rule, retList;
		retList = [];
		for (i = 0; i < document.styleSheets.length; i++) {
			sheet = document.styleSheets[i];
			for (j = 0; j < sheet.cssRules.length; j++) {
				rule = sheet.cssRules[j];
				if (rule.type === rule.STYLE_RULE) {
					retList.push(rule);
				}
			}
		}
		return retList;
	},
	getStyleRuleListBySelector : function(selector) {
		var i, ruleList, retList;
		retList = [];
		ruleList = this.getStyleRuleList();
		for (i = 0; i < ruleList.length; i++) {
			if (ruleList[i].selectorText === selector) {
				retList.push(ruleList[i]);
			}
		}
		return retList;
	},
	getStyleRuleListByProperty : function(propertyList) {
		var i, j, ruleList, retList;
		retList = [];
		ruleList = this.getStyleRuleList();
		for (i = 0; i < ruleList.length; i++) {
			for (j = 0; j < propertyList.length; j++) {
				if (ruleList[i].style.getPropertyValue(propertyList[j]).length) {
					retList.push(ruleList[i]);
					break;
				}
			}
		}
		return retList;
	},
};

addEventListener(
	"load",
	function(eve) {
		CSS.init();
	},
	false
);