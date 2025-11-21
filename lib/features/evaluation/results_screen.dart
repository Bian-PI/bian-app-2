// lib/features/evaluation/results_screen.dart

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/models/evaluation_model.dart';
import '../../core/models/species_model.dart';
import '../../core/theme/bian_theme.dart';
import '../../core/localization/app_localizations.dart';

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

  void _showPDFOptions(BuildContext context) {
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
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
              'Opciones de Reporte PDF',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            
            // Opción: Descargar PDF
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
              title: const Text('Descargar PDF'),
              subtitle: const Text('Guardar en el dispositivo'),
              onTap: () {
                Navigator.pop(context);
                _downloadPDF(context);
              },
            ),
            
            const SizedBox(height: 8),
            
            // Opción: Compartir PDF
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
              title: const Text('Compartir PDF'),
              subtitle: const Text('WhatsApp, Gmail, Drive, etc.'),
              onTap: () {
                Navigator.pop(context);
                _generateAndSharePDF(context);
              },
            ),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ✅ ANIMACIÓN MEJORADA
  void _showLoadingDialog(BuildContext context, AppLocalizations loc) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (context) => Center(
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
                  'Por favor espera...',
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
    );
  }

  // ✅ GUARDAR PDF MEJORADO - Guarda en Descargas/Downloads
  Future<void> _downloadPDF(BuildContext context) async {
    final loc = AppLocalizations.of(context);
    
    _showLoadingDialog(context, loc);

    try {
      final pdf = await _buildPDF(context);
      
      Directory? directory;
      if (Platform.isAndroid) {
        // En Android, usar directorio de Descargas
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = await getDownloadsDirectory();
      }
      
      final fileName = 'BIAN_${evaluation.farmName.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${directory!.path}/$fileName');
      await file.writeAsBytes(await pdf.save());

      if (!context.mounted) return;
      Navigator.pop(context); // Cerrar loading

      // Mostrar diálogo de éxito mejorado
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: BianTheme.successGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: BianTheme.successGreen,
                  size: 32,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  '¡PDF Guardado!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'El PDF se ha guardado exitosamente en:',
                style: TextStyle(fontSize: 14),
              ),
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
                        const Icon(Icons.folder, size: 18, color: BianTheme.primaryRed),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            directory?.path ?? '',
                            style: const TextStyle(
                              fontSize: 11,
                              color: BianTheme.mediumGray,
                              fontWeight: FontWeight.w500,
                            ),
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
                        const Icon(Icons.description, size: 18, color: BianTheme.primaryRed),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            fileName,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
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
                  border: Border.all(color: BianTheme.infoBlue.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 20, color: BianTheme.infoBlue),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        Platform.isAndroid
                            ? 'Busca en la carpeta "Descargas" o "Downloads" de tu dispositivo'
                            : 'Busca en la carpeta de Documentos de tu dispositivo',
                        style: const TextStyle(fontSize: 11, color: BianTheme.darkGray),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.pop(context);
                await Share.shareXFiles(
                  [XFile(file.path)],
                  text: '${loc.translate('evaluation_results')} - ${evaluation.farmName}',
                );
              },
              icon: const Icon(Icons.share),
              label: const Text('Compartir'),
              style: ElevatedButton.styleFrom(
                backgroundColor: BianTheme.infoBlue,
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context); // Cerrar loading
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text('Error al generar PDF: $e')),
            ],
          ),
          backgroundColor: BianTheme.errorRed,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> _generateAndSharePDF(BuildContext context) async {
    final loc = AppLocalizations.of(context);
    
    _showLoadingDialog(context, loc);

    try {
      final pdf = await _buildPDF(context);
      final output = await getTemporaryDirectory();
      final fileName = 'BIAN_${evaluation.farmName.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${output.path}/$fileName');
      await file.writeAsBytes(await pdf.save());

      if (!context.mounted) return;
      Navigator.pop(context); // Cerrar loading

      // Compartir
      await Share.shareXFiles(
        [XFile(file.path)],
        text: '${loc.translate('evaluation_results')} - ${evaluation.farmName}',
      );

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text(loc.translate('pdf_generated'))),
            ],
          ),
          backgroundColor: BianTheme.successGreen,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context); // Cerrar loading
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text('Error al generar PDF: $e')),
            ],
          ),
          backgroundColor: BianTheme.errorRed,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  Future<pw.Document> _buildPDF(BuildContext context) async {
    final loc = AppLocalizations.of(context);
    final pdf = pw.Document();
    
    final overallScore = results['overall_score'] as double;
    final complianceLevel = results['compliance_level'] as String;
    final categoryScores = results['category_scores'] as Map<String, double>;
    final criticalPoints = results['critical_points'] as List;
    final strongPoints = results['strong_points'] as List;
    final recommendations = structuredJson['recommendations'] as List;

    // Color basado en score
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

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          // Header
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              gradient: pw.LinearGradient(
                colors: [
                  PdfColor.fromInt(0xFFEC1C21),
                  PdfColor.fromInt(0xFFB71C1C),
                ],
              ),
              borderRadius: pw.BorderRadius.circular(12),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'BIAN',
                  style: pw.TextStyle(
                    fontSize: 32,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  loc.translate('app_name'),
                  style: const pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.white,
                  ),
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 24),

          // Título
          pw.Text(
            loc.translate('evaluation_results'),
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.SizedBox(height: 20),

          // Score general
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              color: scoreColor.flatten(),
              borderRadius: pw.BorderRadius.circular(12),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  loc.translate('overall_score'),
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                ),
                pw.Text(
                  '${overallScore.toStringAsFixed(1)}%',
                  style: pw.TextStyle(
                    fontSize: 32,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 8),

          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: scoreColor),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Text(
              '${loc.translate('compliance_level')}: ${loc.translate(complianceLevel)}',
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                color: scoreColor,
              ),
            ),
          ),

          pw.SizedBox(height: 24),

          // Información de la granja
          pw.Text(
            loc.translate('farm_information'),
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.SizedBox(height: 12),

          _buildInfoRow(loc.translate('farm_name'), evaluation.farmName),
          _buildInfoRow(loc.translate('location'), evaluation.farmLocation),
          _buildInfoRow(loc.translate('evaluator_name'), evaluation.evaluatorName),
          _buildInfoRow(
            loc.translate('evaluation_date'),
            '${evaluation.evaluationDate.day}/${evaluation.evaluationDate.month}/${evaluation.evaluationDate.year}',
          ),
          _buildInfoRow(loc.translate('species'), species.namePlural),

          pw.SizedBox(height: 24),

          // Scores por categoría
          pw.Text(
            loc.translate('category_scores'),
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.SizedBox(height: 12),

          ...species.categories.map((category) {
            final score = categoryScores[category.id] ?? 0.0;
            return _buildCategoryScore(
              loc.translate(category.id),
              score,
            );
          }),

          pw.SizedBox(height: 24),

          // Puntos Críticos
          pw.Text(
            loc.translate('critical_points'),
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.SizedBox(height: 12),

          if (criticalPoints.isEmpty)
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromInt(0xFFF5F5F5),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Text(
                loc.translate('no_critical_points'),
                style: const pw.TextStyle(fontSize: 12),
              ),
            )
          else
            ...criticalPoints.map((point) {
              final parts = point.toString().split('_');
              final categoryId = parts[0];
              final fieldId = parts.sublist(1).join('_');
              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 8),
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromInt(0xFFFFEBEE),
                  borderRadius: pw.BorderRadius.circular(8),
                  border: pw.Border.all(
                    color: PdfColor.fromInt(0xFFD32F2F),
                  ),
                ),
                child: pw.Row(
                  children: [
                    pw.Container(
                      width: 8,
                      height: 8,
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromInt(0xFFD32F2F),
                        shape: pw.BoxShape.circle,
                      ),
                    ),
                    pw.SizedBox(width: 12),
                    pw.Expanded(
                      child: pw.Text(
                        '${loc.translate(categoryId)}: ${loc.translate(fieldId)}',
                        style: const pw.TextStyle(fontSize: 11),
                      ),
                    ),
                  ],
                ),
              );
            }),

          pw.SizedBox(height: 24),

          // Puntos Fuertes
          pw.Text(
            loc.translate('strong_points'),
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.SizedBox(height: 12),

          if (strongPoints.isEmpty)
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromInt(0xFFF5F5F5),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Text(
                loc.translate('no_strong_points'),
                style: const pw.TextStyle(fontSize: 12),
              ),
            )
          else
            ...strongPoints.map((point) {
              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 8),
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromInt(0xFFE8F5E9),
                  borderRadius: pw.BorderRadius.circular(8),
                  border: pw.Border.all(
                    color: PdfColor.fromInt(0xFF4CAF50),
                  ),
                ),
                child: pw.Row(
                  children: [
                    pw.Container(
                      width: 8,
                      height: 8,
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromInt(0xFF4CAF50),
                        shape: pw.BoxShape.circle,
                      ),
                    ),
                    pw.SizedBox(width: 12),
                    pw.Expanded(
                      child: pw.Text(
                        loc.translate(point.toString()),
                        style: const pw.TextStyle(fontSize: 11),
                      ),
                    ),
                  ],
                ),
              );
            }),

          pw.SizedBox(height: 24),

          // Recomendaciones
          pw.Text(
            loc.translate('recommendations'),
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.SizedBox(height: 12),

          ...List.generate(recommendations.length, (index) {
            return pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 12),
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromInt(0xFFE3F2FD),
                borderRadius: pw.BorderRadius.circular(8),
                border: pw.Border.all(
                  color: PdfColor.fromInt(0xFF2196F3),
                ),
              ),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    '${index + 1}. ',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromInt(0xFF2196F3),
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Text(
                      recommendations[index].toString(),
                      style: const pw.TextStyle(fontSize: 11),
                    ),
                  ),
                ],
              ),
            );
          }),

          pw.SizedBox(height: 32),

          // Footer
          pw.Divider(),
          pw.SizedBox(height: 8),
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
        ],
      ),
    );

    return pdf;
  }

  pw.Widget _buildInfoRow(String label, String value) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 8),
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromInt(0xFFF5F5F5),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(
            value,
            style: const pw.TextStyle(fontSize: 11),
          ),
        ],
      ),
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
      margin: const pw.EdgeInsets.only(bottom: 12),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                categoryName,
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                '${score.toStringAsFixed(1)}%',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  color: barColor,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 6),
          pw.Container(
            height: 10,
            decoration: pw.BoxDecoration(
              color: PdfColor.fromInt(0xFFE0E0E0),
              borderRadius: pw.BorderRadius.circular(5),
            ),
            child: pw.Align(
              alignment: pw.Alignment.centerLeft,
              child: pw.Container(
                width: 500 * (score / 100),
                decoration: pw.BoxDecoration(
                  color: barColor,
                  borderRadius: pw.BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final overallScore = results['overall_score'] as double;
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
            
            // Puntos Críticos
            Text(
              loc.translate('critical_points'),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            if (criticalPoints.isEmpty)
              _buildEmptyCard(context, loc.translate('no_critical_points'), BianTheme.successGreen)
            else
              ...criticalPoints.take(10).map((point) {
                final parts = point.toString().split('_');
                final categoryId = parts[0];
                final fieldId = parts.sublist(1).join('_').replaceAll('_pigs', '').replaceAll('_birds', '');
                return _buildCriticalPointCard(context, loc, categoryId, fieldId);
              }),
            
            const SizedBox(height: 24),
            
            // Puntos Fuertes
            Text(
              loc.translate('strong_points'),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            if (strongPoints.isEmpty)
              _buildEmptyCard(context, loc.translate('no_strong_points'), BianTheme.mediumGray)
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
            ...recommendations.map((rec) => _buildRecommendationCard(context, rec.toString())),
            
            const SizedBox(height: 32),
            
            ElevatedButton(
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

  Widget _buildCategoryScoreCard(BuildContext context, AppLocalizations loc, String categoryId, double score) {
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

  Widget _buildCriticalPointCard(BuildContext context, AppLocalizations loc, String categoryId, String fieldId) {
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
    
    // Mapeo de IDs a etiquetas
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
}