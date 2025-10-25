import 'dart:ui';

import 'package:portfolio/configs/constant_strings.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class KInfiniteScrollImage extends StatefulWidget {
  final List<String> images;
  final double height;
  final double imageWidth;
  final double scrollSpeed; // ✅ NEW: pixels per second (30-100 recommended)
  final String direction; // 'horizontal' or 'vertical'

  const KInfiniteScrollImage({
    super.key,
    required this.images,
    this.height = 120,
    this.imageWidth = 180,
    this.scrollSpeed = 50, // ✅ NEW: Default 50 pixels/second
    this.direction = 'horizontal',
  });

  @override
  State<KInfiniteScrollImage> createState() => _KInfiniteScrollImageState();
}

class _KInfiniteScrollImageState extends State<KInfiniteScrollImage>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final AnimationController _animationController;
  bool _isHovering = false;

  Axis get _axis =>
      widget.direction == 'vertical' ? Axis.vertical : Axis.horizontal;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController.unbounded(vsync: this)
      ..addListener(_onAnimate);
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScrolling());
  }

  void _onAnimate() {
    if (!_scrollController.hasClients || _isHovering) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentValue = _animationController.value;

    // Seamless loop at 2/3 point (middle of repeated content)
    if (currentValue >= maxScroll * 2 / 3) {
      final remainder = currentValue - (maxScroll * 2 / 3);
      _scrollController.jumpTo(remainder);
      _animationController.value = remainder;
    } else {
      _scrollController.jumpTo(currentValue);
    }
  }

  void _startScrolling() {
    if (!_isHovering) {
      if (_scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentOffset = _scrollController.offset;
        final targetScroll = maxScroll * 2 / 3;

        // Calculate remaining distance from current position
        final remainingDistance = targetScroll - currentOffset;

        // If we're past the loop point, normalize position
        double startPosition = currentOffset;
        if (currentOffset >= targetScroll) {
          startPosition = currentOffset - targetScroll;
          _scrollController.jumpTo(startPosition);
        }

        // ✅ CHANGED: Calculate duration based on scrollSpeed (pixels per second)
        final adjustedDuration = Duration(
          milliseconds: ((remainingDistance / widget.scrollSpeed) * 1000)
              .round(),
        );

        // Start animation from current position
        _animationController.value = startPosition;
        _animationController
            .animateTo(
              targetScroll,
              duration: adjustedDuration,
              curve: Curves.linear,
            )
            .whenComplete(() {
              if (mounted && !_isHovering) {
                _animationController.value = 0;
                _scrollController.jumpTo(0);
                _startScrolling();
              }
            });
      }
    }
  }

  void _stopScrolling() {
    _animationController.stop();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<Widget> _buildImageWidgets(List<String> images) {
    return images.map((img) {
      return Padding(
        padding: _axis == Axis.horizontal
            ? const EdgeInsets.symmetric(horizontal: 8)
            : const EdgeInsets.symmetric(vertical: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: assetGithubUrl + img,
            height: _axis == Axis.vertical ? widget.height : null,
            width: _axis == Axis.vertical ? widget.imageWidth : null,
            fit: BoxFit.fitHeight,
            memCacheHeight:
                (_axis == Axis.vertical
                        ? widget.height * 0.5
                        : widget.height * 0.1)
                    .toInt(),
            memCacheWidth: _axis == Axis.vertical
                ? (widget.imageWidth * 0.5).toInt()
                : null,
            errorWidget: (c, e, s) => const SizedBox(),
            placeholder: (context, url) => SizedBox(
              width: widget.imageWidth,
              height: widget.height,
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) return const SizedBox();
    const repeatCount = 3;
    final displayImages = List.generate(
      repeatCount,
      (_) => widget.images,
    ).expand((e) => e).toList();

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovering = true);
        _stopScrolling();
      },
      onExit: (_) {
        setState(() => _isHovering = false);
        _startScrolling();
      },
      child: SizedBox(
        height: _axis == Axis.horizontal ? widget.height : double.infinity,
        width: _axis == Axis.horizontal ? double.infinity : widget.imageWidth,
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: _axis == Axis.horizontal
                  ? Alignment.centerLeft
                  : Alignment.topCenter,
              end: _axis == Axis.horizontal
                  ? Alignment.centerRight
                  : Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black,
                Colors.black,
                Colors.transparent,
              ],
              stops: const [0.0, 0.1, 0.9, 1.0],
            ).createShader(bounds);
          },
          blendMode: BlendMode.dstIn,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              scrollbars: false,
              dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
            ),
            child: ListView(
              controller: _scrollController,
              scrollDirection: _axis,
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                _axis == Axis.horizontal
                    ? Row(children: _buildImageWidgets(displayImages))
                    : Column(children: _buildImageWidgets(displayImages)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
