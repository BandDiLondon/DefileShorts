# Fiche Chrome Web Store — textes à copier-coller

Paquet : `dist\DefileShorts-1.0.0.zip` (refaire avec `outils\paquet.ps1` après chaque changement, en montant
`version` dans `manifest.json`). Vignette : `store\vignette-440x280.png`. Icône 128 : `icons\icon128.png`.

## Onglet « Fiche Play Store » / « Store listing »

**Catégorie** : Productivité → Outils (ou Divertissement). **Langue** : français (ajouter l'anglais ensuite).

### Description (français)

```
DefileShorts passe automatiquement au Short YouTube suivant quand la vidéo en cours se termine. Plus besoin de faire défiler à la main.

• Un interrupteur dans la barre d'outils pour activer ou couper le défilement.
• Fonctionne seulement sur les Shorts de youtube.com.
• Aucune donnée recueillie, aucune requête réseau, aucun cookie lu : tout se passe dans votre navigateur.
• Code court et lisible.

Transparence : cette extension a été codée avec Claude (Anthropic), une IA, sous la direction de BandDiLondon, qui a défini le besoin, testé et validé chaque version.

DefileShorts est un projet indépendant, sans lien avec YouTube ni Google.
```

### Description (English)

```
DefileShorts automatically moves to the next YouTube Short when the current one ends. No more manual scrolling.

• A toolbar switch to turn auto-scroll on or off.
• Works only on youtube.com Shorts.
• No data collected, no network requests, no cookies read: everything stays in your browser.
• Short, readable code.

Transparency: this extension was coded with Claude (Anthropic), an AI, under the direction of BandDiLondon, who defined the need and tested and approved every version.

DefileShorts is an independent project, not affiliated with YouTube or Google.
```

### Images

- Captures d'écran : au moins une, **1280 × 800** (ou 640 × 400). Prendre YouTube Shorts en plein écran avec le
  menu de l'extension ouvert, puis recadrer.
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
The content script must run on youtube.com to detect when a Short finishes and click the page's own "Next video" button. YouTube is a single-page app, so the script is matched on youtube.com and only acts on /shorts/ pages. It makes no network requests and reads no page data.
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
