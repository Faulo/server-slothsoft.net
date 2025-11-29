import Bootstrap from "/slothsoft@farah/js/Bootstrap";
import DOM from "/slothsoft@farah/js/DOM";
import XSLT from "/slothsoft@farah/js/XSLT";

function bootstrap() {
    const dataNode = document.querySelector('template[*|base = "farah://slothsoft@slothsoft.net/talesof/static/CraymelEditor"]');
    const templateNode = document.querySelector('template[*|base = "farah://slothsoft@slothsoft.net/talesof/xsl/CraymelEditor"]');
    if (dataNode && templateNode) {
        const nodes = document.querySelectorAll(".CraymelEditor");
        for (const node of nodes) {
            new CraymelEditor(node, dataNode.content.firstElementChild, templateNode.content.firstElementChild);
        }
    }
}

export default class CraymelEditor {
    static TEMPLATE_URL = "farah://slothsoft@slothsoft.net/talesof/xsl/CraymelEditor";
    static DATA_URL = "farah://slothsoft@slothsoft.net/talesof/static/CraymelEditor";

    static events = {
        dragmousedown(_) {
            if (!this._ce) {
                return;
            }

            this.setAttribute("data-status", "inuse");
        },
        dragmouseup(_) {
            if (!this._ce) {
                return;
            }

            this.removeAttribute("data-status");
        },
        dragstart(eve) {
            if (!this._ce) {
                return;
            }

            eve.dataTransfer.setData("text", this.getAttribute("data-craymel"));
            this._ce.drawParent.setAttribute("data-status", "");
        },
        dragend(_) {
            if (!this._ce) {
                return;
            }

            this._ce.drawParent.removeAttribute("data-status");
        },
        dragover(eve) {
            if (!this._ce) {
                return;
            }

            eve.preventDefault();
        },
        drop(eve) {
            if (!this._ce) {
                return;
            }

            eve.preventDefault();

            this._ce.drawParent.setAttribute("data-status", "busy");
            try {
                const craymelName = eve.dataTransfer.getData("text");
                const mageNo = this.getAttribute("data-cage");
                this._ce.setCraymel(craymelName, mageNo);
            } catch (e) {
                console.error(e);
            }
            this._ce.drawParent.removeAttribute("data-status");
        },
    };

    drawParent = undefined;
    drawNode = undefined;
    isDrawing = false;
    dataDoc = undefined;
    templateDoc = undefined;
    craymels = {};
    mages = [];

    constructor(host, dataDoc, templateDoc) {
        if (!host) {
            throw new Error("CraymelEditor: missing root node");
        }
        if (!dataDoc) {
            throw new Error("CraymelEditor: missing data node");
        }
        if (!templateDoc) {
            throw new Error("CraymelEditor: missing template node");
        }

        this.drawParent = host.parentNode;
        this.drawParent.setAttribute("data-status", "busy");

        try {
            this.templateDoc = templateDoc;
            this.dataDoc = dataDoc;

            // collect mages
            this.mages = [
                ...this.dataDoc.querySelectorAll("craymels"),
                ...this.dataDoc.querySelectorAll("mage"),
            ];

            // index craymels
            this.craymels = {};
            for (const node of this.dataDoc.querySelectorAll("craymel")) {
                node.mage = 0;
                this.craymels[node.getAttribute("name")] = node;
            }

            this.draw();
        } catch (err) {
            console.error(err);
            this.drawParent.setAttribute("data-status", "error");
            this.drawParent.dataset.error = String(err);
        } finally {
            this.drawParent.removeAttribute("data-status");
        }
    }

    async draw() {
        if (this.isDrawing) {
            return;
        }

        this.isDrawing = true;
        try {
            const oldTables = this.drawParent.querySelectorAll("table");

            const frag = await XSLT.transformToFragmentAsync(
                this.dataDoc,
                this.templateDoc,
                this.drawParent.ownerDocument
            );
            this.drawNode = frag.firstChild;

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
                node.addEventListener("dragstart", CraymelEditor.events.dragstart, false);
                node.addEventListener("dragend", CraymelEditor.events.dragend, false);
                node.addEventListener("touchstart", CraymelEditor.events.dragmousedown, { passive: true });
                node.addEventListener("touchend", CraymelEditor.events.dragmouseup, { passive: true });
            }

            // drop targets
            nodeList = DOM.evaluate(".//*[@data-cage]", this.drawParent);
            for (let i = 0; i < nodeList.length; i++) {
                const node = nodeList[i];
                node._ce = this;
                node.setAttribute("data-status", "clear");
                node.addEventListener("dragover", CraymelEditor.events.dragover, false);
                node.addEventListener("drop", CraymelEditor.events.drop, false);
            }
        } finally {
            this.isDrawing = false;
        }
    }

    tradeCraymel(ele) {
        const craymelName = ele.getAttribute("data-craymel");
        const craymel = this.craymels[craymelName];
        let mageNo = craymel.mage;
        mageNo = (mageNo === 2) ? 0 : mageNo + 1;
        craymel.mage = mageNo;
        this.mages[mageNo].appendChild(craymel);
        void this.draw();
    }

    setCraymel(craymelName, mageNo) {
        if (this.craymels[craymelName] && this.mages[mageNo]) {
            const craymel = this.craymels[craymelName];
            this.mages[mageNo].appendChild(craymel);
            void this.draw();
        }
    }
}

Bootstrap.run(bootstrap);