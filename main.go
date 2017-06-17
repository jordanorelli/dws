package main

import (
	"fmt"
	"log"
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

func main() {
	log.Println("Creating new Desktop UI")
	desktop := ui.Desktop()

	c := make(chan ui.Event, 1)
	go func() {
		for e := range c {
			log.Printf("UI Event: %v\n", e)
		}
	}()

	log.Println("Running Desktop UI")
	if err := desktop.Run(c); err != nil {
		exit(1, "UI Error: %v", err)
	}
}
