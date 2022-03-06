
unsigned int call(unsigned int a) {
    unsigned int j = 0xcafed00d;
    unsigned int k = a;
    return 0xcafebabe;
}

int main(int argc, char* argv[]) {
    unsigned int i = 0xdeadc0de;
    unsigned int retval = call(i);
    return retval;
}
