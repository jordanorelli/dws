package ui

type UI interface {
	Init() error
	Run() error
}
