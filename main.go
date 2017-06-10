package main

import (
	"fmt"
	"os"
	"strings"

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

type failable func() error

func must(fn failable, status int, msg string) {
	msg = strings.TrimSpace(msg)
	if err := fn(); err != nil {
		exit(status, "%s: %s", msg, err)
	}
}

func main() {
	ui, err := ui.NewDesktop()
	if err != nil {
		exit(1, "unable to create desktop ui: %s", err)
	}
	must(ui.Init, 1, "unable to initialize desktop ui")
	must(ui.Run, 1, "unable to run desktop ui")
}
