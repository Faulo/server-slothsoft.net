import DOM from "/slothsoft@farah/js/DOM";
import XSLT from "/slothsoft@farah/js/XSLT";

export default class {
    constructor(host) {
        CraymelEditor.init(host);
    }
}

const CraymelEditor = {
    drawParent: undefined,
    drawNode: undefined,
    isDrawing: false,
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

    init: async function(host) {
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
                DOM.loadDocumentAsync(TEMPLATE_URL),
                DOM.loadDocumentAsync(DATA_URL)
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

            await this.draw();
        } catch (err) {
            console.error(err);
            // optional: surface error in UI
            this.drawParent.setAttribute("data-status", "error");
            this.drawParent.dataset.error = String(err);
        } finally {
            this.drawParent.removeAttribute("data-status");
        }
    },

    draw: async function() {
        if (this.isDrawing) {
            return;
        }

        this.isDrawing = true;

        const oldTables = this.drawParent.querySelectorAll("table");

        this.drawNode = (await XSLT.transformToFragmentAsync(this.dataDoc, this.templateDoc, this.drawParent.ownerDocument)).firstChild;

        if (!this.drawNode) {
            return;
        }

        const newTables = this.drawNode.querySelectorAll("table");
        for (let i = 0; i < oldTables.length; i++) {
            oldTables[i].parentNode.replaceChild(newTables[i], oldTables[i]);
        }

        // draggable sources
        let nodeList = DOM.evaluate(".//*[@data-craymel]", this.drawParent);
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
        nodeList = DOM.evaluate(".//*[@data-cage]", this.drawParent);
        for (let i = 0; i < nodeList.length; i++) {
            const node = nodeList[i];
            node._ce = this;
            node.setAttribute("data-status", "clear");
            node.addEventListener("dragover", this.events.dragover, false);
            node.addEventListener("drop", this.events.drop, false);
        }

        this.isDrawing = false;
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