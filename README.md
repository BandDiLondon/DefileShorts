# DefileShorts

> **Fait avec une IA, en toute transparence.** Le code a été écrit par Claude (Anthropic), sous la direction de
> BandDiLondon, qui a défini le besoin, testé et validé chaque version.
>
> **Built with AI, openly.** The code was written by Claude (Anthropic), directed by BandDiLondon, who defined the
> need and tested and approved every version.

[Français](#français) · [English](#english)

## Français

Extension Chrome qui passe automatiquement au Short YouTube suivant quand la vidéo en cours se termine.

- Un interrupteur dans la barre d'outils pour activer ou couper le défilement.
- Agit seulement sur les pages Shorts de `youtube.com`.
- Continue même quand l'onglet est en arrière-plan.
- **Aucune donnée recueillie, aucune requête réseau, aucun cookie lu.** Deux petits fichiers :
  [defile.js](defile.js) et [arriere-plan.js](arriere-plan.js). Voir [PRIVACY.md](PRIVACY.md).

Le projet est né d'une mauvaise surprise : une extension de défilement de Shorts populaire a reçu une mise à jour
qui lisait l'activité du compte Google de ses utilisateurs et l'envoyait à des serveurs tiers. DefileShorts fait la
même chose utile, sans rien d'autre.

### Installer

- **Chrome Web Store** : lien à venir (examen en cours).
- **Release GitHub** : télécharger `DefileShorts-<version>-installation.zip` dans les [releases](https://github.com/BandDiLondon/DefileShorts/releases), l'extraire, puis suivre `INSTALLER.txt`.
- **Depuis le code** : `chrome://extensions` → activer **Mode développeur** → **Charger l'extension non empaquetée**
  → choisir ce dossier.

### Comment ça marche

Les Shorts tournent en boucle, souvent sans événement `ended`. Le script écoute `timeupdate` sur la vidéo et repère
le retour au début juste après la fin. Il clique alors sur le bouton « Vidéo suivante » de la page
(`#navigation-button-down`). Si rien ne bouge, il simule la flèche bas, puis fait défiler `#shorts-inner-container`.

Onglet en arrière-plan : Chrome suspend l'affichage, donc le défilement de la page ne marche plus.
[arriere-plan.js](arriere-plan.js), exécuté dans le contexte de la page (`world: MAIN`) et seulement sur les pages
Shorts quand l'interrupteur est activé :
- fait croire à YouTube que l'onglet est visible (`document.hidden`, `visibilityState`), pour que la lecture continue ;
- remplace `requestAnimationFrame`, suspendu par Chrome, par une minuterie ;
- à la fin du Short, lit l'identifiant du Short suivant dans les données de la page et ouvre
  `/shorts/<identifiant>`. La page se recharge, avec une courte pause entre les Shorts.

Diagnostic : mettre `DIAGNOSTIC = true` en haut de `defile.js`, recharger l'extension et l'onglet, puis F12 →
Console, filtre `DefileShorts`.

### Développement

- Icônes : `powershell -ExecutionPolicy Bypass -File outils\icone.ps1` (dégradé violet-rose, deux chevrons).
- Vignette du store : `outils\vignette.ps1` → `store\`.
- Paquet pour le store : `outils\paquet.ps1` → `dist\DefileShorts-<version>.zip` (chemins avec `/`, exigés par le
  store).
- Textes : `_locales/fr` (par défaut) et `_locales/en`. Fiche du store : [store/](store/).

## English

Chrome extension that automatically moves to the next YouTube Short when the current one ends.

- A toolbar switch to turn auto-scroll on or off.
- Acts only on `youtube.com` Shorts pages.
- Keeps going when the tab is in the background.
- **No data collected, no network requests, no cookies read.** Two small files: [defile.js](defile.js) and
  [arriere-plan.js](arriere-plan.js). See [PRIVACY.md](PRIVACY.md).

This project started after a bad surprise: a popular Shorts auto-scroll extension shipped an update that read its
users' Google account activity and sent it to third-party servers. DefileShorts does the same useful thing, and
nothing else.

### Install

- **Chrome Web Store**: link coming soon (review pending).
- **GitHub release**: download `DefileShorts-<version>-installation.zip` from [releases](https://github.com/BandDiLondon/DefileShorts/releases), extract it, then follow `INSTALLER.txt`.
- **From source**: `chrome://extensions` → enable **Developer mode** → **Load unpacked** → pick this folder.

### How it works

Shorts loop, often without an `ended` event. The script listens to `timeupdate` on the video and detects the jump
back to the start right after the end. It then clicks the page's own "Next video" button
(`#navigation-button-down`), falls back to a simulated Down arrow, then to scrolling `#shorts-inner-container`.

Background tab: Chrome suspends rendering, so page scrolling stops working. [arriere-plan.js](arriere-plan.js) runs
in the page context (`world: MAIN`), only on Shorts pages and only when the switch is on. It tells YouTube the tab
is visible so playback continues, replaces the suspended `requestAnimationFrame` with a timer, and when a Short ends
it reads the next Short's identifier from the page data and opens `/shorts/<id>` (the page reloads, with a short
pause between Shorts).

## Licence / License

GPL-3.0-or-later — voir / see [LICENSE](LICENSE).

DefileShorts est un projet indépendant, sans lien avec YouTube ni Google. / DefileShorts is an independent project,
not affiliated with YouTube or Google.
