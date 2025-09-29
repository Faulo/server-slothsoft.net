Adventure.View.Map = Trait.build({
	uses : [
		"ViewElement"
	],
	construct : function(ownerView, viewId) {
		let templateDoc = DOM.loadDocument("/slothsoft@whatthehell/xsl/view.map");
		this.ViewElement(ownerView, viewId, templateDoc);
		this.intersection = new Intersection();
		this.intersection.init();
		window.viewMapHack = this;
	},
	vars : {
		intersection	: undefined,
		frameNode		: undefined,
		floorItem		: undefined,
		tickInterval	: undefined,
		itemsParent		: undefined,
		items			: undefined,
		storageParent	: undefined,
		storage			: undefined,
		dataMaps 		: undefined,
		dataLayers 		: undefined,
		dataClickies 	: undefined,
		dataPaths 		: undefined,
	},
	methods : {
		draw : function() {
			if (this.tickInterval) {
				window.clearInterval(this.tickInterval);
			}
			this.items = [];
			this.storage = [];
			this.dataMaps = [];
			this.dataLayers = [];
			this.dataClickies = [];
			this.dataPaths = [];
			this.ViewElementDraw();
			
			this.frameNode = this.ownerDocument.getElementById("frame");
			
			this.itemsParent = this.drawFragment.getElementsByTagNameNS(NS.SVG, "g")[1];
			this.storageParent = this.drawFragment.ownerDocument.getElementById("storage");
			
			//this.tickInterval = window.setTimeout(
			this.tickInterval = window.setInterval(
				function(map) {
					map.tick();
				},
				50,
				this
			);
			this.collectItems();
			this.createFloor();
			//this.dropElement("sofa");
		},
		tick : function() {
			var i, j, item;
			for (i = 0; i < this.items.length; i++) {
				item = this.items[i];
				if (item.move()) {
					if (item.collides(this.floorItem)) {
						continue;
					}
					for (j = 0; j < this.items.length; j++) {
						if (!this.items[j].moving && item.collides(this.items[j])) {
							continue;
						}
					}
				}
			}
		},
		createFloor : function() {
			var ele = this.ownerView.makeElement(
				"g", {
					"data-item" : "floor",
				}, [
					this.ownerView.makeElement(
						"rect", {
							
							width : "1000",
							height : "500",
							x : "0",
							y : "500",
						}
					)
				]
			);
			this.itemsParent.appendChild(ele);
			this.floorItem = new Adventure.View.Map.Item(this, ele);
			//this.appendItem(this.floorItem);
		},
		collectItems : function() {
			var i;
			for (i = 0; i < this.itemsParent.childNodes.length; i++) {
				this.appendItem(new Adventure.View.Map.Item(this, this.itemsParent.childNodes[i]));
			}
			for (i = 0; i < this.storageParent.childNodes.length; i++) {
				this.storage.push(this.storageParent.childNodes[i]);
			}
		},
		dropElement : function(name) {
			var i, ele, item;
			if (name) {
				for (i = 0; i < this.storage.length; i++) {
					if (this.storage[i].getAttribute("data-item") === name) {
						break;
					}
				}
			} else {	
				i = parseInt(this.storage.length * Math.random());
			}
			if (this.storage[i]) {
				ele = this.storage[i].cloneNode(true);
				item = new Adventure.View.Map.Item(this, ele);
				this.itemsParent.appendChild(ele);
				this.appendItem(item);
			}
		},
		appendItem : function(ele) {
			ele.moveBy(800*Math.random() - 400, -800);
			ele.drop();
			this.items.push(ele);
		},
		asNode : function(doc) {
			return this.buildMap(doc, this.data);
		},
		buildMap : function(doc, map) {
			var retNode, i;
			retNode = doc.createElement("map");
			retNode.setAttribute("id", this.dataMaps.push(map) - 1);
			for (i = 0; i < map.layers.length; i++) {
				retNode.appendChild(this.buildLayer(doc, map.layers[i]));
			}
			return retNode;
		},
		buildLayer : function(doc, layer) {
			var retNode, i;
			retNode = doc.createElement("layer");
			retNode.setAttribute("id", this.dataLayers.push(layer) - 1);
			retNode.setAttribute("image", layer.image);
			for (i = 0; i < layer.clickies.length; i++) {
				retNode.appendChild(this.buildClicky(doc, layer.clickies[i]));
			}
			return retNode;
		},
		buildClicky : function(doc, clicky) {
			var retNode, i;
			retNode = doc.createElement("clicky");
			retNode.setAttribute("id", this.dataClickies.push(clicky) - 1);
			retNode.setAttribute("name", clicky.name);
			retNode.setAttribute("title", clicky.title);
			for (i = 0; i < clicky.paths.length; i++) {
				retNode.appendChild(this.buildPath(doc, clicky.paths[i]));
			}
			return retNode;
		},
		buildPath : function(doc, path) {
			var retNode, i;
			retNode = doc.createElement("path");
			retNode.setAttribute("id", this.dataPaths.push(path) - 1);
			for (i = 0; i < path.coords.length; i++) {
				retNode.appendChild(this.buildCoord(doc, path.coords[i]));
			}
			return retNode;
		},
		buildCoord : function(doc, coord) {
			var retNode, i;
			retNode = doc.createElement("coord");
			retNode.setAttribute("x", coord[0]);
			retNode.setAttribute("y", coord[1]);
			return retNode;
		},
	}
});