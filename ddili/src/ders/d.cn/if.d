Ddoc

$(DERS_BOLUMU $(IX if) $(CH4 if) 语句)

$(P
我们已经学习到程序是通过使用表达式来实现具体功能的。至今为止我们见到的所有程序的所有表达式都是从 $(C main()) 函数开始，执行到 $(C main) 结尾。
)

$(P
$(IX statement) 而$(I 语句)是一种能影响表达式执行顺序的特性。语句不产生值，自己也没有副作用。它们通常使用一个逻辑判断表达式来决定接下来要执行哪一条表达式。
)

$(P $(I $(B 注意：) 其它编程语言也许对表达式或语句有不同的定义，也有一些语言与 D 语言的定义相同。
)
)

$(H5 $(C if) 块和它的作用域)

$(P
$(C if) 语句通过使用一个逻辑表达式来决定了哪条或哪些语句将要被执行。它和英语单词 “if” 有着相同的意思，就想下面这个句子：“if there is coffee then I will drink coffee”。
)

$(P
$(C if) 用于判断的逻辑表达式应放在 if 后的括号中。如果逻辑表达式的值为 $(C true) 则执行它下方花括号中的表达式；反之如果逻辑表达式的值为 $(C false)，下方花括号中的语句将不会被执行。
)

$(P
花括号中的趋于被称作$(I 作用域)，全部位于作用于中的代码被称作一个$(I 代码块)。
)

$(P
下面是 $(C if) 语句的语法：
)

---
    if (a_logical_expression) {
        // ... 逻辑表达式为 true 时此处表达式将会被执行
    }
---

$(P
例如，表示“如果有咖啡，那就喝咖啡并把杯子洗干净”的程序可以像下面这样写：
)

---
import std.stdio;

void main() {
    bool existsCoffee = true;

    if (existsCoffee) {
        writeln("Drink coffee");
        writeln("Wash the cup");
    }
}
---

$(P
如果 $(C existsCoffee) 的值为 $(C false)，程序将跳过 if 块中的语句，什么都不会输出。
)

$(H5 $(IX else) $(C else) 块和它的作用域)

$(P
有时，我们想在 $(C if) 语句的逻辑表达式为 $(C false) 执行某些操作，即无论怎样总有一些表达式将被执行。例如：如果有咖啡，我就喝咖啡，否则我会喝茶”。
)

$(P
当逻辑表达式为 $(C false) 时要执行的操作应写在 $(C else) 关键字后的作用域中。
)

---
    if (a_logical_expression) {
        // ... 逻辑表达式为 true 时此处表达式将会被执行

    } else {
        // ... 逻辑表达式为 false 时此处表达式将会被执行
    }
---

$(P
例如，我们假设总是有茶:
)

---
    if (existsCoffee) {
        writeln("Drink coffee");

    } else {
        writeln("Drink tea");
    }
---

$(P
在上面的例子中，哪一个字符串将被打印取决于 $(C existsCoffee) 的值。
)

$(P
如果只看 $(C else) 的话它并不是一个语句，它只是一个 $(C if) 语句的可选$(I 分句)；它不能被单独使用。
)

