package ui

import (
	"log"

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
		C.bg_set_root(cpath)

	case events.BeginRequestEvent:
		cpath := C.CString(v.Path)
		req := (*C.struct_RequestMeta)(C.malloc(C.sizeof_struct_RequestMeta))
		req.seq = C.int(v.Seq)
		req.path = cpath
		C.bg_received_request(req)

	case events.EndRequestEvent:
		res := (*C.struct_ResponseMeta)(C.malloc(C.sizeof_struct_ResponseMeta))
		res.seq = C.int(v.Seq)
		res.status = C.int(v.Status)
		res.bytes = C.int(v.Bytes)
		C.bg_sent_response(res)
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
