// Scripts du site, servis depuis glads.fr pour respecter la CSP (script-src 'self').
// Le site reste utilisable sans JavaScript : ces scripts ne font qu'agrémenter.

// Cartes de services : halo qui suit la souris (variables CSS --mouse-x / --mouse-y).
document.addEventListener('mousemove', (e) => {
    const card = e.target.closest('.service-card');
    if (!card) return;
    const rect = card.getBoundingClientRect();
    card.style.setProperty('--mouse-x', `${e.clientX - rect.left}px`);
    card.style.setProperty('--mouse-y', `${e.clientY - rect.top}px`);
});

document.addEventListener('click', async (e) => {
    // Menu mobile : se referme après le choix d'une rubrique.
    const menuLink = e.target.closest('.nav-menu a');
    if (menuLink) menuLink.closest('details').open = false;

    // Bouton « Copier l'adresse » (partial contact-actions.html).
    const btn = e.target.closest('[data-copy]');
    if (!btn) return;
    const label = btn.querySelector('span');
    try {
        await navigator.clipboard.writeText(btn.dataset.copy);
        label.textContent = 'Adresse copiée';
    } catch {
        label.textContent = 'Sélectionnez l\'adresse';
    }
    setTimeout(() => { label.textContent = 'Copier l\'adresse'; }, 2500);
});
