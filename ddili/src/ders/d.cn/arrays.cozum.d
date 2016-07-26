Ddoc

$(COZUM_BOLUMU 数组)

$(OL

$(LI

---
import std.stdio;
import std.algorithm;

void main() {
    write("How many values will be entered? ");
    int count;
    readf(" %s", &count);

    double[] values;
    values.length = count;

    // 计数器通常命名作‘i’
    int i;
    while (i < count) {
        write("Value ", i, ": ");
        readf(" %s", &values[i]);
        ++i;
    }

    writeln("In sorted order:");
    sort(values);

    i = 0;
    while (i < count) {
        write(values[i], " ");
        ++i;
    }
    writeln();

    writeln("In reverse order:");
    reverse(values);

    i = 0;
    while (i < count) {
        write(values[i], " ");
        ++i;
    }
    writeln();
}
---

)

$(LI
解释包含在代码说明中：

---
import std.stdio;
import std.algorithm;

void main() {
    // 使用动态数组的原因是不知道有多少
    // 值要从输入流中读取
    int[] odds;
    int[] evens;

    writeln("Please enter integers (-1 to terminate):");

    while (true) {

        // 从输入流中读取值
        int value;
        readf(" %s", &value);

        // 特殊值 -1 中断循环
        if (value == -1) {
            break;
        }

        // 根据值的奇偶性，把值添加到
        //相应的数组。如果值被 2 
        // 整除而没有余数，那这个数就是偶数。
        if ((value % 2) == 0) {
            evens ~= value;

        } else {
            odds ~= value;
        }
    }

    // 分别排序奇偶数的数组
    sort(odds);
    sort(evens);

    // 连接两个数组从而形成一个新数组
    int[] result;
    result = odds ~ evens;

    writeln("First the odds then the evens, sorted:");

    // 在循环中输出数组元素
    int i;
    while (i < result.length) {
        write(result[i], " ");
        ++i;
    }

    writeln();
}
---

)

$(LI
程序有三个错误(bugs)。前两个在 $(C while) 循环： 循环条件都使用 $(C <=) 运算符而不使用 $(C <) 运算符。结果是，程序使用无效的索引，试图访问不在数组中的元素。

$(P
自行调试第三个错误对你来说更有益，建议你在修复了前两个 bug 之后先运行一下程序。你将注意到程序不会输出结果。在没有读下面这段话之前你能指出剩下的问题吗？
)

$(P
当第一个 $(C while) 循环结束时 $(C i) 值为 5，该值导致第二个循环的逻辑表达式的值为 $(C false)，是它阻止进入第二个循环。 解决办法就是在第二个 $(C while) 循环前重设 $(C i) 为 0，比如使用语句 $(C i = 0;)
)

)

)

Macros:
        SUBTITLE=数组习题解答

        DESCRIPTION=D 语言编程习题解答：数组

        KEYWORDS=D 语言编程教程 数组 习题解答
