import 'package:flutter/material.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:provider/provider.dart';
import '../../core/models/evaluation_model.dart';
import '../../core/models/species_model.dart';
import '../../core/theme/bian_theme.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/custom_snackbar.dart';
import '../../core/utils/connectivity_service.dart';
import 'package:open_filex/open_filex.dart';
import 'ai_chat_screen.dart';
import '../../core/api/api_service.dart';
import '../../core/storage/secure_storage.dart';
import 'package:intl/intl.dart';

class ResultsScreen extends StatelessWidget {
  final Evaluation evaluation;
  final Species species;
  final Map<String, dynamic> results;
  final Map<String, dynamic> structuredJson;

  const ResultsScreen({
    super.key,
    required this.evaluation,
    required this.species,
    required this.results,
    required this.structuredJson,
  });

  /// Prepara los datos de la evaluación para enviar al backend Java
  Future<Map<String, dynamic>> _prepareEvaluationData() async {
    final storage = SecureStorage();
    final user = await storage.getUser();

    if (user == null) {
      throw Exception('No hay usuario logueado');
    }

    // Formato de fecha: YYYY-MM-DD
    final dateFormatter = DateFormat('yyyy-MM-dd');
    final evaluationDateStr = dateFormatter.format(evaluation.evaluationDate);

    // Preparar categories en el formato esperado
    final categories = <String, dynamic>{};
    final overallScore = double.tryParse(results['overall_score']?.toString() ?? '0') ?? 0.0;
    final categoryScores = results['category_scores'] as Map<String, double>;

    for (var category in species.categories) {
      final score = categoryScores[category.id] ?? 0.0;
      categories[category.id] = {
        'score': score.toString(),
        'fields': evaluation.responses.entries
            .where((e) => e.key.startsWith('${category.id}_'))
            .map((e) => {
                  'field_id': e.key,
                  'value': e.value.toString(),
                })
            .toList(),
      };
    }

    // Preparar critical_points
    final criticalPoints = (results['critical_points'] as List)
        .map((point) => {
              'category': point.toString().split('_')[0],
              'field': point.toString(),
            })
        .toList();

    // Preparar strong_points
    final strongPoints = (results['strong_points'] as List)
        .map((point) => {
              'description': point.toString(),
            })
        .toList();

    // Recommendations
    final recommendations = (structuredJson['recommendations'] as List)
        .map((rec) => rec.toString())
        .toList();

    return {
      'connection_status': 'online',
      'user_id': user.id.toString(),
      'evaluation_date': evaluationDateStr,
      'language': evaluation.language,
      'species': species.id,
      'farm_name': evaluation.farmName,
      'farm_location': evaluation.farmLocation,
      'evaluator_name': evaluation.evaluatorName,
      'evaluator_document': evaluation.evaluatorDocument,
      'status': 'completed',
      'overall_score': overallScore.toString(),
      'compliance_level': results['compliance_level'] as String,
      'categories': categories,
      'critical_points': criticalPoints,
      'strong_points': strongPoints,
      'recommendations': recommendations,
    };
  }

