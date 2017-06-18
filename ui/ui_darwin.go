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
	C.ui_init()
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
	C.ui_run()
	return nil
}

func (ui *cocoaUI) forwardEvent(e events.BackgroundEvent) {
	switch v := e.(type) {
	case events.SigIntEvent:
		log.Println("Cocoa UI sees sig int, forwarding to NSApp")
		C.bg_shutdown()

	case events.SetRootEvent:
		cpath := C.CString(v.Path)
		defer C.free(unsafe.Pointer(cpath))
		C.bg_set_root(cpath)

	case events.BeginRequestEvent:
		cpath := C.CString(v.Path)
		defer C.free(unsafe.Pointer(cpath))

		req := &C.struct_RequestMeta{
			seq:  C.int(v.Seq),
			path: cpath,
		}

		C.bg_received_request(req)

	case events.EndRequestEvent:
		C.bg_sent_response(&C.struct_ResponseMeta{
			seq:    C.int(v.Seq),
			status: C.int(v.Status),
			bytes:  C.int(v.Bytes),
		})
	}
}

func (ui *cocoaUI) forwardEvents() {
	for e := range ui.in {
		ui.forwardEvent(e)
	}
}

//export selectDirectory
func selectDirectory(cpath *C.char) {
	path := C.GoString(cpath)
	desktopUI.out <- events.UserSelectedDirectory{Path: path}
}
