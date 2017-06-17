package ui

type UI interface {
	Run(chan Event) error
}

type Event interface {
	isUIEvent()
}

type event struct{}

func (e event) isUIEvent() {}

type SelectDirectoryEvent struct {
	Path string
	event
}
