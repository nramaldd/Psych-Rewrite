import 'dart:io';
//import 'dart:html' as HTML;

String os = Platform.operatingSystem;

void main() async {
  // await HTML.HttpRequest.getString('google.com');
  // new Directory(name).create();
  stdout.write("Did you run this exe as administrator? (y/n): ");
  var confirm = stdin.readLineSync();
  if (confirm == "y") {
    Directory e = new Directory("C:\\Program Files\\Psych");
    if (e.exists() == false) {
      e.create();

      // File app = new File();
    } else {
      print("Appears that 'C:\\Program Files\\Psych' already exists. If it exists, and is empty, please delete it manually.");
    }
  }
  print("Press enter to exit");
  stdin.readLineSync();
}
