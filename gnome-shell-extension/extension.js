const ind = "gmail-indicator";
const si = imports.ui.statusIconDispatcher;

function enable() {
    si.STANDARD_TRAY_ICON_IMPLEMENTATIONS[ind] = ind;
}

function disable() {
    delete si.STANDARD_TRAY_ICON_IMPLEMENTATIONS[ind];
}

function init() {
}
