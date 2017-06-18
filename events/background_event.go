package events

type BackgroundEvent interface {
	Event
	isBackgroundEvent()
}

type backgroundEvent struct{ event }

func (e backgroundEvent) isBackgroundEvent() {}

type SigIntEvent struct{ backgroundEvent }

type SetRootEvent struct {
	Path string
	backgroundEvent
}

type BeginRequestEvent struct {
	Seq  int
	Path string
	backgroundEvent
}

type EndRequestEvent struct {
	Seq    int
	Status int
	Bytes  int
	backgroundEvent
}
