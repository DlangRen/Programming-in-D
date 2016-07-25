Ddoc

$(DERS_BOLUMU $(IX 三元运算符) $(IX ?:) $(IX 条件运算符) 三元运算符 $(CH4 ?:))

$(P
$(C ?:) 运算符与 $(C if-else) 语句的工作模式很像：
)

---
    if (/* 条件检查 */) {
        /* ... 如果条件为 ture 将执行的语句 */

    } else {
        /* ... 如果条件为 false 将执行的语句 */
    }
---

$(P
$(C if) 一定会执行 $(C true) 和 $(C false) 块中的一个。快速回忆一下：作为一个语句，$(C if) 并没有值，它只是影响代码块的执行流程。
)

$(P
而我们这章要学习的 $(C ?:) 运算符是一个表达式。除了有 $(C if-else) 的功能，它还会产生一个值。它等价于下面这样的代码：
)

---
/* 条件 */ ?/* 条件为 true 时执行的表达式 */ : /* 条件为 false 时执行的表达式  */
---

$(P
由于 $(C ?:) 运算符一共使用了三个表达式，所以我们称它为三元运算符。
)

$(P
运算符产生的值为后两个表达式中的一个。别忘了它是表达式，所以它可以用在任何一个表达式能使用的地方。
)

$(P
下面这个例子对比了 $(C ?:) 运算符和 $(C if-else) 语句。对于和例子相似的情况来说，三元运算符通常更加简洁明了。
)

$(UL

$(LI $(B 初始化)

$(P
初始化一个变量，如果是闰年则将其初始化为 366，如果不是则初始化为 365：
)

---
    int days = isLeapYear ?366 : 365;
---

$(P
如果使用 $(C if) 语句，我们只能先以无显式初始值的方式定义变量，然后在将需要的值赋给它：
)

---
    int days;

    if (isLeapYear) {
        days = 366;

    } else {
        days = 365;
    }
---

$(P
另一种使用 $(C if) 初始化的方法是先以非闰年的值初始化变量，如果是闰年则再使其自增 1：
)

---
    int days = 365;

    if (isLeapYear) {
        ++days;
    }
---

)

$(LI $(B 显示)

$(P
在屏幕上显示信息，信息的一部分会随着条件的不同而改变：
)
---
    writeln("The glass is half ",
            isOptimistic ?"full." : "empty.");
---

$(P
如果使用 $(C if)，信息的最后一部分则需要单独输出：
)

---
    write("The glass is half ");

    if (isOptimistic) {
        writeln("full.");

    } else {
        writeln("empty.");
    }
---

$(P
当然也可以将整条信息分开输出：
)

---
    if (isOptimistic) {
        writeln("The glass is half full.");

    } else {
        writeln("The glass is half empty.");
    }
---

)

$(LI $(B 运算)

$(P
在一个西洋双陆棋的游戏中为胜者加分，如果全胜加 2 分，反之加 1 分：
)

---
    score += isGammon ?2 : 1;
---

$(P
直接使用 $(C if) 的等价方法是：
)

---
    if (isGammon) {
        score += 2;

    } else {
        score += 1;
    }
---

$(P
当然也可以直接令其自增 1，之后再用 $(C if) 判断，如果全胜则令其再自增 1：
)

---
    ++score;

    if (isGammon) {
        ++score;
    }
---

)

)

$(P
就像我们从上面的例子看到的那样，在特定情况下使用三元运算符能使代码更加简洁明了。
)

$(H5 三元表达式的返回的类型)

$(P
三元运算符 $(C ?:) 的值为后两个表达式中的一个。这两个表达式的类型可以不同，但它们必须有一个$(I 公共类型)。
)

$(P
$(IX 公共类型) 表达式的公共类型是由一个相对复杂的算法定义的，涉及 $(LINK2 /ders/d.cn/cast.html, 类型转换) 和 $(LINK2 /ders/d.cn/inheritance.html, 继承)。除此之外，结果的$(I 值类型)取决于表达式，它 $(LINK2 /ders/d.cn/lvalue_rvalue.html, 既可能是左值也可能是右值)。我们会在之后的章节中了解到这些概念。
)

$(P
就眼下来说，你只需要接受一个公共类型就可以避免显式类型转换。例如，数字类型 $(C int) 和 $(C long) 就有一个公共类型，因为它们都可以被 $(C long) 储存。而 $(C int) 和 $(C string) 就没有公共类型，即 $(C int) 和 $(C string) 无法自动相互转换。
)

$(P
你可以对其使用 $(C typeof) 运算符并输出其结果的 $(C .stringof) 属性来判断表达式的类型。
)

---
    int i;
    double d;

    auto result = someCondition ?i : d;
    writeln(typeof(result)$(HILITE .stringof));
---

$(P
由于 $(C double) 可以储存 $(C int) 而 $(C int) 无法储存 $(C double)，这个三元表达式的公共类型即为 $(C double)：
)

$(SHELL
double
)

$(P
下面这个例子是用于排版装载货物数量信息的，其中三元运算符的两个表达式没有公共类型。当数量为 12 时显示“A dozen”：“A $(B dozen) items will be shipped.”。如果数量不等于 12 则令消息包含精确的数字：“$(B 3) items will be shipped.”。
)

$(P
你可能会想对消息中变化的部分使用 $(C ?:) 运算符：
)

---
    writeln(
        (count == 12) ?"A dozen" : count, $(DERLEME_HATASI)
        " items will be shipped.");
---

$(P
然而由于 $(STRING "A dozen") 的类型为 $(C string) 而 $(C count) 的类型为 $(C int)，这个表达式没有公共类型。
)

$(P
解决方案是提前将 $(C count) 转换为 $(C string)。$(C std.conv) 模块中的 $(C to!string) 可将其参数转换为 $(C string)。
)

---
import std.conv;
// ...
    writeln((count == 12) ?"A dozen" : to!string(count),
            " items will be shipped.");
---

$(P
现在 $(C ?:) 运算符的两个选择表达式都是 $(C string) 类型了，这样程序就可通过编译并正常运行。
)

$(PROBLEM_TEK

$(P
编写一个程序来对业绩信息进行排版。程序接收一个 $(C int) 作为$(I 净增长额)，整数表示收益，负数表示亏损。
)

$(P
若净增长额为正数，则程序的输出中应包含“gained”，反之则包含“lost”。例如："&#36;100 lost" 或 "&#36;70 gained"。不要在这次练习中使用 $(C if)，即使你觉得它写起来很舒服。
)

)


Macros:
        SUBTITLE=三元运算符 ?:

        DESCRIPTION=D 语言中的 ?: 运算符及它与 if-else 语句的对比

        KEYWORDS=D 编程语言教程 三元运算符
