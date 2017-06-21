package bg

import (
	"fmt"
	"log"
	"net/http"
	"sync/atomic"

	"github.com/jordanorelli/dws/events"
)

type server struct {
	port int
	fs   http.Handler
	out  chan events.BackgroundEvent
}

func (s *server) listen() {
	addr := fmt.Sprintf("0.0.0.0:%d", s.port)
	log.Printf("server listening on addr: %s\n", addr)
	h := &eventEmittingHandler{
		wrapped: s,
		out:     s.out,
	}
	if err := http.ListenAndServe(addr, h); err != nil {
		panic(err)
	}
}

func (s *server) setRoot(path string) {
	log.Printf("server setting root to %s\n", path)
	s.fs = http.FileServer(http.Dir(path))
}

func (s *server) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	if s.fs == nil {
		writeNotInitializedResponse(w)
		return
	}
	s.fs.ServeHTTP(w, r)
}

func writeNotInitializedResponse(w http.ResponseWriter) {
	w.WriteHeader(500)
	fmt.Fprintln(w, "no root directory selected")
}

// trackginWriter is an http.ResponseWriter that tracks the number of bytes
// sent and the status sent
type trackingWriter struct {
	http.ResponseWriter
	status int // last http status written
	wrote  int // total number of bytes written
}

func (t *trackingWriter) WriteHeader(status int) {
	t.ResponseWriter.WriteHeader(status)
	t.status = status
}

func (t *trackingWriter) Write(b []byte) (int, error) {
	n, err := t.ResponseWriter.Write(b)
	if t.status == 0 {
		t.status = 200
	}
	t.wrote += n
	return n, err
}

// eventEmittingHandler is an http.Handler that emits events on an event
// channel to report on requests and responses.
type eventEmittingHandler struct {
	wrapped http.Handler
	out     chan events.BackgroundEvent
	count   uint32
}

func (h *eventEmittingHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	id := int(h.nextCount())
	h.out <- events.BeginRequestEvent{
		Seq:  id,
		Path: r.URL.Path,
	}
	tw := &trackingWriter{ResponseWriter: w}
	h.wrapped.ServeHTTP(tw, r)
	h.out <- events.EndRequestEvent{
		Seq:    id,
		Status: tw.status,
		Bytes:  tw.wrote,
	}
}

func (h *eventEmittingHandler) nextCount() uint32 {
	return atomic.AddUint32(&h.count, 1)
}
