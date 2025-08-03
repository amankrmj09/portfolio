import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'animated_typer_text.dart';

class CodeBlock extends StatefulWidget {
  const CodeBlock({super.key});

  @override
  State<CodeBlock> createState() => _CodeBlockState();
}

class _CodeBlockState extends State<CodeBlock>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _slideEditor;

  @override
  void initState() {
    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    )..forward();
    _slideEditor = Tween<double>(
      begin: 0,
      end: -20,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          builder: (context, child) {
            return Positioned(
              left: _slideEditor.value,
              top: _slideEditor.value,
              child: child!,
            );
          },
          animation: _slideEditor,
          child: Opacity(opacity: 0.4, child: Editor(isBackground: true)),
        ),
        Editor(),
      ],
    );
  }
}

class Editor extends StatelessWidget {
  Editor({super.key, this.isBackground = false});

  final bool isBackground;
  final btnColors = [Colors.yellow, Colors.green, Colors.red];

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: InkWell(
        onTap: () {
          Get.toNamed('/cli');
        },
        child: Container(
          width: 400,
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(width: 1, color: Colors.black12),
            color: Colors.black,
          ),
          padding: const EdgeInsets.all(12.0),
          margin: const EdgeInsets.only(left: 25.0, top: 25.0, bottom: 25.0),
          child: isBackground
              ? SizedBox()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ...btnColors.map(
                          (color) => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.circle, size: 14, color: color),
                              SizedBox(width: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                    AnimatedTyperText(
                      lines: [
                        '\$ find / name -"life.dart"\n',
                        '> Searching . . .\n',
                        '> Error: No life is found!\n',
                        '> Since you are a programmer, you have no life!',
                      ],
                      styles: [
                        Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'ShantellSans',
                        ),
                        TextStyle(
                          color: Colors.yellow,
                          fontSize: 16,
                          fontFamily: 'ShantellSans',
                        ),
                        TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontFamily: 'ShantellSans',
                          fontWeight: FontWeight.bold,
                        ),
                        TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontFamily: 'ShantellSans',
                          fontStyle: FontStyle.italic,
                        ),
                      ],
                      width: 400,
                      speed: const Duration(milliseconds: 60),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
