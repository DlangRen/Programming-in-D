Ddoc

$(DERS_BOLUMU $(IX input) 从标准输入中读取数据)

$(P
程序读取的任何数据首先必须要存储在一个变量中。比如，一个从输入中读取学生人数的程序必须存储此信息在一个变量中。这个特定变量的类型可以是 $(C int)。
)

$(P
正如在前面的章节所看到的，当打印信息到输出时，我们不需要键入 $(C stdout)。因为它是隐含的。此外，要打印的信息会被指定为参数。所以，$(C write(studentCount)) 语句足够打印出 $(C studentCount) 的值了。概述如下:
)

$(MONO
stream:      stdout
operation:   write
data:        the value of the studentCount variable
target:      commonly the terminal window
)

$(P
$(IX readf) $(C write) 的相反操作是 $(C readf)；它会从标准输入中读取数据。该函数名字中的 "f" 来源于 "formatted"，它表示总是按照一个特定格式读取数据。
)

$(P
从前面的章节中，我们也知道了标准输入流是 $(C stdin)。
)

$(P
在读取数据时，还有一个令人困惑的事情：把数据存在哪儿呢。概述如下:
)

$(MONO
stream:      stdin
operation:   readf
data:        some information
target:      ?
)

$(P
可以指定一个变量的地址作为存储数据的位置。变量的地址指的是数据存储在计算机内存中的精确位置。
)

$(P
$(IX &, address of) 在 D 中，某个名字前面的 $(C &) 字符表示该名字代表的地址。举个例子，$(C studentCount) 变量的地址就是 $(C &amp;studentCount)。这里，$(C &amp;studentCount) 可以解读为“$(C studentCount) 的地址"，同时也用于代替上面问号处缺失的部分:
)

$(MONO
stream:      stdin
operation:   readf
data:        some information
target:      the location of the studentCount variable
)

$(P
在某个名字前面键入 $(C &) 表示 $(I 指向) 该名字代表处。这个概念是稍后章节中引用和指针的基础。
)

$(P
稍后，我将解释 $(C readf) 的使用。现在，让我们先接受 $(C readf) 的第一个参数必须是 $(STRING "%s") 的规则:
)

---
    readf("%s", &studentCount);
---

$(P
$(I $(B 注意:) 正如我在下面解释的那样，大多数情况还必须有一个空格: $(STRING "&nbsp;%s")。)
)

$(P
$(STRING "%s") 表明数据应该被自动转换成适合该变量类型的方式。举个例子，当读取字符 '4' 和 '2' 到一个 $(C int) 类型的变量时，它们会被转换成整型值 42。
)

$(P
下面的程序要求用户输入学生的数量。你必须在打字输入后按下回车键:
)

---
import std.stdio;

void main() {
    write("How many students are there? ");

    /* The definition of the variable that will be used to
     * store the information that is read from the input. */
    int studentCount;

    // Storing the input data to that variable
    readf("%s", &studentCount);

    writeln("Got it: There are ", studentCount, " students.");
}
---

$(H5 $(IX %s, with whitespace) $(IX whitespace) 跳过空白字符)

$(P
按下回车键之后，数据就会存储为特殊的编码，并放入 $(C stdin) 流中。这对于检测输入的信息是单行还是多行非常有帮助。
)

$(P
尽管有时候有用，但这样的特殊编码通常对于程序来说并不重要，而且必须从输入中过滤掉。否则的话，它们会 $(I 阻塞) 输入，防止读取其它数据。
)

$(P
要在程序中看到这个 $(I 问题)，让我们还从输入中读取教师的数量:
)

---
import std.stdio;

void main() {
    write("How many students are there? ");
    int studentCount;
    readf("%s", &studentCount);

    write("How many teachers are there? ");
    int teacherCount;
    readf("%s", &teacherCount);

    writeln("Got it: There are ", studentCount, " students",
            " and ", teacherCount, " teachers.");
}
---

$(P
很不幸，程序在期望一个 $(C int) 值时，不能用特殊编码:
)

$(SHELL
How many students are there? 100
How many teachers are there? 20
  $(SHELL_NOTE_WRONG An exception is thrown here)
)

$(P
虽然用户输入了教师数量 20，但用户前面输入 100 时按下了回车键。这个特殊编码仍然在输入流中，并阻塞了该输入流。出现在输入流中的字符跟下面的表示很类似:
)

$(MONO
100$(HILITE [EnterCode])20[EnterCode]
)

$(P
我对阻塞输入的 Enter code 进行了高亮显示。
)

$(P
解决方案是在 $(STRING %s) 前面使用一个空格字符，以表明出现在读取教师数量之前的 Enter code 并不重要: $(STRING "&nbsp;%s")。格式化字符串中的空格用于读取并忽略 0 个或多个隐藏在输入中的不可见字符。这样的字符包括空格字符，表示回车键的编码，制表符等。它们统一叫做 $(I 空白字符)。
)

$(P
作为一个通用规则，从输入中读取的每份数据你都可以使用 $(STRING "&nbsp;%s")。上面的程序应用下面的更改就可以像期望的那样工作了:
)

---
// ...
    readf(" %s", &studentCount);
// ...
    readf(" %s", &teacherCount);
// ...
---

$(P
输出:
)

$(SHELL
How many students are there? 100
How many teachers are there? 20
Got it: There are 100 students and 20 teachers.
)

$(H5 附加信息)

$(UL

$(LI
$(IX comment) $(IX /*) $(IX */) 起始于 $(COMMENT //) 的行适用于单行注释。要进行多行注释，可以把多行封装入一对 $(COMMENT /*) 和 $(COMMENT */) 标记中。


$(P
$(IX /+) $(IX +/) 为了能够注释其它注释，可以使用 $(COMMENT /+) 和 $(COMMENT +/) 标记对:

)

---
    /+
     // A single line of comment

     /*
       A comment that spans
       multiple lines
      */

      /+
        It can even include nested /+ comments +/
      +/

      A comment block that includes other comments
     +/
---

)

$(LI
源代码中的大多数空白都是无关紧要的。把很长的表达式写成多行或者添加额外的空白使得代码更易读是一个良好实践。当然，只要符合编程语言的语法规则，编写程序也可以不用额外的空白:

---
import std.stdio;void main(){writeln("Hard to read!");}
---

$(P
只有少量空白的源代码非常难读。
)

)

)

$(PROBLEM_TEK

$(P
当程序期望整型值时，输入非数字字符。此时就会观察到程序不能正常工作。
)

)


Macros:
        SUBTITLE=Reading from the Standard Input

        DESCRIPTION=Getting information from the input in D

        KEYWORDS=d programming language tutorial book read stdin

MINI_SOZLUK=
