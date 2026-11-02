#!/usr/bin/env python3
# Génère les icônes d'onglet et d'écran d'accueil à partir de static/img/logo.png.
# Le logo est blanc sur transparent (invisible sur un onglet clair) : il est posé
# sur un carré à la couleur de fond du site (--bg-dark).
# Usage : python3 scripts/favicons.py (nécessite Pillow)
from pathlib import Path
from PIL import Image, ImageDraw

racine = Path(__file__).resolve().parent.parent
fond = (7, 9, 14, 255)  # --bg-dark, layouts/partials/page-style.html
logo = Image.open(racine / "static/img/logo.png").convert("RGBA")
logo = logo.crop(logo.getchannel("A").getbbox())  # retire la marge transparente


def icone(cote, arrondi):
    img = Image.new("RGBA", (cote, cote), (0, 0, 0, 0))
    ImageDraw.Draw(img).rounded_rectangle((0, 0, cote - 1, cote - 1), radius=int(cote * arrondi), fill=fond)
    marge = int(cote * 0.12)
    l = logo.copy()
    l.thumbnail((cote - 2 * marge, cote - 2 * marge), Image.LANCZOS)
    img.alpha_composite(l, ((cote - l.width) // 2, (cote - l.height) // 2))
    return img


icone(256, 0.2).save(racine / "static/favicon.ico", sizes=[(16, 16), (32, 32), (48, 48)])
icone(512, 0.2).save(racine / "static/img/icon-512.png", optimize=True)
icone(180, 0).save(racine / "static/img/apple-touch-icon.png", optimize=True)  # iOS arrondit lui-même
