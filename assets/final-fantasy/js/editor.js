function initializeEditor() {
    const form = document.getElementById('ff-editor');
    const file = form?.querySelector('input[name="ff-save"]');
    if (!file) {
        return;
    }
    const commands = form.querySelectorAll('button[name="ff-action"]');
    const stats = form.querySelectorAll('[data-stats]');
    const previewError = document.getElementById('ff-preview-error');
    const errorPanel = document.getElementById('ff-errors');
    const updateErrorPanel = () => {
        errorPanel.hidden = ![...errorPanel.children].some(node => !node.hidden);
    };
    let previewTimer;
    let previewController;
    let previewVersion = 0;
    const cancelPreview = () => {
        clearTimeout(previewTimer);
        previewController?.abort();
        return ++previewVersion;
    };
    const readPreview = async response => {
        if (!response.ok) {
            throw new Error('Could not update stats. Try changing equipment again.');
        }
        const document = new DOMParser().parseFromString(await response.text(), 'application/xml');
        const namespace = 'http://schema.slothsoft.net/final-fantasy/i';
        const error = document.getElementsByTagNameNS(namespace, 'error')[0];
        if (error) {
            throw new Error(error.textContent);
        }
        const characters = [...document.getElementsByTagNameNS(namespace, 'character')];
        if (characters.length !== stats.length) {
            throw new Error('Could not update stats. Try changing equipment again.');
        }
        const values = [];
        for (const character of characters) {
            const source = character.getElementsByTagNameNS(namespace, 'stats')[0];
            const index = character.getAttribute('index');
            const target = [...form.querySelectorAll('[data-character]')].find(node => node.dataset.character === index);
            if (!source || !target) {
                throw new Error('Could not update stats. Try changing equipment again.');
            }
            for (const node of target.querySelectorAll('[data-stat]')) {
                const value = source.getAttribute(node.dataset.stat);
                if (!/^\d{1,3}$/.test(value)) {
                    throw new Error('Could not update stats. Try changing equipment again.');
                }
                values.push([node, value]);
            }
        }
        return values;
    };
    const updateStats = () => {
        const version = cancelPreview();
        if (!stats.length) {
            return;
        }
        stats.forEach(node => node.setAttribute('aria-busy', 'true'));
        previewError.hidden = true;
        updateErrorPanel();
        previewTimer = setTimeout(async () => {
            previewController = new AbortController();
            const body = new FormData(form);
            body.delete('ff-save');
            body.set('ff-action', 'preview');
            try {
                const response = await fetch(form.dataset.previewUrl, {
                    method: 'POST', body, signal: previewController.signal, cache: 'no-store'
                });
                const values = await readPreview(response);
                if (version !== previewVersion) {
                    return;
                }
                values.forEach(([node, value]) => node.textContent = value);
            } catch (error) {
                if (version !== previewVersion) {
                    return;
                }
                form.querySelectorAll('[data-stat]').forEach(node => node.textContent = '-');
                previewError.textContent = error.message;
                previewError.hidden = false;
                updateErrorPanel();
            } finally {
                if (version === previewVersion) {
                    stats.forEach(node => node.setAttribute('aria-busy', 'false'));
                }
            }
        }, 150);
    };
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
        if (event.target.localName === 'select' || event.target.matches('.ff-equipped')) {
            updateStats();
        }
    });
    const update = () => {
        updateCommands();
        updateCasts();
        updateStats();
    };
    form.addEventListener('reset', () => setTimeout(update, 0));
    window.addEventListener('pageshow', update);
    form.addEventListener('submit', cancelPreview);
    update();
}

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initializeEditor, {once: true});
} else {
    initializeEditor();
}
