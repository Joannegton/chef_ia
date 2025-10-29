/*
// Camera page commented out for future implementation
// All camera/photo functionality has been disabled

import 'package:chef_ia/features/home/presentation/providers/ingredients_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as img;
import 'dart:io';
import 'dart:typed_data';

import '../../../../core/router/app_router.dart';

/// Página da câmera para capturar ingredientes
class CameraPage extends ConsumerStatefulWidget {
  const CameraPage({super.key});

  @override
  ConsumerState<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends ConsumerState<CameraPage>
    with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isProcessing = false;
  String? _error;

  final TextRecognizer _textRecognizer = TextRecognizer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text('Fotografar Ingredientes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flip_camera_ios),
            onPressed: _isInitialized ? _switchCamera : null,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Preview da câmera
          if (_isInitialized && _controller != null)
            Positioned.fill(
              child: CameraPreview(_controller!),
            )
          else if (_error != null)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.white70,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Erro na câmera',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _error!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _initializeCamera,
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            )
          else
            const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),

          // Overlay com instruções
          if (_isInitialized)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Posicione a câmera sobre sua geladeira',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'A IA irá identificar os ingredientes automaticamente',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Botões de ação
          if (_isInitialized)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Galeria
                      GestureDetector(
                        onTap: _pickFromGallery,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.5),
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.photo_library,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),

                      // Botão de captura
                      GestureDetector(
                        onTap: _isProcessing ? null : _takePicture,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: _isProcessing 
                                ? Colors.grey 
                                : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 4,
                            ),
                          ),
                          child: _isProcessing
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(
                                  Icons.camera,
                                  color: Colors.black,
                                  size: 32,
                                ),
                        ),
                      ),

                      // Flash
                      GestureDetector(
                        onTap: _toggleFlash,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.5),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            _controller?.value.flashMode == FlashMode.torch
                                ? Icons.flash_on
                                : Icons.flash_off,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Loading overlay
          if (_isProcessing)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Processando imagem...',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Identificando ingredientes com IA',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Inicializa a câmera
  Future<void> _initializeCamera() async {
    try {
      setState(() {
        _error = null;
        _isInitialized = false;
      });

      // Verificar permissão
      final permission = await Permission.camera.request();
      if (!permission.isGranted) {
        setState(() {
          _error = 'Permissão de câmera negada';
        });
        return;
      }

      // Obter câmeras disponíveis
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        setState(() {
          _error = 'Nenhuma câmera encontrada';
        });
        return;
      }

      // Inicializar controller
      _controller = CameraController(
        _cameras!.first,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Erro ao inicializar câmera: $e';
      });
    }
  }

  /// Tira foto e processa
  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final XFile picture = await _controller!.takePicture();
      await _processImage(picture.path);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao capturar foto: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  /// Seleciona da galeria
  Future<void> _pickFromGallery() async {
    // TODO: Implementar seleção da galeria
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidade da galeria em desenvolvimento'),
      ),
    );
  }

  /// Processa a imagem com ML Kit
  Future<void> _processImage(String imagePath) async {
    try {
      // Criar InputImage
      final inputImage = InputImage.fromFilePath(imagePath);
      
      // Processar com Text Recognition
      final recognizedText = await _textRecognizer.processImage(inputImage);
      
      // Extrair ingredientes do texto
      final ingredients = _extractIngredients(recognizedText.text);
      
      if (ingredients.isNotEmpty) {
        // Adicionar aos ingredientes
        ref.read(ingredientsProvider.notifier).setIngredientsFromCamera(ingredients);
        
        if (mounted) {
          // Voltar para home
          context.pop();
          
          // Mostrar sucesso
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${ingredients.length} ingredientes detectados!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Nenhum ingrediente identificado. Tente uma foto mais clara.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao processar imagem: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Extrai ingredientes do texto reconhecido
  List<String> _extractIngredients(String text) {
    // Lista de ingredientes comuns para identificação
    final commonIngredients = [
      'tomate', 'cebola', 'alho', 'arroz', 'feijão', 'frango', 'carne',
      'batata', 'cenoura', 'pimentão', 'azeite', 'sal', 'pimenta',
      'ovos', 'ovo', 'leite', 'queijo', 'presunto', 'macarrão', 'farinha',
      'açúcar', 'manteiga', 'abobrinha', 'brócolis', 'couve', 'espinafre',
      'alface', 'pepino', 'limão', 'laranja', 'maçã', 'banana', 'yogurt',
      'iogurte', 'chocolate', 'café', 'chá', 'água', 'refrigerante',
    ];

    final foundIngredients = <String>[];
    final lowerText = text.toLowerCase();

    for (final ingredient in commonIngredients) {
      if (lowerText.contains(ingredient) && !foundIngredients.contains(ingredient)) {
        foundIngredients.add(ingredient);
      }
    }

    return foundIngredients;
  }

  /// Alterna entre câmeras
  Future<void> _switchCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;

    final currentIndex = _cameras!.indexOf(_controller!.description);
    final nextIndex = (currentIndex + 1) % _cameras!.length;

    final newController = CameraController(
      _cameras![nextIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller!.dispose();
    _controller = newController;

    try {
      await _controller!.initialize();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      setState(() {
        _error = 'Erro ao trocar câmera: $e';
      });
    }
  }

  /// Toggle flash
  Future<void> _toggleFlash() async {
    if (_controller == null) return;

    try {
      final flashMode = _controller!.value.flashMode;
      if (flashMode == FlashMode.torch) {
        await _controller!.setFlashMode(FlashMode.off);
      } else {
        await _controller!.setFlashMode(FlashMode.torch);
      }
      setState(() {});
    } catch (e) {
      // Ignore flash errors
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    _textRecognizer.close();
    super.dispose();
  }
}
*/