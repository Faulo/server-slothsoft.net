// © 2012 Daniel Schulz

var MelnicsTranslator = {
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
    init: function() {
        if (!this.initialized) {
            var req = new XMLHttpRequest();
            req.open("GET", "/slothsoft@slothsoft.net/talesof/static/Melnics", false);
            req.send();
            this.dataDoc = req.responseXML;

            this.rootNode = document.getElementsByClassName("Translator")[0];
            for (var i in this.formNodes) {
                this.formNodes[i] = this.rootNode.getElementsByClassName(i)[0];
            }
            //alert(this.formNodes["input-english"]);
            this.initialized = true;
        }
    },
    typeCharacter: function(inputNode) {
        if (!this.typingCharacter) {
            var match, input, output, regex, key, found, searchType, found;
            this.init();
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
            //input = input.split("\n").join(" ").split("\r").join(" ");
            //alert(input);
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
            //alert(output);
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

        var kana = XPath.evaluate(query, this.dataDoc);
        if (kana === "") {
            return false;
        }

        return kana;
    },
};

addEventListener(
    "load",
    function(eve) {
        MelnicsTranslator.init();

    },
    false
);