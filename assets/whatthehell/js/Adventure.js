const ACTION = {
	DEBUG : -1,
	CONTROLLER_START : 1,
	MODEL_START : 2,
	VIEW_START : 3,
	VIEW_MAP_LOAD : 4,
	MODEL_VIEW_LOAD : 5,
	VIEW_VIEW_LOAD : 6,
	CONTROLLER_UPLOAD : 7,
	MODEL_UPLOAD : 8,
	CONTROLLER_DOWNLOAD : 9,
	MODEL_DOWNLOAD : 10,
	VIEW_DOWNLOAD : 11,
	
	MODEL_PULL_REGISTER : 12,
	VIEW_PULL_PARSE : 13,
	MODEL_PUSH : 14,
};

var Adventure = Trait.build({
	uses : [
	],
	construct : function() {
		this.controller = new Adventure.Controller();
		this.view = new Adventure.View();
		this.model = new Worker("/slothsoft@whatthehell/js/worker.model");
		
		this.model.model 			= this.model;
		this.model.view 			= this.view;
		this.model.controller 		= this.controller;
		this.view.model 			= this.model;
		this.view.view 				= this.view;
		this.view.controller 		= this.controller;
		this.controller.model 		= this.model;
		this.controller.view 		= this.view;
		this.controller.controller 	= this.controller;
		
		this.model.addEventListener(
			"message",
			function(eve) {
				if (!this.view.parseMessage(eve.data.action, eve.data.payload)) {
					//throw new Exception("Worker sent unknown action: " + eve.data.action);
				}
			},
			false
		);
		
		this.controller.start();
	},
	vars : {
		model		: undefined,
		view		: undefined,
		controller	: undefined,
	},
	methods : {
	}
});