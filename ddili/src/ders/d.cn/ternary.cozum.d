Ddoc

$(COZUM_BOLUMU 三元运算符 $(C ?:))

$(P
虽然在本练习中使用 $(C if-else) 语句可能更合理，但下面的程序还是使用了两个 $(C ?:) 运算符来实现需求：
)

---
import std.stdio;

void main() {
    write("Please enter the net amount: ");

    int amount;
    readf(" %s", &amount);

    writeln("$",
            amount < 0 ?-amount : amount,
            amount < 0 ?" lost" : " gained");
}
---

$(P
如果输入 0，程序也会显示“gained”。修改这个程序使其对 0 的输出更加合理的信息。
)

Macros:
        SUBTITLE=三元运算符 ?: 习题解答

        DESCRIPTION=D 语言编程习题解答：运算符 ?:

        KEYWORDS=D 编程语言教程 习题解答
