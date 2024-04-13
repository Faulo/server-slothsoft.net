function Unison() {
}

//static
Unison.hostURI = "/getData.php/slothsoft/archive.host?dnt&media-id=";
Unison.guestURI = "/getData.php/slothsoft/archive.guest?dnt&media-id=";
Unison.sseURI = "/getData.php/sse/server.unison";
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
	hostPlay : function(eve) {
		this.ownerUnison.pushStatus();
	},
	guestPlay : function(eve) {
		this.ownerUnison.pullStatus();
	},
	hostPause : function(eve) {
		this.ownerUnison.pushStatus();
	},
	hostChange : function(eve) {
		this.ownerUnison.setMedia(this.ownerUnison.selectElement.value);
		this.ownerUnison.pushStatus();
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
	sseLog : function(eve) {
		//console.log("%o", eve);
	},
	sseStart : function(eve) {
		this.sseClient._unison.initSSE();
	},
	sseStatus : function(eve) {
		//console.log("%o", eve.data);
		this.sseClient._unison.setStatus(JSON.parse(eve.data));
	},
};

//instance
Unison.prototype.init = function(rootElement) {
	this.lastId = 0;
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
	
	this.sse = new SSE.Client(
		Unison.sseURI,
		this.id,
		Unison.events.sseLog
	);
	this.sse._unison = this;
	this.sse.addEventListener("start", Unison.events.sseStart);
};
Unison.prototype.initSSE = function() {
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
	this.pushStatus();
};
Unison.prototype.initGuest = function() {
	this.sse.addEventListener("status", Unison.events.sseStatus);
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
	this.pullStatus();
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
Unison.prototype.pushStatus = function() {
	var status = {};
	status.media = this.mediaId;
	status.playing = !this.videoElement.paused;
	status.progress = this.videoElement.currentTime;
	this.sse.dispatchEvent("status", status);
};
Unison.prototype.pullStatus = function() {
	this.sse.dispatchLastEvent();
	/*
	var req, queryURI, queryContent, callback;
	queryURI = this.constructor.guestURI;
	queryContent = 0;
	callback = this.constructor.events.pullStatus;
	
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
	//*/
};


addEventListener(
	"load",
	function(eve) {
		removeEventListener("load", arguments.callee, true);
		Unison.load();
	},
	false
);