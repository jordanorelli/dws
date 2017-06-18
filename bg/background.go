package bg

import (
	"github.com/jordanorelli/dws/events"
)

func Run(out chan events.BackgroundEvent, in chan events.UserEvent) {
	bg := &background{
		in:     in,
		out:    out,
		server: newServer(),
	}
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
		}
	}
}
