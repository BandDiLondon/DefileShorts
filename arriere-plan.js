// DefileShorts — continuer quand l'onglet est en arrière-plan.
// Exécuté dans le contexte de la page (world MAIN) dès le chargement, seulement sur youtube.com.
// N'agit que sur les pages /shorts/ et seulement si l'interrupteur est activé
// (defile.js le signale par l'attribut data-defile-shorts sur <html>).
// 1. YouTube croit l'onglet visible : il ne met pas les Shorts en pause.
// 2. Onglet caché : Chrome ne déclenche plus requestAnimationFrame, dont YouTube a besoin pour passer au
//    Short suivant. On le remplace alors par une minuterie.
// 3. Onglet caché : lit dans la page l'identifiant du Short suivant et ouvre son adresse.
// Aucune requête réseau de notre part, rien n'est stocké ni envoyé.
(() => {
  const actif = () =>
    location.pathname.startsWith("/shorts/") &&
    document.documentElement.dataset.defileShorts !== "0";

  const proto = Document.prototype;
  const vraiHidden = Object.getOwnPropertyDescriptor(proto, "hidden").get;
  const vraiEtat = Object.getOwnPropertyDescriptor(proto, "visibilityState").get;
  const vraimentCache = () => vraiHidden.call(document);

  Object.defineProperty(proto, "hidden", {
    configurable: true,
    get() { return actif() ? false : vraiHidden.call(this); }
  });
  Object.defineProperty(proto, "visibilityState", {
    configurable: true,
    get() { return actif() ? "visible" : vraiEtat.call(this); }
  });
  const webkit = Object.getOwnPropertyDescriptor(proto, "webkitHidden");
  if (webkit && webkit.get) {
    Object.defineProperty(proto, "webkitHidden", {
      configurable: true,
      get() { return actif() ? false : webkit.get.call(this); }
    });
  }

  const bloquer = (e) => { if (actif()) e.stopImmediatePropagation(); };
  window.addEventListener("visibilitychange", bloquer, true);
  document.addEventListener("visibilitychange", bloquer, true);

  const vraiRAF = window.requestAnimationFrame.bind(window);
  const vraiCancel = window.cancelAnimationFrame.bind(window);
  const minuteries = new Map();
  let suivant = 1;

  window.requestAnimationFrame = function (rappel) {
    if (!(actif() && vraimentCache())) return vraiRAF(rappel);
    const id = -(suivant++); // négatif : pas de collision avec les identifiants de Chrome
    minuteries.set(id, setTimeout(() => {
      minuteries.delete(id);
      rappel(performance.now());
    }, 16));
    return id;
  };
  window.cancelAnimationFrame = function (id) {
    if (minuteries.has(id)) {
      clearTimeout(minuteries.get(id));
      minuteries.delete(id);
    } else {
      vraiCancel(id);
    }
  };

  // 3. Onglet caché : Chrome ne fait plus défiler la page et YouTube ne voit pas le changement de Short.
  //    defile.js envoie alors « defileshorts-suivant » : on cherche l'identifiant du Short suivant dans les
  //    données de la page, puis on ouvre directement son adresse.
  const log = (...a) => {
    if (document.documentElement.dataset.defileDiag === "1") console.log("[DefileShorts/page]", ...a);
  };
  const ID = /^[A-Za-z0-9_-]{11}$/;

  // Parcourt un objet et renvoie les videoId rencontrés, dans l'ordre, sans doublon.
  function idsDans(racine, limite) {
    const vus = new WeakSet();
    const ids = [];
    const pile = [racine];
    let n = 0;
    while (pile.length && n++ < limite) {
      const o = pile.pop();
      if (!o || typeof o !== "object" || vus.has(o) || o instanceof Node) continue;
      vus.add(o);
      if (typeof o.videoId === "string" && ID.test(o.videoId) && !ids.includes(o.videoId)) ids.push(o.videoId);
      const cles = Object.keys(o);
      for (let i = cles.length - 1; i >= 0; i--) {
        const v = o[cles[i]];
        if (v && typeof v === "object") pile.push(v);
      }
    }
    return ids;
  }
  // Les données d'un élément YouTube, selon la version de la page.
  function donnees(el) {
    if (!el) return [];
    const pc = el.polymerController;
    return [el.data, el.__data, pc && pc.data, pc && pc.__data, el.inst && el.inst.data].filter(Boolean);
  }
  const idsElement = (el, limite) => {
    const ids = [];
    for (const d of donnees(el)) for (const id of idsDans(d, limite)) if (!ids.includes(id)) ids.push(id);
    return ids;
  };
  // Identifiants vus dans les miniatures (i.ytimg.com/vi/<id>/...) d'un bout de page.
  const idsMiniatures = (el) =>
    el ? [...new Set([...el.outerHTML.matchAll(/\/vi(?:_webp)?\/([A-Za-z0-9_-]{11})\//g)].map((m) => m[1]))] : [];
  const apres = (liste, actuel) => {
    const i = liste.indexOf(actuel);
    return i >= 0 && i + 1 < liste.length ? liste[i + 1] : null;
  };

  function lecteurActif() {
    return (
      document.querySelector("ytd-reel-video-renderer[is-active]") ||
      (document.querySelector("ytd-shorts video") || { closest: () => null }).closest("ytd-reel-video-renderer")
    );
  }

  function idSuivant() {
    const actuel = location.pathname.split("/")[2];
    const autre = (liste) => liste.find((x) => x !== actuel) || null;

    // a) Les lecteurs qui suivent le lecteur actif : données, puis miniatures
    const actifEl = lecteurActif();
    let el = actifEl && actifEl.nextElementSibling;
    for (let k = 0; el && k < 3; k++, el = el.nextElementSibling) {
      const id = autre(idsElement(el, 3000)) || autre(idsMiniatures(el));
      if (id) return ["lecteur suivant", id];
    }
    // b) La liste des Shorts chargés par la page
    let id = apres(idsElement(document.querySelector("ytd-shorts"), 60000), actuel);
    if (id) return ["liste ytd-shorts", id];
    for (const nom of ["ytInitialReelWatchSequenceResponse", "ytInitialData"]) {
      id = apres(idsDans(window[nom], 60000), actuel);
      if (id) return [nom, id];
    }
    // c) Dernier recours : n'importe quel autre Short lié dans la page
    const lien = [...document.querySelectorAll("a[href*='/shorts/']")]
      .map((a) => (a.getAttribute("href").match(/\/shorts\/([A-Za-z0-9_-]{11})/) || [])[1])
      .find((x) => x && x !== actuel);
    if (lien) return ["lien dans la page", lien];
    return [null, null];
  }

  function resume() {
    const lecteurs = [...document.querySelectorAll("ytd-reel-video-renderer")];
    const actifEl = lecteurActif();
    const s = document.querySelector("ytd-shorts");
    return {
      actuel: location.pathname,
      lecteurs: lecteurs.length,
      indexActif: lecteurs.indexOf(actifEl),
      attributsActif: actifEl ? [...actifEl.attributes].map((a) => a.name).join(" ") : "aucun",
      clesSuivant: actifEl && actifEl.nextElementSibling
        ? ["data", "__data", "polymerController", "inst"].filter((k) => actifEl.nextElementSibling[k]).join(" ") +
          " | balise " + actifEl.nextElementSibling.tagName
        : "pas de suivant",
      clesYtdShorts: s ? ["data", "__data", "polymerController", "inst"].filter((k) => s[k]).join(" ") : "absent",
      idsYtdShorts: idsElement(s, 60000).length,
      miniatures: idsMiniatures(document.querySelector("#shorts-inner-container")).length,
      liensShorts: document.querySelectorAll("a[href*='/shorts/']").length
    };
  }

  document.addEventListener("defileshorts-suivant", () => {
    if (!actif()) return;
    const [source, id] = idSuivant();
    log("onglet caché, Short suivant :", id, "(" + source + ")");
    if (id) location.assign("/shorts/" + id);
    else log("introuvable, ce que la page contient :", JSON.stringify(resume()));
  });
})();
