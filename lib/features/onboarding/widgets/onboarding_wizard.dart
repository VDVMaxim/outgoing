import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';

abstract class OnboardingStep {
  Widget build(BuildContext context, VoidCallback onStateRefresh);
  String? validate(BuildContext context);
  VoidCallback? onNextPressed;

  void setOnNextCallback(VoidCallback? callback) {
    onNextPressed = callback;
  }
}

typedef NextButtonTextBuilder =
    String Function(BuildContext context, int currentStep, int totalSteps);

class OnboardingWizard extends StatefulWidget {
  final List<OnboardingStep> steps;
  final VoidCallback onComplete;
  final bool showProgressIndicator;
  final bool Function(int currentStep, int totalSteps)?
      showProgressIndicatorForStep;
  final bool showBackButton;
  final bool showNextButton;
  final bool Function(int currentStep, int totalSteps)? showNextButtonForStep;
  final dynamic nextButtonText;
  final String? backButtonText;
  final bool swipeable;

  const OnboardingWizard({
    super.key,
    required this.steps,
    required this.onComplete,
    this.showProgressIndicator = true,
    this.showProgressIndicatorForStep,
    this.showBackButton = true,
    this.showNextButton = true,
    this.showNextButtonForStep,
    this.nextButtonText,
    this.backButtonText,
    this.swipeable = true,
  });

  @override
  // FIX: Verwijzing is nu publiek (zonder underscore)
  State<OnboardingWizard> createState() => OnboardingWizardState(); 
}

// FIX: Klasse is nu publiek gemaakt door de underscore weg te halen!
class OnboardingWizardState extends State<OnboardingWizard> {
  late PageController _pageController;
  int _currentStep = 0;
  final bool _isLoading = false;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // FIX: Functie is nu publiek zodat de NotificationStep hem kan aanroepen
  void goToNextPage() {
    final currentStep = widget.steps[_currentStep];

    if (currentStep.onNextPressed != null) {
      currentStep.onNextPressed!();
      return;
    }

    final error = currentStep.validate(context);
    if (error != null) {
      setState(() => _validationError = error);
      return;
    }

    setState(() => _validationError = null);

    if (_currentStep < widget.steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    } else {
      widget.onComplete();
    }
  }

  // FIX: Functie is publiek
  void goToPreviousPage() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  // FIX: Functie is publiek
  void refreshCurrentStep() {
    setState(() {});
  }

  bool get _shouldShowNextButton {
    if (!widget.showNextButton) return false;
    if (widget.showNextButtonForStep != null) {
      return widget.showNextButtonForStep!(_currentStep, widget.steps.length);
    }
    return true;
  }

  bool get _shouldShowProgressIndicator {
    if (!widget.showProgressIndicator) return false;
    if (widget.showProgressIndicatorForStep != null) {
      return widget.showProgressIndicatorForStep!(
        _currentStep,
        widget.steps.length,
      );
    }
    return true;
  }

  String _getNextButtonText(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isLastStep = _currentStep == widget.steps.length - 1;

    if (widget.nextButtonText is NextButtonTextBuilder) {
      return (widget.nextButtonText as NextButtonTextBuilder)(
        context,
        _currentStep,
        widget.steps.length,
      );
    }

    if (widget.nextButtonText != null) {
      return widget.nextButtonText as String;
    }

    return isLastStep ? l10n.onboardingStartExploring : l10n.onboardingNext;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: widget.showBackButton
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: _currentStep > 0
                  ? IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      onPressed: goToPreviousPage, // Gebruik de publieke functie
                    )
                  : null,
              title: Text(
                l10n.onboardingSetupTitle,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            )
          : null,
      body: SafeArea(
        child: Column(
          children: [
            if (_shouldShowProgressIndicator) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Row(
                  children: List.generate(widget.steps.length, (index) {
                    final isCompleted = index < _currentStep;
                    final isCurrent = index == _currentStep;
                    return Expanded(
                      child: Container(
                        height: 4,
                        margin: EdgeInsets.only(
                          right: index < widget.steps.length - 1 ? 4 : 0,
                        ),
                        decoration: BoxDecoration(
                          color: isCompleted || isCurrent
                              ? Colors.blueAccent
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: widget.swipeable
                    ? const BouncingScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() => _currentStep = index);
                },
                children: widget.steps.map((step) {
                  return step.build(context, refreshCurrentStep); // Gebruik publieke functie
                }).toList(),
              ),
            ),
            if (_validationError != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  _validationError!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
            ],
            if (_shouldShowNextButton) ...[
              Padding(
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ShadButton(
                    onPressed: _isLoading ? null : goToNextPage, // Gebruik publieke functie
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            _getNextButtonText(context),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}