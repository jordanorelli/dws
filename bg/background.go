package bg

import (
	"os"
	"os/signal"

	"github.com/jordanorelli/dws/events"
)

func Run(out chan events.BackgroundEvent, in chan events.UserEvent) {
	bg := &background{
		in:     in,
		out:    out,
		server: newServer(),
	}
	go bg.handleSignals()
	go bg.listen()
	bg.run()
}

type background struct {
	in  chan events.UserEvent
	out chan events.BackgroundEvent
	*server
}

func (bg *background) run() {
	for e := range bg.in {
		switch v := e.(type) {
		case events.UserSelectedDirectory:
			bg.setRoot(v.Path)
			bg.out <- events.SetRootEvent{Path: v.Path}
		}
	}
}

func (bg *background) handleSignals() {
	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt)
	<-c
	bg.out <- events.SigIntEvent{}
}
