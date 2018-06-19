function VocabTest() {
}
VocabTest.prototype.formNode = undefined;
VocabTest.prototype.status = 0;
VocabTest.prototype.STATUS_NEW = 0;
VocabTest.prototype.STATUS_INIT = 1;
VocabTest.prototype.STATUS_DONE = 9;
VocabTest.prototype.language = undefined;
VocabTest.prototype.mode = undefined;
VocabTest.prototype.type = undefined;
VocabTest.prototype.resourceURI = undefined;
VocabTest.prototype.resourceDoc = undefined;
VocabTest.prototype.logURI = undefined;
VocabTest.prototype.templateURI = undefined;
VocabTest.prototype.templateDoc = undefined;
VocabTest.prototype.questionNodeList = undefined;
VocabTest.prototype.currentQuestion = undefined;
VocabTest.prototype.currentQuestionNode = undefined;
VocabTest.prototype.currentAnswerNode = undefined;
VocabTest.prototype.answerRequest = undefined;
VocabTest.prototype.answerStack = undefined;
VocabTest.prototype.events = {
	submitTyping : function(eve) {
		eve.preventDefault();
		this._vocabTest.progressTestTyping();
	},
	submitClick : function(eve) {
		eve.preventDefault();
		this._vocabTest.progressTestClick(this);
	},
};
VocabTest.prototype.init = function(formNode) {
	this.formNode = formNode;
	this.status = this.STATUS_INIT;
	this.answerRequest = false;
	this.answerStack = [];
	try {
		this.language = this.formNode.getAttributeNS(NS.XML, "lang");
		this.mode = this.formNode.getAttribute("data-vocab-test");
		this.type = this.formNode.getAttribute("data-vocab-type");
		this.resourceURI = this.formNode.getAttribute("data-vocab-resource");
		this.logURI = this.formNode.getAttribute("data-vocab-log");
		this.formNode._vocabTest = this;
		this.templateURI = "/getTemplate.php/slothsoft/kana";
		this.questionNodeList = [];
		this.currentQuestion = 0;
		
		switch (this.type) {
			case "choice":
				this.initChoice();
				break;
			case "typing":
				this.initTyping();
				break;
			case "click":
				this.initClick();
				break;
		}
		
		this.showQuestion();
	} catch(e) {
		this.setError(e);
	}
};
VocabTest.prototype.initTyping = function() {
	var nodeList, node, i;
	
	this.formNode["vocab-submit"].style.display = "none";
	
	this.formNode.addEventListener(
		"submit",
		this.events.submitTyping,
		false
	);
	this.questionNodeList = XPath.evaluate("html:article", this.formNode);
	for (i = 0; i < this.questionNodeList.length; i++) {
		this.currentQuestionNode = this.questionNodeList[i];
		this.hideQuestion();
	}
	this.templateDoc = DOM.loadDocument(this.templateURI);
	this.resourceDoc = DOM.loadDocument(this.resourceURI);
	
	if (node = XPath.evaluate(".//day[@now]", this.resourceDoc)[0]) {
		this.currentQuestion = 0;
		if (node.hasAttribute("user-wrong")) {
			this.currentQuestion += parseInt(node.getAttribute("user-wrong"));
		}
		if (node.hasAttribute("user-correct")) {
			this.currentQuestion += parseInt(node.getAttribute("user-correct"));
		}
	}
};
VocabTest.prototype.initChoice = function() {
	this.questionNodeList = XPath.evaluate("html:article", this.formNode);
	//this.focusInput(this.formNode);
};
VocabTest.prototype.initClick = function() {
	var nodeList, node, i;
	
	this.formNode["vocab-submit"].style.display = "none";
	
	nodeList = XPath.evaluate(".//html:button[@name]", this.formNode);
	for (i = 0; i < nodeList.length; i++) {
		node = nodeList[i];
		node._vocabTest = this;
		node.addEventListener(
			"click",
			this.events.submitClick,
			false
		);
	}
	
	this.questionNodeList = XPath.evaluate("html:article", this.formNode);
	for (i = 0; i < this.questionNodeList.length; i++) {
		this.currentQuestionNode = this.questionNodeList[i];
		this.hideQuestion();
	}
	//this.templateDoc = DOM.loadDocument(this.templateURI);
	this.resourceDoc = DOM.loadDocument(this.resourceURI);
	
	if (node = XPath.evaluate(".//day[@now]", this.resourceDoc)[0]) {
		this.currentQuestion = 0;
		if (node.hasAttribute("user-wrong")) {
			this.currentQuestion += parseInt(node.getAttribute("user-wrong"));
		}
		if (node.hasAttribute("user-correct")) {
			this.currentQuestion += parseInt(node.getAttribute("user-correct"));
		}
	}
};
VocabTest.prototype.setError = function(errorMessage) {
	var errorNode;
	errorNode = this.formNode.ownerDocument.createElement("pre");
	errorNode.textContent = errorMessage;
	this.formNode.parentNode.replaceChild(errorNode, this.formNode);
};
VocabTest.prototype.focusInput = function(node) {
	node.scrollIntoView(true);
	if (node = XPath.evaluate(".//*[@tabindex][not(@disabled)]", node)[0]) {
		node.focus();
	}
};
VocabTest.prototype.focusSubmit = function(node) {
	if (node = XPath.evaluate(".//*[@type='submit'][not(@disabled)]", node)[0]) {
		node.focus();
	}
};
VocabTest.prototype.hideQuestion = function() {
	if (this.currentQuestionNode) {
		this.currentQuestionNode.style.display = "none";
	}
};
VocabTest.prototype.showQuestion = function() {
	if (this.questionNodeList[this.currentQuestion]) {
		this.currentQuestionNode = this.questionNodeList[this.currentQuestion];
		//this.currentQuestionNode.style.display = "block";
		this.currentQuestionNode.style.removeProperty("display");
		this.formNode.parentNode.style.removeProperty("display");
		this.focusInput(this.currentQuestionNode);
	} else {
		this.currentQuestionNode = undefined;
		this.currentAnswerNode = undefined;
		//this.formNode.parentNode.appendChild(this.formNode.ownerDocument.createTextNode("🏁"));
		//this.formNode.parentNode.removeChild(this.formNode);
		this.status = this.STATUS_DONE;
		this.formNode.parentNode.style.display = "none";
		this.sendAnswer();
	}
};
VocabTest.prototype.nextQuestion = function() {
	this.hideQuestion();
	this.currentQuestion++;
	this.showQuestion();
	this.currentAnswerNode = undefined;
};
VocabTest.prototype.progressTestClick = function(submitNode) {
	if (this.currentQuestionNode) {
		this.verifyQuestionClick(submitNode);
		if (this.currentQuestionNode.getAttribute("data-vocab-correct") === "1") {
			this.nextQuestion();
		}
	}
};
VocabTest.prototype.verifyQuestionClick = function(submitNode) {
	var rootNode, questionId, questionNode, answerId, answerNode, name, nodeList, node, i, isCorrect;
	if (this.currentQuestionNode) {
		questionId = submitNode.getAttribute("name");
		answerId = submitNode.getAttribute("value");
		
		if (!this.currentQuestionNode.hasAttribute("data-vocab-sent")) {
			this.currentQuestionNode.setAttribute("data-vocab-sent", "");
			this.sendAnswer(questionId, answerId);
		}
		
		questionNode = this.getResourceNode(questionId);
		answerNode = this.getResourceNode(answerId);
		
		isCorrect = (questionNode === answerNode);
		
		if (isCorrect) {
			this.currentQuestionNode.setAttribute("data-vocab-correct", "1");
		} else {
			this.currentQuestionNode.setAttribute("data-vocab-correct", "0");
			submitNode.disabled = true;
		}
	}
};
VocabTest.prototype.progressTestTyping = function() {
	if (this.currentQuestionNode) {
		if (this.currentQuestionNode.getAttribute("data-vocab-correct") === "1") {
			this.nextQuestion();
		} else {
			this.verifyQuestionTyping();
		}
	}
};
VocabTest.prototype.verifyQuestionTyping = function() {
	var rootNode, questionId, questionNode, answerId, answerNode, name, nodeList, node, i, isCorrect;
	if (this.currentQuestionNode) {
		questionId = this.currentQuestionNode.getAttribute("data-vocab-id");
		questionName = XPath.evaluate("string(.//html:input[@name]/@name)", this.currentQuestionNode);
		answerId = "";
		if (questionName && this.formNode[questionName]) {
			nodeList = this.formNode[questionName];
			for (i = 0; i < nodeList.length; i++) {
				node = nodeList[i];
				if (node.checked) {
					answerId = node.value;
				}
			}
		}
		
		if (!this.currentQuestionNode.hasAttribute("data-vocab-sent")) {
			this.currentQuestionNode.setAttribute("data-vocab-sent", "");
			this.sendAnswer(questionId, answerId);
		}
		
		questionNode = this.getResourceNode(questionId);
		answerNode = this.getResourceNode(answerId);
		
		rootNode = this.resourceDoc.createElement("test-answer");
		rootNode.setAttribute("mode", this.mode);
		rootNode.appendChild(questionNode.cloneNode(true));
		isCorrect = true;
		if (questionNode !== answerNode) {
			rootNode.appendChild(answerNode.cloneNode(true));
			isCorrect = false;
		}
		/*
		this.resourceDoc.documentElement.appendChild(rootNode);
		this.currentAnswerNode = XSLT.transformToFragment(rootNode, this.templateDoc, this.formNode.ownerDocument);
		this.resourceDoc.documentElement.removeChild(rootNode);
		this.currentQuestionNode.appendChild(this.currentAnswerNode);
		//*/
		
		if (isCorrect) {
			this.currentQuestionNode.setAttribute("data-vocab-correct", "1");
			this.focusSubmit(this.formNode);
		} else {
			this.currentQuestionNode.setAttribute("data-vocab-correct", "0");
			this.focusInput(this.formNode);
		}
	}
};
VocabTest.prototype.sendAnswer = function(questionId, answerId) {
	if (questionId) {
		this.answerStack.push([questionId, answerId]);
	}
	if (!this.answerRequest) {
		if (this.answerStack.length) {
			var req, param, i;
			param = {};
			for (i = 0; i < this.answerStack.length; i++) {
				param[this.answerStack[i][0]] = this.answerStack[i][1];
			}
			this.answerStack = [];
			this.answerRequest = new XMLHttpRequest();
			this.answerRequest._vocabTest = this;
			this.answerRequest._param = param;
			this.answerRequest.open("POST", ".?vocab-test-json=1&test-language=" + this.language, true);
			this.answerRequest.timeout = 10000;	//10s Timeout
			this.answerRequest.addEventListener(
				"error",
				this.sendAnswerError,
				false
			);
			this.answerRequest.addEventListener(
				"timeout",
				this.sendAnswerError,
				false
			);
			this.answerRequest.addEventListener(
				"loadend",
				this.sendAnswerSuccess,
				false
			);
			this.answerRequest.send(JSON.stringify(param));
		} else {
			if (this.status === this.STATUS_DONE) {
				this.updateLog();
			}
		}
	}
};
VocabTest.prototype.sendAnswerSuccess = function(eve) {
	this._vocabTest.answerRequest = false;
	this._vocabTest.sendAnswer();
};
VocabTest.prototype.sendAnswerError = function(eve) {
	var key, val;
	for (key in this._param) {
		val = this._param[key];
		this._vocabTest.sendAnswer(key, val);
	}
};
VocabTest.prototype.updateLog = function() {
	if (this.logURI) {
		var doc, nodeList, oldNode, newNode, i;
		nodeList = XPath.evaluate("//svg:svg[@llo:vocab-log]", this.formNode);
		for (i = 0; i < nodeList.length; i++) {
			oldNode = nodeList[i];
			doc = DOM.loadDocument(this.logURI);
			if (doc) {
				newNode = XPath.evaluate("//svg:svg", doc)[0];
				if (newNode) {
					oldNode.parentNode.replaceChild(
						this.formNode.ownerDocument.importNode(newNode, true),
						oldNode
					);
				}
			}
		}
	}
};
VocabTest.prototype.getResourceNode = function(id) {
	var retNode;
	retNode = XPath.evaluate(".//vocable[word/@id = \""+id+"\"]", this.resourceDoc)[0];
	if (!retNode) {
		retNode = this.resourceDoc.createElement("vocable");
	}
	return retNode;
};