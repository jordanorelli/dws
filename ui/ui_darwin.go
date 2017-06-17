package ui

import (
	"log"
	"runtime"
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

	log.Println("Creating new cocoaUI")
	runtime.LockOSThread()
	C.Initialize()
	desktopUI = new(cocoaUI)
	return desktopUI
}

type cocoaUI struct {
	out chan Event
}

func (ui *cocoaUI) Run(out chan Event) error {
	ui.out = out
	C.Run()
	return nil
}

//export selectDirectory
func selectDirectory(path string) {
	desktopUI.out <- SelectDirectoryEvent{Path: path}
}
