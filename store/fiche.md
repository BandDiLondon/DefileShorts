# Fiche Chrome Web Store — textes à copier-coller

Paquet : `dist\DefileShorts-<version>.zip` (refaire avec `outils\paquet.ps1` après chaque changement, en montant
`version` dans `manifest.json`). Vignette : `store\vignette-440x280.png`. Icône 128 : `icons\icon128.png`.

## Onglet « Fiche Play Store » / « Store listing »

**Catégorie** : Productivité → Outils (ou Divertissement). **Langue** : français (ajouter l'anglais ensuite).

### Descriptions

Texte brut prêt à coller : [description-fr.txt](description-fr.txt) et [description-en.txt](description-en.txt).

### Images

- Captures d'écran : `capture-fr-1280x800.png` / `capture-en-1280x800.png` (`outils\captures.ps1`).
- Petite vignette promotionnelle : `store\vignette-440x280.png`.

## Onglet « Pratiques de confidentialité » / « Privacy practices »

**Objectif unique / Single purpose**

```
Automatically advance to the next YouTube Short when the current video finishes playing.
```

**Justification de `storage`**

```
Stores a single on/off setting (whether auto-scroll is enabled), locally in the browser.
```

**Justification de l'autorisation d'hôte (https://www.youtube.com/*)**

```
The content scripts must run on youtube.com to detect when a Short finishes and click the page's own "Next video" button. YouTube is a single-page app, so the scripts are matched on youtube.com and only act on /shorts/ pages. When the tab is in the background (Chrome suspends rendering, so scrolling no longer works), a page-context script keeps playback going by reporting the tab as visible, and opens the next Short's URL using the video ID found in the page. It makes no network requests of its own, and nothing is stored or sent.
```

**Code à distance / Remote code** : *Non, je n'utilise pas de code à distance.*

```
No. All JavaScript is included in the package; nothing is downloaded or evaluated at runtime.
```

**Utilisation des données / Data usage** : ne cocher **aucun** type de donnée. Cocher les trois attestations
(pas de vente, pas d'usage hors objectif, pas d'usage pour le crédit).

**Règles de confidentialité (URL)** : pas obligatoire si aucune donnée n'est recueillie. Si le formulaire l'exige,
mettre l'URL du README une fois le code publié sur GitHub.

## Onglet « Distribution »

- Visibilité : **Public** (ou **Non répertorié** pour un premier essai : seulement les gens qui ont le lien).
- Régions : toutes.
