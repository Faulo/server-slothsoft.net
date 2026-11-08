function initializeEditor() {
    const form = document.getElementById('ff-editor');
    const file = form?.querySelector('input[name="ff-save"]');
    if (!file) {
        return;
    }
    const commands = form.querySelectorAll('button[name="ff-action"]');
    const updateCommands = () => {
        const uploading = file.files.length > 0;
        for (const command of commands) {
            command.disabled = command.value === 'upload' ? !uploading : uploading;
        }
    };
    file.addEventListener('input', updateCommands);
    file.addEventListener('change', updateCommands);
    form.addEventListener('reset', () => setTimeout(updateCommands, 0));
    window.addEventListener('pageshow', updateCommands);
    updateCommands();
}

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initializeEditor, {once: true});
} else {
    initializeEditor();
}
