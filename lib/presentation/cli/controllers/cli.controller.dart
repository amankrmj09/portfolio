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
  final List<String> skills = ['flutter', 'dart', 'firebase', 'getx', 'python'];
  final Map<String, String> contact = {
    'email': 'example@email.com',
    'phone': '+1234567890',
  };

  // --- Command Definitions ---
  final Map<String, List<String>> commandHelp = {
    'help': ['Shows this help message.'],
    'about': ['Displays information about this portfolio.'],
    'about <file>': ['Shows the description of a project or certificate.'],
    'run <file>': ['Launches the URL of a project or certificate.'],
    'tree': ['Displays the directory structure in a tree format.'],
    'home': ['Navigates to the home directory.'],
    'help <file>': [
      'Shows available commands for a specific project or certificate.',
    ],
    'ls': ['Lists files and directories.'],
    'cd <dir>': ['Changes the current directory.'],
    'pwd': ['Prints the current working directory.'],
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
    _initializeFileSystem(); // Initialize rootDirectory first
    _getProjectsData(); // Then use it in _getProjectsData()
    _getCertificatesData();
    _getProfileLinksData(); // Initialize certificates directory
    // Use everAll to reactively update projects when infoFetchController.projects changes
    everAll([infoFetchController.projects], (_) => _getProjectsData());
    // Reactively update certificates when infoFetchController.certificates changes
    everAll([infoFetchController.certificates], (_) => _getCertificatesData());

    // Reactively update profile links when infoFetchController.profiles changes
    everAll([infoFetchController.profiles], (_) => _getProfileLinksData());
  }

  void _getProjectsData() {
    // Create projects map more efficiently using Map.fromEntries
    rootDirectory['projects'] = Map.fromEntries(
      infoFetchController.projects.map((project) {
        final key = '${project.name.toLowerCase().replaceAll(' ', '_')}.run';
        return MapEntry(key, {
          'about': project.description,
          'url': project.url,
        });
      }),
    );
  }

  void _getCertificatesData() {
    // Create skills map more efficiently using Map.fromEntries
    rootDirectory['certificates'] = Map.fromEntries(
      infoFetchController.certificates.map((certificate) {
        final key =
            '${certificate.name.toLowerCase().replaceAll(' ', '_')}.certificate';
        return MapEntry(key, {
          'about': certificate.description,
          'url': certificate.url,
        });
      }),
    );
  }

  void _getProfileLinksData() {
    // Check if profiles exists and is not empty
    if (infoFetchController.profiles.isEmpty) {
      log('No profile links data available', name: 'CliController');
      // Initialize with empty map if no data is available
      rootDirectory['profile_links'] = {};
      return;
    }

    try {
      // Create profile links map more efficiently using Map.fromEntries
      final profileLinksMap = Map.fromEntries(
        infoFetchController.profiles.map((profile) {
          final key =
              '${profile.name.toLowerCase().replaceAll(' ', '_')}.profile';
          return MapEntry(key, {
            'about': 'Profile on ${profile.name}',
            'url': profile.url,
          });
        }),
      );

      // Set the profile_links in rootDirectory
      rootDirectory['profile_links'] = profileLinksMap;
      log(
        'Loaded ${profileLinksMap.length} profile links',
        name: 'CliController',
      );
    } catch (e) {
      log('Error loading profile links: $e', name: 'CliController');
      // Provide a fallback to prevent crashes
      rootDirectory['profile_links'] = {};
    }
  }

  void _run(String command, String file) {
    final dir = currentDirectoryMap;
    // Only allow commands for files ending with valid extensions
    if (!file.endsWith('.run') &&
        !file.endsWith('.certificate') &&
        !file.endsWith('.profile')) {
      _addError(
        'Unknown file: $file. Valid files end with .run, .certificate, or .profile',
      );
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
      'projects': {},
      'certificates': {},
      'skills': {},
      'contact': contact,
      'profile_links': {},
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
        .map((e) => '${e.key.padRight(12, '')} -    ${e.value.join('\n')}')
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

    _addOutput(entries.join(''));
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
        // Only recurse into entries that:
        // 1. Are Maps (directories)
        // 2. Are not empty
        // 3. Don't have a dot in their name (not files)
        if (node[key] is Map<String, dynamic> &&
            (node[key] as Map).isNotEmpty &&
            !key.contains('.')) {
          printTree(node[key], prefix + (isLast ? '    ' : '│   '));
        }
      }
    }

    printTree(dir, '');
    _addOutput(buffer.isEmpty ? '(empty)' : buffer.toString());
  }

  void _executeHelpCommand(List<String> args) {
    if (args.isNotEmpty && args.first.endsWith('.run')) {
      final file = args.first;
      final dir = currentDirectoryMap;
      if (dir.containsKey(file)) {
        _addOutput(
          'Available commands for $file:\n'
          'about $file  - Show project description\n'
          'run $file    - Launch project URL',
        );
      } else {
        _addError('No such file: $file');
      }
    } else {
      _executeHelp();
    }
  }

  void _executePwd() {
    // Format the output to match standard pwd command output
    final path = currentPath.isEmpty ? '~' : '~/${currentPath.join('/')}';
    _addOutput(path);
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
        _executeHelpCommand(args);
        break;
      case 'ls':
        _executeLs();
        break;
      case 'cd':
        _executeCd(args);
        break;
      case 'pwd':
        _executePwd();
        break;
      case 'about':
        if (args.isNotEmpty &&
            (args.first.endsWith('.run') ||
                args.first.endsWith('.certificate') ||
                args.first.endsWith('.profile'))) {
          _run('about', args.first);
        } else {
          _addOutput(aboutText);
        }
        break;
      case 'run':
        if (args.isNotEmpty &&
            (args.first.endsWith('.run') ||
                args.first.endsWith('.certificate') ||
                args.first.endsWith('.profile'))) {
          _run('run', args.first);
        } else {
          _addError('Usage: run <file.run|file.certificate|file.profile>');
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
        Future.delayed(const Duration(seconds: 2), () {
          Get.offAllNamed('/home');
        });
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
    } else if (event.logicalKey == LogicalKeyboardKey.tab) {
      _handleTabCompletion();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      inputFocusNode.requestFocus();
    });
  }

  void _handleTabCompletion() {
    final currentInput = inputController.text;

    // Split into command parts
    final parts = currentInput.trim().split(RegExp(r'\s+'));

    // If there are multiple parts, we might be trying to complete a path or file
    if (parts.length > 1) {
      // Handle cd, ls, about, run, help commands with tab completion
      if ([
        'cd',
        'ls',
        'about',
        'run',
        'help',
      ].contains(parts.first.toLowerCase())) {
        _completePathOrFile(parts);
        return;
      }
    }

    // If single word, try to complete a command
    _completeCommand(currentInput);
  }

  void _completeCommand(String prefix) {
    if (prefix.isEmpty) return;

    // Available commands for tab completion
    final availableCommands = [
      'help',
      'about',
      'ls',
      'cd',
      'history',
      'smile',
      'clear',
      'tree',
      'home',
      'exit',
      'run',
    ];

    final matches = availableCommands
        .where((cmd) => cmd.startsWith(prefix.toLowerCase()))
        .toList();

    if (matches.isEmpty) {
      // No matches found
      return;
    } else if (matches.length == 1) {
      // Exact match found, complete it
      inputController.text = matches.first;
      inputController.selection = TextSelection.fromPosition(
        TextPosition(offset: inputController.text.length),
      );
    } else {
      // Multiple matches found, show options
      _addOutput('Available completions: ${matches.join(', ')}');
      // Find common prefix among matches if any
      final commonPrefix = _findCommonPrefix(matches);
      if (commonPrefix.length > prefix.length) {
        inputController.text = commonPrefix;
        inputController.selection = TextSelection.fromPosition(
          TextPosition(offset: inputController.text.length),
        );
      }
    }
  }

  void _completePathOrFile(List<String> parts) {
    parts.first.toLowerCase();
    String currentPath = parts.length > 1 ? parts.last : '';

    // Get the current directory map to search in
    Map<String, dynamic> searchDir = currentDirectoryMap;

    // If we have a partial path with /, navigate to that directory
    if (currentPath.contains('/')) {
      final pathSegments = currentPath
          .split('/')
          .where((s) => s.isNotEmpty)
          .toList();

      // The last segment is what we're trying to complete
      final lastSegment = pathSegments.isEmpty ? '' : pathSegments.removeLast();

      // Navigate to the directory containing what we're trying to complete
      for (final segment in pathSegments) {
        if (searchDir.containsKey(segment) && searchDir[segment] is Map) {
          searchDir = searchDir[segment];
        } else {
          // Directory doesn't exist, no completion possible
          return;
        }
      }

      // Update current path to just the last segment we're completing
      currentPath = lastSegment;
    }

    // Find matching entries in the directory
    final matches = searchDir.keys
        .where((key) => key.startsWith(currentPath))
        .toList();

    if (matches.isEmpty) {
      // No matches found
      return;
    } else if (matches.length == 1) {
      // Single match, complete it
      final match = matches.first;
      // Handle for different commands
      _completeWithMatch(parts, match, searchDir[match] is Map);
    } else {
      // Multiple matches
      _addOutput('Possible completions: ${matches.join(', ')}');
      // Try to complete as far as possible with common prefix
      final commonPrefix = _findCommonPrefix(matches);
      if (commonPrefix.length > currentPath.length) {
        _updateInputWithCompletion(parts, commonPrefix);
      }
    }
  }

  void _completeWithMatch(List<String> parts, String match, bool isDirectory) {
    // Don't add trailing slash for directories anymore
    _updateInputWithCompletion(parts, match);
  }

  void _updateInputWithCompletion(List<String> parts, String completion) {
    // Replace the last part with the completion
    parts[parts.length - 1] = completion;

    // Rebuild the command
    inputController.text = parts.join(' ');
    inputController.selection = TextSelection.fromPosition(
      TextPosition(offset: inputController.text.length),
    );
  }

  String _findCommonPrefix(List<String> strings) {
    if (strings.isEmpty) return '';
    if (strings.length == 1) return strings.first;

    String prefix = strings.first;
    for (int i = 1; i < strings.length; i++) {
      int j = 0;
      while (j < prefix.length &&
          j < strings[i].length &&
          prefix[j] == strings[i][j]) {
        j++;
      }
      prefix = prefix.substring(0, j);
      if (prefix.isEmpty) break;
    }

    return prefix;
  }
}
