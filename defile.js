// DefileShorts : passe au Short suivant quand la vidéo arrive au bout.
// Les Shorts tournent en boucle (souvent sans événement « ended ») : on repère le retour au début
// juste après la fin, puis on avance (bouton « Vidéo suivante », sinon flèche bas, sinon défilement).
// Aucune requête réseau, aucune lecture de cookies ni de données de page.
// Diagnostic : passer DIAGNOSTIC à true, puis console de la page (F12), préfixe [DefileShorts].
(() => {
  const DIAGNOSTIC = false;
  const log = DIAGNOSTIC ? (...a) => console.log("[DefileShorts]", ...a) : () => {};
  let actif = true;
  chrome.storage.local.get({ actif: true }, (v) => { actif = v.actif; });
  chrome.storage.onChanged.addListener((ch) => { if (ch.actif) actif = ch.actif.newValue; });
  log("chargé");

  const etat = new WeakMap(); // vidéo -> { src, t }
  let bloqueJusqua = 0;

  const surShorts = () => location.pathname.startsWith("/shorts/");
  const visible = (el) => !!el && el.offsetParent !== null;

  function trouverBouton() {
    const selecteurs = [
      "#navigation-button-down button",
      "#navigation-button-down [role='button']",
      "ytd-shorts button[aria-label*='suivant' i]",
      "ytd-shorts button[aria-label*='next' i]"
    ];
    for (const s of selecteurs) {
      const b = [...document.querySelectorAll(s)].find(visible);
      if (b) return b;
    }
    return null;
  }

  function suivant(raison) {
    if (Date.now() < bloqueJusqua) return;
    bloqueJusqua = Date.now() + 2500; // évite de sauter deux Shorts d'un coup
    const depart = location.href;
    log("fin détectée (" + raison + ")");

    const b = trouverBouton();
    if (b) { log("clic sur le bouton suivant"); b.click(); }

    setTimeout(() => {
      if (location.href !== depart) return;
      log("le bouton n'a rien fait : flèche bas");
      for (const cible of [document.activeElement || document.body, document]) {
        cible.dispatchEvent(new KeyboardEvent("keydown", {
          key: "ArrowDown", code: "ArrowDown", keyCode: 40, which: 40, bubbles: true
        }));
      }
      setTimeout(() => {
        if (location.href !== depart) return;
        const c = document.querySelector("#shorts-inner-container");
        log(c ? "flèche bas sans effet : défilement du conteneur" : "aucun moyen trouvé pour avancer");
        if (c) c.scrollBy({ top: c.clientHeight, behavior: "smooth" });
      }, 800);
    }, 800);
  }

  document.addEventListener("timeupdate", (e) => {
    const v = e.target;
    if (!(v instanceof HTMLVideoElement) || !actif || !surShorts()) return;
    if (!(v.duration > 0) || v.paused) return;

    const t = v.currentTime;
    const avant = etat.get(v);
    etat.set(v, { src: v.currentSrc, t });
    if (!avant || avant.src !== v.currentSrc) return; // nouvelle vidéo : on repart à zéro

    // Bouclage : on était dans la dernière seconde et demie, et on est revenu au tout début.
    if (avant.t > v.duration - 1.5 && t < 1.5 && t < avant.t - 1) suivant("bouclage");
  }, true);

  document.addEventListener("ended", (e) => {
    if (e.target instanceof HTMLVideoElement && actif && surShorts()) suivant("ended");
  }, true);
})();
