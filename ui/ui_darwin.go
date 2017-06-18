package ui

import (
	"log"

	"github.com/jordanorelli/dws/events"
)

/*
#cgo CFLAGS: -x objective-c
#cgo LDFLAGS: -framework Cocoa
#include "ui_darwin.h"
*/
import "C"

var desktopUI *cocoaUI

func Desktop() UI {
	if desktopUI != nil {
		return desktopUI
	}

	log.Println("Creating new Cocoa UI")
	C.Initialize()
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
	C.Run()
	return nil
}

//export selectDirectory
func selectDirectory(cpath *C.char) {
	path := C.GoString(cpath)
	desktopUI.out <- events.UserSelectedDirectory{Path: path}
}
