import 'package:flutter/material.dart';
import 'package:flutter_crud_aldrin/db/operaciones.dart';
import 'package:flutter_crud_aldrin/modelo/notas.dart';

class guardarPagina extends StatefulWidget {
  const guardarPagina({super.key});

  @override
  State<guardarPagina> createState() => _guardarPaginaState();
}

class _guardarPaginaState extends State<guardarPagina> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guardar Nota'),
        backgroundColor: Colors.teal,
      ),
      body: guardarFormulario(),
    );
  }
}

class guardarFormulario extends StatefulWidget {
  const guardarFormulario({super.key});

  @override
  State<guardarFormulario> createState() => _guardarFormularioState();
}

class _guardarFormularioState extends State<guardarFormulario> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _tituloController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _tituloController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor ingrese un título';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: 'Título de la Nota',
                labelStyle: TextStyle(color: Colors.teal),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _descriptionController,
              maxLength: 1000,
              maxLines: 4,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor ingresa una descripción';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: 'Descripción de la Nota',
                labelStyle: TextStyle(color: Colors.teal),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    child: Text('Guardar Nota'),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true;
                        });

                        try {
                          await Operaciones.insertarOperacion(
                            Nota(
                              titulo: _tituloController.text,
                              description: _descriptionController.text,
                            ),
                          );

                          setState(() {
                            _isLoading = false;
                          });

                          Navigator.pop(context, true); // Regresar a la pantalla principal y enviar un resultado positivo
                        } catch (e) {
                          setState(() {
                            _isLoading = false;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error al guardar la nota: $e')),
                          );

                          Navigator.pop(context, false); // Regresar a la pantalla principal y enviar un resultado negativo
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      textStyle: TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
