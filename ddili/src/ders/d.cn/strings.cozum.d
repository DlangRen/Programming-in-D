Ddoc

$(COZUM_BOLUMU 字符串)

$(OL

$(LI
对于字符串，虽然 Phobos 模块的一些函数易于使用，但库文档通常比教程简短。在这一点上，你会发现 Phobos 的让人迷惑的 ranges 尤其明显。在稍后的一章中我们将看到 Phobos 的 ranges 。
)

$(LI
许多别的函数可以嵌套使用：

---
import std.stdio;
import std.string;

void main() {
    write("First name: ");
    string first = capitalize(strip(readln()));

    write("Last name: ");
    string last = capitalize(strip(readln()));

    string fullName = first ~ " " ~ last;
    writeln(fullName);
}
---

)

$(LI 这段程序使用两个索引值来生成一个切片：

---
import std.stdio;
import std.string;

void main() {
    write("Please enter a line: ");
    string line = strip(readln());

    ptrdiff_t first_e = indexOf(line, 'e');

    if (first_e == -1) {
        writeln("There is no letter e in this line.");

    } else {
        ptrdiff_t last_e = lastIndexOf(line, 'e');
        writeln(line[first_e .. last_e + 1]);
    }
}
---

)

)

Macros:
        SUBTITLE=字符串 习题解答

        DESCRIPTION=D语言编程习题解答：字符串

        KEYWORDS=D 语言教程 字符串 习题解答
