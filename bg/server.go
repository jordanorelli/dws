package bg

import (
	"fmt"
	"log"
	"net/http"

	"github.com/jordanorelli/dws/events"
)

type server struct {
	port int
	root string
	out  chan events.BackgroundEvent
}

func (s *server) listen() {
	addr := fmt.Sprintf("0.0.0.0:%d", s.port)
	log.Printf("server listening on addr: %s\n", addr)
	if err := http.ListenAndServe(addr, s); err != nil {
		panic(err)
	}
}

func (s *server) setRoot(path string) {
	log.Printf("server setting root to %s\n", path)
	s.root = path
}

func (s *server) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	s.out <- events.BeginRequestEvent{
		Path: r.URL.Path,
	}
	if s.root == "" {
		writeNotInitializedResponse(w)
		return
	}
	fmt.Fprintf(w, "root: %s", s.root)
	s.out <- events.EndRequestEvent{}
}

func writeNotInitializedResponse(w http.ResponseWriter) {
	w.WriteHeader(500)
	fmt.Fprintln(w, "no root directory selected")
}
