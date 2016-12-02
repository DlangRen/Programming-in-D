Ddoc

$(DERS_BOLUMU $(IX input, 格式化) $(IX 格式化输入) 格式化输入)

$(P
与输出一样，数据输入的格式也是可以在程序中指定的。我们既可以指定需要读取的数据格式，也可以指定哪一个字符应被忽略。
)

$(P
D 语言的输入格式化说明符与 C 语言相似。
)

$(P
$(STRING "%s") 将根据变量的类型读取数据，这和我们在前一章中使用的相同。比如下面这个类型为 $(C double) 的变量会令程序从标准输入读取浮点型的数据：
)

---
    double number;

    readf(" %s", &number);
---

$(P
格式化字符串中可包含三类信息：
)

$(UL
$(LI $(B 空白字符)：表示输入中的$(I 零个)或多个空白字符，并指示这些字符应被读取并忽略。)

$(LI $(B 格式化说明符)：输入格式化说明符以 $(C %) 开头，它决定了以何种格式读取数据。这与输出格式化说明符相同。)

$(LI $(B 其它字符)：输入数据中应包含的字符，它们将被读取并忽略。)

)

$(P
格式化字符串能帮我们从输入数据中提取需要的数据，并忽略掉无用的信息。
)

$(P
我们将用一个例子来展示格式化字符串中这三类信息的用法。我们假设学生的学号和成绩是以下面这种格式输入的：
)

$(SHELL
number:123 grade:90
)

$(P
我们需要忽略 $(C number:) 和 $(C grade:) 这两个标签。下面这个格式化字符串会将学号和成绩$(I 提取)出来并忽略其它的字符：
)

---
    int number;
    int grade;
    readf("number:%s grade:%s", &number, &grade);
---

$(P
$(STRING "$(HILITE number:)%s&nbsp;$(HILITE grade:)%s") 中被高亮的字符必须在输入中出现并与指定的格式相同；只有这样 $(C readf()) 才能正确读取并忽略它们。
)

$(P
虽然格式化字符串中只有一个空白字符，但是它能保证所有在指定位置的空白字符都被读取并忽略。
)

$(P
由于字符 $(C %) 在格式化字符串中有特殊含义，所以当我们想要读取并忽略它时需要将其写作 $(C %%)。
)

$(P
在 $(LINK2 /ders/d.cn/strings.html, 字符串) 一章中，我们曾推荐使用 $(C strip(readln())) 来按行读取输入的数据。除了这种方法，在格式化字符串后添加 $(C \n) 也可以达到同样的目的：
)

---
import std.stdio;

void main() {
    write("First name: ");
    string firstName;
    readf(" %s\n", &firstName);    // ← 末尾的 \n

    write("Last name : ");
    string lastName;
    readf(" %s\n", &lastName);     // ← 末尾的 \n

    write("Age       : ");
    int age;
    readf(" %s", &age);

    writefln("%s %s (%s)", firstName, lastName, age);
}
---

$(P
在读取 $(C firstName) 和 $(C lastName) 时，末尾的 $(C \n) 字符将使程序读取并忽略换行符。但字符串末尾可能存在的空格依旧需要使用 $(C strip()) 去除。
)

$(H5 格式化说明符)

$(P
下面的这些字符将指定程序读取数据的方式：
)

$(P $(IX %d, 输入) $(C d)：读取一个十进制整数。)

$(P $(IX %o, 输入) $(C o)：读取一个八进制整数。)

$(P $(IX %x, 输入) $(C x)：读取一个十六进制整数。)

$(P $(IX %f, 输入) $(C f)：读取一个浮点数。)

$(P $(IX %s, 输入) $(C s)：按变量类型读取。这是最常用的说明符。)

$(P $(IX %c) $(C c)：读取一个字符。这个说明符也能读取一个空白字符。（但是它不会将空白字符忽略。）
)

$(P
比如 “23 23 23” 这组数据，根据不同的格式化说明符程序将以不同的形式读取它们。
)

---
    int number_d;
    int number_o;
    int number_x;

    readf(" %d %o %x", &number_d, &number_o, &number_x);

    writeln("Read with %d: ", number_d);
    writeln("Read with %o: ", number_o);
    writeln("Read with %x: ", number_x);
---

$(P
虽然看起来它们都是 “23”，但实际上对程序来说它们的值是不同的：
)

$(SHELL
Read with %d: 23
Read with %o: 19
Read with %x: 35
)

$(P
$(I $(B 注：)“23” 对应的八进制数是 2x8+3=19，对应的十六进制数是 2x16+3=35。)
)

$(PROBLEM_TEK

$(P
假设日期以$(I 年.月.日)的格式输入。编写一个程序显示其中的月份。比如输入了 $(C 2009.09.30)，那程序将输出 $(C 9)。
)

)

Macros:
        SUBTITLE=格式化输入

        DESCRIPTION=以确定的格式读入数据。

        KEYWORDS=D 编程语言教程 格式化 输入
