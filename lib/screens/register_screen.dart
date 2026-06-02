// SM2_EXAMEN_VALIDACIONES - Formulario de Registro con Validaciones Avanzadas
// Curso: Soluciones Movil II
// Alumno: Royser Alonsso Villanueva Mamani
// Código: 2021071090

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../widgets/auth_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // CA1: Implementación de Form y GlobalKey
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dniController = TextEditingController(); // Campo adicional para validación numérica
  
  bool _isLoading = false;
  bool _obscurePassword = true; // CA3: Visibilidad de contraseña
  bool _obscureConfirmPassword = true;
  
  // Controlador para confirmar contraseña
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _dniController.dispose();
    super.dispose();
  }

  // CA2: Expresiones Regulares Avanzadas
  // RegEx para Correo Electrónico
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  
  // RegEx para Contraseña Fuerte (Mayúscula, minúscula, número, mínimo 8 caracteres)
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$',
  );
  
  // RegEx para DNI Peruano (8 dígitos numéricos)
  static final RegExp _dniRegExp = RegExp(
    r'^\d{8}$',
  );
  
  // RegEx para Teléfono Peruano (9 dígitos numéricos)
  static final RegExp _phoneRegExp = RegExp(
    r'^\d{9}$',
  );

  // CA3: Simulación de envío con estado de carga
  Future<void> _submitForm() async {
    // CA1: Validación al presionar el botón
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simular procesamiento de 2 segundos
      await Future.delayed(const Duration(seconds: 2));
      
      // Aquí iría la llamada real a AuthService
      // final error = await authService.register(...);
      
      setState(() {
        _isLoading = false;
      });
      
      // Mostrar éxito (simulado)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Registro exitoso! (Simulación)'),
            backgroundColor: Colors.green,
          ),
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
        title: const Text('Registro de Usuario'),
        elevation: 0,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 16),
              
              // Ícono de registro
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person_add,
                    size: 48,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Campo: Nombre Completo
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Nombre Completo',
                  hintText: 'Juan Pérez',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '⚠️ El nombre es obligatorio';
                  }
                  if (value.trim().length < 3) {
                    return '⚠️ Ingresa al menos 3 caracteres';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // CA2 + CA3: Campo Correo Electrónico con RegEx y teclado email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Correo Electrónico',
                  hintText: 'usuario@ejemplo.com',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '⚠️ El correo es obligatorio';
                  }
                  if (!_emailRegExp.hasMatch(value.trim())) {
                    return '⚠️ Formato inválido: usuario@dominio.com';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // CA2 + CA3: Campo Contraseña con RegEx y visibilidad toggle
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
              
              const SizedBox(height: 16),
              
              // CA3: Campo Confirmar Contraseña
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: 'Confirmar Contraseña',
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
              
              const SizedBox(height: 16),
              
              // CA2: Campo DNI con RegEx numérico (8 dígitos)
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
              
              const SizedBox(height: 16),
              
              // CA2: Campo Teléfono con RegEx numérico (9 dígitos)
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  hintText: '9 dígitos (Ej: 987654321)',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null; // Opcional
                  }
                  if (!_phoneRegExp.hasMatch(value.trim())) {
                    return '⚠️ Debe contener exactamente 9 dígitos numéricos';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              // CA3: Botón con estado de carga
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
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
                          'Registrarse',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
              
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}