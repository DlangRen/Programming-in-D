Ddoc

$(COZUM_BOLUMU 格式化输出)

$(OL

$(LI 如果你使用格式化说明符，那这个任务就会变得非常简单：

---
import std.stdio;

void main() {
    writeln("(Enter 0 to exit the program.)");

    while (true) {
        write("Please enter a number: ");
        long number;
        readf(" %s", &number);

        if (number == 0) {
            break;
        }

        writefln("%1$d <=> %1$#x", number);
    }
}
---

)

$(LI
注意如果你想要输出 $(C %)，那必须在格式化字符串中将其写作 $(C %%)：

---
import std.stdio;

void main() {
    write("Please enter the percentage value: ");
    double percentage;
    readf(" %s", &percentage);

    writefln("%%%.2f", percentage);
}
---

)

)


Macros:
        SUBTITLE=格式化输出习题解答

        DESCRIPTION=D 编程语言练习解答：格式化输出

        KEYWORDS=D 编程语言教程 格式化输出 解答
