Adventure.View.God = Trait.build({
	uses : [
		"ViewGameElement"
	],
	construct : function(ownerView, viewId) {
		this.ViewGameElement(
			ownerView,
			viewId,
			"/slothsoft@whatthehell/xsl/view.god",
			"api.pull.php?handle=human"
		);
		//this.ownerView.controller.loadView("map", this);
		this.ownerView.controller.loadView("dropButtons", this);
		this.droppingElements = [];
		window.viewGodHack = this;
	},
	vars : {
		droppingElements : undefined,
	},
	methods : {
		handlePush : function() {
			if (this.droppingElements.length) {
				var data = this.droppingElements.join(",");
				this.ownerView.controller.handlePush(
					"api.push.php?handle=god",
					data
				);
				this.droppingElements = [];
			}
		},
		handlePull : function(uri, data) {
			this.syncNode = this.ownerView.controller.parseMap(this.syncNode, data);
		},
		dropElement : function(name) {
			this.droppingElements.push(name);
		},
	}
});