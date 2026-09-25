# Site www.glads.fr

Site Hugo (gabarits propres dans `layouts/`, sans thème ; polices et icônes auto-hébergées dans `static/`, aucune ressource tierce), déployé sur GitHub Pages par `.github/workflows/` à chaque push sur `main` (le dossier `public/` n'est pas versionné).

## Section /veille/ (non référencée)

- Pages de travail publiées pour être lues depuis les notifications ntfy : résumés quotidiens (`/veille/resumes/AAAA-MM-JJ/`) et revues des projets (`/veille/projets/AAAA-MM-JJ-HHh/`). Sommaire : `/veille/`.
- Source : dépôt privé `glads-code/veille-techno`. Import : `scripts/sync-veille.sh <clone veille-techno>`, puis commit et push.
- Non référencées : `<meta name="robots" content="noindex, nofollow">` (layout `layouts/veille/single.html`), `sitemap.disable` dans chaque page, aucun lien depuis le menu ou le pied de page.
- Pas de `Disallow` dans robots.txt : il empêcherait Google de lire la balise noindex, et une URL bloquée mais découverte peut quand même être indexée.
- Ces pages sont publiques : n'y mettre aucun secret ni donnée personnelle.

## IndexNow (Bing, Yandex, Seznam, Naver)

- Après chaque déploiement, le job `indexnow` de `.github/workflows/hugo.yml` envoie les URL du sitemap (hors `/veille/`) à `api.indexnow.org`. Aucun compte n'est nécessaire.
- La clé est publique par conception (ce n'est pas un secret) : `static/<clé>.txt`, dont le contenu est la clé elle-même. Pour la changer, renommer ce fichier et mettre à jour `INDEXNOW_KEY` dans le workflow.
- Google n'utilise pas IndexNow.

## security.txt (RFC 9116)

- `static/.well-known/security.txt`, signé en clair avec la sous-clé [S] de contact@glads.fr.
- **Expire le 2027-09-25** : avant cette date, mettre à jour `Expires:` (un an au plus) et re-signer :
  `gpg --local-user '47396D7E43F4792C2CF89E2BE33DF3F3AAF30EA9!' --clearsign` sur le texte non signé.
- À re-signer aussi après tout changement de clé ou d'adresse de la clé publique.