$(P
注意本书将花括号写在与 $(C if) 和 $(C else) 同一行上。虽然将花括号单独写在一行是 $(LINK2 http://dlang.org/dstyle.html, D 语言官方编程风格)，但本书依旧使用更加普遍的内嵌花括号风格。

)

$(H5 始终使用作用域花括号)

$(P
虽然当作用域中只有一条语句时花括号可以省略，但我们并不推荐这样做。如果 $(C if) 或 $(C else) 的作用域中只有一条语句我们可以将代码写成下面这样：
)

---
    if (existsCoffee)
        writeln("Drink coffee");

    else
        writeln("Drink tea");
---

$(P
即使只有一条语句，大多数有经验的程序员也会使用花括号。（只有本章中的一个练习忽略了它们）不得不说的一点是，我将展示唯一一种省略花括号反而更好的情况。
)

$(H5 $(IX else if) “if, else if, else” 链)

$(P
你可以以一种复杂嵌套的方式使用语句和表达式。除了表达式，作用域还可以包含其它语句。例如：在 $(C else) 作用域中包含一个 $(C if) 语句。以不同的方式连接表达式和语句可以使我们程序的行为更加智能。
)

$(P
下面这段更复杂的代码表示的是：优先选择骑车到一个好的咖啡店，如果没有自行车的话则步行至稍差的咖啡店。
)

---
    if (existsCoffee) {
        writeln("Drink coffee at home");

    } else {

        if (existsBicycle) {
            writeln("Ride to the good place");

        } else {
            writeln("Walk to the bad place");
        }
    }
---

$(P
上面这段代码代表这样一个句子：“如果有咖啡，就在家喝咖啡；如果没有咖啡但有自行车，则骑车去不错的咖啡店；否则步行到一般的咖啡店”。
)

$(P
让我们继续这一复杂的决策过程：在没有自行车的时候先去邻居家问一下邻居是否有咖啡，如果邻居也没有咖啡则再走路到一般的咖啡店：
)

---
    if (existsCoffee) {
        writeln("Drink coffee at home");

    } else {

        if (existsBicycle) {
            writeln("Ride to the good place");

        } else {

            if (neighborIsHome) {
                writeln("Have coffee at neighbor's");

            } else {
                writeln("Walk to the bad place");
            }
        }
    }
---

$(P
类似于 "if this case, else if that other case, else if that even other case, etc." 这样的决策在程序中非常常见。而如果一定要使用花括号，代码将会有太多水平和竖直的空白：忽略空行，上面代码中 3 个 $(C if) 语句和 4 个 $(C writeln) 表达式总共占用 13 行。
)

$(P
为了能以更紧凑的方式书写上面的结构，当 $(C else) 作用域中只有一个 $(C if) 语句时，省略 $(C else) 的花括号。这是本指南的例外情况。
)

$(P
在重构至更好的形式之前，我们先看一段凌乱代码。任何代码都不应该写得这么乱。
)

$(P
下面这段代码是移除两个只包含一个 $(C else) 语句的 $(C if) 语句大括号后的样子：
)

---
    if (existsCoffee) {
        writeln("Drink coffee at home");

    } else

        if (existsBicycle) {
            writeln("Ride to the good place");

        } else

            if (neighborIsHome) {
                writeln("Have coffee at neighbor's");

            } else {
                writeln("Walk to the bad place");
            }
---

$(P
如果现在我们将 $(C if) 语句提到与包裹住它的 $(C else) 语句同一行并整理下代码，我们将会得到像下面这样可读性更强的代码：
)

---
    if (existsCoffee) {
        writeln("Drink coffee at home");

    } else if (existsBicycle) {
        writeln("Ride to the good place");

    } else if (neighborIsHome) {
        writeln("Have coffee at neighbor's");

    } else {
        writeln("Walk to the bad place");
    }
---

$(P
移除花括号使得代码更加紧凑并使表达式可读性更强。逻辑表达式、其求值顺序、以及值为 true 时执行的操作都一目了然。
)

$(P
这种常见的编程结构被称为 “if, else if, else” 链。
)


$(PROBLEM_COK

$(PROBLEM

当逻辑表达式的值为 $(C true) 时，我们希望程序$(I 喝柠檬水并将杯子洗干净)：

---
import std.stdio;

void main() {
    bool existsLemonade = true;

    if (existsLemonade) {
        writeln("Drinking lemonade");
        writeln("Washing the cup");

    } else
        writeln("Eating pie");
        writeln("Washing the plate");
}
---

但是当你运行程序时除了我们预期的结果，你还会看到 $(I washes the plate)：

$(SHELL
Drinking lemonade
Washing the cup
Washing the plate
)

为什么会这样呢？修正程序使其只在表达式为 $(C false) 时才清洗盘子。
)

$(PROBLEM
写一个可以和用户玩游戏的程序（一个需要用户足够诚实的游戏）。用户将掷骰子得到的数输入程序。之后根据这个值来确定是程序获胜还是用户获胜：

$(MONO
$(B Value of the die         Output of the program)
        1                      You won
        2                      You won
        3                      You won
        4                      I won
        5                      I won
        6                      I won
 Any other value               ERROR: Invalid value
)

额外任务：让程序考虑输入值的有效性。例如：

$(SHELL
ERROR: 7 is invalid
)

)

$(PROBLEM
修改下程序让我们可以输入 1 到 1000 的值。当输入的值在 1-500 内时用户获胜，当值在 501-1000 时程序获胜。上一题你写的程序可以经过简单的修改就达到我们的要求吗？
)

)

Macros:
        SUBTITLE=if 语句

        DESCRIPTION=if 语句是 D 语言条件语句之一

        KEYWORDS=D 编程语言教程 if 条件语句

MINI_SOZLUK=
