Ddoc

$(COZUM_BOLUMU 字符串)

$(OL

$(LI
尽管，Phobos 模块中的一些函数易于处理字符串，但库文档通常要比教程简短。因此此时你或许会非常迷惑，尤其是对于 Phobos 中的 range。在稍后的一章中我们将看到 Phobos 的 range。
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

        DESCRIPTION=D 语言编程习题解答：字符串

        KEYWORDS=D 语言教程 字符串 习题解答
