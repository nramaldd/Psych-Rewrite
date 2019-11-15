import 'dart:io';
// Below is implied w/ dart above 2.1, but to make the linter shut up I explicity imported it.
import 'dart:async';
import 'dart:core';

String os = Platform.operatingSystem;

String argAt(theargs,i) {
  if (theargs.length > i) {
    return theargs[i];
  } else {
    return "Fail";
  }
}

void lazySave(name,text) {
  if (os == "windows") {
      Process.run("cmd",["/C","echo",text,">>",name]);
  } else {
      Process.run("echo",[text,">>",name]);
  }
}

Future<String> getF(filename) async {
  var config = File(filename);
  var contents;
  // Put the whole file in a single string.
  contents = config.readAsString();
  return contents;
}

void clone(url) async {
  await Process.run("git", ["clone",url]);
}

Future<int> gitop(opts) async {
  int res = await Process.run("git",opts).then((ProcessResult pr) {
    return pr.exitCode;
  });
  return res;
}

Future<List> getlinks(project) async {
  var urlsSTR = await getF("urls.txt");
  List urls = urlsSTR.split("\n");
  return urls;
}

void main(List<String> args) async {
  if (args.isNotEmpty) {
    var command = argAt(args,0);
    if (command == "newproject" || command == "-n" || command == "-np" || command == "--n" || command == "--np") {
      var name = argAt(args,1);
      new Directory(name).create();
      print("Made a folder for $name");
      Directory.current = name;
      print("Now we're going to add URLS.\nEnter blank to end");
      bool stop = false;
      while (!stop) {
        print("URL: ");
        var input = stdin.readLineSync();
        if (input != "") {
          lazySave("urls.txt",input);
        } else {
          stop = true;
        }
      }
      print("Done.");
    } else if (command == "download" || command == "-d" || command =="--d") {
      print("Downloading could take time if the repos are large.");
      print("Please be patient, even if it looks like the operation has locked up.");
      var name = argAt(args,1);
      Directory.current = name;
      List urls = await getlinks(name);
      for (var url in urls) {
        if (url != "" && url != " ") {
          print("Starting $url");
          await clone(url);
          print("Finished $url");
        }
      }
    } else if (command == "send" || command == "-send" || command == "--send") {
      var name = argAt(args,1);
      var msg = argAt(args,2);
      print("Commit msg: $msg");
      Directory.current = name;
      var save = Directory.current;
      List contents = Directory.current.listSync();
      for (var thing in contents) {
        if (thing is Directory) {
          Directory.current = thing;
          print("Pushing changes to $thing");
          await gitop(["add","*"]);
          await gitop(["commit","-m",'"' + msg + '"']);
          int stat = await gitop(["push"]);
          if (stat == 0) {
            print("Push probably failed. This is either because you didn't change anything, or you're behind remote. Try to pull first?");
          }
          Directory.current = save;
        }
      }
    }
    else if (command == "sync" || command == "-sync" || command == "--sync") {
      var name = argAt(args,1);
      Directory.current = name;
      var save = Directory.current;
      List contents = Directory.current.listSync();
      for (var thing in contents) {
        if (thing is Directory) {
          print("Pulling for $thing");
          Directory.current = thing;
          await gitop(["pull"]);
          Directory.current = save;
        }
      }
    } else if (command == "help" || command == "--help" || command == "/?") {
        print("Commands:");
        print("- newproject <name> : creates a new Psych project. Will prompt you for the git URLS to clone from.");
        print("- download <name> : Downloads (clones) all repos that are a part of project <name>");
        print("- send <name> <message> : Pushes all local changes in each repo within <name>, using commit message <message>");
        print("- sync <name> : Pulls all remote changes for each repo in <name>");
    } else {
      print("Unknown command. Quitting");
    }
  } else {
    print("No arguements passed. Quitting.");
  }
}
