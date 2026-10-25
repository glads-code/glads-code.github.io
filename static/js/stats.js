// Mesure d'audience Matomo (stats.glads-code.fr, serveur de GLADS en France),
// réglée pour être exemptée de consentement (CNIL) : aucun cookie, adresse IP
// tronquée de 2 octets par le serveur, pas de suivi entre sites. Le visiteur
// peut s'y opposer depuis les mentions légales : le choix est gardé dans
// localStorage (clé matomo-optout) et le traceur n'est alors pas chargé.
(function () {
    var CLE = 'matomo-optout';
    function oppose() {
        try { return localStorage.getItem(CLE) === '1'; } catch (e) { return false; }
    }

    // Bouton d'opposition (page mentions légales)
    document.addEventListener('DOMContentLoaded', function () {
        var bouton = document.getElementById('matomo-optout');
        var etat = document.getElementById('matomo-optout-etat');
        if (!bouton || !etat) return;
        function affiche() {
            var o = oppose();
            etat.textContent = o
                ? 'Vos visites ne sont pas mesurées.'
                : 'Vos visites sont mesurées de façon anonyme.';
            bouton.textContent = o ? 'Accepter la mesure d\'audience' : 'Refuser la mesure d\'audience';
        }
        bouton.addEventListener('click', function () {
            try {
                if (oppose()) localStorage.removeItem(CLE); else localStorage.setItem(CLE, '1');
            } catch (e) {}
            affiche();
        });
        bouton.hidden = false;
        affiche();
    });

    if (oppose()) return;
    var _paq = window._paq = window._paq || [];
    _paq.push(['disableCookies']);
    _paq.push(['setDoNotTrack', true]);
    _paq.push(['trackPageView']);
    _paq.push(['enableLinkTracking']);
    var u = 'https://stats.glads-code.fr/';
    _paq.push(['setTrackerUrl', u + 'matomo.php']);
    _paq.push(['setSiteId', '1']);
    var s = document.createElement('script');
    s.async = true;
    s.src = u + 'matomo.js';
    document.head.appendChild(s);
})();
