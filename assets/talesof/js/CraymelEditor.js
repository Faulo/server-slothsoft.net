var CraymelEditor = {
	drawParent : undefined,
	drawNode : undefined,
	dataDoc : undefined,
	templateDoc : undefined,
	craymels : {},
	mages : [],
	events : {
		dragmousedown : function(eve) {
			this.setAttribute("data-status", "inuse");
		},
		dragmouseup : function(eve) {
			this.removeAttribute("data-status");
		},
		dragstart : function(eve) {
			//this.style.border.style = "inset";
			eve.dataTransfer.setData("text", this.getAttribute("data-craymel"));
			this._ce.drawParent.setAttribute("data-status", "");
		},
		dragend : function(eve) {
			this._ce.drawParent.removeAttribute("data-status");
		},
		dragover : function(eve) {
			eve.preventDefault();
		},
		drop : function(eve) {
			var craymelName, mageNo;
			eve.preventDefault();
			
			this._ce.drawParent.setAttribute("data-status", "busy");
			
			try {
				craymelName = eve.dataTransfer.getData("text");
				mageNo = this.getAttribute("data-cage");
				this._ce.setCraymel(craymelName, mageNo);
			} catch(e) {
				console.log(e);
			}
			
			this._ce.drawParent.removeAttribute("data-status");
		},
	},
	init : function() {	
		var dataDoc,
			templateDoc,
			req,
			nodeList, i;
		this.drawParent = document.getElementsByClassName("CraymelEditor")[0].parentNode;
		
		//HACK: enables CSS:active http://stackoverflow.com/questions/6063308/touch-css-pseudo-class-or-something-similar
		//this.drawParent.addEventListener("touchstart", function(eve) {}, false);
		
		req = new XMLHttpRequest();
		req.open("GET", "/slothsoft@slothsoft.net/talesof/xsl/CraymelEditor", false);
		req.send();
		this.templateDoc = req.responseXML;
		
		req = new XMLHttpRequest();
		req.open("GET", "/slothsoft@slothsoft.net/talesof/static/CraymelEditor", false);
		req.send();
		this.dataDoc = req.responseXML;
		
		nodeList = this.dataDoc.getElementsByTagName("craymels");
		for (i = 0; i < nodeList.length; i++) {
			this.mages.push(nodeList[i]);
		}
		nodeList = this.dataDoc.getElementsByTagName("mage");
		for (i = 0; i < nodeList.length; i++) {
			this.mages.push(nodeList[i]);
		}
		
		nodeList = this.dataDoc.getElementsByTagName("craymel");
		for (i = 0; i < nodeList.length; i++) {
			nodeList[i].mage = 0;
			this.craymels[nodeList[i].getAttribute("name")] = nodeList[i];
		}	
		this.draw();
	},
	draw : function() {
		var oldNodes, newNodes, nodeList, node, i;
		/*
		while (this.drawParent.hasChildNodes()) {
			this.drawParent.removeChild(this.drawParent.lastChild);
		}
		//*/
		this.drawNode = XSLT.transformToNode(this.dataDoc, this.templateDoc, document);
		
		oldNodes = this.drawParent.querySelectorAll("table");
		newNodes = this.drawNode.querySelectorAll("table");
		for (i = 0; i < oldNodes.length; i++) {
			oldNodes[i].parentNode.replaceChild(
				newNodes[i],
				oldNodes[i]
			);
		}
		
		nodeList = XPath.evaluate(".//*[@data-craymel]", this.drawParent);
		for (i = 0; i < nodeList.length; i++) {
			node = nodeList[i];
			node._ce = this;
			node.setAttribute("draggable", "true");
			node.addEventListener(
				"dragstart",
				this.events.dragstart,
				false
			);
			node.addEventListener(
				"dragend",
				this.events.dragend,
				false
			);
			node.addEventListener(
				"touchstart",
				this.events.dragmousedown,
				false
			);
			node.addEventListener(
				"touchend",
				this.events.dragmouseup,
				false
			);
		}
		
		nodeList = XPath.evaluate(".//*[@data-cage]", this.drawParent);
		for (i = 0; i < nodeList.length; i++) {
			node = nodeList[i];
			node._ce = this;
			node.setAttribute("data-status", "clear");
			node.addEventListener(
				"dragover",
				this.events.dragover,
				false
			);
			node.addEventListener(
				"drop",
				this.events.drop,
				false
			);
		}
		//this.drawParent.appendChild(this.drawNode);
	},
	tradeCraymel : function(ele) {
		var craymel, craymelName, mageNo;
		craymelName = ele.getAttribute("data-craymel");
		craymel = this.craymels[craymelName];
		mageNo = craymel.mage;
		if (mageNo === 2) {
			mageNo = 0;
		} else {
			mageNo++;
		}
		craymel.mage = mageNo;
		this.mages[mageNo].appendChild(craymel);
		this.draw();
	},
	setCraymel : function(craymelName, mageNo) {
		var craymel = this.craymels[craymelName];
		this.mages[mageNo].appendChild(craymel);
		this.draw();
	},
};

addEventListener(
	"load",
	function(eve) {
		CraymelEditor.init();
	},
	false
);
