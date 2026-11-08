function initializeEditor() {
    const form = document.getElementById('ff-editor');
    const file = form?.querySelector('input[name="ff-save"]');
    if (!file) {
        return;
    }
    const commands = form.querySelectorAll('button[name="ff-action"]');
    const updateCasts = () => {
        for (const character of form.querySelectorAll('[data-character]')) {
            const list = character.querySelector('[data-casts]');
            const spells = new Map();
            for (const select of character.querySelectorAll('select')) {
                const option = select.selectedOptions[0];
                if (option?.dataset.spell) {
                    spells.set(Number(option.dataset.spell), option.dataset);
                }
            }
            list.replaceChildren();
            for (const [, spell] of [...spells].sort(([a], [b]) => a - b)) {
                const item = document.createElementNS(list.namespaceURI, 'li');
                const link = document.createElementNS(list.namespaceURI, 'a');
                link.setAttribute('href', spell.spellUrl);
                link.textContent = spell.spellName;
                item.append(link);
                list.append(item);
            }
            if (!spells.size) {
                const item = document.createElementNS(list.namespaceURI, 'li');
                item.textContent = '-';
                list.append(item);
            }
        }
    };
    const updateCommands = () => {
        const uploading = file.files.length > 0;
        for (const command of commands) {
            command.disabled = command.value === 'upload' ? !uploading : uploading;
        }
    };
    file.addEventListener('input', updateCommands);
    file.addEventListener('change', updateCommands);
    form.addEventListener('change', event => {
        if (event.target.localName === 'select') {
            updateCasts();
        }
    });
    const update = () => {
        updateCommands();
        updateCasts();
    };
    form.addEventListener('reset', () => setTimeout(update, 0));
    window.addEventListener('pageshow', update);
    update();
}

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initializeEditor, {once: true});
} else {
    initializeEditor();
}
