int strlen(const char *str) {
  auto it = str;
  while (*(it++))
    ;
  return it - str;
}

void print(const char *str) {
  volatile const unsigned long length = strlen(str);

  asm volatile("mov $1, %%rax\n"       // Syscall number for sys_write (1)
               "mov $1, %%rdi\n"       // File descriptor (stdout)
               "mov %0, %%rsi\n"       // Buffer (message)
               "mov %1, %%rdx\n"       // Buffer length (length)
               "syscall"               // Make the syscall
               :                       // No output operands
               : "r"(str), "r"(length) // Input operands
               : "%rax", "%rdi", "%rsi", "%rdx" // Clobbered registers
  );
}

const char *to_morse(char c) {
  // clang-format off
  switch (c) {
    case 'a': case 'A': return ".-";
    case 'b': case 'B': return "-...";
    case 'c': case 'C': return "-.-.";
    case 'd': case 'D': return "-..";
    case 'e': case 'E': return ".";
    case 'f': case 'F': return "..-.";
    case 'g': case 'G': return "--.";
    case 'h': case 'H': return "....";
    case 'i': case 'I': return "..";
    case 'j': case 'J': return ".---";
    case 'k': case 'K': return "-.-";
    case 'l': case 'L': return ".-..";
    case 'm': case 'M': return "--";
    case 'n': case 'N': return "-.";
    case 'o': case 'O': return "---";
    case 'p': case 'P': return ".--.";
    case 'q': case 'Q': return "--.-";
    case 'r': case 'R': return ".-.";
    case 's': case 'S': return "...";
    case 't': case 'T': return "-";
    case 'u': case 'U': return "..-";
    case 'v': case 'V': return "...-";
    case 'w': case 'W': return ".--";
    case 'x': case 'X': return "-..-";
    case 'y': case 'Y': return "-.--";
    case 'z': case 'Z': return "--..";

    case '0': return "-----";
    case '1': return ".----";
    case '2': return "..---";
    case '3': return "...--";
    case '4': return "....-";
    case '5': return ".....";
    case '6': return "-....";
    case '7': return "--...";
    case '8': return "---..";
    case '9': return "----.";

    default: return "X";
  }
  // clang-format off
}


int main() {
    const char* strs[] = {"4ZM", "Firmware"};

    for (auto str : strs) {
        int len = strlen(str);
        for (int i = 0; i < len-1; ++i) {
            print(to_morse(str[i]));
            print(" ");
        }
        print("  ");
    }
    print("\n");

    for(;;) {}
}

extern "C" void startup() {
    main();
    for(;;) {}
}
