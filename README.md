# Site www.glads.fr

Site Hugo (gabarits propres dans `layouts/`, sans thème ; polices et icônes auto-hébergées dans `static/`, aucune ressource tierce), déployé sur GitHub Pages par `.github/workflows/` à chaque push sur `main` (le dossier `public/` n'est pas versionné).

## Section /veille/ (non référencée)

- Pages de travail publiées pour être lues depuis les notifications ntfy : résumés quotidiens (`/veille/resumes/AAAA-MM-JJ/`) et revues des projets (`/veille/projets/AAAA-MM-JJ-HHh/`). Sommaire : `/veille/`.
- Source : dépôt privé `glads-code/veille-techno`. Import : `scripts/sync-veille.sh <clone veille-techno>`, puis commit et push.
- Non référencées : `<meta name="robots" content="noindex, nofollow">` (layout `layouts/veille/single.html`), `sitemap.disable` dans chaque page, aucun lien depuis le menu ou le pied de page.
- Pas de `Disallow` dans robots.txt : il empêcherait Google de lire la balise noindex, et une URL bloquée mais découverte peut quand même être indexée.
- Ces pages sont publiques : n'y mettre aucun secret ni donnée personnelle.