  /// Sincroniza la evaluación con el backend Java
  Future<void> _syncToServer(BuildContext context) async {
    final loc = AppLocalizations.of(context);

    // Mostrar diálogo de carga
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => PopScope(
        canPop: false,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.all(32),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(BianTheme.primaryRed),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    loc.translate('syncing_to_server'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    try {
      print('📤 Preparando datos para sincronización...');
      final evaluationData = await _prepareEvaluationData();

      print('📤 Enviando evaluación al backend Java...');
      final apiService = ApiService();
      final result = await apiService.createEvaluationReport(evaluationData);

      if (!context.mounted) return;
      Navigator.pop(context); // Cerrar diálogo de carga

      if (result['success'] == true) {
        print('✅ Evaluación sincronizada exitosamente');
        CustomSnackbar.showSuccess(
          context,
          loc.translate('evaluation_synced_successfully'),
        );
      } else {
        print('❌ Error al sincronizar: ${result['message']}');
        CustomSnackbar.showError(
          context,
          loc.translate(result['message'] ?? 'sync_error'),
        );
      }
    } catch (e) {
      print('❌ Excepción al sincronizar: $e');
      if (!context.mounted) return;
      Navigator.pop(context); // Cerrar diálogo de carga

      CustomSnackbar.showError(
        context,
        '${loc.translate('sync_error')}: $e',
      );
    }
  }

  Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      try {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        final sdkInt = androidInfo.version.sdkInt;
        print('📱 Android SDK: $sdkInt');

        if (sdkInt >= 33) {
          print('✅ Android 13+ - Permisos no requeridos');
          return true;
        }

        if (sdkInt >= 30) {
          print('⚙️ Android 11-12 - Verificando MANAGE_EXTERNAL_STORAGE');
          final status = await Permission.manageExternalStorage.status;

          if (status.isGranted) {
            print('✅ Permiso ya concedido');
            return true;
          }

          if (status.isDenied) {
            final result = await Permission.manageExternalStorage.request();
            print('📊 Resultado: $result');
            return result.isGranted;
          }

          if (status.isPermanentlyDenied) {
            await openAppSettings();
            return false;
          }

          return status.isGranted;
        }

        print('⚙️ Android ≤10 - Verificando STORAGE');
        final status = await Permission.storage.status;

        if (status.isGranted) return true;
        if (status.isDenied) {
          final result = await Permission.storage.request();
          return result.isGranted;
        }
        if (status.isPermanentlyDenied) {
          await openAppSettings();
          return false;
        }

        return status.isGranted;
      } catch (e) {
        print('⚠️ Error verificando permisos: $e');
        return true;
      }
    }
    return true;
  }

Future<void> _openPDF(BuildContext context, String filePath) async {
    try {
      print('📂 Intentando abrir PDF: $filePath');
      
      final result = await OpenFilex.open(filePath);
      print('📊 Resultado de apertura: ${result.type} - ${result.message}');
      
      if (result.type != ResultType.done) {
        if (!context.mounted) return;

        CustomSnackbar.show(
          context,
          'No se pudo abrir automáticamente. Busca el archivo en Descargas.',
          isWarning: true,
          duration: Duration(seconds: 4),
          actionLabel: 'Compartir',
          onActionPressed: () async {
            await Share.shareXFiles([XFile(filePath)]);
          },
        );
      } else {
        print('✅ PDF abierto exitosamente');
      }
    } catch (e) {
      print('❌ Error abriendo PDF: $e');

      if (!context.mounted) return;

      CustomSnackbar.showError(
        context,
        'Error al abrir PDF: $e',
        duration: Duration(seconds: 3),
      );
    }
  }

