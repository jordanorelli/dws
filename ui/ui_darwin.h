struct RequestMeta {
	char *path;
};

typedef struct RequestMeta RequestMeta;

struct ResponseMeta {

};

typedef struct ResponseMeta ResponseMeta;

void initialize();
int run();
void shutdown();
void set_root(char *);
void begin_request(RequestMeta *);
void end_request();
