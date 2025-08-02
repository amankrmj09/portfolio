import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CliHistoryEntry {
  final String prompt;
  final String text;
  final CliHistoryType type;

  CliHistoryEntry({
    required this.prompt,
    required this.text,
    required this.type,
  });
}

enum CliHistoryType { user, output, error }

class CliController extends GetxController {
  final RxList<CliHistoryEntry> displayHistory =
      <CliHistoryEntry>[].obs; // For display (all lines)
  final RxList<String> commandHistory = <String>[].obs; // Only user commands
  final inputController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  late final String userName;

  final List<String> commands = [
    'help',
    'about',
    'ls',
    'smile',
    'clear',
    'exit',
  ];

  final help = [
    'use help <command> for more details',
    'available commands:',
    'about - Show information about the portfolio',
    'ls - List directories and files',
    'history - Show command history',
    'text format - Format text output in the CLI',
    'clear - Clear the terminal screen',
    'exit - Exit the terminal',
  ];

  void lsCommand() {
    displayHistory.add(
      CliHistoryEntry(
        prompt: prompt,
        text: 'projects/\nskills/\ncontact/',
        type: CliHistoryType.output,
      ),
    );
  }

  final textFormatHelp = [
    'text format -c <color>  | Available colors: blue, white, green, orange, brown, pink',
    'text format -s <size>   | Font size (min: 24, max: 40)',
    'text format -f <family> | Font family (use -f and provide a family, see list)',
  ];

  final aboutCommand = [
    'This is a portfolio CLI application.',
    'It showcases various projects and skills.',
    'Developed using Flutter and GetX.',
    'Feel free to explore the commands.',
  ];

  final exitMessage = ['Thank you for using the portfolio CLI!', 'Goodbye!'];

  final List<String> userNameList = [
    'eren_yeager',
    'mikasa_ackerman',
    'armin_arlert',
    'levi_ackerman',
    'erwin_smith',
    'jean_kirstein',
    'sasha_blouse',
    'connie_springer',
    'historia_reiss',
    'reiner_braun',
    'annie_leonhart',
    'bertolt_hoover',
    'hange_zoe',
    'zeke_yeager',
    'ymir',
    'pieck_finger',
    'porco_galliard',
    'gabi_braun',
    'falco_grice',
    'kenny_ackerman',
    'marco_bott',
    'moblit_berner',
    'petra_ral',
    'mike_zacharias',
    'dot_pixis',
    'nile_dok',
    'floch_forster',
    'rico_brzenska',
    'ilse_langnar',
    'hitch_dreyse',
    'mina_carolina',
    'marlowe_freudenberg',
    'gunther_schultz',
    'olu_bozado',
    'eld_jinn',
    'franz_kefka',
    'hannes',
    'carla_yeager',
    'grisha_yeager',
    'faye_yeager',
    'rod_reiss',
    'uri_reiss',
    'frieda_reiss',
    'kiyomi_azumabito',
    'niccolo',
    'yelena',
    'onyankopon',
    'lara_tybur',
    'willy_tybur',
    'theo_magath',
    'colt_grice',
    'samuel',
    'daz',
    'sina',
    'moses_braun',
    'mina_carolina',
    'thomas_wagner',
    'hugo',
    'boris_feulner',
    'ian_dietrich',
    'mitabi_jarnach',
    'hitch_dreyse',
    'marlowe_freudenberg',
    'nifa',
    'sannes',
    'ralph',
    'gross',
    'kiyomi_azumabito',
    'kiyomi_azumabito',
    'kiyomi_azumabito',
  ];

  String get prompt =>
      'user@[32m${userNameList[0]}\u001b[0m ~ \u001b[36m\$[0m';

  final FocusNode inputFocusNode = FocusNode();
  int historyIndex = -1;

  @override
  void onInit() {
    super.onInit();
    userNameList.shuffle();
    userName = userNameList.first;
    welcomeMessage();
  }

  void helpCommand() {
    displayHistory.add(
      CliHistoryEntry(
        prompt: prompt,
        text: help.join('\n'),
        type: CliHistoryType.output,
      ),
    );
  }

  void historyCommand() {
    if (commandHistory.isEmpty) {
      displayHistory.add(
        CliHistoryEntry(
          prompt: prompt,
          text: 'No command history available.',
          type: CliHistoryType.output,
        ),
      );
    } else {
      displayHistory.add(
        CliHistoryEntry(
          prompt: prompt,
          text: commandHistory.join('\n'),
          type: CliHistoryType.output,
        ),
      );
    }
  }

