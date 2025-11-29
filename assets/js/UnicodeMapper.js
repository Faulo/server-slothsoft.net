import Bootstrap from "/slothsoft@farah/js/Bootstrap";
import DOM from "/slothsoft@farah/js/DOM";
import { NS } from "/slothsoft@farah/js/XMLNamespaces";

const UNICODE_XML = "/slothsoft@slothsoft.net/static/unicode-mapper";

Bootstrap.run(async () => {
    const nodes = document.querySelectorAll(".UnicodeMapper");
    if (nodes.length) {
        const unicodeDocument = await DOM.loadDocumentAsync(UNICODE_XML);
        for (const node of nodes) {
            new UnicodeMapper(node, unicodeDocument);
        }
    }
});

export default class UnicodeMapper {
    fontList = {};
    outputNodes = {};

    constructor(containerNode, unicodeDocument) {
        if (!containerNode) {
            throw new Error("UnicodeMapper requires a container node.");
        }

        if (!unicodeDocument) {
            throw new Error("UnicodeMapper requires a unicode document.");
        }

        const fontNodeList = unicodeDocument.querySelectorAll("font");

        for (const fontNode of fontNodeList) {
            const fontName = fontNode.getAttribute("name");
            if (!fontName) {
                continue;
            }

            const font = {};
            const letterNodes = fontNode.querySelectorAll("letter");

            for (const letterNode of letterNodes) {
                const key = letterNode.getAttribute("source");
                const val = letterNode.getAttribute("target");
                if (key && val) {
                    font[key] = val;
                }
            }

            this.fontList[fontName] = font;
        }

        const document = containerNode.ownerDocument;
        const outputNode = containerNode.querySelector("fieldset");

        for (const fontName in this.fontList) {
            const labelNode = document.createElementNS(NS.HTML, "label");

            const spanNode = document.createElementNS(NS.HTML, "span");
            spanNode.appendChild(
                document.createTextNode(this.convertWord(`Output, ${fontName}`, fontName)),
            );
            labelNode.appendChild(spanNode);

            const textarea = document.createElementNS(NS.HTML, "textarea");
            textarea.setAttribute("class", "myParagraph");

            labelNode.appendChild(textarea);
            outputNode.appendChild(labelNode);

            this.outputNodes[fontName] = textarea;
        }

        const inputNode = containerNode.querySelector("textarea");
        inputNode.addEventListener(
            "input",
            eve => this.typeCharacter(eve.target),
            false
        );
        this.typeCharacter(inputNode);
    }

    typeCharacter(inputNode) {
        const inputText = inputNode.value ?? "";

        for (const fontType in this.fontList) {
            const outputText = this.convertWord(inputText, fontType);
            this.outputNodes[fontType].value = outputText;
        }
    }

    convertWord(inputText, fontType) {
        let outputText = "";

        for (let i = 0; i < inputText.length; i++) {
            let currentChar = inputText[i];

            const font = this.fontList[fontType];
            if (font && font[currentChar]) {
                currentChar = font[currentChar];
            }

            switch (fontType) {
                case "underlined-single":
                    currentChar += "̲";
                    break;
                case "underlined-double":
                    currentChar += "͇";
                    break;
                case "strikethrough-single":
                    currentChar += "̶";
                    break;
                case "crosshatch":
                    currentChar += "̷";
                    break;
            }

            outputText += currentChar;
        }

        return outputText;
    }
}
