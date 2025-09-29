Adventure.Model.Pull = Trait.build({
	uses : [
	],
	construct : function() {
	},
	vars : {
		uri		: undefined,
		source 	: undefined,
		events : {
			message : function(eve) {
				sendMessage(
					ACTION.VIEW_PULL_PARSE,
					{
						uri : this.pull.uri,
						data : eve.data
					}
				);
			},
		},
	},
	methods : {
		init : function(uri) {
			this.uri = uri;
			this.source = new EventSource(REL_PATH + this.uri);
			this.source.pull = this;
			this.source.addEventListener(
				"message", 
				this.events.message,
				false
			);
		}
	}
});