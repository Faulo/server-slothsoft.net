Adventure.View = Trait.build({
	uses : [
		"ViewDocument"
	],
	construct : function() {
		this.ViewDocument(Adventure.View, window.document);
		this.setDrawParent(this.ownerDocument.getElementById("body"));
	},
	vars : {
		model		: undefined,
		view		: undefined,
		controller	: undefined,
		
		mouseFollower : undefined,
		
		events : {
			rootClick : function(eve) {
				if (eve.target.hasAttribute("data-action")) {
					this.controller.parseAction(eve.target.getAttribute("data-action"));
				}
			},
			tooltipCheck : function(eve) {
				if (this.view.mouseFollower) {
					this.view.mouseFollower.events.update.call(this.view.mouseFollower.node, eve);
				}
				/*
				var ele = false;
				if (eve.target.hasAttribute("data-tooltip")) {
					ele = eve.target;
				} else if (eve.target.parentNode && eve.target.parentNode.hasAttribute && eve.target.parentNode.hasAttribute("data-tooltip")){
					ele = eve.target.parentNode;
				}
				if (ele) {
					var text = ele.getAttribute("data-tooltip");
					if (this.view.tooltipX.value !== eve.pageX) {
						this.view.tooltipX.value = eve.pageX;
					}
					if (this.view.tooltipY.value !== eve.pageY) {
						this.view.tooltipY.value = eve.pageY;
					}
					if (this.view.tooltipText.data !== text) {
						this.view.tooltipText.data = text;
					}
				} else {
					if (this.view.tooltipText.data.length) {
						this.view.tooltipText.data = "";
					}
				}
				if (eve.target.hasAttribute("data-item")) {
					ele = eve.target;
				} else if (eve.target.parentNode && eve.target.parentNode.hasAttribute && eve.target.parentNode.hasAttribute("data-item")){
					ele = eve.target.parentNode;
				}
				if (ele && ele.item.followMouse) {
					ele.item.moveBy(eve.pageX - ele.item.followMouseX, eve.pageY - ele.item.followMouseY);
					ele.item.followMouseX = eve.pageX;
					ele.item.followMouseY = eve.pageY;
				}
				//*/
			},
		},
	},
	methods : {
		init : function(config) {
			//this.sendMessage(ACTION.CONTROLLER_START, config);
			var i, j, parent, node;
			/*
			parent = document.getElementById("inventory").getElementsByTagName("g")[0];
			for (i = 0; i < 24; i++) {
				for (j = 0; j < 8; j++) {
					node = document.createElementNS("http://www.w3.org/2000/svg", "rect");
					node.setAttribute("width", "24");
					node.setAttribute("height", "24");
					node.setAttribute("x", i * 24); 
					node.setAttribute("y", j * 24);
					parent.appendChild(node);
				}
			}
			parent.addEventListener(
				"click",
				function(eve) {
					var x = parseInt(eve.target.getAttribute("x")) / 24;
					var y = parseInt(eve.target.getAttribute("y")) / 24;
					alert(x + " | " + y);
				},
				false
			);
			
			this.mapNode = document.getElementById("map");
			this.mapNode.coordMatrix = this.mapNode.transform.baseVal.getItem(0).matrix;
			*/
			this.tooltipNode = document.getElementById("tooltip");
			this.tooltipText = this.tooltipNode.firstChild;
			this.tooltipX = this.tooltipNode.x.baseVal.getItem(0);
			this.tooltipY = this.tooltipNode.y.baseVal.getItem(0);
			
			this.rootElement = document.documentElement;
			this.rootElement.view = this;
			this.rootElement.controller = this.controller;
			this.rootElement.addEventListener(
				"mousemove",
				this.events.tooltipCheck,
				false
			);
			this.rootElement.addEventListener(
				"click",
				this.events.rootClick,
				false
			);
		},
		sendMessage : function(action, payload) {
			window.setTimeout(
				function(view, action, payload) {
					view.controller.parseMessage(action, payload);
				},
				10,
				this,
				action,
				payload
			);
		},
		parseMessage : function(action, payload) {
			switch (action) {
				case ACTION.DEBUG:
					alert("MODEL DEBUG:\n"+payload);
					break;
				case ACTION.VIEW_START:
					this.init(payload);
					break;
				case ACTION.VIEW_VIEW_LOAD:
					this.loadView(payload.name, payload.data, payload.parent);
					break;
				case ACTION.VIEW_DOWNLOAD:
					this.controller.parseMap(this.ownerDocument.getElementById(payload.id), payload.xml);
					break;
				case ACTION.VIEW_PULL_PARSE:
					this.controller.pulls[payload.uri].handlePull(payload.data);
					break;
			}
			return false;
		},
	}
});