document.addEventListener('change', event => {
    const select = event.target;
    if (!(select instanceof HTMLSelectElement) || !select.matches('.final-fantasy .ff-item-picker select')) {
        return;
    }
    const icon = select.closest('.ff-item-picker').querySelector('.ff-selected-icon');
    const option = select.selectedOptions[0];
    const glyph = Number(option?.dataset.icon);
    const label = option?.dataset.iconLabel ?? '';
    icon.hidden = !Number.isInteger(glyph) || glyph < 212 || glyph > 225;
    icon.dataset.glyph = icon.hidden ? '' : String(glyph);
    icon.style.setProperty('--ff-icon-index', icon.hidden ? '0' : String(glyph - 212));
    icon.title = label;
    icon.setAttribute('aria-label', label);
});