  void exitCommand() {
    displayHistory.add(
      CliHistoryEntry(
        prompt: prompt,
        text: exitMessage.join('\n'),
        type: CliHistoryType.output,
      ),
    );
    // Future.delayed(const Duration(seconds: 2), () {
    //   Get.back();
    // });
  }

  void smileCommand(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // Only generate a circle of diameter width/4
    final int diameter =
        ((width / 4).clamp(13, 60).toInt() | 1); // ensure odd, allow larger
    final int radius = diameter ~/ 2;
    final List<String> lines = [];
    // Use a scaling factor to make the circle more visually round in ASCII
    final double yScale = 0.38;

    for (int y = 0; y < diameter; y++) {
      StringBuffer line = StringBuffer();
      for (int x = 0; x < diameter; x++) {
        final dx = x - radius;
        final dy = ((y - radius) / yScale);
        final dist = dx * dx + dy * dy;
        final r2 = radius * radius;
        // Draw the circle border (tighter threshold)
        if ((dist - r2).abs() < radius * 0.5) {
          line.write('.');
        } else {
          line.write(' ');
        }
      }
      lines.add(line.toString());
    }
    displayHistory.add(
      CliHistoryEntry(
        prompt: prompt,
        text: lines.join('\n'),
        type: CliHistoryType.output,
      ),
    );
  }

  void welcomeMessage() {
    displayHistory.add(
      CliHistoryEntry(
        prompt: prompt,
        text:
            'Welcome to the portfolio CLI, $userName! \nType "help" for commands.',
        type: CliHistoryType.output,
      ),
    );
  }

  void onCommandSubmitted(String value, BuildContext context) {
    if (value.isEmpty) return;
    commandHistory.add(value);
    displayHistory.add(
      CliHistoryEntry(
        prompt: 'user@${userName} ~ \$ ',
        text: value,
        type: CliHistoryType.user,
      ),
    );
    inputController.clear();
    historyIndex = -1;
    inputFocusNode.requestFocus();
    if (commands.contains(value)) {
      switch (value) {
        case 'help':
          helpCommand();
          break;
        case 'about':
          for (final line in aboutCommand) {
            displayHistory.add(
              CliHistoryEntry(
                prompt: '',
                text: line,
                type: CliHistoryType.output,
              ),
            );
          }
          break;
        case 'projects':
          displayHistory.add(
            CliHistoryEntry(
              prompt: '',
              text: 'List of projects...',
              type: CliHistoryType.output,
            ),
          );
          break;
        case 'skills':
          displayHistory.add(
            CliHistoryEntry(
              prompt: '',
              text: 'List of skills...',
              type: CliHistoryType.output,
            ),
          );
          break;
        case 'history':
          historyCommand();
          break;
        case 'contact':
          displayHistory.add(
            CliHistoryEntry(
              prompt: '',
              text: 'Contact information...',
              type: CliHistoryType.output,
            ),
          );
          break;
        case 'clear':
          displayHistory.clear();
          break;
        case 'smile':
          smileCommand(context);
          break;
        case 'exit':
          exitCommand();
          break;
      }
    } else {
      displayHistory.add(
        CliHistoryEntry(
          prompt: '',
          text: 'Command not found: $value',
          type: CliHistoryType.error,
        ),
      );
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  void onInputKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        if (commandHistory.isNotEmpty &&
            historyIndex < commandHistory.length - 1) {
          historyIndex++;
          inputController.text =
              commandHistory[commandHistory.length - 1 - historyIndex];
          inputController.selection = TextSelection.fromPosition(
            TextPosition(offset: inputController.text.length),
          );
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        if (commandHistory.isNotEmpty && historyIndex > 0) {
          historyIndex--;
          inputController.text =
              commandHistory[commandHistory.length - 1 - historyIndex];
          inputController.selection = TextSelection.fromPosition(
            TextPosition(offset: inputController.text.length),
          );
        } else if (historyIndex == 0) {
          historyIndex = -1;
          inputController.clear();
        }
      }
    }
  }
}

class ColoredTextLine {
  final String text;
  final Color color;
  final bool nextLine;

  ColoredTextLine({
    required this.text,
    required this.color,
    required this.nextLine,
  });
}
