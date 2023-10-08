import 'package:flutter/material.dart';
import 'package:localization_plus/src/localization_plus_controller.dart';
import 'package:localization_plus/src/presentation/localization_plus_provider.dart';

class LocalizationPlus extends StatefulWidget {
  final LocalizationPlusController controller;
  final Widget child;

  const LocalizationPlus({
    super.key,
    required this.controller,
    required this.child,
  });

  @override
  State<LocalizationPlus> createState() => _LocalizationPlusState();

  static LocalizationPlusProvider of(BuildContext context) =>
      LocalizationPlusProvider.of(context);
}

class _LocalizationPlusState extends State<LocalizationPlus> {
  @override
  void initState() {
    widget.controller.addListener(() {
      if (mounted) setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller.translationsLoadError != null) {
      return ErrorWidget(widget.controller.translationsLoadError);
    }

    return LocalizationPlusProvider(
      parent: widget,
      controller: widget.controller,
      locale: widget.controller.currentLocale,
    );
  }
}
