package events

type UserEvent interface {
	Event
	isUserEvent()
}

type userEvent struct{ event }

func (e userEvent) isUserEvent() {}

type UserSelectedDirectory struct {
	Path string
	userEvent
}
