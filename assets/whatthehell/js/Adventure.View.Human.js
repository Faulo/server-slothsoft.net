Adventure.View.Human = Trait.build({
	uses : [
		"ViewGameElement"
	],
	construct : function(ownerView, viewId) {
		this.ViewGameElement(
			ownerView,
			viewId,
			"/slothsoft@whatthehell/xsl/view.human",
			"api.pull.php?handle=god"
		);
		this.ownerView.controller.loadView("map", this);
		//this.ownerView.controller.loadView("dropButtons", this);
	},
	vars : {
		lastData : undefined,
	},
	methods : {
		handlePush : function() {
			var data = this.ownerView.controller.serializer.serializeToString(this.syncNode);
			if (data !== this.lastData) {
				this.lastData = data;
				//this.ownerView.sendMessage(ACTION.CONTROLLER_UPLOAD, this.drawFragment.firstChild);
				this.ownerView.controller.handlePush(
					"api.push.php?handle=human",
					this.lastData
				);
			}
		},
		handlePull : function(uri, data) {
			var i;
			data = data.split(",");
			for (i = 0; i < data.length; i++) {
				this.dropElement(data[i]);
			}
		},
		dropElement : function(name) {
			if (window.viewMapHack) {
				window.viewMapHack.dropElement(name);
			}
		},
	}
});