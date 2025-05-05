// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:karnova/services/gemini_ai_service.dart';

/// A widget that attempts to load an image from a URL and falls back to AI-generated image if loading fails.
class AIImage extends ConsumerStatefulWidget {
  final String imageUrl;
  final String fallbackPrompt;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const AIImage({
    super.key,
    required this.imageUrl,
    required this.fallbackPrompt,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  ConsumerState<AIImage> createState() => _AIImageState();
}

class _AIImageState extends ConsumerState<AIImage> {
  bool _isLoading = false;
  bool _hasError = false;
  String? _generatedImageUrl;

  @override
  Widget build(BuildContext context) {
    // Check if we already have a generated image for this prompt in the cache
    final generatedImages = ref.watch(generatedImagesProvider);
    if (_generatedImageUrl == null && generatedImages.containsKey(widget.fallbackPrompt)) {
      _generatedImageUrl = generatedImages[widget.fallbackPrompt];
    }

    // If we have a generated image, use it
    if (_generatedImageUrl != null) {
      return _buildImageWithBorderRadius(
        Image.network(
          _generatedImageUrl!,
          fit: widget.fit,
          width: widget.width,
          height: widget.height,
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorPlaceholder();
          },
        ),
      );
    }

    // If we're loading, show a loading indicator
    if (_isLoading) {
      return _buildImageWithBorderRadius(
        Container(
          width: widget.width,
          height: widget.height,
          color: Colors.grey[300],
          child: Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      );
    }

    // If we had an error and haven't generated an image yet, show error placeholder
    if (_hasError) {
      return _buildImageWithBorderRadius(_buildErrorPlaceholder());
    }

    // Otherwise, try to load the original image
    return _buildImageWithBorderRadius(
      Image.network(
        widget.imageUrl,
        fit: widget.fit,
        width: widget.width,
        height: widget.height,
        errorBuilder: (context, error, stackTrace) {
          // If the image fails to load, generate an AI image
          _generateAIImage();
          return Container(
            width: widget.width,
            height: widget.height,
            color: Colors.grey[300],
            child: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageWithBorderRadius(Widget child) {
    if (widget.borderRadius != null) {
      return ClipRRect(
        borderRadius: widget.borderRadius!,
        child: child,
      );
    }
    return child;
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.grey[300],
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.image_not_supported,
              size: 40.sp,
              color: Colors.grey[600],
            ),
            SizedBox(height: 8.h),
            Text(
              'Image not available',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generateAIImage() async {
    if (_isLoading || _generatedImageUrl != null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Set the loading state in the provider
      ref.read(imageGenerationLoadingProvider.notifier).state = true;

      // Generate the image
      final geminiService = ref.read(geminiAIServiceProvider);
      final imageUrl = await geminiService.generateImage(
        prompt: widget.fallbackPrompt,
      );

      // Cache the generated image
      final generatedImagesNotifier = ref.read(generatedImagesProvider.notifier);
      generatedImagesNotifier.state = {
        ...generatedImagesNotifier.state,
        widget.fallbackPrompt: imageUrl,
      };

      // Update the state
      if (mounted) {
        setState(() {
          _generatedImageUrl = imageUrl;
          _isLoading = false;
          _hasError = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    } finally {
      // Reset the loading state
      ref.read(imageGenerationLoadingProvider.notifier).state = false;
    }
  }
}
