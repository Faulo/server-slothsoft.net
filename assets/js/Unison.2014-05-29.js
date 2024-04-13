function Unison() {
}

//static
Unison.hostURI = "/getData.php/slothsoft/archive.host?dnt&media-id=";
Unison.guestURI = "/getData.php/slothsoft/archive.guest?dnt&media-id=";
Unison.videoURI = "?dnt&download=";
Unison.trackURI = "?dnt&subtitles=";
Unison.load = function(eve) {
	var arr, unison;
	arr = XPath.evaluate(".//*[@data-archive-unison]", document);
	while(arr.length) {
		unison = new Unison();
		unison.init(arr.pop());
	}
};
Unison.events = {
	sendStatus : function(eve) {
		this.ownerUnison.req = null;
	},
	forceStatus : function(eve) {
		switch (this.status) {
			case 200:
				this.ownerUnison.setStatus(JSON.parse(this.responseText));
				break;
			default:
				break;
		}
		this.ownerUnison.req = null;
	},
	pullStatus : function(eve) {
		switch (this.status) {
			case 204:
				this.ownerUnison.pullStatus();
				break;
			case 200:
				this.ownerUnison.setStatus(JSON.parse(this.responseText));
				this.ownerUnison.pullStatus();
				break;
			default:
				//alert(this.responseText);
				break;
		}
		this.ownerUnison.req = null;
	},
	hostPlay : function(eve) {
		this.ownerUnison.sendStatus();
	},
	guestPlay : function(eve) {
		this.ownerUnison.forceStatus();
	},
	hostPause : function(eve) {
		this.ownerUnison.sendStatus();
	},
	hostChange : function(eve) {
		this.ownerUnison.setMedia(this.ownerUnison.selectElement.value);
		this.ownerUnison.sendStatus();
	},
	guestChange : function(eve) {
		this.ownerUnison.setMedia(this.ownerUnison.selectElement.value);
	},
	hostFilter : function(eve) {
		this.ownerUnison.setFilter(this.ownerUnison.filterElement.value);
	},
	guestFilter : function(eve) {
		this.ownerUnison.setFilter(this.ownerUnison.filterElement.value);
	},
};

