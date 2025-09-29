Adventure.View.Menu = Trait.build({
	uses : [
		"ViewElement"
	],
	construct : function(ownerView, viewId) {
		let templateDoc = DOM.loadDocument("/slothsoft@whatthehell/xsl/view.menu");
		this.ViewElement(ownerView, viewId, templateDoc);
	},
	vars : {
	},
	methods : {
		draw : function() {
			return this.ViewElementDraw();
		},
		asNode : function(doc) {
			return this.buildMenu(doc, this.data);
		},
		buildMenu : function(doc, menu) {
			var retNode, i;
			retNode = doc.createElement("menu");
			if (menu.id) {
				retNode.setAttribute("id", menu.id);
			}
			if (menu.width) {
				retNode.setAttribute("width", menu.width);
			}
			for (i = 0; i < menu.title.length; i++) {
				retNode.appendChild(this.buildTitle(doc, menu.title[i]));
			}
			for (i = 0; i < menu.buttons.length; i++) {
				retNode.appendChild(this.buildButtons(doc, menu.buttons[i]));
			}
			return retNode;
		},
		buildTitle : function(doc, title) {
			var retNode;
			retNode = doc.createElement("title");
			retNode.appendChild(doc.createTextNode(title));
			return retNode;
		},
		buildButtons : function(doc, button) {
			var retNode, i;
			retNode = doc.createElement("button");
			retNode.setAttribute("title", button.title);
			retNode.setAttribute("action", button.action);
			return retNode;
		},
	}
});