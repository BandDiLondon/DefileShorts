# DefileShorts — Règles de confidentialité / Privacy policy

*Dernière mise à jour / Last updated: 2026-11-03 (version 1.1.0)*

## Français

DefileShorts ne recueille, ne stocke à distance, ne vend et ne transmet **aucune donnée**.

- L'extension n'envoie **aucune requête réseau** : elle ne contacte aucun serveur, ni le nôtre ni celui d'un tiers.
- Elle ne lit ni cookies, ni historique, ni identifiants de connexion.
- Elle s'exécute seulement sur `youtube.com`, et n'agit que sur les pages Shorts : elle repère la fin de la vidéo
  et clique sur le bouton « Vidéo suivante » de la page.
- Quand l'onglet est en arrière-plan, elle lit dans la page **seulement l'identifiant du Short suivant** pour ouvrir
  son adresse (`youtube.com/shorts/<identifiant>`). Cet identifiant n'est ni conservé ni envoyé.
- Sur les pages Shorts, elle indique à YouTube que l'onglet est visible, pour que la lecture continue en arrière-plan.
- Le seul réglage enregistré est l'interrupteur marche/arrêt, gardé **localement** dans votre navigateur
  (`chrome.storage.local`). Il est effacé quand vous désinstallez l'extension.

Questions : par la page de l'extension sur le Chrome Web Store, ou une issue sur
https://github.com/BandDiLondon/DefileShorts.

## English

DefileShorts collects, remotely stores, sells and transmits **no data at all**.

- The extension makes **no network requests**: it contacts no server, neither ours nor any third party's.
- It reads no cookies, history or login credentials.
- It runs only on `youtube.com` and only acts on Shorts pages: it detects when the video ends and clicks the page's
  own "Next video" button.
- When the tab is in the background, it reads **only the next Short's identifier** from the page to open its address
  (`youtube.com/shorts/<id>`). That identifier is neither kept nor sent anywhere.
- On Shorts pages, it tells YouTube the tab is visible, so playback continues in the background.
- The only stored setting is the on/off switch, kept **locally** in your browser (`chrome.storage.local`). It is
  removed when you uninstall the extension.

Questions: through the extension's Chrome Web Store page, or an issue at https://github.com/BandDiLondon/DefileShorts.
