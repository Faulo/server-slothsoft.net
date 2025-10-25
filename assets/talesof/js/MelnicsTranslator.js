import DOM from "/slothsoft@farah/js/DOM";

export default class {
    constructor(rootNode) {
        MelnicsTranslator.init(rootNode);
    }

    typeCharacter(inputNode) {
        MelnicsTranslator.typeCharacter(inputNode);
    }
}

const MelnicsTranslator = {
    initialized: false,
    typingCharacter: false,
    dataDoc: undefined,
    rootNode: undefined,
    formNodes: {
        "input-english": undefined,
        "input-melnics": undefined,
        "output-english": undefined,
        "output-melnics": undefined,
    },
    init: async function(rootNode) {
        this.dataDoc = await DOM.loadDocumentAsync("/slothsoft@slothsoft.net/talesof/static/Melnics");
        this.rootNode = rootNode;
        for (var i in this.formNodes) {
            this.formNodes[i] = this.rootNode.querySelector("." + i);
        }
        this.initialized = true;
    },
    typeCharacter: function(inputNode) {
        if (!this.initialized) {
            return;
        }

        if (!this.typingCharacter) {
            var match, input, output, regex, key, found, searchType, found;
            this.typingCharacter = true;

            regex = {
                //neException : /^(ne)([\s\S]*)$/,
                eaException: /^(ea)([\s\S]*)$/,
                char3: /^(\w{3})([\s\S]*)$/,
                char2: /^(\w{2})([\s\S]*)$/,
                char1: /^(\w{1})([\s\S]*)$/,
                noprint: /^(')([\s\S]*)$/,
                nomatch: /^([\s\S])([\s\S]*)$/,
            };
            searchType = inputNode.getAttribute("data-translator-type");
            input = inputNode.value;
            input = input.toLowerCase();

            output = [];
            do {
                found = false;
                for (key in regex) {
                    if (match = regex[key].exec(input)) {
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
            output = output.join("");

            switch (searchType) {
                case "melnics":
                    this.formNodes["input-english"].value = output;
                    break;
                case "english":
                    this.formNodes["input-melnics"].value = output;
                    break;
            }

            this.formNodes["output-english"].value = this.formNodes["input-english"].value;
            this.typingCharacter = false;
        }
    },
    findChar: function(input, searchType) {
        var query;
        switch (searchType) {
            case "melnics":
                query = 'string(//melnics[@name = "' + input + '"][1]/../@name)';
                break;
            case "english":
                query = 'string(//english[@name = "' + input + '"][1]/melnics[1]/@name)';
                break;
            default:
                return false;
        }

        var kana = DOM.evaluate(query, this.dataDoc);
        if (kana === "") {
            return false;
        }

        return kana;
    },
};