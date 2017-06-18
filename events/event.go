package events

type Event interface {
	isEvent()
}

type event struct{}

func (e event) isEvent() {}
