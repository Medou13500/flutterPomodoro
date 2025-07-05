Authentification avec Supabase
Fonctionnement
J’ai utilisé Supabase pour gérer l’inscription et la connexion des utilisateurs.

L’utilisateur doit s’inscrire (email + mot de passe) pour accéder à l’application Pomodoro.

Une fois connecté, il est automatiquement redirigé vers le timer.

Formulaires créés
Formulaire d’inscription : crée un nouvel utilisateur dans Supabase.

Formulaire de connexion : vérifie les identifiants et connecte l’utilisateur.

Redirection
Si l’utilisateur est déjà connecté → il est directement redirigé vers l’écran Pomodoro sans repasser par la connexion.

Table session
À chaque connexion, une nouvelle ligne est ajoutée dans la table session :

user_id

type: "login"

duration: 0 (pour l’instant)

À savoir
J’ai désactivé la vérification d’email pour aller plus vite pendant le développement.

En production, on pourrait activer la confirmation par mail si besoin.
