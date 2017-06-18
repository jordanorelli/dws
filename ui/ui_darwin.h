struct RequestMeta {
	int seq;
	char *path;
};

typedef struct RequestMeta RequestMeta;

struct ResponseMeta {
	int seq;
	int status;
	int bytes;
};

typedef struct ResponseMeta ResponseMeta;

void initialize();
int run();
void shutdown();
void set_root(char *);
void received_request(RequestMeta *);
void sent_response(ResponseMeta *);
