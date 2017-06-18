package ui

import (
	"github.com/jordanorelli/dws/events"
)

type UI interface {
	Run(chan events.UserEvent, chan events.BackgroundEvent) error
}
