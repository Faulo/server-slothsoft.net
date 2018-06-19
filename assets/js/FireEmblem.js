var FireEmblem = {
	shipLinkNode : undefined,
	characterNodeList : undefined,
	shipList : undefined,
	shipCountNode : undefined,
	shipContainerNode : undefined,
	unshipCountNode : undefined,
	unshipContainerNode : undefined,
	faceNodeList : undefined,
	init : function() {
		var nodeList, node, i, j, childNodeList, childNode, name;
		this.shipLinkNode = document.querySelector(".shipLink");
		this.shipCountNode = document.querySelector("*.shipCount");
		this.shipContainerNode = document.querySelector("*.shipContainer");
		this.unshipCountNode = document.querySelector("*.unshipCount");
		this.unshipContainerNode = document.querySelector("*.unshipContainer");
		
		this.faceNodeList = {};
		nodeList = this.unshipContainerNode.querySelectorAll("*[data-name]");
		for (i = 0; i < nodeList.length; i++) {
			node = nodeList[i];
			name = node.getAttribute("data-name");
			this.faceNodeList[name] = node;
		}
		
		this.shipList = {};
		this.characterNodeList = {};
		
		nodeList = document.querySelectorAll("*[data-character]");
		for (i = 0; i < nodeList.length; i++) {
			node = nodeList[i];
			name = node.getAttribute("data-character");
			this.characterNodeList[name] = node;
			this.shipList[name] = "";
			childNodeList = node.querySelectorAll("input");
			for (j = 0; j < childNodeList.length; j++) {
				childNode = childNodeList[j];
				childNode.addEventListener(
					"change",
					function(eve) {
						//alert(this.getAttribute("data-name") + "/" + this.value);
						FireEmblem.setShip(this.value, this.getAttribute("data-name"));
						FireEmblem.syncShips();
						FireEmblem.outputShips();
					},
					false
				);
			}
		}
		this.loadShips("" + window.location.hash.split("#")[1]);
		this.syncShips();
		this.outputShips();
	},
	loadShips : function(shipList) {
		var ship, i, characterName, supportName;
		shipList = shipList.split(";");
		for (i = 0; i < shipList.length; i++) {
			ship = shipList[i];
			ship = ship.split("/");
			characterName = ship[0];
			supportName = ship[1];
			if (characterName && supportName) {
				this.setShip(characterName, supportName);
			}
		}
	},
	syncShips : function() {
		var characterName, characterNode, inputNode, supportName;
		this.setNodeListProperty(document.querySelectorAll(".supportContainer input"), "disabled", false);
		for (characterName in this.characterNodeList) {
			characterNode = this.characterNodeList[characterName];
			supportName = this.shipList[characterName];
			this.setNodeListProperty(characterNode.querySelectorAll("input"), "checked", false);
			inputNode = characterNode.querySelector("input[value = '" + supportName + "']");
			if (inputNode) {
				inputNode.checked = true;
				if (supportName) {
					characterNode.setAttribute("data-partner", supportName);
					this.setNodeListProperty(document.querySelectorAll(".supportContainer input[value = \"" + characterName + "\"]"), "disabled", true);
				} else {
					characterNode.removeAttribute("data-partner");
				}
				/*
				supportName = inputNode.value;
				if (supportName) {
					this.setShip(characterName, supportName);
				}
				//*/
			}
			
		}
		
	},
	outputShips : function() {
		var shipCount, unshipCount, characterName, supportName, isShipped, shipNode, shipLink;
		shipCount = 0;
		unshipCount = 0;
		
		for (characterName in this.faceNodeList) {
			this.unshipContainerNode.appendChild(this.faceNodeList[characterName]);
		}
		
		while (this.shipContainerNode.hasChildNodes()) {
			this.shipContainerNode.removeChild(this.shipContainerNode.lastChild);
		}
		
		isShipped = {};
		shipLink = [];
		for (characterName in this.shipList) {
			supportName = this.shipList[characterName];
			unshipCount++;
			if (supportName) {
				if (!isShipped[characterName] && !isShipped[supportName]) {
					isShipped[characterName] = true;
					isShipped[supportName] = true;
					shipCount += 2;
					unshipCount -= 2;
					shipNode = document.createElement("div");
					shipNode.appendChild(this.faceNodeList[characterName]);
					shipNode.appendChild(this.faceNodeList[supportName]);
					this.shipContainerNode.appendChild(shipNode);
					
					shipLink.push(characterName + "/" + supportName);
					
					//this.shipContainerNode.innerHTML += "<li>"+characterName+"/"+supportName+"</li>";
				}
			}
		}
		shipLink = "#" + shipLink.join(";");
		window.location.hash = shipLink;
		this.shipLinkNode.value = window.location.href.split("#")[0] + shipLink;
		this.shipCountNode.textContent = shipCount;
		this.unshipCountNode.textContent = unshipCount;
	},
	setShip : function(characterName, supportName) {
		this.clearShip(characterName);
		this.clearShip(supportName);
		if (characterName && supportName) {
			this.shipList[characterName] = supportName;
			this.shipList[supportName] = characterName;
		}
	},
	clearShip : function(name) {
		if (this.shipList[name]) {
			this.shipList[this.shipList[name]] = "";
			this.shipList[name] = "";
		}
	},
	setNodeListProperty : function(nodeList, key, val) {
		for (var i = 0; i < nodeList.length; i++) {
			nodeList[i][key] = val;
		}
	}
};

addEventListener(
	"load",
	function(eve) {
		FireEmblem.init();
	},
	false
);