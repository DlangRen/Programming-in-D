Ddoc

$(COZUM_BOLUMU Files)

---
import std.stdio;
import std.string;

void main() {
    write("Please enter the name of the file to read from: ");
    string inFileName = strip(readln());
    File inFile = File(inFileName, "r");

    string outFileName = inFileName ~ ".out";
    File outFile = File(outFileName, "w");

    while (!inFile.eof()) {
        string line = strip(inFile.readln());

        if (line.length != 0) {
            outFile.writeln(line);
        }
    }

    writeln(outFileName, " has been created.");
}
---

Macros:
        SUBTITLE=文件练习解答

        DESCRIPTION=D 编程语言练习解答：基本文件操作

        KEYWORDS=D 编程语言教程 if else 解答
