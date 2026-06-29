import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/core/diagnostics/models/diagnosis.dart';
import 'package:flutter/material.dart';

class DiagnosisResultSheet extends StatelessWidget {
  final Diagnosis diagnosis;

  const DiagnosisResultSheet({super.key, required this.diagnosis});

  static Future<void> show(BuildContext context, Diagnosis diagnosis) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DiagnosisResultSheet(diagnosis: diagnosis),
    );
  }

  Color get _statusColor =>
      diagnosis.isAnomaly ? AppColors.red : AppColors.green;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _statusColor.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      diagnosis.isAnomaly
                          ? Icons.warning_amber_rounded
                          : Icons.check_circle_outline,
                      color: _statusColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          diagnosis.isAnomaly ? 'Anomaly Detected' : 'All Normal',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.black,
                          ),
                        ),
                        Text(
                          'Confidence: ${diagnosis.confidence}',
                          style: TextStyle(
                            color: AppColors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _InfoTile(
                label: 'Message',
                value: diagnosis.message,
              ),
              if (diagnosis.likelySystem != null &&
                  diagnosis.likelySystem!.isNotEmpty)
                _InfoTile(
                  label: 'Likely System',
                  value: diagnosis.likelySystem!,
                ),
              _InfoTile(
                label: 'Anomaly Score',
                value: diagnosis.anomalyScore.toStringAsFixed(2),
              ),
              _InfoTile(
                label: 'Threshold',
                value: diagnosis.threshold.toStringAsFixed(2),
              ),
              _InfoTile(
                label: 'Baseline Used',
                value: diagnosis.baselineUsed,
              ),
              if (diagnosis.windowSize != null)
                _InfoTile(
                  label: 'Window Size',
                  value: diagnosis.windowSize.toString(),
                ),
              const SizedBox(height: 12),
              Text(
                'Health Gate',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 8),
              _HealthGateCard(gate: diagnosis.healthGate),
              if (diagnosis.topDeviations.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Top Deviations',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 8),
                ...diagnosis.topDeviations.map(
                  (deviation) => _DeviationTile(deviation: deviation),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _HealthGateCard extends StatelessWidget {
  final HealthGate gate;

  const _HealthGateCard({required this.gate});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: (gate.passed ? AppColors.green : AppColors.red).withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (gate.passed ? AppColors.green : AppColors.red).withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            gate.passed ? 'Passed' : 'Failed',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: gate.passed ? AppColors.green : AppColors.red,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'MIL on: ${gate.milOn ? 'Yes' : 'No'}',
            style: TextStyle(color: AppColors.black, fontSize: 13),
          ),
          if (gate.dtcCodes.isNotEmpty)
            Text(
              'DTC codes: ${gate.dtcCodes.join(', ')}',
              style: TextStyle(color: AppColors.black, fontSize: 13),
            ),
        ],
      ),
    );
  }
}

class _DeviationTile extends StatelessWidget {
  final FeatureDeviation deviation;

  const _DeviationTile({required this.deviation});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.pink.withOpacity(0.25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deviation.feature,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                    fontSize: 13,
                  ),
                ),
                Text(
                  deviation.system,
                  style: TextStyle(color: AppColors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
          Text(
            'z=${deviation.zScore.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.red,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
