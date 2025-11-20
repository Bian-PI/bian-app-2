// lib/features/evaluation/results_screen.dart

import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final overallScore = results['overall_score'] as double;
    final complianceLevel = results['compliance_level'] as String;
    final categoryScores = results['category_scores'] as Map<String, double>;
    final recommendations = structuredJson['recommendations'] as List;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('evaluation_results')),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: null, // ✅ Sin acción por ahora
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildScoreHeader(context, overallScore, complianceLevel),
            
            SizedBox(height: 24),
            
            _buildInfoCard(context, loc),
            
            SizedBox(height: 24),
            
            Text(
              loc.translate('category_scores'),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 16),
            ...species.categories.map((category) {
              final score = categoryScores[category.id] ?? 0.0;
              return _buildCategoryScore(context, loc, category.id, score);
            }),
            
            SizedBox(height: 24),
            
            Text(
              loc.translate('recommendations'),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 16),
            ...recommendations.map((rec) => _buildRecommendationCard(context, rec.toString())),
            
            SizedBox(height: 32),
            
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
      scoreColor = Color(0xFF4CAF50);
      scoreIcon = Icons.thumb_up;
    } else if (score >= 60) {
      scoreColor = BianTheme.warningYellow;
      scoreIcon = Icons.warning_amber;
    } else {
      scoreColor = BianTheme.errorRed;
      scoreIcon = Icons.error_outline;
    }

    return Container(
      padding: EdgeInsets.all(24),
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
          SizedBox(height: 16),
          Text(
            '${score.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              loc.translate(level),
              style: TextStyle(
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
      padding: EdgeInsets.all(16),
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
              Icon(Icons.business, color: BianTheme.primaryRed),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.translate('farm_name'),
                      style: TextStyle(
                        fontSize: 12,
                        color: BianTheme.mediumGray,
                      ),
                    ),
                    Text(
                      evaluation.farmName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(height: 24),
          Row(
            children: [
              Icon(Icons.location_on, color: BianTheme.primaryRed),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.translate('location'),
                      style: TextStyle(
                        fontSize: 12,
                        color: BianTheme.mediumGray,
                      ),
                    ),
                    Text(
                      evaluation.farmLocation,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(height: 24),
          Row(
            children: [
              Icon(Icons.person, color: BianTheme.primaryRed),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.translate('evaluator_name'),
                      style: TextStyle(
                        fontSize: 12,
                        color: BianTheme.mediumGray,
                      ),
                    ),
                    Text(
                      evaluation.evaluatorName,
                      style: TextStyle(
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

  Widget _buildCategoryScore(BuildContext context, AppLocalizations loc, String categoryId, double score) {
    Color barColor;
    if (score >= 80) {
      barColor = BianTheme.successGreen;
    } else if (score >= 60) {
      barColor = BianTheme.warningYellow;
    } else {
      barColor = BianTheme.errorRed;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
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
                style: TextStyle(
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
          SizedBox(height: 12),
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

  Widget _buildRecommendationCard(BuildContext context, String recommendation) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BianTheme.infoBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BianTheme.infoBlue.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: BianTheme.infoBlue,
            size: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              recommendation,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}