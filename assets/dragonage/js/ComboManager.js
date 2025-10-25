
export default class {
    constructor(formNode, comboNode) {
        var i, nodeList, node, name, character;
        this.formNode = formNode;
        this.comboNode = comboNode;
        this.characterList = {};

        for (i = 0; i < this.formNode["character[]"].length; i++) {
            name = this.formNode["character[]"][i].value;
            this.characterList[name] = new ComboCharacter(this, name);
        }

        nodeList = this.formNode["disabler[]"];
        for (i = 0; i < nodeList.length; i++) {
            node = nodeList[i];
            node._ownerManager = this;
            name = node.getAttribute("data-character");
            if (character = this.getCharacterByName(name)) {
                character.addDisabler(node);
            }
        }
        nodeList = this.formNode["detonator[]"];
        for (i = 0; i < nodeList.length; i++) {
            node = nodeList[i];
            node._ownerManager = this;
            name = node.getAttribute("data-character");
            if (character = this.getCharacterByName(name)) {
                character.addDetonator(node);
            }
        }

        this.calcResult();
    }
    getCharacterByName(name) {
        return this.characterList[name];
    }
    calcResult() {
        var thisName, comboName, thisChar, comboChar;
        for (thisName in this.characterList) {
            thisChar = this.characterList[thisName];
            for (comboName in this.characterList) {
                comboChar = this.characterList[comboName];
                thisChar.calcResult(comboChar);
            }
        }
    }
}

class ComboCharacter {
    constructor(ownerManager, name) {
        this.ownerManager = ownerManager;
        this.name = name;
        this.disablerList = {};
        this.detonatorList = {};
    }
    addDisabler(node) {
        this.disablerList[node.value] = node;

        node._ownerCharacter = this;
        node.addEventListener(
            "change",
            function(eve) {
                this._ownerCharacter.calcStatus();
            },
            false
        );
        node.dispatchEvent(new Event("change"));
    }
    addDetonator(node) {
        this.detonatorList[node.value] = node;

        node._ownerCharacter = this;
        node.addEventListener(
            "change",
            function(eve) {
                this._ownerCharacter.calcBomb();
            },
            false
        );
        //node.dispatchEvent(new Event("change"));
    }
    setStatus(status, val) {
        var key = ["status", this.name, status].join("-");
        this.ownerManager.formNode[key].checked = !!val;
    }
    setBomb(status, val) {
        var key = ["bomb", this.name, status].join("-");
        this.ownerManager.formNode[key].checked = !!val;
    }
    setResult(comboChar, status, bomb, val) {
        var key, node;
        key = ["result", this.name, comboChar.name, status, bomb].join("-");
        val = !!val;
        //console.log("setting " + key + " to " + JSON.stringify(val));
        node = this.ownerManager.formNode[key].parentNode;
        if (val) {
            node.removeAttribute("hidden");
        } else {
            node.setAttribute("hidden", "hidden");
        }
    }
    getStatusList() {
        var key, node, status, val, ret;
        ret = {};
        for (key in this.disablerList) {
            node = this.disablerList[key];
            val = node.checked;
            status = node.getAttribute("data-status");
            ret[status] = (ret[status] || val);
        }
        return ret;
    }
    getBombList() {
        var key, node, bomb, val, ret;
        ret = {};
        for (key in this.detonatorList) {
            node = this.detonatorList[key];
            val = node.checked;
            bomb = node.getAttribute("data-bomb");
            ret[bomb] = (ret[bomb] || val);
        }
        return ret;
    }
    calcStatus() {
        var list, key;
        list = this.getStatusList();
        for (key in list) {
            this.setStatus(key, list[key]);
        }
        this.ownerManager.calcResult();
    }
    calcBomb() {
        var list, key;
        list = this.getBombList();
        for (key in list) {
            this.setBomb(key, list[key]);
        }
        this.ownerManager.calcResult();
    }
    calcResult(comboChar) {
        var statusList, status, bombList, bomb;

        statusList = comboChar.getStatusList();
        bombList = this.getBombList();

        for (status in statusList) {
            for (bomb in bombList) {
                this.setResult(comboChar, status, bomb, (statusList[status] && bombList[bomb]));
            }
        }
    }
}

