Ddoc

$(DERS_BOLUMU $(IX do-while) $(IX loop, do-while) $(CH4 do-while) 循环)

$(P
在 $(LINK2 /ders/d.cn/for.html, $(C for) 循环) 一章中，我们已经见过 $(LINK2 /ders/d.cn/while.html, $(C while) 循环) 执行的步骤：
)

$(MONO
准备

条件检查
循环体
迭代

条件检查
循环体
迭代

...
)

$(P
$(C do-while) 循环与 $(C while) 循环十分相似，不同之处在于 $(C do-while) 循环的$(I 条件检查)是在每一次迭代的最后，因此$(I 循环体)至少会被执行一次：
)

$(MONO
准备

循环体
迭代
条件检查    $(SHELL_NOTE 迭代最后)

循环体
迭代
条件检查    $(SHELL_NOTE 迭代最后)

...
)

$(P
例如， $(C do-while) 用在下面这个猜数字程序里会更加自然，因为用户至少需要猜一次数字以用作比较：
)

---
import std.stdio;
import std.random;

void main() {
    int number = uniform(1, 101);

    writeln("I am thinking of a number between 1 and 100.");

    int guess;

    do {
        write("What is your guess? ");

        readf(" %s", &guess);

        if (number < guess) {
            write("My number is less than that. ");

        } else if (number > guess) {
            write("My number is greater than that. ");
        }

    } while (guess != number);

    writeln("Correct!");
}
---

$(P
这个程序用到了函数 $(C uniform()) ，它是 $(C std.random) 模块的一部分，作用是返回一个指定范围内的随机数。使用方法如上所示，但要注意，函数的第二个参数并不在指定范围内，也就是说此例中， $(C uniform()) 永远不会返回 101。
)

$(PROBLEM_TEK

$(P
编程实现例子中相同的游戏，但是由程序来猜数字，如果实现正确，最多只需要7次程序就能正确的猜到用户指定的数字。
)

)

Macros:
        SUBTITLE=do-while 循环

        DESCRIPTION=D 语言中的 do-while 循环，以及与 while 循环的比较

        KEYWORDS=D 编程语言教程 do while 循环
