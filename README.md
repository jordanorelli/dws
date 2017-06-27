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
function](https://github.com/jordanorelli/dws/blob/8dee9e5b564edb92c6cbd10103701495dd33f5d6/main.go#L27),
which gives us a bird's-eye view of the application's structure:

``` go
func main() {
	runtime.LockOSThread()

	desktop := ui.Desktop()

	uiEvents := make(chan events.UserEvent, 1)
	bgEvents := make(chan events.BackgroundEvent, 1)

	go bg.Run(bgEvents, uiEvents)

	if err := desktop.Run(uiEvents, bgEvents); err != nil {
		exit(1, "UI Error: %v", err)
	}
}
```

We start by [calling
`runtime.LockOSThread()`](https://github.com/jordanorelli/dws/blob/8dee9e5b564edb92c6cbd10103701495dd33f5d6/main.go#L28)
to lock the `main` function to the main thread of the application. This is
because of a Cocoa requirement: OSX will only send events to an application's
main thread, so we need to make sure that we're launching our Cocoa app from
the main thread. Boring.

Next, we initialize our Cocoa app by [calling
`ui.Desktop()`](https://github.com/jordanorelli/dws/blob/8dee9e5b564edb92c6cbd10103701495dd33f5d6/main.go#L31).
The UI itself is written to be opaque to the backend so that we can build many
different UI implementations over the same backend.

Next we create a pair of channels, `uiEvents` and `bgEvents`. These channels
will be passed to both the backend and the frontend. The UI will listen on the
`bgEvents` channel for messages from the backend and send any user events such
as clicks or menu selections as `events.UserEvent` messages on the `uiEvents`
channel. Similarly, the backend will listen on the `uiEvents` channel to accept
and respond to the user's actions. The `bgEvents` channel is used by the
backend to send messages that should be displayed to the user. Since our
application is an http server, that's things like "started handling an http
request" and "finished handling an http request". Next we kick off the
background in its own goroutine so that it can run independently of the UI's
run loop. Finally, we call `desktop.Run` to start the application's run loop
and block until it has completed. We'll talk about the presentation layer
first, then come back to the background server functionality.

## setting up the Cocoa UI

Our [`ui.Desktop`
definition](https://github.com/jordanorelli/dws/blob/8dee9e5b564edb92c6cbd10103701495dd33f5d6/ui/ui_darwin.go#L7-L9)
is very short:

``` go
func Desktop() UI {
	return cocoa.Desktop()
}
```

Since our `Desktop` function is defined [in
`ui/ui_darwin.go`](https://github.com/jordanorelli/dws/blob/8dee9e5b564edb92c6cbd10103701495dd33f5d6/ui/ui_darwin.go#L7),
it will only be compiled on MacOS. The `_darwin.go` suffix tells the Go
compiler to only compile the file on Darwin. Attempting to compile this program
will fail on all other operating systems because `ui.Desktop` will only be
defined on MacOS. (more about conditional compilation in Go can be found [here
on Dave Cheney's
blog](https://dave.cheney.net/2013/10/12/how-to-use-conditional-compilation-with-the-go-build-tool)).
We could conceivably write a win32 presentation layer by defining a conformant
`ui.Desktop()` function in `ui_windows.go`, but no such win32 implementation
has been written yet. In essence, this file tells the Go compiler to only
define the `Desktop` function on MacOS, and that its invocations should be
forwarded to `cocoa.Desktop`. We'll use the `ui/cocoa` package to contain all
of our Mac-specific code.

### the cgo import

Since we've imported the `cocoa` package, the Go tool compiles all of the `.go`
files, which is just one file:
[`ui.go`](https://github.com/jordanorelli/dws/blob/8dee9e5b564edb92c6cbd10103701495dd33f5d6/ui/cocoa/ui.go),
which contains our `cocoa.Desktop` definition:

``` go
func Desktop() *ui {
	if instance != nil {
		return instance
	}
	C.ui_init()
	instance = new(ui)
	return instance
}
```

`instance` in this case is just a pointer to a package global, which exists to
ensure that we only attempt to initialize the Cocoa UI once, like a poorly-made
singleton with no synchronization. Not very strong, but fine for our use case.
We then initialize our Cocoa app by calling `C.ui_init`. This demands closer
inspection.

First, it should be immediately clear to Go programmers that we're calling what
appears to be an unexported function on a different package. `C` in this case,
and in all cases of cgo, is not a package in the sense that it is a true Go
package: it is a pseudo-package that acts as an interface to our C code. Let's
take a look at how we imported this package:

``` go
/*
#cgo CFLAGS: -x objective-c
#cgo LDFLAGS: -framework Cocoa
#include <stdlib.h>
#include "ui.h"
*/
import "C"
```

This comment block is a [cgo](https://golang.org/cmd/cgo/) import statement. It
instructs the Go tool to use cgo, which will in turn, invoke a C compiler. In
our case, that means clang, because that is the default C compiler on Darwin.
More literally: clang is selected because the value of the `CC` environment
variable is `clang`. We provide a few options to clang that are relevant to our
project using the `#cgo` statements. The `CFLAGS` statement allows us to pass
arguments to clang. Specifically, we enable Objective-C compilation. `LDFLAGS`
allows us to specify linker flags: this is where we ask the linker to link
against the Cocoa framework. Cgo will follow similar rules to the rest of the
Go tool: all of the source code files in the directory will be included in the
compilation. This means _all_ of the `.go`, `.h`, and `.m` files will be
compiled and included in our binary automatically, and we don't need to write a
Makefile. (If you're curious about compiler caching, it's the same situation as
Go in general: `go build` will always rebuild the entire application, while `go
install` will cache the intermediate objects. `go install` is, in general,
faster beyond the first compile, but since it moves your binary, we use `go
build` in our explainers later because it is simpler to reason about.)

The next two lines are plain C. We could write more C code here if we so
desired, but restricting ourselves to only includes helps to keep our languages
in order. `<stdlib.h>` has to be included in order to define `C.free`, which
allows us to call C's `free` from Go to release memory allocated on the C heap.

We also include
[`ui.h`](https://github.com/jordanorelli/dws/blob/360224ce612984b83ad033a549192cbd0df08672/ui/cocoa/ui.h),
our header file for our Cocoa ui. We see in this file the definition for the
`ui_init` function:

``` c
void ui_init();
```

This C declaration corresponds to the `C.ui_init()` call we saw in `cocoa/ui.go`. Its implementation can be seen [in `ui.m`](https://github.com/jordanorelli/dws/blob/360224ce612984b83ad033a549192cbd0df08672/ui/cocoa/ui.m#L9-L14):

### setting up a Cocoa application without XCode or Nib files

``` objective-c
void ui_init() {
    defaultAutoreleasePool = [NSAutoreleasePool new];
    [NSApplication sharedApplication];
    [NSApp setDelegate: [[AppDelegate new] autorelease]];
    [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
}
```

We start by initializing our
[NSAutoreleasePool](https://developer.apple.com/documentation/foundation/nsautoreleasepool),
which is used for
[reference-counting](https://en.wikipedia.org/wiki/Reference_counting) in both
our code and in Cocoa's code. Without this line, any Objective-C objects that
were memory-managed using `autorelease` messages will never be released, and
our application will leak memory. Even if we didn't use `autorelease`
ourselves, Cocoa uses it internally, so leaving this off would cause Cocoa to
leak. We'll see quickly that the differing memory management systems between
Go, C, and Objective-C have noticeable effects on our application.

Next, we initialize our
[NSApplication](https://developer.apple.com/documentation/appkit/nsapplication?language=objc),
the base application type for managing a Mac application. Sending a
[`sharedApplication`
message](https://developer.apple.com/documentation/appkit/nsapplication/1428360-sharedapplication?language=objc)
to NSApplication returns the application instance, creating it if it doesn't
exist yet. We're not interested in the return value, we just call this function
for its side effects.

Next we set our application's delegate with a [`setDelegate`
message](https://developer.apple.com/documentation/appkit/nsapplication/1428705-delegate?language=objc).
It turns out that Cocoa's extensive use of the delegation pattern makes Cocoa
programming very easy for Go programmers to reason about. An Objective-C
_delegate_ property in the general case is a reference to an object that
implements a _protocol_ in the Objective-C parlance, but for a Go programmer,
we can think of a delegate property as being a struct field with an interface
type. NSApplication's `delegate` property is of [`NSApplicationDelegate`
type](https://developer.apple.com/documentation/appkit/nsapplicationdelegate?language=objc),
which is a protocol.

Our AppDelegate is declared [in `AppDelegate.h`](https://github.com/jordanorelli/dws/blob/360224ce612984b83ad033a549192cbd0df08672/ui/cocoa/AppDelegate.h#L4-L5):

``` objective-c
@interface AppDelegate : NSObject <NSApplicationDelegate>
@end
```

and implemented [in
`AppDelegate.m`](https://github.com/jordanorelli/dws/blob/360224ce612984b83ad033a549192cbd0df08672/ui/cocoa/AppDelegate.m).
We'll take a look at some of the methods we've decided to implement when we
send our `NSApplication` a `run` message.

