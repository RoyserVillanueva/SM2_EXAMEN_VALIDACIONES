// SM2_EXAMEN_VALIDACIONES - Formulario de Registro con Validaciones Avanzadas
// Curso: Soluciones Movil II
// Alumno: Royser Alonsso Villanueva Mamani
// Código: 2021071090

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // ==================== CA1: Formulario con GlobalKey ====================
  final _formKey = GlobalKey<FormState>();

  // Controladores
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController(); // ✅ NUEVO
  final _dniController = TextEditingController(); // ✅ NUEVO (CA2)
  final _phoneController = TextEditingController();

  // Estados visuales
  bool _isLoading = false;
  bool _obscurePassword = true; // ✅ CA3: Ocultar/mostrar contraseña
  bool _obscureConfirmPassword = true; // ✅ CA3

  // ==================== CA2: Expresiones Regulares ====================

  // ✅ RegEx para Correo Electrónico (estricto)
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // ✅ RegEx para Contraseña Segura (Mayúscula, minúscula, número, mínimo 8)
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$',
  );

  // ✅ RegEx para DNI Peruano (8 dígitos exactos)
  static final RegExp _dniRegExp = RegExp(r'^\d{8}$');

  // ✅ RegEx para Teléfono (9 dígitos exactos - opcional)
  static final RegExp _phoneRegExp = RegExp(r'^\d{9}$');

  // ==================== Métodos ====================

  void _showVerificationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.email, color: Colors.blue),
            SizedBox(width: 8),
            Text('Verifica tu correo'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Te hemos enviado un enlace de verificación a tu correo electrónico.',
              style: TextStyle(height: 1.4),
            ),
            const SizedBox(height: 12),
            Text(
              _emailController.text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Por favor, verifica tu cuenta antes de iniciar sesión.',
              style: TextStyle(height: 1.4),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  // ✅ CA3: Simulación de carga durante 2 segundos
  Future<void> _submitForm() async {
    // CA1: Validación al presionar el botón
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simular procesamiento de 2 segundos
      await Future.delayed(const Duration(seconds: 2));

      // Aquí iría la llamada real al servicio
      final authService = Provider.of<AuthService>(context, listen: false);
      final error = await authService.register(
        _emailController.text,
        _passwordController.text,
        _nameController.text,
        _phoneController.text.isEmpty ? null : _phoneController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (!mounted) return;

      if (error == null) {
        _showVerificationDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Cuenta'),
        elevation: 0,
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.1),
              theme.colorScheme.secondary.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey, // ✅ CA1: GlobalKey asociado
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  // Logo
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Icon(
                        Icons.person_add,
                        size: 48,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    'Crear Cuenta',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  Text(
                    'Únete a nuestra comunidad segura',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  // ==================== FORMULARIO ====================
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          // Campo 1: Nombre
                          TextFormField(
                            controller: _nameController,
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              labelText: 'Nombre completo',
                              hintText: 'Juan Pérez',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return '⚠️ El nombre es obligatorio';
                              }
                              if (value.trim().length < 3) {
                                return '⚠️ Mínimo 3 caracteres';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),

                          // ✅ CA2 + CA3: Campo Correo Electrónico
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Correo electrónico',
                              hintText: 'usuario@ejemplo.com',
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '⚠️ El correo es obligatorio';
                              }
                              if (!_emailRegExp.hasMatch(value.trim())) {
                                return '⚠️ Formato inválido: usuario@dominio.com';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),

                          // ✅ CA2 + CA3: Campo Contraseña con visibilidad toggle
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              hintText: 'Mínimo 8 caracteres',
                              prefixIcon: const Icon(Icons.lock),
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '⚠️ La contraseña es obligatoria';
                              }
                              if (!_passwordRegExp.hasMatch(value)) {
                                return '⚠️ Debe tener: Mayúscula, minúscula, número y mínimo 8 caracteres';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),

                          // ✅ CA3: Confirmar Contraseña
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              labelText: 'Confirmar contraseña',
                              prefixIcon: const Icon(Icons.lock_outline),
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword = !_obscureConfirmPassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '⚠️ Confirma tu contraseña';
                              }
                              if (value != _passwordController.text) {
                                return '⚠️ Las contraseñas no coinciden';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),

                          // ✅ CA2: Campo DNI (8 dígitos numéricos)
                          TextFormField(
                            controller: _dniController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'DNI',
                              hintText: '8 dígitos',
                              prefixIcon: Icon(Icons.badge),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '⚠️ El DNI es obligatorio';
                              }
                              if (!_dniRegExp.hasMatch(value.trim())) {
                                return '⚠️ Debe contener exactamente 8 dígitos numéricos';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),

                          // ✅ CA2: Campo Teléfono (9 dígitos - opcional)
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              labelText: 'Teléfono (opcional)',
                              hintText: '9 dígitos',
                              prefixIcon: Icon(Icons.phone),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) return null;
                              if (!_phoneRegExp.hasMatch(value.trim())) {
                                return '⚠️ Debe contener exactamente 9 dígitos numéricos';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),

                          // ✅ CA3: Botón con estado de carga
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                foregroundColor: theme.colorScheme.onPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isLoading
                                  ? const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Text('Procesando...'),
                                      ],
                                    )
                                  : const Text(
                                      'Crear Cuenta',
                                      style: TextStyle(fontSize: 16),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dniController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}