package bg

import (
	"fmt"
	"log"
	"net/http"
)

type server struct {
	port int
	root string
}

func newServer() *server {
	return &server{port: 8000}
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
	if s.root == "" {
		writeNotInitializedResponse(w)
		return
	}
	fmt.Fprintf(w, "root: %s", s.root)
}

func writeNotInitializedResponse(w http.ResponseWriter) {
	w.WriteHeader(500)
	fmt.Fprintln(w, "no root directory selected")
}
