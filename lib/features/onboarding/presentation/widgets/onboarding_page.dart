import 'package:ai_travel/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class OnboardingModel {
  final String title;
  final String description;
  final List<String> images;

  OnboardingModel({
    required this.title,
    required this.description,
    required this.images,
  });
}

class OnboardingPages extends StatelessWidget {
  final OnboardingModel item;
  final int index;

  const OnboardingPages({super.key, required this.item, required this.index});

  static final List<OnboardingModel> pages = [
    OnboardingModel(
      title: 'Plan trips with AI',
      description:
          'Experience effortless adventure with your personal travel concierge. Just say where.',
      images: [
        'assets/images/onboarding1.png',
        'assets/images/On1.png',
        'assets/images/onboard1.png',
      ],
    ),
    OnboardingModel(
      title: 'Real-time weather & prices',
      description:
          'Stay ahead of the curve with instant updates on local conditions and live currency rates for your journey.',
      images: ['assets/images/onboarding2.png'],
    ),
    OnboardingModel(
      title: 'Save trips, travel offline',
      description:
          'Access your plans, maps, and tickets anywhere in the world—even without data.',
      images: ['assets/images/onboarding3.png'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: index == 0
                ? FirstPageAnimatedImages(images: item.images)
                : SingleAnimatedImage(images: [item.images[0]], index: index),
          ),
        ),
        Text(
          item.title,
          style: AppTypography.headlinemedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
          child: Text(
            item.description,
            style: AppTypography.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }
}

class FirstPageAnimatedImages extends StatefulWidget {
  final List<String> images;

  const FirstPageAnimatedImages({super.key, required this.images});

  @override
  State<FirstPageAnimatedImages> createState() =>
      _FirstPageAnimatedImagesState();
}

class _FirstPageAnimatedImagesState extends State<FirstPageAnimatedImages>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _float;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _float = Tween<double>(
      begin: -12,
      end: 12,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.images;
    if (images.length < 2) {
      return const SizedBox.shrink();
    }

    return Center(
      child: SizedBox(
        height: 300,
        width: 300,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            AnimatedBuilder(
              animation: _float,
              builder: (context, child) {
                return Positioned(
                  height: 270,
                  width: 300,
                  child: Transform.translate(
                    offset: Offset(0, _float.value),
                    child: child,
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.asset(images[0], fit: BoxFit.cover),
              ),
            ),
            // Second image, top-left — static
            Positioned(
              top: -10,
              left: -40,
              child: Transform.rotate(
                angle: -0.10,
                child: SizedBox(
                  height: 120,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.asset(images[1], fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            // Third image, top-right — static
            if (images.length > 2)
              Positioned(
                top: 266,
                right: -40,
                child: Transform.rotate(
                  angle: 0.10,
                  child: SizedBox(
                    height: 120,
                    width: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.asset(images[2], fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SingleAnimatedImage extends StatefulWidget {
  final List<String> images;
  final int index;
  const SingleAnimatedImage({
    super.key,
    required this.images,
    required this.index,
  });

  @override
  State<SingleAnimatedImage> createState() => _SingleAnimatedImageState();
}

class _SingleAnimatedImageState extends State<SingleAnimatedImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _float;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _float = Tween<double>(
      begin: -12,
      end: 12,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double imageHeight = widget.index == 1
        ? 210.0
        : (widget.index == 2 ? 400.0 : 250.0);
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: _float,
          builder: (context, child) => Transform.translate(
            offset: Offset(0, _float.value),
            child: child,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24.0),
            child: Image.asset(
              widget.images.first,
              height: imageHeight,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}