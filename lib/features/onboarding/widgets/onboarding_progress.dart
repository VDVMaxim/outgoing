import 'package:flutter/material.dart';

class OnboardingProgress extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const OnboardingProgress({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(totalSteps, (index) {
            final isCompleted = index < currentStep;
            final isCurrent = index == currentStep;
            final isLast = index == totalSteps - 1;

            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _StepDot(
                      isCompleted: isCompleted,
                      isCurrent: isCurrent,
                    ),
                  ),
                  if (!isLast) _Connector(isCompleted: isCompleted),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Step ${currentStep + 1}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              ' of $totalSteps',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
      ],
    );
  }
}

class _StepDot extends StatelessWidget {
  final bool isCompleted;
  final bool isCurrent;

  const _StepDot({required this.isCompleted, required this.isCurrent});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isCurrent ? 32 : 24,
      height: isCurrent ? 32 : 24,
      decoration: BoxDecoration(
        color: isCompleted || isCurrent ? Colors.blueAccent : Colors.grey[300],
        shape: BoxShape.circle,
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: Colors.blueAccent.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Center(
        child: isCompleted
            ? const Icon(Icons.check, size: 14, color: Colors.white)
            : null,
      ),
    );
  }
}

class _Connector extends StatelessWidget {
  final bool isCompleted;

  const _Connector({required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 24,
      height: 3,
      decoration: BoxDecoration(
        color: isCompleted ? Colors.blueAccent : Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
