#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "yuarel.h" // Assuming this is the correct header for the yuarel library

#define BUFSIZE 1024 // Define BUFSIZE appropriately
#define MAX_PARAMS 3

int main(void) {
    int p;
    char content[BUFSIZE];
    struct yuarel_param params[MAX_PARAMS];
    char *env = "QUERY_STRING";

    if (!getenv(env)) {
        fprintf(stderr, "The environment variable %s was not found\n", env);
        exit(1);
    }

    if (snprintf(content, BUFSIZE, "%s", getenv(env)) >= BUFSIZE) {
        fprintf(stderr, "BUFSIZE of %d was too small. Aborting\n", BUFSIZE);
        exit(1);
    }

    p = yuarel_parse_query(content, '&', params, MAX_PARAMS);
    if (p < 0) {
        fprintf(stderr, "Error parsing query parameters\n");
        exit(1);
    }

    for (int i = 0; i < p; i++) {
        printf("\t%s: %s\n", params[i].key, params[i].val);

        if (strcmp("servoposition", params[i].key) == 0) {
            printf("Worked!\n");
        }
    }

    return 0;
}
