import 'package:flutter/material.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final Map<int, bool> completedSteps;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.completedSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: List.generate(totalSteps * 2 - 1, (index) {
          if (index.isOdd) {
            return Expanded(
              child: Container(
                height: 3,
                color: _isStepCompleted(index ~/ 2)
                    ? Colors.blueAccent
                    : Colors.grey[300],
              ),
            );
          } else {
            final stepIndex = index ~/ 2;
            return _StepDot(
              stepNumber: stepIndex + 1,
              isCompleted: _isStepCompleted(stepIndex),
              isCurrent: stepIndex == currentStep,
            );
          }
        }),
      ),
    );
  }

  bool _isStepCompleted(int stepIndex) {
    return completedSteps[stepIndex] == true || stepIndex < currentStep;
  }
}

class _StepDot extends StatelessWidget {
  final int stepNumber;
  final bool isCompleted;
  final bool isCurrent;

  const _StepDot({
    required this.stepNumber,
    required this.isCompleted,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: isCurrent ? 1.2 : 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: isCurrent ? 32 : 24,
        height: isCurrent ? 32 : 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCompleted ? Colors.blueAccent : Colors.transparent,
          border: Border.all(
            color: isCompleted || isCurrent
                ? Colors.blueAccent
                : Colors.grey[400]!,
            width: 2,
          ),
          boxShadow: isCurrent
              ? [
                  BoxShadow(
                    color: Colors.blueAccent.withValues(alpha: 0.4),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: isCompleted
              ? const Icon(Icons.check, color: Colors.white, size: 16)
              : Text(
                  '$stepNumber',
                  style: TextStyle(
                    color: isCurrent ? Colors.blueAccent : Colors.grey[600],
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
        ),
      ),
    );
  }
}
