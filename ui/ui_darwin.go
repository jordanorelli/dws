package ui

import (
	"runtime"
)

/*
#cgo CFLAGS: -x objective-c
#cgo LDFLAGS: -framework Cocoa
#include "ui_darwin.h"
*/
import "C"

func NewDesktop() (UI, error) {
	runtime.LockOSThread()
	return new(cocoaUI), nil
}

type cocoaUI struct {
}

func (ui *cocoaUI) Init() error {
	C.Initialize()
	return nil
}

func (ui *cocoaUI) Run() error {
	C.Run()
	return nil
}
