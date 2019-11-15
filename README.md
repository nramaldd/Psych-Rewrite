# Psych
Git project manager written in Dart
## Install
* Make sure you have git installed: https://git-scm.com/ (or install using your os package manager)
* Check [releases tab](https://github.com/SomethingGeneric/Psych-Rewrite/releases) to see if there's an executable for your system.
  * If so, just download that and plop it somewhere that your terminal knows of (e.g. /bin on \*nix, or in your PATH on Windows.)
  * If not, you're going to have to build an executable yourself.
    * `git clone https://github.com/SomethingGeneric/Psych-Rewrite`
    * Install DartSDK from https://dart.dev/get-dart
    * In the project directory, run `dart2native main.dart -o psych` or `dart2native main.dart -o psych.exe` if you're windows.
    * Put the resulting file somewhere your terminal can use it
## Usage:
* `newproject <name>` : creates a new Psych project. Will prompt you for the git URLS to clone from.
* `download <name>` : Downloads (clones) all repos that are a part of project <name>
* `send <name> <message>` : Pushes all local changes in each repo within <name>, using commit message <message>
* `sync <name>` : Pulls all remote changes for each repo in <name>
