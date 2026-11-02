#!/usr/bin/env python3
# Génère les icônes d'onglet et d'écran d'accueil à partir de static/img/logo.png.
# Seul le symbole du logo est gardé (le mot « GLADS » serait illisible en 16 px), en
# blanc sur un dégradé des couleurs d'accent du site. Ses traits sont épaissis pour
# rester nets aux petites tailles.
# Usage : python3 scripts/favicons.py (nécessite Pillow)
from pathlib import Path
from PIL import Image, ImageDraw, ImageFilter

racine = Path(__file__).resolve().parent.parent
# --accent-primary et --accent-secondary, layouts/partials/page-style.html
debut, fin = (59, 130, 246), (139, 92, 246)

alpha = Image.open(racine / "static/img/logo.png").convert("RGBA").getchannel("A")
alpha = alpha.crop(alpha.getbbox())
# Le symbole est séparé du mot par des lignes vides : on coupe à la première.
ligne_vide = next(y for y in range(alpha.height) if not alpha.crop((0, y, alpha.width, y + 1)).getbbox())
symbole = alpha.crop((0, 0, alpha.width, ligne_vide))


def degrade(cote):
    img = Image.new("RGBA", (cote, cote))
    px = img.load()
    for y in range(cote):
        for x in range(cote):
            t = (x + y) / (2 * (cote - 1))
            px[x, y] = tuple(round(a + (b - a) * t) for a, b in zip(debut, fin)) + (255,)
    return img


def icone(cote, arrondi):
    travail = 512  # dessin en grand puis réduction, pour un rendu lissé
    fond = degrade(travail)
    masque = Image.new("L", (travail, travail), 0)
    ImageDraw.Draw(masque).rounded_rectangle((0, 0, travail - 1, travail - 1), radius=int(travail * arrondi), fill=255)
    fond.putalpha(masque)

    marge = int(travail * 0.18)
    echelle = (travail - 2 * marge) / max(symbole.size)
    s = symbole.resize((round(symbole.width * echelle), round(symbole.height * echelle)), Image.LANCZOS)
    # Épaissit les traits : environ 0,7 px une fois réduit, quelle que soit la taille finale.
    rayon = max(1, round(travail / cote * 0.35))
    s = s.filter(ImageFilter.MaxFilter(2 * rayon + 1))
    blanc = Image.new("RGBA", s.size, (255, 255, 255, 255))
    blanc.putalpha(s)
    fond.alpha_composite(blanc, ((travail - s.width) // 2, (travail - s.height) // 2))
    return fond.resize((cote, cote), Image.LANCZOS)


ico = [icone(c, 0.22) for c in (48, 32, 16)]
ico[0].save(racine / "static/favicon.ico", sizes=[i.size for i in ico], append_images=ico[1:])
icone(512, 0.22).save(racine / "static/img/icon-512.png", optimize=True)
icone(180, 0).save(racine / "static/img/apple-touch-icon.png", optimize=True)  # iOS arrondit lui-même
