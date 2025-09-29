Trait.ViewGameElement = {
	uses : [
		"ViewElement"
	],
	construct : function(ownerView, viewId, templateURI, pullURI) {
		let templateDoc = DOM.loadDocument(templateURI);
		this.ViewElement(ownerView, viewId, templateDoc);
		if (pullURI) {
			this.ownerView.controller.addPullListener(
				pullURI,
				this
			);
		}
	},
	vars : {
		viewMap 		: undefined,
		viewMenu 		: undefined,
		pushInterval	: undefined,
		syncNode		: undefined,
	},
	methods : {
		draw : function() {
			this.ViewElementDraw();
			if (this.viewMap) {
				this.viewMap.draw();
				this.viewMap.setDrawParent(this.drawFragment.lastChild);
			}
			if (this.viewMenu) {
				this.viewMenu.draw();
				this.viewMenu.setDrawParent(this.drawFragment);
			}
			
			this.syncNode = document.getElementById("items");
			
			if (this.pushInterval) {
				window.clearInterval(this.pushInterval);
			}
			this.pushInterval = window.setInterval(
				function(game) {
					game.handlePush();
				},
				100,
				this
			);
		},
		handlePush : function() {
		},
		handlePull : function(uri, data) {
			alert(data);
		},
		appendView : function(viewNode) {
			if (viewNode instanceof this.ownerView.viewPrototypes.Map) {
				this.viewMap = viewNode;
			}
			if (viewNode instanceof this.ownerView.viewPrototypes.Menu) {
				this.viewMenu = viewNode;
			}
			this.ViewNodeAppendView(viewNode);
		},
		asNode : function(doc) {
			return this.buildGame(doc, this.data);
		},
		buildGame : function(doc, map) {
			var retNode;
			retNode = doc.createElement("game");
			return retNode;
		},
	}	
};