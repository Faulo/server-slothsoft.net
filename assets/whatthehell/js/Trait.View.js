Trait.ViewNode = {
	uses : [
	],
	construct : function(ownerView, viewId) {
		this.ownerView = ownerView;
		this.ownerDocument = ownerView.ownerDocument;
		this.viewId = viewId;
		this.childViews = [];
	},
	vars : {
		viewId				: undefined,	//int
		ownerView			: undefined,	//View Document
		parentView			: undefined,	//View Node
		childViews 			: undefined,	//View Elements
		ownerDocument 		: undefined,	//SVG DOM Document
		drawParent			: undefined,	//DOM Parent Node
		drawFragment 		: undefined,	//DOM Fragment
	},
	methods : {
		appendView : function(viewNode) {
			this.childViews.push(viewNode);
			viewNode.ownerView = this.ownerView;
			viewNode.parentView = this;
		},
		setDrawParent : function(node) {
			this.drawParent = node;
			if (this.drawFragment) {
				this.drawParent.appendChild(this.drawFragment);
			}
		},
		draw : function() {
		}
	}	
};

Trait.ViewElement = {
	uses : [
		"ViewNode"
	],
	construct : function(ownerView, viewId, templateDoc) {
		this.templateDoc = templateDoc;
		this.dataDoc = this.templateDoc.implementation.createDocument(null, null, null);
		this.ViewNode(ownerView, viewId);
	},
	vars : {
		templateDoc			: undefined,	//XSL DOM Document
		dataDoc				: undefined,	//XML DOM Document
		data				: undefined,	//{}
	},
	methods : {
		setData : function(data) {
			this.data = data;
		},
		asNode : function(dataDoc) {
			alert("implement asNode!");
		},
		draw : function() {
			var node;
			if (this.drawFragment && this.drawFragment.parentNode) {
				this.drawFragment.parentNode.removeChild(this.drawFragment);
			}
			node = this.asNode(this.dataDoc);
			this.dataDoc.appendChild(node);
			this.drawFragment = XSLT.transformToNode(
				this.dataDoc,
				this.templateDoc,
				this.ownerDocument
			);
			this.dataDoc.removeChild(node);
			if (this.drawParent) {
				this.drawParent.appendChild(this.drawFragment);
			}
		}
	}
};

Trait.ViewDocument = {
	uses : [
		"ViewNode"
	],
	construct : function(viewPrototypes, ownerDocument) {
		this.viewPrototypes = viewPrototypes;
		this.ownerDocument = ownerDocument;
		window.svgDocument = this.ownerDocument;
		this.ownedViewCount = 0;
		this.ownedViews = {
			0 : this
		};
		this.ViewNode(this, this.ownedViewCount);
	},
	vars : {
		viewPrototypes		: undefined,	//View Prototypes
		ownedViews			: undefined,	//View Elements
		ownedViewCount		: undefined,	//last View ID
	},
	methods : {
		appendView : function(viewNode) {
			this.childViews = [viewNode];
		},
		createView : function(viewName) {
			this.ownedViewCount++;
			this.ownedViews[this.ownedViewCount] = new this.viewPrototypes[viewName](this, this.ownedViewCount);
			return this.ownedViews[this.ownedViewCount];
		},
		loadView : function(viewName, viewData, viewParentId) {
			var viewNode, viewParent;
			viewNode = this.createView(viewName);
			viewParent = this.getViewById(viewParentId);
			if (viewNode) {
				viewNode.setData(viewData);
				if (viewParent) {
					viewParent.appendView(viewNode);
					viewParent.draw();
				} else {
					alert(viewParentId);
				}
			}
		},
		getViewById : function(viewId) {
			if (this.ownedViews[viewId]) {
				return this.ownedViews[viewId];
			}
			return undefined;
		},
		draw : function() {
			var i;
			while (this.drawParent.hasChildNodes()) {
				this.drawParent.removeChild(this.drawParent.firstChild);
			}
			//this.drawFragment = this.ownerDocument.createDocumentFragment();
			for (i = 0; i < this.childViews.length; i++) {
				this.childViews[i].setDrawParent(this.drawParent);
				this.childViews[i].draw();
			}
			//this.drawParent.appendChild(this.drawFragment);
		},
		makeElement : function(tagName, attributeMap, childNodes) {
			var retNode = this.ownerDocument.createElementNS(NS.SVG, tagName);
			//retNode = this.ownerDocument.getElementsByTagName("svg")[0].createSVGRect();
			//alert(retNode);
			if (attributeMap) {
				var key;
				for (key in attributeMap) {
					retNode.setAttribute(key, attributeMap[key]);
					//retNode[key] = attributeMap[key];
				}
			}
			if (childNodes) {
				var i;
				for (i = 0; i < childNodes.length; i++) {
					retNode.appendChild(childNodes[i]);
				}
			}
			return retNode;
		},
	}
};