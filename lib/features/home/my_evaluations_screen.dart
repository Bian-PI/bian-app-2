import 'package:flutter/material.dart';
import '../../core/models/evaluation_model.dart';
import '../../core/theme/bian_theme.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/api/api_service.dart';
import '../../core/widgets/custom_snackbar.dart';
import '../../core/storage/reports_storage.dart';
import '../../core/storage/local_reports_storage.dart';
import '../../core/storage/secure_storage.dart';
import 'package:intl/intl.dart';

/// Pantalla dedicada para mostrar todas las evaluaciones del usuario actual
/// Separada del HomeScreen para mejor organización y rendimiento
class MyEvaluationsScreen extends StatefulWidget {
  const MyEvaluationsScreen({super.key});

  @override
  State<MyEvaluationsScreen> createState() => _MyEvaluationsScreenState();
}

class _MyEvaluationsScreenState extends State<MyEvaluationsScreen> {
  final _apiService = ApiService();
  final _storage = SecureStorage();

  List<Evaluation> _serverReports = [];
  List<Evaluation> _localReports = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  int _reportTotal = 0;
  int _reportOffset = 0;
  bool _hasMoreReports = false;
  final int _reportLimit = 20;

  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadEvaluations();
  }

  Future<void> _loadEvaluations() async {
    setState(() => _isLoading = true);

    try {
      // Obtener ID del usuario actual
      final user = await _storage.getUser();
      if (user == null) {
        print('⚠️ No hay usuario logueado');
        if (mounted) {
          CustomSnackbar.showError(
            context,
            AppLocalizations.of(context).translate('no_user_logged_in'),
          );
        }
        setState(() => _isLoading = false);
        return;
      }

      _userId = user.id.toString();
      print('👤 Cargando evaluaciones para usuario: ${user.name} (ID: $_userId)');

      // 1. Cargar reportes LOCALES pendientes de sincronización
      final localReports = await LocalReportsStorage.getAllLocalReports();
      print('📦 Reportes locales encontrados: ${localReports.length}');

      // 2. Cargar reportes del servidor filtrados por usuario
      final result = await _apiService.getUserEvaluations(
        limit: _reportLimit,
        offset: 0,
      );

      if (result['success'] == true) {
        final evaluationsData = result['evaluations'] as List;
        final serverReports = evaluationsData
            .map((e) => Evaluation.fromJson(e))
            .toList();

        final total = result['total'] ?? 0;
        final hasMore = result['hasMore'] ?? false;

        print('✅ Reportes del servidor: ${serverReports.length} de $total');

        setState(() {
          _serverReports = serverReports;
          _localReports = localReports;
          _reportTotal = total;
          _hasMoreReports = hasMore;
          _reportOffset = serverReports.length;
          _isLoading = false;
        });
      } else {
        print('⚠️ Error cargando reportes del servidor: ${result['message']}');

        // Fallback: usar cache local
        final cachedReports = await ReportsStorage.getAllReports();
        print('📦 Usando cache local: ${cachedReports.length} reportes');

        setState(() {
          _serverReports = cachedReports;
          _localReports = localReports;
          _isLoading = false;
        });

        if (mounted) {
          CustomSnackbar.showError(
            context,
            AppLocalizations.of(context).translate('error_loading_evaluations'),
          );
        }
      }
    } catch (e) {
      print('❌ Error cargando evaluaciones: $e');
      setState(() => _isLoading = false);

      if (mounted) {
        CustomSnackbar.showError(
          context,
          AppLocalizations.of(context).translate('connection_error'),
        );
      }
    }
  }

  Future<void> _loadMoreReports() async {
    if (_isLoadingMore || !_hasMoreReports) return;

    setState(() => _isLoadingMore = true);

    try {
      final result = await _apiService.getUserEvaluations(
        limit: _reportLimit,
        offset: _reportOffset,
      );

      if (result['success'] == true) {
        final evaluationsData = result['evaluations'] as List;
        final newReports = evaluationsData
            .map((e) => Evaluation.fromJson(e))
            .toList();

        setState(() {
          _serverReports.addAll(newReports);
          _reportOffset += newReports.length;
          _hasMoreReports = result['hasMore'] ?? false;
          _isLoadingMore = false;
        });

        print('✅ Más reportes cargados: +${newReports.length} (total: ${_serverReports.length})');
      }
    } catch (e) {
      print('❌ Error cargando más reportes: $e');
      setState(() => _isLoadingMore = false);

      if (mounted) {
        CustomSnackbar.showError(
          context,
          AppLocalizations.of(context).translate('error_loading_more'),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('my_evaluations')),
        backgroundColor: BianTheme.primaryRed,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadEvaluations,
              child: _buildEvaluationsList(loc),
            ),
    );
  }

  Widget _buildEvaluationsList(AppLocalizations loc) {
    final totalEvaluations = _localReports.length + _serverReports.length;

    if (totalEvaluations == 0) {
      return _buildEmptyState(loc);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: totalEvaluations + (_hasMoreReports ? 1 : 0),
      itemBuilder: (context, index) {
        // Primero mostrar reportes locales
        if (index < _localReports.length) {
          return _buildLocalReportCard(_localReports[index], loc);
        }

        // Luego reportes del servidor
        final serverIndex = index - _localReports.length;
        if (serverIndex < _serverReports.length) {
          return _buildServerReportCard(_serverReports[serverIndex], loc);
        }

        // Botón "Cargar más"
        return _buildLoadMoreButton(loc);
      },
    );
  }

  Widget _buildEmptyState(AppLocalizations loc) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 80,
              color: BianTheme.lightGray,
            ),
            const SizedBox(height: 16),
            Text(
              loc.translate('no_evaluations_yet'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: BianTheme.darkGray,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              loc.translate('start_evaluation_to_see_here'),
              style: TextStyle(
                fontSize: 14,
                color: BianTheme.mediumGray,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocalReportCard(Evaluation evaluation, AppLocalizations loc) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
          color: BianTheme.warningYellow,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          // Navegar a detalles del reporte local
          _showLocalReportDetails(evaluation, loc);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: BianTheme.warningYellow.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.sync,
                          size: 14,
                          color: BianTheme.warningYellow,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          loc.translate('pending_sync'),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: BianTheme.warningYellow,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    evaluation.speciesId == 'birds'
                        ? Icons.grain
                        : Icons.pets,
                    color: BianTheme.primaryRed,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                evaluation.farmName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                evaluation.farmLocation,
                style: TextStyle(
                  fontSize: 13,
                  color: BianTheme.mediumGray,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: BianTheme.mediumGray,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('dd/MM/yyyy').format(evaluation.evaluationDate),
                    style: TextStyle(
                      fontSize: 12,
                      color: BianTheme.mediumGray,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServerReportCard(Evaluation evaluation, AppLocalizations loc) {
    final score = evaluation.overallScore ?? 0.0;
    Color scoreColor;
    if (score >= 90) {
      scoreColor = BianTheme.successGreen;
    } else if (score >= 75) {
      scoreColor = const Color(0xFF4CAF50);
    } else if (score >= 60) {
      scoreColor = BianTheme.warningYellow;
    } else {
      scoreColor = BianTheme.errorRed;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Navegar a detalles del reporte
          _showServerReportDetails(evaluation, loc);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: scoreColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${score.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: scoreColor,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    evaluation.speciesId == 'birds'
                        ? Icons.grain
                        : Icons.pets,
                    color: BianTheme.primaryRed,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                evaluation.farmName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                evaluation.farmLocation,
                style: TextStyle(
                  fontSize: 13,
                  color: BianTheme.mediumGray,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: BianTheme.mediumGray,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('dd/MM/yyyy').format(evaluation.evaluationDate),
                    style: TextStyle(
                      fontSize: 12,
                      color: BianTheme.mediumGray,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.cloud_done,
                    size: 14,
                    color: BianTheme.successGreen,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    loc.translate('synced'),
                    style: const TextStyle(
                      fontSize: 12,
                      color: BianTheme.successGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadMoreButton(AppLocalizations loc) {
    if (_isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: OutlinedButton.icon(
          onPressed: _loadMoreReports,
          icon: const Icon(Icons.refresh),
          label: Text(loc.translate('load_more')),
          style: OutlinedButton.styleFrom(
            foregroundColor: BianTheme.primaryRed,
            side: const BorderSide(color: BianTheme.primaryRed),
          ),
        ),
      ),
    );
  }

  void _showLocalReportDetails(Evaluation evaluation, AppLocalizations loc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.translate('local_report')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              evaluation.farmName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${loc.translate('location')}: ${evaluation.farmLocation}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              '${loc.translate('date')}: ${DateFormat('dd/MM/yyyy').format(evaluation.evaluationDate)}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: BianTheme.warningYellow.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: BianTheme.warningYellow,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      loc.translate('pending_sync_message'),
                      style: const TextStyle(fontSize: 12),
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
            child: Text(loc.translate('close')),
          ),
        ],
      ),
    );
  }

  void _showServerReportDetails(Evaluation evaluation, AppLocalizations loc) {
    final score = evaluation.overallScore ?? 0.0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.translate('evaluation_details')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              evaluation.farmName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${loc.translate('score')}: ${score.toStringAsFixed(1)}%',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${loc.translate('location')}: ${evaluation.farmLocation}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              '${loc.translate('date')}: ${DateFormat('dd/MM/yyyy').format(evaluation.evaluationDate)}',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(loc.translate('close')),
          ),
        ],
      ),
    );
  }
}
