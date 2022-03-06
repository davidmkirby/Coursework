
void call2(void) {
    int k = 0xcafebabe;
}

void call(void) {
    int j = 0xcafed00d;
    call2();
}

int main(int argc, char* argv[]) {
    int i = 0xdeadc0de;
    call();
    return 0;
}
