import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:portfolio/utils/launch.url.dart';

import '../../../infrastructure/navigation/bindings/controllers/info.fetch.controller.dart';

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
  final RxList<CliHistoryEntry> displayHistory = <CliHistoryEntry>[].obs;
  final RxList<String> commandHistory = <String>[].obs;
  final inputController = TextEditingController();
  final scrollController = ScrollController();
  final inputFocusNode = FocusNode();

  final InfoFetchController infoFetchController =
      Get.find<InfoFetchController>();

  // --- State Variables ---
  late final String userName;
  final RxList<String> currentPath = <String>[].obs;
  int historyIndex = -1;

  // --- Simulated File System ---
  late final Map<String, dynamic> rootDirectory;
  final List<String> projects = [];
  final List<String> projectsDescription = [];
  final List<String> projectsUrl = [];
  final List<String> skills = ['flutter', 'dart', 'firebase', 'getx', 'python'];
  final Map<String, String> contact = {
    'email': 'example@email.com',
    'phone': '+1234567890',
  };
  final Map<String, String> profileLinks = {
    'github': 'https://github.com/example',
    'linkedin': 'https://linkedin.com/in/example',
  };

  // --- Command Definitions ---
  final Map<String, List<String>> commandHelp = {
    'help': ['Shows this help message.'],
    'about': ['Displays information about this portfolio.'],
    'ls': ['Lists files and directories.'],
    'cd <dir>': ['Changes the current directory.'],
    'history': ['Shows your command history.'],
    'smile': ['Makes you smile. :)'],
    'clear': ['Clears the terminal screen.'],
    'exit': ['Exits the terminal.'],
  };

  final aboutText = [
    'This is a portfolio CLI application built with Flutter & GetX.',
    'It showcases my projects, skills, and contact information.',
    'Feel free to explore using the available commands.',
  ].join('\n');

  final exitMessage = 'Thank you for using the portfolio CLI! Goodbye!';

  final List<String> userNameList = [
    'eren_yeager',
    'mikasa_ackerman',
    'armin_arlert',
    'levi_ackerman',
    'hange_zoe',
  ];

  // --- Getters for dynamic parts of the UI ---
  String get currentPathString =>
      currentPath.isEmpty ? '~' : '~/${currentPath.join('/')}';

  String get prompt => 'user@$userName:$currentPathString\$ ';

  Map<String, dynamic> get currentDirectoryMap {
    Map<String, dynamic> dir = rootDirectory;
    for (final part in currentPath) {
      if (dir.containsKey(part) && dir[part] is Map<String, dynamic>) {
        dir = dir[part];
      } else {
        // This case should ideally not be reached if cd is implemented correctly
        return {};
      }
    }
    return dir;
  }

  @override
  void onInit() {
    super.onInit();
    userNameList.shuffle();
    userName = userNameList.first;
    _showWelcomeMessage();
    _getProjectsData();
    _initializeFileSystem();
    // Use everAll to reactively update projects when infoFetchController.projects changes
    everAll([infoFetchController.projects], (_) => _getProjectsData());
  }

  void _getProjectsData() {
    projects.clear();
    projects.addAll(
      infoFetchController.projects.map((project) => project.name).toList(),
    );
    projectsDescription.clear();
    projectsDescription.addAll(
      infoFetchController.projects
          .map((project) => project.description)
          .toList(),
    );
    projectsUrl.clear();
    projectsUrl.addAll(
      infoFetchController.projects.map((project) => project.url).toList(),
    );
    // Update rootDirectory in-place instead of re-initializing
    // rootDirectory['projects'] = {for (var item in projects) item: {}};
    for (final project in projects) {
      rootDirectory['projects']['${project.toLowerCase().split(' ').join('_')}.run'] =
          {
            'about': projectsDescription[projects.indexOf(project)],
            'url': projectsUrl[projects.indexOf(project)],
          };
      log('Added project: $project', name: 'CliController');
    }
    log('Fetched projects: ${projects.length}', name: 'CliController');
  }

  void _run(String command, String file) {
    final dir = currentDirectoryMap;
    // Only allow commands for files ending with .run
    if (!file.endsWith('.run')) {
      _addError('Unknown file: $file');
      return;
    }
    if (command == 'about') {
      _addOutput(dir[file]['about'] ?? 'No description available.');
    } else if (command == 'run') {
      _addOutput(dir[file]['url'] ?? 'No URL available.');
      Future.delayed(const Duration(milliseconds: 500), () {
        _addOutput('Launching URL... ${dir[file]['url']}');
      });
      launchUrlExternal(dir[file]['url'] ?? '');
    } else {
      _addError('Unknown command: $command');
    }
  }

  void _initializeFileSystem() {
    rootDirectory = {
      'projects': {for (var item in projects) item: {}},
      'skills': {for (var item in skills) item: {}},
      'contact': contact,
      'profile_links': profileLinks,
    };
  }

  void _showWelcomeMessage() {
    displayHistory.add(
      CliHistoryEntry(
        prompt: '',
        text:
            'Welcome to the portfolio CLI, $userName!\nType "help" for a list of commands.',
        type: CliHistoryType.output,
      ),
    );
  }

  // --- Command Handlers ---

  void _executeHelp() {
    final helpText = commandHelp.entries
        .map((e) => '${e.key.padRight(12)} - ${e.value.join('\n')}')
        .join('\n');
    _addOutput(helpText);
  }

  void _executeLs() {
    final dir = currentDirectoryMap;
    if (dir.isEmpty) {
      _addOutput('(empty)');
      return;
    }

    final entries = dir.keys.map((key) {
      // Add a slash to directories for better visual representation
      if (key.contains('.')) {
        return dir[key] is Map ? '$key\n' : key;
      }
      return dir[key] is Map ? '$key/\n' : key;
    }).toList();

    _addOutput(entries.join('  '));
  }

  void _executeCd(List<String> args) {
    if (args.isEmpty || args.first == '~' || args.first == '~/') {
      currentPath.clear();
      return;
    }

    final targetPath = args.first;
    // Prevent cd into folders with a dot in the name
    if (targetPath
        .split('/')
        .any((segment) => segment.contains('.') && segment != '..')) {
      _addError('cd: cannot change directory into a file.');
      return;
    }

    List<String> newPathSegments = targetPath.startsWith('/')
        ? []
        : List<String>.from(currentPath);

    final segments = targetPath
        .split('/')
        .where((s) => s.isNotEmpty && s != '.');

    for (final segment in segments) {
      if (segment == '..') {
        if (newPathSegments.isNotEmpty) {
          newPathSegments.removeLast();
        }
      } else {
        newPathSegments.add(segment);
      }
    }

    // Validate the final path
    Map<String, dynamic> currentDir = rootDirectory;
    bool isValid = true;
    for (final segment in newPathSegments) {
      if (currentDir.containsKey(segment) && currentDir[segment] is Map) {
        currentDir = currentDir[segment];
      } else {
        isValid = false;
        break;
      }
    }

    if (isValid) {
      currentPath.assignAll(newPathSegments);
    } else {
      _addError('cd: no such directory: $targetPath');
    }
  }

  void _executeHistory() {
    if (commandHistory.isEmpty) {
      _addOutput('No command history.');
    } else {
      _addOutput(commandHistory.join('\n'));
    }
  }

  void _executeSmile(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final int diameter = (width / 4).clamp(15, 55).toInt() | 1; // Ensure odd
    final int radius = diameter ~/ 2;
    final List<String> lines = [];
    const double yScale = 0.45; // Aspect ratio correction for characters

    for (int y = 0; y < diameter; y++) {
      StringBuffer line = StringBuffer();
      for (int x = 0; x < diameter; x++) {
        final dx = x - radius;
        final dy = (y - radius) / yScale;
        final dist = dx * dx + dy * dy;
        final r2 = radius * radius;
        if ((dist - r2).abs() < radius) {
          line.write('*');
        } else {
          line.write(' ');
        }
      }
      lines.add(line.toString());
    }
    _addOutput(lines.join('\n'));
  }

  void _executeHome() {
    currentPath.clear();
  }

  void _executeTree() {
    final dir = currentDirectoryMap;
    final buffer = StringBuffer();
    void printTree(Map<String, dynamic> node, String prefix) {
      final keys = node.keys.toList();
      for (int i = 0; i < keys.length; i++) {
        final key = keys[i];
        final isLast = i == keys.length - 1;
        buffer.writeln('$prefix${isLast ? '└──' : '├──'} $key');
        if (node[key] is Map<String, dynamic> &&
            (node[key] as Map).isNotEmpty) {
          printTree(node[key], prefix + (isLast ? '    ' : '│   '));
        }
      }
    }

    printTree(dir, '');
    _addOutput(buffer.isEmpty ? '(empty)' : buffer.toString());
  }

  // --- Helper methods for updating history ---

  void _addUserInput(String text) {
    displayHistory.add(
      CliHistoryEntry(prompt: prompt, text: text, type: CliHistoryType.user),
    );
  }

  void _addOutput(String text) {
    displayHistory.add(
      CliHistoryEntry(prompt: '', text: text, type: CliHistoryType.output),
    );
  }

  void _addError(String text) {
    displayHistory.add(
      CliHistoryEntry(prompt: '', text: text, type: CliHistoryType.error),
    );
  }

  // --- Main Input Handlers ---

  void onCommandSubmitted(String value, BuildContext context) {
    final trimmedValue = value.trim();
    if (trimmedValue.isEmpty) return;

    _addUserInput(trimmedValue);
    if (commandHistory.isEmpty || commandHistory.last != trimmedValue) {
      commandHistory.add(trimmedValue);
    }

    inputController.clear();
    historyIndex = -1;
    inputFocusNode.requestFocus();

    final parts = trimmedValue.split(RegExp(r'\s+'));
    final command = parts.first.toLowerCase();
    final args = parts.sublist(1);

    switch (command) {
      case 'help':
        _executeHelp();
        break;
      case 'ls':
        _executeLs();
        break;
      case 'cd':
        _executeCd(args);
        break;
      case 'about':
        if (args.isNotEmpty && args.first.endsWith('.run')) {
          _run('about', args.first);
        } else {
          _addOutput(aboutText);
        }
        break;
      case 'run':
        if (args.isNotEmpty && args.first.endsWith('.run')) {
          _run('run', args.first);
        } else {
          _addError('Usage: run <file.run>');
        }
        break;
      case 'history':
        _executeHistory();
        break;
      case 'clear':
        displayHistory.clear();
        _showWelcomeMessage();
        break;
      case 'smile':
        _executeSmile(context);
        break;
      case 'home':
        _executeHome();
        break;
      case 'tree':
        _executeTree();
        break;
      case 'exit':
        _addOutput(exitMessage);
        break;
      default:
        _addError('Command not found: $command');
        break;
    }

    // Scroll to the bottom after the UI updates
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void onInputKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      if (commandHistory.isNotEmpty &&
          historyIndex < commandHistory.length - 1) {
        historyIndex++;
        final historicCommand =
            commandHistory[commandHistory.length - 1 - historyIndex];
        inputController.text = historicCommand;
        inputController.selection = TextSelection.fromPosition(
          TextPosition(offset: historicCommand.length),
        );
      }
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (historyIndex > 0) {
        historyIndex--;
        final historicCommand =
            commandHistory[commandHistory.length - 1 - historyIndex];
        inputController.text = historicCommand;
        inputController.selection = TextSelection.fromPosition(
          TextPosition(offset: historicCommand.length),
        );
      } else {
        historyIndex = -1;
        inputController.clear();
      }
    }
  }
}
