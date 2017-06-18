package events

type BackgroundEvent interface {
	Event
	isBackgroundEvent()
}

type backgroundEvent struct{ event }

func (e backgroundEvent) isBackgroundEvent() {}

type SigIntEvent struct{ backgroundEvent }