//instance
Unison.prototype.init = function(rootElement) {
	this.lastId = 0;
	this.req = null;
	this.rootElement = rootElement;
	this.mode = this.rootElement.getAttribute("data-archive-unison");
	this.id = this.rootElement.getAttribute("data-archive-id");
	this.mediaId = "";
	this.videoElement = this.rootElement.getElementsByTagName("video")[0];
	this.videoElement.ownerUnison = this;
	
	this.trackElement = this.rootElement.getElementsByTagName("track")[0];
	this.trackElement.ownerUnison = this;
	
	this.filterElement = this.rootElement.getElementsByTagName("select")[0];
	this.filterElement.ownerUnison = this;
	this.selectElement = this.rootElement.getElementsByTagName("select")[1];
	this.selectElement.ownerUnison = this;
	
	this.buttonElement = this.rootElement.getElementsByTagName("button")[0];
	this.buttonElement.ownerUnison = this;
	
	switch (this.mode) {
		case "host":
			this.initHost();
			break;
		case "guest":
			this.initGuest();
			break;
	}
};
Unison.prototype.initHost = function() {
	this.videoElement.addEventListener(
		"play",
		this.constructor.events.hostPlay,
		false
	);
	this.videoElement.addEventListener(
		"pause",
		this.constructor.events.hostPause,
		false
	);
	this.videoElement.addEventListener(
		"seeked",
		this.constructor.events.hostPause,
		false
	);
	this.buttonElement.addEventListener(
		"click",
		this.constructor.events.hostPlay,
		false
	);
	this.selectElement.addEventListener(
		"change",
		this.constructor.events.hostChange,
		false
	);
	this.filterElement.addEventListener(
		"change",
		this.constructor.events.hostFilter,
		false
	);
	this.setMedia(this.selectElement.value);
	this.sendStatus();
};
Unison.prototype.initGuest = function() {
	this.pullStatus();
	this.videoElement.addEventListener(
		"loadeddata",
		this.constructor.events.guestPlay,
		false
	);
	this.buttonElement.addEventListener(
		"click",
		this.constructor.events.guestPlay,
		false
	);
	this.selectElement.addEventListener(
		"change",
		this.constructor.events.guestChange,
		false
	);
	this.filterElement.addEventListener(
		"change",
		this.constructor.events.guestFilter,
		false
	);
};
Unison.prototype.setFilter = function(id) {
	var nodeList, node, i, j;
	nodeList = this.selectElement.getElementsByTagName("optgroup");
	for (i = 0; i < nodeList.length; i++) {
		node = nodeList[i];
		node.removeAttribute("disabled");
		if (id.length && node.getAttribute("data-archive-folder") !== id) {
			node.setAttribute("disabled", "disabled");
		}
	}
};
Unison.prototype.setMedia = function(id) {
	var ret = false;
	if (this.mediaId !== id) {
		this.mediaId = id;
		this.videoElement.src = Unison.videoURI + id;
		this.trackElement.src = Unison.trackURI + id;
		this.videoElement.load();
		if (this.mediaId) {
			this.setProgress(0);
			ret = true;
		}
	}
	if (this.mediaId !== this.selectElement.value) {
		this.selectElement.value = this.mediaId;
	}
	if (this.selectElement.options[this.selectElement.selectedIndex]) {
		document.title = this.selectElement.options[this.selectElement.selectedIndex].textContent;
	}
	return ret;
};
Unison.prototype.setProgress = function(time) {
	try {
		this.videoElement.currentTime = time;
	} catch(e) {
	}
	//this.videoElement.load();
};
Unison.prototype.setPlaying = function(isPlaying) {
	if (isPlaying && this.videoElement.paused) {
		this.videoElement.play();
	}
	if (!isPlaying && !this.videoElement.paused) {
		this.videoElement.pause();
	}
};
Unison.prototype.setStatus = function(status) {
	try {
		if (this.setMedia(status.media)) {
			//this.pullStatus();
		}
		if (this.videoElement.readyState) {
			this.lastId = status.id;
			this.setProgress(status.progress);
			this.setPlaying(status.playing);
		}
	} catch(e) {
	}
};
Unison.prototype.sendStatus = function() {
	var status = {};
	status.media = this.mediaId;
	status.playing = !this.videoElement.paused;
	status.progress = this.videoElement.currentTime;
	this.ajaxCall(
		this.constructor.hostURI,
		status,
		this.constructor.events.sendStatus
	);
};
Unison.prototype.pullStatus = function() {
	this.ajaxCall(
		this.constructor.guestURI,
		this.lastId,
		this.constructor.events.pullStatus
	);
};
Unison.prototype.forceStatus = function() {
	var req, queryURI, queryContent, callback;
	queryURI = this.constructor.guestURI;
	queryContent = 0;
	callback = this.constructor.events.forceStatus;
	
	req = new XMLHttpRequest();
	req.ownerUnison = this;
	req.open("POST", queryURI + this.id, true);
	req.setRequestHeader("Content-Type","application/json");
	req.addEventListener(
		"loadend",
		callback,
		false
	);
	req.send(JSON.stringify(queryContent));
};
Unison.prototype.ajaxCall = function(queryURI, queryContent, callback) {
	if (this.req) {
		try {
			this.req.abort();
		} catch(e) {
		}
	}
	this.req = new XMLHttpRequest();
	this.req.ownerUnison = this;
	this.req.open("POST", queryURI + this.id, true);
	this.req.setRequestHeader("Content-Type","application/json");
	this.req.addEventListener(
		"loadend",
		callback,
		false
	);
	this.req.send(JSON.stringify(queryContent));
};


addEventListener(
	"load",
	function(eve) {
		removeEventListener("load", arguments.callee, true);
		Unison.load();
	},
	false
);