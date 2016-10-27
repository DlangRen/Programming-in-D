Ddoc

$(COZUM_BOLUMU 格式化输入)

$(P
仅需将输入中的日期部分替换成 $(C %s) 就完成了我们需要的格式化字符串：
)

---
import std.stdio;

void main() {
    int year;
    int month;
    int day;

    readf("%s.%s.%s", &year, &month, &day);

    writeln("Month: ", month);
}
---

Macros:
        SUBTITLE=格式化输入习题解答

        DESCRIPTION=D 编程语言练习解答：格式化输入

        KEYWORDS=D 编程语言教程 格式化输入 解答
