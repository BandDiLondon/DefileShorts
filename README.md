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
- **Aucune donnée recueillie, aucune requête réseau, aucun cookie lu.** Toute la logique tient dans
  [defile.js](defile.js), moins de 80 lignes. Voir [PRIVACY.md](PRIVACY.md).

Le projet est né d'une mauvaise surprise : une extension de défilement de Shorts populaire a reçu une mise à jour
qui lisait l'activité du compte Google de ses utilisateurs et l'envoyait à des serveurs tiers. DefileShorts fait la
même chose utile, sans rien d'autre.

### Installer

- **Chrome Web Store** : lien à venir.
- **Depuis le code** : `chrome://extensions` → activer **Mode développeur** → **Charger l'extension non empaquetée**
  → choisir ce dossier.

### Comment ça marche

Les Shorts tournent en boucle, souvent sans événement `ended`. Le script écoute `timeupdate` sur la vidéo et repère
le retour au début juste après la fin. Il clique alors sur le bouton « Vidéo suivante » de la page
(`#navigation-button-down`). Si rien ne bouge, il simule la flèche bas, puis fait défiler `#shorts-inner-container`.

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
- **No data collected, no network requests, no cookies read.** All the logic fits in [defile.js](defile.js), under 80
  lines. See [PRIVACY.md](PRIVACY.md).

This project started after a bad surprise: a popular Shorts auto-scroll extension shipped an update that read its
users' Google account activity and sent it to third-party servers. DefileShorts does the same useful thing, and
nothing else.

### Install

- **Chrome Web Store**: link coming soon.
- **From source**: `chrome://extensions` → enable **Developer mode** → **Load unpacked** → pick this folder.

### How it works

Shorts loop, often without an `ended` event. The script listens to `timeupdate` on the video and detects the jump
back to the start right after the end. It then clicks the page's own "Next video" button
(`#navigation-button-down`), falls back to a simulated Down arrow, then to scrolling `#shorts-inner-container`.

## Licence / License

GPL-3.0-or-later — voir / see [LICENSE](LICENSE).

DefileShorts est un projet indépendant, sans lien avec YouTube ni Google. / DefileShorts is an independent project,
not affiliated with YouTube or Google.
