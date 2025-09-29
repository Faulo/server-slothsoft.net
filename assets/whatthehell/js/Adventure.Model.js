Adventure.Model = Trait.build({
	uses : [
	],
	construct : function() {
		this.pulls = [];
		this.pushs = {};
	},
	vars : {
		pulls				: undefined,
		pushs				: undefined,
		mapUploadFile		: "../../api.push.php?",
		mapUploadProgress 	: false,
		mapDownloadFile		: "../../data/getMap.php",
		mapDownloadProgress : false,
	},
	methods : {
		mapUpload : function(str) {
			if (!this.mapUploadProgress) {
				this.mapUploadProgress = true;
				var httpRequest = new XMLHttpRequest();
				httpRequest.addEventListener("readystatechange", this.mapUploadRespond, false);
				httpRequest.open("POST", this.mapUploadFile, true);
				//httpRequest.setRequestHeader("Content-Type","application/xml");//"application/json");//"application/x-www-form-urlencoded"
				httpRequest.send(str);
			}
		},
		mapUploadRespond : function() {
			switch (this.readyState) {
				case 4:
					model.mapUploadProgress = false;
					break;
			}
		},
		mapDownload : function(id) {
			
			if (!this.mapDownloadProgress) {
				this.mapDownloadProgress = id;
				var httpRequest = new XMLHttpRequest();
				httpRequest.addEventListener("readystatechange", this.mapDownloadRespond, false);
				httpRequest.open("POST", this.mapDownloadFile, true);
				//httpRequest.setRequestHeader("Content-Type","application/xml");//"application/json");//"application/x-www-form-urlencoded"
				httpRequest.send();
				
			}
		},
		mapDownloadRespond : function() {
			switch (this.readyState) {
				case 4:
					sendMessage(
						ACTION.VIEW_DOWNLOAD,
						{
							id : model.mapDownloadProgress,
							xml : this.responseText
						}
					);
					model.mapDownloadProgress = false;
					break;
			}
		},
		addPull : function(uri) {
			var pull = new Adventure.Model.Pull();
			pull.init(uri);
			this.pulls.push(pull);
		},
		handlePush : function(uri, data) {
			if (!this.pushs[uri]) {
				var httpRequest = new XMLHttpRequest();
				this.pushs[uri] = httpRequest;
				httpRequest.uri = uri;
				httpRequest.model = this;
				httpRequest.addEventListener("readystatechange", this.handlePushRespond, false);
				httpRequest.open("POST", REL_PATH + uri, true);
				//httpRequest.setRequestHeader("Content-Type","application/xml");//"application/json");//"application/x-www-form-urlencoded"
				httpRequest.send(data);
				
			}
		},
		handlePushRespond : function() {
			switch (this.readyState) {
				case 4:
					this.model.pushs[this.uri] = false;
					break;
			}
		},
		loadView : function(data) {
			var viewName = undefined,
				viewData = undefined,
				viewParent = data.parent;
			switch (data.name) {
				case "dropButtons":
					viewName = "Menu";
					viewData = {
						title : ["Baue eine", "Sofa-Festung!"],
						id : "menuDrop",
						width : 200,
						buttons : [
							{ title : "Sofa", action : "game.drop.sofa"},
							{ title : "Sessel", action : "game.drop.sessel" },
							{ title : "Kissen", action : "game.drop.kissen"},
							{ title : "Decke", action : "game.drop.decke"},
							{ title : "Taschenlampe", action : "game.drop.taschenlampe"},
							{ title : "Kakao", action : "game.drop.kakao"},
							//{ title : "Mensch-Modus", action : "game.closeMenu"},
						]
					};
					break;
				case "index":
					viewName = "Menu";
					viewData = {
						title : ["What The Hell?"],
						width : "100%",
						buttons : [
							//{ title : "Human", action : "game.loadView.human"},
							//{ title : "God", action : "game.loadView.god" },
							{ title : "Solo", action : "game.loadView.solo"},
						]
					};
					break;
				case "human":
					viewName = "Human";
					viewData = {
					};
					break;
				case "god":
					viewName = "God";
					viewData = {
					};
					break;
				case "solo":
					viewName = "Solo";
					viewData = {
					};
					break;
				case "map":
					viewName = "Map";
					viewData = {
						layers : [
							{
								image : "/slothsoft@whatthehell/static/background-fort",
								clickies : [
									{
										name : "Baum",
										title : "Baum",
										paths : [
											{
												coords : [
													[0, 0],
													[150, 0],
													[100, 100],
													[0, 200]
												]
											}
										]
									},
									{
										name : "Sonne",
										title : "Sonne",
										paths : [
											{
												coords : [
													[500, 0],
													[650, 0],
													[600, 100],
													[500, 200]
												]
											}
										]
									}
								],
								items : [
								],
								chars : [
								]
							}
						]
					};
					break;
			}
			if (viewName && viewData) {
				sendMessage(
					ACTION.VIEW_VIEW_LOAD,
					{
						name : viewName,
						data : viewData,
						parent : viewParent
					}
				);
			}
		},
	}
});