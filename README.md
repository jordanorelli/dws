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

###building an app bundle

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

# code walk

dws is both a Go application and a Cocoa application. It is compiled with [the
Go tool](https://golang.org/cmd/go/). Although it may be tempting to speak of
the Go and the Cocoa portions of the project as "the Go application" and "the
Cocoa application", that would be misleading: there is just one application.
The Go portion and the Cocoa portion of the application reside in the same
process, with the same address space.

During compilation, the Go tool invokes clang via cgo, and clang compiles a
mixture of C and Objective-C files into object files, which are linked by the
Go linker. cgo will generate some bridging C code for us that will create
function call bindings to allow Go code to call C code and vice-versa. Go is
able to access C type definitions, including struct definitions, but C is not
able to access Go structs. Go is not aware that it is linking against the
Objective-C runtime. Indeed, Go and Objective-C are incapable of interacting
directly, so there is a thin bridging layer written in C that can connect the
two.  

## project structure

The project consists of the following packages:
- `main`: the root of the git project. This package defines the application's
  entry point and imports the other packages.
- `bg`: the background package. This package contains the http server
  implementation. It is written entirely in Go.
- `events`: defines data types that can be used by the bg and ui packages to
  communicate. We define these communication primitives in their own package to
  avoid a circular import, which is forbidden in Go.
- `ui`: defines our user interface. 
- `ui/cocoa`: contains our Cocoa application. This package is the only package
  that uses cgo.

## the entry point

The application's entry point is defined in Go.
[`main.go`](https://github.com/jordanorelli/dws/blob/8dee9e5b564edb92c6cbd10103701495dd33f5d6/main.go)
contains the definition of [the `main`
function](https://github.com/jordanorelli/dws/blob/8dee9e5b564edb92c6cbd10103701495dd33f5d6/main.go#L27):

``` go
func main() {
    // ...
}
```

We start by [calling
`runtime.LockOSThread()`](https://github.com/jordanorelli/dws/blob/8dee9e5b564edb92c6cbd10103701495dd33f5d6/main.go#L28)
to lock the `main` function to the main thread of the application. This is
because of a Cocoa requirement: OSX will only send events to an application's
main thread, so we need to make sure that we're launching our Cocoa app from
the main thread.

Next, we initialize our Cocoa app by [calling
`ui.Desktop()`](https://github.com/jordanorelli/dws/blob/8dee9e5b564edb92c6cbd10103701495dd33f5d6/main.go#L31).
Our `Desktop` function is defined [in
`ui/ui_darwin.go`](https://github.com/jordanorelli/dws/blob/8dee9e5b564edb92c6cbd10103701495dd33f5d6/ui/ui_darwin.go#L7),
which is compiled on OSX and OSX alone because the file ends with `_darwin.go`
(more about conditional compilation in Go can be found [here on Dave Cheney's
blog](https://dave.cheney.net/2013/10/12/how-to-use-conditional-compilation-with-the-go-build-tool)).
We could conceivably write a drop-in win32 presentation layer by defining a
conformant `ui.Desktop()` function in `ui_windows.go`, but no such win32
implementation has been written yet.

Our [`ui.Desktop`
definition](https://github.com/jordanorelli/dws/blob/8dee9e5b564edb92c6cbd10103701495dd33f5d6/ui/ui_darwin.go#L7-L9)
is very short:

``` go
func Desktop() UI {
	return cocoa.Desktop()
}
```

This is where we first encounter [the `ui/cocoa`
package](https://github.com/jordanorelli/dws/tree/8dee9e5b564edb92c6cbd10103701495dd33f5d6/ui/cocoa).
Since we've imported the `cocoa` package, the Go tool compiles all of the
`.go` files, which is just one file:
[`ui.go`](https://github.com/jordanorelli/dws/blob/8dee9e5b564edb92c6cbd10103701495dd33f5d6/ui/cocoa/ui.go). In this file we see a cgo import statement:


``` go
/*
#cgo CFLAGS: -x objective-c
#cgo LDFLAGS: -framework Cocoa
#include <stdlib.h>
#include "ui.h"
*/
import "C"
```

This is where the Go tool observes that it needs to use cgo to invoke a C
compiler. The `#cgo CFLAGS` line allows us to pass arguments to our C compiler
(clang). Specifically, we enable Objective-C compilation. `LDFLAGS` allows us
to specify linker flags: this is where we ask the linker to link against the
Cocoa framework. The next two lines are plain C. We could write more C code
here, but I prefer to keep it to header includes and to avoid writing too much
mixed Go and C in the same file. `<stdlib.h>` has to be included to define
`C.free`, which allows us to call C's `free` from Go to release memory
allocated on the C heap. We also include `ui.h`, our header file for our Cocoa
ui. We'll take a look at that in a second.


