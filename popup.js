document.documentElement.lang = chrome.i18n.getUILanguage();
document.getElementById("texte").textContent = chrome.i18n.getMessage("interrupteur");
document.getElementById("note").textContent = chrome.i18n.getMessage("note");

const caseActif = document.getElementById("actif");
chrome.storage.local.get({ actif: true }, (v) => { caseActif.checked = v.actif; });
caseActif.addEventListener("change", () => chrome.storage.local.set({ actif: caseActif.checked }));
