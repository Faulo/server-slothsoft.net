Adventure.Controller.Pull = Trait.build({
	uses : [
	],
	construct : function(uri, pullHandler) {
		this.uri = uri;
		this.pullHandler = pullHandler;
		this.source = new EventSource(this.uri);
		this.source.pull = this;
		this.source.addEventListener(
			"message", 
			this.events.message,
			false
		);
	},
	vars : {
		uri		: undefined,
		source 	: undefined,
		pullHandler : undefined,
		events : {
			message : function(eve) {
				this.pull.pullHandler.handlePull(this.pull.uri, eve.data);
			},
		},
	},
	methods : {
	}
});