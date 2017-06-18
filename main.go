package main

import (
	"fmt"
	"log"
	"os"
	"runtime"
	"strings"

	"github.com/jordanorelli/dws/bg"
	"github.com/jordanorelli/dws/events"
	"github.com/jordanorelli/dws/ui"
)

func exit(status int, t string, args ...interface{}) {
	if !strings.HasSuffix(t, "\n") {
		t = t + "\n"
	}
	if status == 0 {
		fmt.Fprintf(os.Stdout, t, args...)
	} else {
		fmt.Fprintf(os.Stderr, t, args...)
	}
	os.Exit(status)
}

func main() {
	runtime.LockOSThread()

	log.Println("Creating new Desktop UI")
	desktop := ui.Desktop()

	uiEvents := make(chan events.UserEvent, 1)
	bgEvents := make(chan events.BackgroundEvent, 1)

	go bg.Run(bgEvents, uiEvents)

	if err := desktop.Run(uiEvents, bgEvents); err != nil {
		exit(1, "UI Error: %v", err)
	}
}
