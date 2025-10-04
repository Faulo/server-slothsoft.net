var CraymelEditor = {
    drawParent: undefined,
    drawNode: undefined,
    dataDoc: undefined,
    templateDoc: undefined,
    craymels: {},
    mages: [],
    events: {
        dragmousedown(_) {
            this.setAttribute("data-status", "inuse");
        },
        dragmouseup(_) {
            this.removeAttribute("data-status");
        },
        dragstart(eve) {
            eve.dataTransfer.setData("text", this.getAttribute("data-craymel"));
            this._ce.drawParent.setAttribute("data-status", "");
        },
        dragend(_) {
            this._ce.drawParent.removeAttribute("data-status");
        },
        dragover(eve) {
            eve.preventDefault();
        },
        drop(eve) {
            eve.preventDefault();
            this._ce.drawParent.setAttribute("data-status", "busy");
            try {
                const craymelName = eve.dataTransfer.getData("text");
                const mageNo = this.getAttribute("data-cage");
                this._ce.setCraymel(craymelName, mageNo);
            } catch (e) {
                console.log(e);
            }
            this._ce.drawParent.removeAttribute("data-status");
        },
    },
    init: async function() {
        const host = document.querySelector(".CraymelEditor");
        if (!host) {
            throw new Error("CraymelEditor: no element with class .CraymelEditor found.");
        }
        this.drawParent = host.parentNode;

        this.drawParent.setAttribute("data-status", "busy");

        const TEMPLATE_URL = "farah://slothsoft@slothsoft.net/talesof/xsl/CraymelEditor";
        const DATA_URL = "farah://slothsoft@slothsoft.net/talesof/static/CraymelEditor";

        try {
            // Load both XMLs in parallel
            const [templateDoc, dataDoc] = await Promise.all([
                this.loadDocument(TEMPLATE_URL),
                this.loadDocument(DATA_URL)
            ]);
            this.templateDoc = templateDoc;
            this.dataDoc = dataDoc;

            // collect mages
            this.mages = [
                ...this.dataDoc.getElementsByTagName("craymels"),
                ...this.dataDoc.getElementsByTagName("mage"),
            ];

            // index craymels
            this.craymels = {};
            for (const node of this.dataDoc.getElementsByTagName("craymel")) {
                node.mage = 0;
                this.craymels[node.getAttribute("name")] = node;
            }

            this.draw();
        } catch (err) {
            console.error(err);
            // optional: surface error in UI
            this.drawParent.setAttribute("data-status", "error");
            this.drawParent.dataset.error = String(err);
        } finally {
            this.drawParent.removeAttribute("data-status");
        }
    },
    normalizeUrl: function(uri) {
        if (uri.startsWith("farah://")) {
            return "/" + uri.substring("farah://".length);
        }
        return uri;
    },
    loadDocument: async function(uri) {
        return new Promise((resolve, reject) => {
            const request = new XMLHttpRequest();
            request.open("GET", this.normalizeUrl(uri), true);
            request.addEventListener(
                "loadend",
                (eve) => {
                    const request = eve.target;
                    const document = request.responseXML;
                    if (document) {
                        document.fileURI = uri;
                        resolve(document);
                    } else {
                        reject("Error " + request.status + ":\n" + request.statusText);
                    }
                },
                false
            );
            request.send();
        });
    },
    transformToFragment: async function(dataNode, templateDoc, ownerDoc) {
        try {
            try {
                for (let node; node = XPath.evaluate("/xsl:stylesheet/xsl:import", templateDoc)[0];) {
                    const uri = node.getAttribute("href");
                    const tmpDoc = await this.loadDocument(uri);
                    const nodeList = XPath.evaluate("/xsl:stylesheet/*", tmpDoc);
                    for (let i = 0; i < nodeList.length; i++) {
                        templateDoc.documentElement.appendChild(templateDoc.importNode(nodeList[i], true));
                    }
                    templateDoc.documentElement.removeChild(node);
                }
            } catch (e) {
                console.log("XSLT Error: could not process xsl:import elements");
                console.log("Exception:%o", e);
            }

            const xslt = new XSLTProcessor();
            xslt.importStylesheet(templateDoc);

            const retFragment = xslt.transformToFragment(dataNode, ownerDoc);

            if (!retFragment) {
                throw new Error("XSLTProcessor.transformToFragment returned null!");
            }

            return retFragment;
        } catch (e) {
            console.log("An error occured while attempting to XSL transform. :|");
            console.log("Data node:%o", dataNode);
            console.log("Template document:%o", templateDoc);
            console.log("Owner document:%o", ownerDoc);
            console.log("Exception:%o", e);
            return ownerDoc.createDocumentFragment();
        }
    },
    transformToNode: async function(dataNode, templateDoc, ownerDoc) {
        return (await this.transformToFragment(dataNode, templateDoc, ownerDoc)).firstChild;
    },
    draw: async function() {
        const oldTables = this.drawParent.querySelectorAll("table");

        this.drawNode = await this.transformToNode(this.dataDoc, this.templateDoc, document);

        if (!this.drawNode) {
            return;
        }

        const newTables = this.drawNode.querySelectorAll("table");
        for (let i = 0; i < oldTables.length; i++) {
            oldTables[i].parentNode.replaceChild(newTables[i], oldTables[i]);
        }

        // draggable sources
        let nodeList = XPath.evaluate(".//*[@data-craymel]", this.drawParent);
        for (let i = 0; i < nodeList.length; i++) {
            const node = nodeList[i];
            node._ce = this;
            node.setAttribute("draggable", "true");
            node.addEventListener("dragstart", this.events.dragstart, false);
            node.addEventListener("dragend", this.events.dragend, false);
            node.addEventListener("touchstart", this.events.dragmousedown, { passive: true });
            node.addEventListener("touchend", this.events.dragmouseup, { passive: true });
        }

        // drop targets
        nodeList = XPath.evaluate(".//*[@data-cage]", this.drawParent);
        for (let i = 0; i < nodeList.length; i++) {
            const node = nodeList[i];
            node._ce = this;
            node.setAttribute("data-status", "clear");
            node.addEventListener("dragover", this.events.dragover, false);
            node.addEventListener("drop", this.events.drop, false);
        }
    },

    tradeCraymel: function(ele) {
        const craymelName = ele.getAttribute("data-craymel");
        const craymel = this.craymels[craymelName];
        let mageNo = craymel.mage;
        mageNo = (mageNo === 2) ? 0 : mageNo + 1;
        craymel.mage = mageNo;
        this.mages[mageNo].appendChild(craymel);
        this.draw();
    },

    setCraymel: function(craymelName, mageNo) {
        const craymel = this.craymels[craymelName];
        this.mages[mageNo].appendChild(craymel);
        this.draw();
    },
};

CraymelEditor.init();