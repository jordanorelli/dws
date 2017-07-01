# dws

dws (desktop web server) is a simple http fileserver app. It can be used to
run an http server on a Mac as a native Mac application with a native Mac UI
using Apple's
[Cocoa](https://developer.apple.com/library/content/documentation/MacOSX/Conceptual/OSX_Technology_Overview/CocoaApplicationLayer/CocoaApplicationLayer.html)
framework.  This project functions primarily as an exploration into writing a
Go application with a native UI. The app is very similar to Python's
SimpleHTTP server, but demonstrates how to produce a single statically linked
binary that integrates both the desktop UI and the webserver, running in a
shared memory environment.

## download


Compiled applications will be posted on the [releases](/releases) page on the
project's github. You should be able to download the zip, unzip it, and run
the app inside. I've only tested it on macOS Sierra so far.

## build

Building this project requires that you have compilers for Go, C, and
Objective-C, as well as the necessary header files for Cocoa. In practice,
this only means having a Go compiler and the XCode command-line tools, since
the XCode command-line tools will give you everything you need for developing
Cocoa applications. You do not need to use XCode or Interface builder to
compile or work on this project. Given a Go compiler and clang, the process
for building the executable is as follows:

```
go build
```

The Go tool will invoke clang for you automatically. There are no nib files or
resource files.  Be aware that this will produce only a binary file, it will
not produce an [App
bundle](https://developer.apple.com/app-store/app-bundles/). The Go tool is
not aware of the App Bundle structure, it is only responsible for building the
executable.

### building an app bundle

Building an App Bundle is reasonably straightforward. The App Bundle is just a
special folder layout. A Makefile is included in the project to simplify this
task. If you have Make, you can build and assemble a fresh App Bundle as follows:

```
make
```

If you _don't_ have Make, you can recreate the folder structure by hand:

```
dws.app/
└── Contents
    ├── Info.plist
    └── MacOS
        └── dws
```
