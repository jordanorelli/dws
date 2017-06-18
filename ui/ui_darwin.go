package ui

import (
	"log"
	"unsafe"

	"github.com/jordanorelli/dws/events"
)

/*
#cgo CFLAGS: -x objective-c
#cgo LDFLAGS: -framework Cocoa
#include <stdlib.h>
#include "ui_darwin.h"
*/
import "C"

var desktopUI *cocoaUI

func Desktop() UI {
	if desktopUI != nil {
		return desktopUI
	}

	log.Println("Creating new Cocoa UI")
	C.initialize()
	desktopUI = new(cocoaUI)
	return desktopUI
}

type cocoaUI struct {
	in  chan events.BackgroundEvent
	out chan events.UserEvent
}

func (ui *cocoaUI) Run(out chan events.UserEvent, in chan events.BackgroundEvent) error {
	log.Println("Running Desktop UI")
	ui.in = in
	ui.out = out
	go ui.forwardEvents()
	C.run()
	return nil
}

func (ui *cocoaUI) forwardEvents() {
	for e := range ui.in {
		switch v := e.(type) {
		case events.SigIntEvent:
			log.Println("Cocoa UI sees sig int, forwarding to NSApp")
			C.shutdown()
		case events.SetRootEvent:
			cs := C.CString(v.Path)
			C.set_root(cs)
			C.free(unsafe.Pointer(cs))
		}
	}
}

//export selectDirectory
func selectDirectory(cpath *C.char) {
	path := C.GoString(cpath)
	desktopUI.out <- events.UserSelectedDirectory{Path: path}
}
