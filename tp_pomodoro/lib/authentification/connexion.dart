import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../timer/timer.dart';
import 'inscription.dart';

class ConnexionScreen extends StatefulWidget {
  const ConnexionScreen({super.key});

  @override
  State<ConnexionScreen> createState() => _ConnexionScreenState();
}

class _ConnexionScreenState extends State<ConnexionScreen> {
  // ─────────────────────────────────────────────────────
  // CONFIG
  // ─────────────────────────────────────────────────────
  /// Passe à `true` si tu veux accepter la connexion même si
  /// l’e-mail n’a pas encore été confirmé.
  static const bool skipEmailConfirmation = false;

  // ─────────────────────────────────────────────────────
  // CONTRÔLEURS & SUPABASE
  // ─────────────────────────────────────────────────────
  final _formKey = GlobalKey<FormState>();
  final _email     = TextEditingController();
  final _password  = TextEditingController();

  final supabase = Supabase.instance.client;

  // ─────────────────────────────────────────────────────
  // LIFE-CYCLE
  // ─────────────────────────────────────────────────────
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────
  // AUTH
  // ─────────────────────────────────────────────────────
  Future<void> _signIn() async {
    try {
      final res = await supabase.auth.signInWithPassword(
        email   : _email.text.trim(),
        password: _password.text.trim(),
      );

      final user     = res.user;
      final emailOk  = user?.emailConfirmedAt != null;

      if (user != null && (emailOk || skipEmailConfirmation)) {
        // journalise la connexion
        await supabase.from('session').insert({
          'user_id' : user.id,
          'type'    : 'login',
          'duration': 0,
        });

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PomodoroScreen()),
        );
      } else {
        throw 'Adresse e-mail non confirmée';
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Erreur de connexion : $e'),
        ),
      );
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _signIn();
    }
  }

  // ─────────────────────────────────────────────────────
  // UI
  // ─────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ─── TITRE ───
              const Text(
                'Bienvenue',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Connecte-toi à ton compte',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),

              // ─── FORMULAIRE ───
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // e-mail
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText : 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Veuillez entrer votre email';
                        }
                        if (!v.contains('@')) {
                          return 'Adresse e-mail invalide';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // mot de passe
                    TextFormField(
                      controller: _password,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText : 'Mot de passe',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Veuillez entrer votre mot de passe';
                        }
                        if (v.length < 6) {
                          return 'Minimum 6 caractères';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    // bouton de connexion
                    SizedBox(
                      width : double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Se connecter',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // lien inscription
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const InscriptionScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Créer un compte',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
