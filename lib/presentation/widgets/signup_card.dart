import 'package:flutter/material.dart';
import '../../data/services/auth_service.dart';

class SignUpWidget extends StatefulWidget {
  final VoidCallback onSwitch;

  SignUpWidget({required this.onSwitch});

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String pseudonyme = '', email = '', password = '', twitter = '', facebook = '', instagram = '', phoneNumber = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un compte'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 8,
            shadowColor: Colors.black26,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTextField(
                      'Pseudonyme',
                          (val) => pseudonyme = val,
                      validator: (val) => val == null || val.isEmpty ? 'Pseudonyme requis' : null,
                    ),
                    _buildTextField(
                      'Adresse mail',
                          (val) => email = val,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) => val == null || val.isEmpty ? 'Adresse mail requise' : null,
                    ),
                    _buildTextField(
                      'Mot de passe',
                          (val) => password = val,
                      obscureText: true,
                      validator: (val) => val == null || val.isEmpty ? 'Mot de passe requis' : null,
                    ),
                    const SizedBox(height: 10),
                    _buildSocialFields(),
                    _buildTextField(
                      'Numéro de téléphone',
                          (val) => phoneNumber = val,
                      keyboardType: TextInputType.phone,
                      validator: (val) => val == null || val.isEmpty ? 'Numéro de téléphone requis' : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.blueAccent,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            final user = await _authService.signUpWithDetails(
                              email: email,
                              password: password,
                              pseudonyme: pseudonyme,
                              twitter: twitter,
                              facebook: facebook,
                              instagram: instagram,
                              phoneNumber: phoneNumber,
                            );
                            if (user != null) {
                              Navigator.pushReplacementNamed(context, '/home');
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Erreur : ${e.toString()}'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      child: const Text(
                        'Créer un compte',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: widget.onSwitch,
                      child: Text(
                        'Déjà un compte ? Connectez-vous',
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label,
      Function(String) onChanged, {
        bool obscureText = false,
        TextInputType keyboardType = TextInputType.text,
        String? Function(String?)? validator,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.grey[200],
          prefixIcon: _getIcon(label),
        ),
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  Widget _buildSocialFields() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildTextField('Twitter', (val) => twitter = val),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildTextField('Facebook', (val) => facebook = val),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _buildTextField('Instagram', (val) => instagram = val),
      ],
    );
  }

  Icon? _getIcon(String label) {
    switch (label) {
      case 'Pseudonyme':
        return Icon(Icons.person);
      case 'Adresse mail':
        return Icon(Icons.email);
      case 'Mot de passe':
        return Icon(Icons.lock);
      case 'Twitter':
        return Icon(Icons.alternate_email);
      case 'Facebook':
        return Icon(Icons.facebook);
      case 'Instagram':
        return Icon(Icons.camera_alt);
      case 'Numéro de téléphone':
        return Icon(Icons.phone);
      default:
        return null;
    }
  }
}