  void _showPDFOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: BianTheme.lightGray,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context).translate('pdf_report_options'),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: BianTheme.primaryRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.download,
                  color: BianTheme.primaryRed,
                ),
              ),
              title: Text(AppLocalizations.of(context).translate('download_pdf')),
              subtitle: Text(AppLocalizations.of(context).translate('download_on_device')),
              onTap: () {
                Navigator.pop(bottomSheetContext);
                _downloadPDF(context);
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: BianTheme.infoBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.share,
                  color: BianTheme.infoBlue,
                ),
              ),
              title: Text(AppLocalizations.of(context).translate('share_pdf')),
              subtitle: Text(AppLocalizations.of(context).translate('share_via_apps')),
              onTap: () {
                Navigator.pop(bottomSheetContext);
                _generateAndSharePDF(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showLoadingDialog(BuildContext context, AppLocalizations loc) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (dialogContext) => PopScope(
        canPop: false,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.all(32),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      strokeWidth: 6,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        BianTheme.primaryRed,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    loc.translate('generating_pdf'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: BianTheme.darkGray,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    loc.translate('please_wait'),
                    style: TextStyle(
                      fontSize: 14,
                      color: BianTheme.mediumGray,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _downloadPDF(BuildContext context) async {
    print('🔵 === INICIANDO DESCARGA DE PDF ===');
    final loc = AppLocalizations.of(context);

    try {
      print('🔐 Paso 1: Verificando permisos...');
      final hasPermission = await _requestPermissions();
      print('🔐 Permisos: $hasPermission');

      if (!hasPermission) {
        print('❌ Permisos denegados');
        if (!context.mounted) return;
        CustomSnackbar.showError(context, loc.translate('storage_permissions_required'));
        return;
      }

      if (!context.mounted) return;
      print('✅ Paso 2: Mostrando diálogo de carga...');
      _showLoadingDialog(context, loc);

      print('📄 Paso 3: Construyendo PDF...');
      final pdf = await _buildPDFNoContext(loc);
      print('✅ PDF construido exitosamente');

      print('📁 Paso 4: Determinando directorio...');
      Directory? directory;

      if (Platform.isAndroid) {
        print('🤖 Plataforma: Android');
        directory = Directory('/storage/emulated/0/Download');
        print('🔍 Intentando: ${directory.path}');

        if (!await directory.exists()) {
          print('❌ No existe, probando Downloads...');
          directory = Directory('/storage/emulated/0/Downloads');
          print('🔍 Intentando: ${directory.path}');
        }

        if (!await directory.exists()) {
          print('❌ No existe, usando external storage...');
          directory = await getExternalStorageDirectory();
          print('🔍 Usando: ${directory?.path}');
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
        print('📱 Plataforma: iOS - ${directory.path}');
      }

      if (directory == null) {
        throw Exception(loc.translate('storage_directory_error'));
      }

      print('✅ Directorio seleccionado: ${directory.path}');
      print('📝 Paso 5: Creando archivo...');

      final fileName =
          'BIAN_${evaluation.farmName.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final filePath = '${directory.path}/$fileName';
      print('📍 Ruta completa: $filePath');

      final file = File(filePath);

      print('💾 Paso 6: Guardando PDF...');
      final pdfBytes = await pdf.save();
      print('📦 Tamaño del PDF: ${pdfBytes.length} bytes');

      await file.writeAsBytes(pdfBytes, flush: true);
      print('✅ Archivo escrito');

      print('🔍 Paso 7: Verificando archivo...');
      final exists = await file.exists();
      print('📂 ¿Archivo existe?: $exists');

      if (!exists) {
        throw Exception(loc.translate('file_not_created_correctly'));
      }

      final fileSize = await file.length();
      print('📊 Tamaño del archivo guardado: $fileSize bytes');

      if (!context.mounted) return;

      Navigator.pop(context);

      print('✅ === PDF GUARDADO EXITOSAMENTE ===');

      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: BianTheme.successGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.check_circle,
                    color: BianTheme.successGreen, size: 32),
              ),
              const SizedBox(width: 12),
              Expanded(
                  child: Text(loc.translate('pdf_saved_title'),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold))),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(loc.translate('pdf_saved_successfully_at'),
                  style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: BianTheme.lightGray.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: BianTheme.lightGray),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.folder,
                            size: 18, color: BianTheme.primaryRed),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            directory?.path ?? 'N/A',
                            style: const TextStyle(
                                fontSize: 11,
                                color: BianTheme.mediumGray,
                                fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(height: 1),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.description,
                            size: 18, color: BianTheme.primaryRed),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(fileName,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: BianTheme.infoBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(color: BianTheme.infoBlue.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline,
                        size: 20, color: BianTheme.infoBlue),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        Platform.isAndroid
                            ? loc.translate('find_in_downloads_android')
                            : loc.translate('find_in_documents_ios'),
                        style: const TextStyle(
                            fontSize: 11, color: BianTheme.darkGray),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cerrar')),
                OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(dialogContext);
                _openPDF(context, filePath);
              },
              icon: const Icon(Icons.visibility),
              label: const Text('Ver PDF'),
              style: OutlinedButton.styleFrom(
                foregroundColor: BianTheme.primaryRed,
                side: const BorderSide(color: BianTheme.primaryRed),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.pop(dialogContext);
                print('🔄 Compartiendo PDF...');
                await Share.shareXFiles([XFile(filePath)],
                    text: 'Reporte BIAN - ${evaluation.farmName}');
                print('✅ PDF compartido');
              },
              icon: const Icon(Icons.share),
              label: const Text('Compartir'),
              style:
                  ElevatedButton.styleFrom(backgroundColor: BianTheme.infoBlue),
            ),
          ],
        ),
      );
    } catch (e, stackTrace) {
      print('💥 ═══ ERROR CRÍTICO ═══');
      print('❌ Error: $e');
      print('📍 Stack trace:');
      print(stackTrace);
      print('═══════════════════════');

      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).popUntil((route) {
          return route.isFirst || !route.willHandlePopInternally;
        });
      }

      if (!context.mounted) return;

      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.error_outline, color: BianTheme.errorRed, size: 32),
              SizedBox(width: 12),
              Expanded(
                  child: Text('Error al guardar',
                      style: TextStyle(fontSize: 18))),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('No se pudo guardar el PDF:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: BianTheme.errorRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(e.toString(),
                    style: TextStyle(fontSize: 12, fontFamily: 'monospace')),
              ),
              SizedBox(height: 12),
              Text('💡 Sugerencias:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              SizedBox(height: 8),
              Text('• Intenta usar "Compartir PDF" en su lugar',
                  style: TextStyle(fontSize: 12)),
              Text('• Verifica que tengas espacio disponible',
                  style: TextStyle(fontSize: 12)),
              Text('• Revisa los permisos de la app',
                  style: TextStyle(fontSize: 12)),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text('Cerrar')),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _generateAndSharePDF(context);
              },
              child: Text('Intentar Compartir'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: BianTheme.infoBlue),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _generateAndSharePDF(BuildContext context) async {
    final loc = AppLocalizations.of(context);

    _showLoadingDialog(context, loc);

    try {
      print('🔵 Generando PDF para compartir...');
      final pdf = await _buildPDFNoContext(loc);

      if (!context.mounted) return;
      Navigator.pop(context);

      final output = await getTemporaryDirectory();
      final fileName =
          'BIAN_${evaluation.farmName.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final filePath = '${output.path}/$fileName';
      final file = File(filePath);

      print('💾 Guardando temporal en: $filePath');

      final pdfBytes = await pdf.save();
      await file.writeAsBytes(pdfBytes);

      print('✅ Listo para compartir');

      if (!context.mounted) return;

      await Share.shareXFiles([XFile(filePath)],
          text:
              '${loc.translate('evaluation_results')} - ${evaluation.farmName}');

      if (!context.mounted) return;

      CustomSnackbar.showSuccess(context, loc.translate('pdf_generated'));
    } catch (e, stackTrace) {
      print('💥 ERROR: $e');
      print('📍 Stack: $stackTrace');

      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).popUntil((route) {
          return route.isFirst || !route.willHandlePopInternally;
        });
      }

      if (!context.mounted) return;

      CustomSnackbar.showError(
        context,
        'Error: $e',
        duration: Duration(seconds: 5),
      );
    }
  }
  Future<pw.Document> _buildPDFNoContext(AppLocalizations loc) async {
    print('🔵 Iniciando generación de PDF...');

    final pdf = pw.Document();

    final overallScore = double.tryParse(results['overall_score']?.toString() ?? '0') ?? 0.0;
    final complianceLevel = results['compliance_level'] as String;
    final categoryScores = results['category_scores'] as Map<String, double>;
    final criticalPoints = results['critical_points'] as List;
    final strongPoints = results['strong_points'] as List;
    final recommendations = structuredJson['recommendations'] as List;

    print('📊 Datos cargados - Score: $overallScore');

    PdfColor scoreColor;
    if (overallScore >= 90) {
      scoreColor = PdfColor.fromInt(0xFF4CAF50);
    } else if (overallScore >= 75) {
      scoreColor = PdfColor.fromInt(0xFF8BC34A);
    } else if (overallScore >= 60) {
      scoreColor = PdfColor.fromInt(0xFFFFB300);
    } else {
      scoreColor = PdfColor.fromInt(0xFFD32F2F);
    }

    print('🎨 Color determinado');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          print('📄 Construyendo página PDF...');
          return [
            pw.Container(
              padding: const pw.EdgeInsets.all(20),
              decoration: pw.BoxDecoration(
                gradient: pw.LinearGradient(
                  colors: [
                    PdfColor.fromInt(0xFFEC1C21),
                    PdfColor.fromInt(0xFFB71C1C),
                  ],
                ),
                borderRadius: pw.BorderRadius.circular(16),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'BIAN',
                        style: pw.TextStyle(
                          fontSize: 36,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white,
                        ),
                      ),
                      pw.SizedBox(height: 6),
                      pw.Text(
                        loc.translate('app_name'),
                        style: const pw.TextStyle(
                          fontSize: 13,
                          color: PdfColors.white,
                        ),
                      ),
                    ],
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromInt(
                          0xFFF5F5F5),
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Column(
                      children: [
                        pw.Text(
                          overallScore.toStringAsFixed(1),
                          style: pw.TextStyle(
                            fontSize: 32,
                            fontWeight: pw.FontWeight.bold,
                            color:  PdfColor.fromInt(
                          0xFFDB7093),
                          ),
                        ),
                        pw.Text(
                          '%',
                          style: pw.TextStyle(
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColor.fromInt(
                          0xFFDB7093),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 24),

            pw.Text(
              loc.translate('evaluation_results'),
              style: pw.TextStyle(
                fontSize: 26,
                fontWeight: pw.FontWeight.bold,
                color: PdfColor.fromInt(0xFF2D2D2D),
              ),
            ),

            pw.SizedBox(height: 20),

            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromInt(0xFFEEEEEE),
                borderRadius: pw.BorderRadius.circular(12),
                border: pw.Border.all(color: scoreColor, width: 2),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          loc.translate('compliance_level'),
                          style: pw.TextStyle(
                            fontSize: 14,
                            color: PdfColor.fromInt(0xFF757575),
                          ),
                        ),
                        pw.SizedBox(height: 6),
                        pw.Text(
                          loc.translate(complianceLevel),
                          style: pw.TextStyle(
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                            color: scoreColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 24),

            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromInt(0xFFF5F5F5),
                borderRadius: pw.BorderRadius.circular(12),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    loc.translate('farm_information'),
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromInt(0xFF2D2D2D),
                    ),
                  ),
                  pw.SizedBox(height: 12),
                  _buildInfoRow(
                      loc.translate('farm_name'), evaluation.farmName),
                  pw.SizedBox(height: 8),
                  _buildInfoRow(
                      loc.translate('location'), evaluation.farmLocation),
                  pw.SizedBox(height: 8),
                  _buildInfoRow(loc.translate('evaluator_name'),
                      evaluation.evaluatorName),
                  pw.SizedBox(height: 8),
                  _buildInfoRow(
                    loc.translate('evaluation_date'),
                    '${evaluation.evaluationDate.day}/${evaluation.evaluationDate.month}/${evaluation.evaluationDate.year}',
                  ),
                  pw.SizedBox(height: 8),
                  _buildInfoRow(loc.translate('species'), species.namePlural),
                ],
              ),
            ),

            pw.SizedBox(height: 24),

            pw.Text(
              loc.translate('category_scores'),
              style: pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
                color: PdfColor.fromInt(0xFF2D2D2D),
              ),
            ),

            pw.SizedBox(height: 16),

            ...species.categories.map((category) {
              final score = categoryScores[category.id] ?? 0.0;
              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 12),
                child: _buildCategoryScore(loc.translate(category.id), score),
              );
            }),

            pw.SizedBox(height: 24),

            pw.Text(
              loc.translate('critical_points'),
              style: pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
                color: PdfColor.fromInt(0xFF2D2D2D),
              ),
            ),

            pw.SizedBox(height: 16),

            if (criticalPoints.isEmpty)
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromInt(0xFFE8F5E9),
                  borderRadius: pw.BorderRadius.circular(8),
                  border: pw.Border.all(color: PdfColor.fromInt(0xFF4CAF50)),
                ),
                child: pw.Row(
                  children: [
                    pw.Container(
                      width: 24,
                      height: 24,
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromInt(0xFF4CAF50),
                        shape: pw.BoxShape.circle,
                      ),
                      child: pw.Center(
                        child: pw.Text(
                          '✓',
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    pw.SizedBox(width: 12),
                    pw.Expanded(
                      child: pw.Text(
                        loc.translate('no_critical_points'),
                        style: pw.TextStyle(
                          fontSize: 13,
                          color: PdfColor.fromInt(0xFF2D2D2D),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              ...criticalPoints.map((point) {
                final parts = point.toString().split('_');
                final categoryId = parts[0];
                final fieldId = parts.sublist(1).join('_');
                return pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 10),
                  padding: const pw.EdgeInsets.all(14),
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromInt(0xFFFFEBEE),
                    borderRadius: pw.BorderRadius.circular(8),
                    border: pw.Border.all(
                      color: PdfColor.fromInt(0xFFD32F2F),
                      width: 1.5,
                    ),
                  ),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        width: 22,
                        height: 22,
                        decoration: pw.BoxDecoration(
                          color: PdfColor.fromInt(0xFFD32F2F),
                          shape: pw.BoxShape.circle,
                        ),
                        child: pw.Center(
                          child: pw.Text(
                            '!',
                            style: pw.TextStyle(
                              color: PdfColors.white,
                              fontSize: 13,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      pw.SizedBox(width: 12),
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              loc.translate(categoryId),
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColor.fromInt(0xFFD32F2F),
                              ),
                            ),
                            pw.SizedBox(height: 4),
                            pw.Text(
                              loc.translate(fieldId),
                              style: pw.TextStyle(
                                fontSize: 11,
                                color: PdfColor.fromInt(0xFF2D2D2D),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),

            pw.SizedBox(height: 24),

            pw.Text(
              loc.translate('strong_points'),
              style: pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
                color: PdfColor.fromInt(0xFF2D2D2D),
              ),
            ),

            pw.SizedBox(height: 16),

            if (strongPoints.isEmpty)
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromInt(0xFFF5F5F5),
                  borderRadius: pw.BorderRadius.circular(8),
                  border: pw.Border.all(color: PdfColor.fromInt(0xFFE0E0E0)),
                ),
                child: pw.Text(
                  loc.translate('no_strong_points'),
                  style: pw.TextStyle(
                    fontSize: 13,
                    color: PdfColor.fromInt(0xFF757575),
                  ),
                ),
              )
            else
              ...strongPoints.map((point) {
                return pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 10),
                  padding: const pw.EdgeInsets.all(14),
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromInt(0xFFE8F5E9),
                    borderRadius: pw.BorderRadius.circular(8),
                    border: pw.Border.all(
                      color: PdfColor.fromInt(0xFF4CAF50),
                      width: 1.5,
                    ),
                  ),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        width: 22,
                        height: 22,
                        decoration: pw.BoxDecoration(
                          color: PdfColor.fromInt(0xFF4CAF50),
                          shape: pw.BoxShape.circle,
                        ),
                        child: pw.Center(
                          child: pw.Text(
                            '✓',
                            style: pw.TextStyle(
                              color: PdfColors.white,
                              fontSize: 13,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      pw.SizedBox(width: 12),
                      pw.Expanded(
                        child: pw.Text(
                          loc.translate(point.toString()),
                          style: pw.TextStyle(
                            fontSize: 12,
                            color: PdfColor.fromInt(0xFF2D2D2D),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

            pw.SizedBox(height: 24),

            pw.Text(
              loc.translate('recommendations'),
              style: pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
                color: PdfColor.fromInt(0xFF2D2D2D),
              ),
            ),

            pw.SizedBox(height: 16),

            ...List.generate(recommendations.length, (index) {
              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 12),
                padding: const pw.EdgeInsets.all(14),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromInt(0xFFE3F2FD),
                  borderRadius: pw.BorderRadius.circular(8),
                  border: pw.Border.all(
                    color: PdfColor.fromInt(0xFF2196F3),
                    width: 1.5,
                  ),
                ),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      width: 24,
                      height: 24,
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromInt(0xFF2196F3),
                        shape: pw.BoxShape.circle,
                      ),
                      child: pw.Center(
                        child: pw.Text(
                          '${index + 1}',
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                      ),
                    ),
                    pw.SizedBox(width: 12),
                    pw.Expanded(
                      child: pw.Text(
                        recommendations[index].toString(),
                        style: pw.TextStyle(
                          fontSize: 12,
                          color: PdfColor.fromInt(0xFF2D2D2D),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),

            pw.SizedBox(height: 32),

            pw.Divider(color: PdfColor.fromInt(0xFFE0E0E0)),
            pw.SizedBox(height: 12),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'BIAN - ${loc.translate('app_name')}',
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: PdfColor.fromInt(0xFF757575),
                  ),
                ),
                pw.Text(
                  'Generado: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: PdfColor.fromInt(0xFF757575),
                  ),
                ),
              ],
            ),
          ];
        },
      ),
    );

    print('✅ PDF construido exitosamente');
    return pdf;
  }

  pw.Widget _buildInfoRow(String label, String value) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 11,
            fontWeight: pw.FontWeight.bold,
            color: PdfColor.fromInt(0xFF757575),
          ),
        ),
        pw.Expanded(
          child: pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 11,
              color: PdfColor.fromInt(0xFF2D2D2D),
            ),
            textAlign: pw.TextAlign.right,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildCategoryScore(String categoryName, double score) {
    PdfColor barColor;
    if (score >= 80) {
      barColor = PdfColor.fromInt(0xFF4CAF50);
    } else if (score >= 60) {
      barColor = PdfColor.fromInt(0xFFFFB300);
    } else {
      barColor = PdfColor.fromInt(0xFFD32F2F);
    }

    return pw.Container(
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: PdfColor.fromInt(0xFFE0E0E0)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                categoryName,
                style: pw.TextStyle(
                  fontSize: 13,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromInt(0xFF2D2D2D),
                ),
              ),
              pw.Text(
                '${score.toStringAsFixed(1)}%',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: barColor,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Container(
            height: 12,
            decoration: pw.BoxDecoration(
              color: PdfColor.fromInt(0xFFE0E0E0),
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Stack(
              children: [
                pw.Container(
                  width: 500 * (score / 100),
                  decoration: pw.BoxDecoration(
                    color: barColor,
                    borderRadius: pw.BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final overallScore = double.tryParse(results['overall_score']?.toString() ?? '0.0') ?? 0.0;
    final complianceLevel = results['compliance_level'] as String;
    final categoryScores = results['category_scores'] as Map<String, double>;
    final criticalPoints = results['critical_points'] as List;
    final strongPoints = results['strong_points'] as List;
    final recommendations = structuredJson['recommendations'] as List;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('evaluation_results')),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _showPDFOptions(context),
            tooltip: 'Opciones PDF',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildScoreHeader(context, overallScore, complianceLevel),
            const SizedBox(height: 24),
            _buildInfoCard(context, loc),
            const SizedBox(height: 24),
            Text(
              loc.translate('category_scores'),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            ...species.categories.map((category) {
              final score = categoryScores[category.id] ?? 0.0;
              return _buildCategoryScoreCard(context, loc, category.id, score);
            }),
            const SizedBox(height: 24),
            Text(
              loc.translate('critical_points'),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            if (criticalPoints.isEmpty)
              _buildEmptyCard(context, loc.translate('no_critical_points'),
                  BianTheme.successGreen)
            else
              ...criticalPoints.take(10).map((point) {
                final parts = point.toString().split('_');
                final categoryId = parts[0];
                final fieldId = parts
                    .sublist(1)
                    .join('_')
                    .replaceAll('_pigs', '')
                    .replaceAll('_birds', '');
                return _buildCriticalPointCard(
                    context, loc, categoryId, fieldId);
              }),
            const SizedBox(height: 24),
            Text(
              loc.translate('strong_points'),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            if (strongPoints.isEmpty)
              _buildEmptyCard(context, loc.translate('no_strong_points'),
                  BianTheme.mediumGray)
            else
              ...strongPoints.map((point) {
                return _buildStrongPointCard(
                  context,
                  loc.translate(point.toString()),
                );
              }),
            const SizedBox(height: 24),
            Text(
              loc.translate('recommendations'),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            ...recommendations.map(
                (rec) => _buildRecommendationCard(context, rec.toString())),
            const SizedBox(height: 32),

            _buildAIAnalysisButton(context, loc, overallScore, categoryScores, criticalPoints, strongPoints),

            const SizedBox(height: 16),

            // Botón de sincronización con servidor
            Consumer<ConnectivityService>(
              builder: (context, connectivityService, _) {
                return StreamBuilder<bool>(
                  stream: connectivityService.connectionStatus,
                  builder: (context, snapshot) {
                    // Esperar a que el stream emita el primer valor real
                    if (!snapshot.hasData) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final hasConnection = snapshot.data!;

                    if (!hasConnection) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: BianTheme.warningYellow.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: BianTheme.warningYellow),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.cloud_off,
                              color: BianTheme.warningYellow,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                loc.translate('offline_mode_active'),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ElevatedButton.icon(
                      onPressed: () => _syncToServer(context),
                      icon: const Icon(Icons.cloud_upload),
                      label: Text(loc.translate('sync_to_server')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BianTheme.successGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        minimumSize: const Size(double.infinity, 52),
                      ),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(loc.translate('close')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreHeader(BuildContext context, double score, String level) {
    final loc = AppLocalizations.of(context);

    Color scoreColor;
    IconData scoreIcon;

    if (score >= 90) {
      scoreColor = BianTheme.successGreen;
      scoreIcon = Icons.celebration;
    } else if (score >= 75) {
      scoreColor = const Color(0xFF4CAF50);
      scoreIcon = Icons.thumb_up;
    } else if (score >= 60) {
      scoreColor = BianTheme.warningYellow;
      scoreIcon = Icons.warning_amber;
    } else {
      scoreColor = BianTheme.errorRed;
      scoreIcon = Icons.error_outline;
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [scoreColor, scoreColor.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: BianTheme.elevatedShadow,
      ),
      child: Column(
        children: [
          Icon(scoreIcon, size: 64, color: Colors.white),
          const SizedBox(height: 16),
          Text(
            '${score.toStringAsFixed(1)}%',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              loc.translate(level),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: BianTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.business, color: BianTheme.primaryRed),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.translate('farm_name'),
                      style: const TextStyle(
                        fontSize: 12,
                        color: BianTheme.mediumGray,
                      ),
                    ),
                    Text(
                      evaluation.farmName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            children: [
              const Icon(Icons.location_on, color: BianTheme.primaryRed),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.translate('location'),
                      style: const TextStyle(
                        fontSize: 12,
                        color: BianTheme.mediumGray,
                      ),
                    ),
                    Text(
                      evaluation.farmLocation,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            children: [
              const Icon(Icons.person, color: BianTheme.primaryRed),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.translate('evaluator_name'),
                      style: const TextStyle(
                        fontSize: 12,
                        color: BianTheme.mediumGray,
                      ),
                    ),
                    Text(
                      evaluation.evaluatorName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryScoreCard(BuildContext context, AppLocalizations loc,
      String categoryId, double score) {
    Color barColor;
    if (score >= 80) {
      barColor = BianTheme.successGreen;
    } else if (score >= 60) {
      barColor = BianTheme.warningYellow;
    } else {
      barColor = BianTheme.errorRed;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BianTheme.lightGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                loc.translate(categoryId),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                '${score.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: barColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: score / 100,
              minHeight: 10,
              backgroundColor: BianTheme.lightGray,
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCriticalPointCard(BuildContext context, AppLocalizations loc,
      String categoryId, String fieldId) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BianTheme.errorRed.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BianTheme.errorRed.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_rounded,
            color: BianTheme.errorRed,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.translate(categoryId),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: BianTheme.errorRed,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getFieldLabel(loc, fieldId),
                  style: const TextStyle(
                    fontSize: 13,
                    color: BianTheme.darkGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getFieldLabel(AppLocalizations loc, String fieldId) {
    final language = evaluation.language;

    final labelsEs = {
      'water_access': 'Acceso al agua',
      'feed_quality': 'Calidad del alimento',
      'feeders_sufficient': 'Comederos suficientes',
      'feed_frequency': 'Frecuencia de alimentación',
      'general_health': 'Estado de salud general',
      'mortality_rate': 'Tasa de mortalidad',
      'injuries': 'Lesiones o heridas',
      'vaccination': 'Vacunación',
      'diseases': 'Enfermedades',
      'tail_biting': 'Mordedura de colas',
      'natural_behavior': 'Comportamiento natural',
      'aggression': 'Agresividad',
      'stress_signs': 'Signos de estrés',
      'movement': 'Movilidad',
      'enrichment': 'Enriquecimiento ambiental',
      'space_per_bird': 'Espacio por ave',
      'space_per_pig': 'Espacio por cerdo',
      'ventilation': 'Ventilación',
      'temperature': 'Temperatura',
      'temperature_facility': 'Temperatura instalación',
      'litter_quality': 'Calidad de la cama',
      'floor_quality': 'Calidad del piso',
      'lighting': 'Iluminación',
      'resting_area': 'Área de descanso',
      'staff_training': 'Capacitación del personal',
      'records': 'Registros',
      'biosecurity': 'Bioseguridad',
      'handling': 'Manejo',
      'castration': 'Castración',
    };

    final labelsEn = {
      'water_access': 'Water access',
      'feed_quality': 'Feed quality',
      'feeders_sufficient': 'Sufficient feeders',
      'feed_frequency': 'Feeding frequency',
      'general_health': 'General health',
      'mortality_rate': 'Mortality rate',
      'injuries': 'Injuries or wounds',
      'vaccination': 'Vaccination',
      'diseases': 'Diseases',
      'tail_biting': 'Tail biting',
      'natural_behavior': 'Natural behavior',
      'aggression': 'Aggression',
      'stress_signs': 'Stress signs',
      'movement': 'Movement',
      'enrichment': 'Environmental enrichment',
      'space_per_bird': 'Space per bird',
      'space_per_pig': 'Space per pig',
      'ventilation': 'Ventilation',
      'temperature': 'Temperature',
      'temperature_facility': 'Facility temperature',
      'litter_quality': 'Litter quality',
      'floor_quality': 'Floor quality',
      'lighting': 'Lighting',
      'resting_area': 'Resting area',
      'staff_training': 'Staff training',
      'records': 'Records',
      'biosecurity': 'Biosecurity',
      'handling': 'Handling',
      'castration': 'Castration',
    };

    final labels = language == 'en' ? labelsEn : labelsEs;
    return labels[fieldId] ?? fieldId;
  }

  Widget _buildStrongPointCard(BuildContext context, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BianTheme.successGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BianTheme.successGreen.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: BianTheme.successGreen,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(BuildContext context, String recommendation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BianTheme.infoBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BianTheme.infoBlue.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_outline,
            color: BianTheme.infoBlue,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              recommendation,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCard(BuildContext context, String text, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIAnalysisButton(
    BuildContext context,
    AppLocalizations loc,
    double overallScore,
    Map<String, double> categoryScores,
    List criticalPoints,
    List strongPoints,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF8F9FA),
            Color(0xFFFFFFFF),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: BianTheme.primaryRed.withOpacity(0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: BianTheme.primaryRed.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            final connectivityService =
                Provider.of<ConnectivityService>(context, listen: false);
            final hasConnection = await connectivityService.checkConnection();

            if (!hasConnection) {
              if (!context.mounted) return;
              CustomSnackbar.showError(
                context,
                evaluation.language == 'es'
                    ? 'Necesitas conexión a internet'
                    : 'You need internet connection',
              );
              return;
            }

            if (!context.mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AIChatScreen(
                  speciesType: species.id,
                  overallScore: overallScore,
                  categoryScores: categoryScores,
                  criticalPoints: criticalPoints,
                  strongPoints: strongPoints,
                  language: evaluation.language,
                  formResponses: evaluation.responses,
                  farmName: evaluation.farmName,
                  farmLocation: evaluation.farmLocation,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      BianTheme.primaryRed,
                      BianTheme.primaryRed.withOpacity(0.8),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: BianTheme.primaryRed.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      evaluation.language == 'es'
                          ? '¿Más detalles?'
                          : 'Want more details?',
                      style: TextStyle(
                        color: BianTheme.darkGray,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      evaluation.language == 'es'
                          ? 'Pregunta lo que quieras sobre tu reporte'
                          : 'Ask anything about your report',
                      style: TextStyle(
                        color: BianTheme.mediumGray,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: BianTheme.primaryRed.withOpacity(0.6),
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
