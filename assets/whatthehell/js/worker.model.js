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

const REL_PATH = "../../";


const CLASSES = [
	"/slothsoft@whatthehell/js/Trait",
	"/slothsoft@whatthehell/js/Adventure.Model",
	"/slothsoft@whatthehell/js/Adventure.Model.Pull",
];

self.sendMessage = function(action, payload) {
	postMessage({
		action : action,
		payload : payload === undefined
			? null
			: payload
	});
};
self.parseMessage = function(action, payload) {
	switch (action) {
		case ACTION.MODEL_START:
			init(payload);
			break;
		case ACTION.MODEL_VIEW_LOAD:
			model.loadView(payload);
			break;
		case ACTION.MODEL_UPLOAD:
			model.mapUpload(payload);
			break;
		case ACTION.MODEL_PUSH:
			model.handlePush(payload.uri, payload.data);
			break;
		case ACTION.MODEL_DOWNLOAD:
			model.mapDownload(payload);
			break;
		case ACTION.MODEL_PULL_REGISTER:
			model.addPull(payload);
			break;
	}
	return false;
};
self.addEventListener(
	"message",
	function(eve) {
		parseMessage(eve.data.action, eve.data.payload);
	},
	false
);
self.init = function(config) {
	self.Adventure = {};
	importScripts.apply(this, CLASSES);
	model = new Adventure.Model();
	sendMessage(ACTION.VIEW_START, config);
};
self.model = undefined;