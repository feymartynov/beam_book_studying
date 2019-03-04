#include <stdio.h>
#include <stdlib.h>

#define STOP 0
#define ADD 1
#define MUL 2
#define PUSH 3

#define pop() (stack[--sp])
#define push(X) (stack[sp++] = X)

int run(char *bytecode) {
    int stack[1000];
    int sp = 0, size = 0, val = 0;
    char *ip = bytecode;

    while (*ip != STOP) {
        switch (*ip++) {
            case ADD: push(pop() + pop()); break;
            case MUL: push(pop() * pop()); break;
            case PUSH:
                size = *ip++;
                val = 0;
                while (size--) { val = val * 256  + *ip++; }
                push(val);
                break;
        }
    }

    return pop();
}

char* read_source(char* path) {
    char* buf = NULL;
    FILE* fp = fopen(path, "r");

    if (!fp) {
        fputs("Error opening file\n", stderr);
        return NULL;
    }

    if (fseek(fp, 0L, SEEK_END) == 0) {
        long bufsize = ftell(fp);
        if (bufsize == -1) return NULL;

        buf = malloc(sizeof(char) * (bufsize + 1));

        if (fseek(fp, 0L, SEEK_SET) != 0) {
            free(buf);
            return NULL;
        }

        size_t newLen = fread(buf, sizeof(char), bufsize, fp);

        if (ferror(fp) != 0) {
            free(buf);
            return NULL;
        }

        buf[newLen++] = '\0';
    }

    fclose(fp);
    return buf;
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        fputs("Error: missing filename argument.\n", stderr);
        return 1;
    }

    char *bytecode = read_source(argv[1]);

    if (!bytecode) {
        fputs("Error reading file", stderr);
        return 1;
    }

    int result = run(bytecode);
    fprintf(stdout, "%d\n", result);
    free(bytecode);
    return 0;
}
