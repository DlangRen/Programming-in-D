Ddoc

$(COZUM_BOLUMU if 语句)

$(OL

$(LI
语句 $(C writeln("Washing the plate")) 的缩进使这条语句像是处在 $(C else) 的作用域中。但 $(C else) 并没有使用花括号指定作用域，所以只有 $(C writeln("Eating pie")) 语句处在 $(C else) 的作用域中。

$(P
由于空白在 D 语言的语法中并不起作用$(I 刷盘子的语句) 实际上是 $(C main()) 函数中的一条独立语句。无论如何它都会执行。让读者混淆的地方在于它使用了一个与一般情况不同的缩进。如果要将$(I 刷盘子的语句) 写在 $(C else) 的作用域中则需用花括号把作用域括起来：
)

---
import std.stdio;

void main() {
    bool existsLemonade = true;

    if (existsLemonade) {
        writeln("Drinking lemonade");
        writeln("Washing the cup");

    } else $(HILITE {)
        writeln("Eating pie");
        writeln("Washing the plate");
    $(HILITE })
}
---

)

$(LI
有不止一种方法可以实现这个游戏。我将会展示两个例子。在第一个例子中我们直接按照题干提供的信息编写代码：

---
import std.stdio;

void main() {
    write("What is the value of the die? ");
    int die;
    readf(" %s", &die);

    if (die == 1) {
        writeln("You won");

    } else if (die == 2) {
        writeln("You won");

    } else if (die == 3) {
        writeln("You won");

    } else if (die == 4) {
        writeln("I won");

    } else if (die == 5) {
        writeln("I won");

    } else if (die == 6) {
        writeln("I won");

    } else {
        writeln("ERROR: ", die, " is invalid");
    }
}
---

$(P
但这个程序有太多的重复代码。我们可以设计另一种方法实现相同的功能。代码如下：
)

---
import std.stdio;

void main() {
    write("What is the value of the die? ");
    int die;
    readf(" %s", &die);

    if ((die == 1) || (die == 2) || (die == 3)) {
        writeln("You won");

    } else if ((die == 4) || (die == 5) || (die == 6)) {
        writeln("I won");

    } else {
        writeln("ERROR: ", die, " is invalid");
    }
}
---

)

$(LI
上一题的第一种方法并不能在这道题中使用。在程序中分别处理 1000 个输入的数还要保证代码正确且易读是不现实的。所以，最好还是判断输入的数处在$(I 哪一个范围)：

---
    if ((die >= 1) && (die <= 500))
---

)

)

Macros:
        SUBTITLE=if 语句习题解答

        DESCRIPTION=D 编程语言练习解答：‘if’语句和它可选的‘else’从句

        KEYWORDS=D 编程语言教程 if else 解答
