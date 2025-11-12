export default class Translator {
    static {
        const dataNode = document.querySelector('template[data-url = "farah://slothsoft@slothsoft.net/talesof/static/Melnics"]');
        if (dataNode) {
            const rootNodes = document.querySelectorAll(".MelnicsTranslator");
            for (const rootNode of rootNodes) {
                new Translator(rootNode, dataNode.content);
            }
        }
    }

    rootNode = undefined;
    dataDoc = undefined;

    formNodes = {
        "input-melnics": undefined,
        "input-english": undefined,
        "output-melnics": undefined,
        "output-english": undefined,
    };

    static regex = {
        eaException: /^(ea)([\s\S]*)$/,
        char3: /^(\w{3})([\s\S]*)$/,
        char2: /^(\w{2})([\s\S]*)$/,
        char1: /^(\w{1})([\s\S]*)$/,
        noprint: /^(')([\s\S]*)$/,
        nomatch: /^([\s\S])([\s\S]*)$/,
    };

    constructor(rootNode, dataDoc) {
        this.dataDoc = dataDoc;
        this.rootNode = rootNode;

        for (var i in this.formNodes) {
            this.formNodes[i] = this.rootNode.querySelector("." + i);
            if (this.formNodes[i] instanceof HTMLTextAreaElement) {
                this.formNodes[i].disabled = false;
                this.formNodes[i].addEventListener(
                    "input",
                    eve => this.typeCharacter(eve.target),
                    false
                );

                if (this.formNodes[i].hasAttribute("autofocus")) {
                    this.formNodes[i].focus();
                }
            }
        }
        this.initialized = true;
    }

    typeCharacter(inputNode) {
        const searchType = inputNode.getAttribute("data-translator-type");
        const output = [];

        let input = inputNode.value.toLowerCase();
        let found;
        do {
            found = false;
            for (const key in Translator.regex) {
                const match = Translator.regex[key].exec(input);
                if (match) {
                    switch (key) {
                        case "neException":
                            if (searchType === "melnics") {
                                found = true;
                                match[1] = "ea";
                            }
                            break;
                        case "eaException":
                            if (searchType === "english") {
                                found = true;
                                match[1] = "n'e";
                            }
                            break;
                        case "noprint":
                            match[1] = "";
                        case "nomatch":
                            found = true;
                            break;
                        default:
                            match[1] = this.findChar(match[1], searchType);
                            if (match[1]) {
                                found = true;
                            }
                            break;
                    }
                    if (found) {
                        output.push(match[1]);
                        input = match[2];
                        break;
                    }
                }
            }
        } while (found);

        const outputText = output.join("");

        switch (searchType) {
            case "melnics":
                this.formNodes["input-english"].value = outputText;
                break;
            case "english":
                this.formNodes["input-melnics"].value = outputText;
                break;
        }

        this.formNodes["output-english"].value = this.formNodes["input-english"].value;
    }

    findChar(input, searchType) {
        switch (searchType) {
            case "melnics":
                const melnics = this.dataDoc.querySelector(`melnics[name = "${input}"]`);
                if (melnics) {
                    return melnics.parentNode.getAttribute("name");
                }
                break;
            case "english":
                const english = this.dataDoc.querySelector(`english[name = "${input}"]`);
                if (english) {
                    return english.firstElementChild.getAttribute("name");
                }
                break;
        }

        return false;
    }
}