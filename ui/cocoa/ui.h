// RequestMeta contains metadata about an http request as received by the http
// server
struct RequestMeta {
	// seq is a request identifier that can be used to relate incoming requests
	// to outgoing responses.
	int seq;
	char *path;
};

typedef struct RequestMeta RequestMeta;

// ResponseMeta contains metadata about an http request as sent by the http
// server
struct ResponseMeta {
	int seq;    // same id as the originating request
	int status; // http status code
	int bytes;  // number of bytes written in the response
};

typedef struct ResponseMeta ResponseMeta;

// the Go backend calls initialize to allow the frontend to perform any up
// front allocations or reserve any resources it might need.
void ui_init();

// the Go backend calls run to start the front end's main event loop. this
// function is expected to block until the front end is done and the
// application is ready to terminate.
int ui_run();

// shutdown is provided to allow the Go backend to signal to the frontend that
// it believes the program should be shut down for some reason outside of user
// interaction.
void bg_shutdown();

// set_root informs the front end that the webserver has set its root directory
void bg_set_root(char *);

// received_request informs the front end that the webserver has received an
// http request.
void bg_received_request(RequestMeta *);

// sent_response informs the front end that the webserver has completed serving
// a response.
void bg_sent_response(ResponseMeta *);
