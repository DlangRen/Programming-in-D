Ddoc

$(DERS_BOLUMU $(IX file) 文件)

$(P
在前面的章节我们了解到标准输入输出流可以通过在终端中使用 $(C >)、$(C <) 或 $(C |) 运算符重定向至文件或另一个程序。虽然管道非常强大，但是它并不适用于所有情况。因为在大多数情况下仅通过简单的读取和输出程序并不能完成任务。
)

$(P
举个例子：一个处理学生记录的程序可能需要使用标准输出来显示菜单。程序需要将学生记录写入到一个真实存在的文件而不是 $(C stdout)。
)

$(P
本章中，我们将学习读取和写入文件系统中的文件的方法。
)

$(H5 基本概念)

$(P
文件是指 $(C std.stdio) 模块中的 $(C File) $(I 结构体)。因为我还没有介绍结构体，所以我们现在不得不暂且接受结构体的构造语法。
)

$(P
在接触代码示例之前我们需要先了解一些有关文件的基本概念。
)

$(H6 创建者和用户)

$(P
在某个平台上创建的文件可能无法在其他平台上使用。仅仅是打开文件并向其中写入数据是不够的，我们还需要确保数据能被用户正确获取。数据的创建者和用户必须在文件的数据格式上达成一致。例如，如果创建者将学生记录中的学生 ID 和学生姓名以某种顺序写入文件，那用户必须以相同的顺序读取。
)

$(P
除此之外，下面的代码示例并没有在文件开头写入$(I 字节顺序标记（byte order mark）) (BOM)。这可能使你的文件无法兼容需要 BOM 的系统。（BOM 指明文件是以什么样的顺序组织 UTF 字符的代码单元。）
)

$(H6 访问权限)

$(P
文件系统在给程序提供文件时会附以特定的权限。访问权限对数据的完整性和操作文件的性能都非常重要。
)

$(P
在读取文件时，文件系统可能允许多个程序同时读取一个文件以提高其性能，因为程序不再需要等待其他程序读取完成后再开始读取。而对于写入，即使只有一个程序想要写入文件，禁止并发访问文件也往往是有益的。通过锁定文件，操作系统可以防止其他程序读取到不完整的数据或将彼此的数据覆盖等情况的发生。
)

$(H6 打开文件)

$(P
在程序启动时标准输入流 $(C stdin) 和标准输出流 $(C stdout) 就已经被$(I 打开)。你可以随时使用它们。
)

$(P
通常情况下，必须先通过指定文件名和访问权限打开文件才能对其进行操作。就像我们在下面这个例子中看到的这样，创建一个 $(C File) 对象来打开指定的文件：
)

---
    File file = File("student_records", "r");
---

$(H6 关闭文件)

$(P
在使用完成后程序必须将其打开的文件关闭。在大多数情况下你不需要手动关闭文件；它们会在 $(C File) 对象被销毁时自动关闭。

)

---
if (aCondition) {

    // 假设我们在这里创建并使用了一个文件对象。
    // ...

} // ← 文件将会在离开此作用域时自动关闭
  //   你不需要显式关闭它。
---

$(P
某些时候你需要重新打开文件对象以访问另一个文件或以不同的权限访问之前的文件。在这种情况下需先将文件关闭然后再重新打开它。
)

---
    file.close();
    file.open("student_records", "r");
---

$(H6 写入和读取文件)

$(P
文件的输入输出函数与向控制台输入输出的函数 $(C writeln)、$(C readf) 等的用法相同，因为它们都是字符流。唯一的区别是你需要一个类型为 $(C File) 的变量名和一个点运算符：
)

---
    writeln("hello");        // 写至标准输出
    stdout.writeln("hello"); // 同上
    $(HILITE file.)writeln("hello");   // 写入某个文件
---

$(H6 $(IX eof) 使用 $(C eof()) 判断是否到达文件末尾)

$(P
在读取文件时，$(C File) 的成员函数 $(C eof()) 可以用来判断是否已经读取到文件末尾。在到达文件末尾时该函数返回 $(C true)。
)

$(P
例如下面这个循环会一直执行直到文件流到达末尾：
)

---
    while (!file.eof()) {
        // ...
    }
---

$(H6 $(IX std.file) $(C std.file) 模块)

$(P
$(LINK2 http://dlang.org/phobos/std_file.html, $(C std.file) 模块) 提供了一些用于操作目录内容的实用函数和类型。例如 $(C exists) 可以检测一个文件或目录是否存在于文件系统上：
)

---
import std.file;

// ...

    if (exists(fileName)) {
        // 对应名称的文件或目录存在

    } else {
        // 对应名称的文件或目录不存在
    }
---

$(H5 $(IX File) $(C std.stdio.File) 结构体)

$(P
$(IX mode, 文件) $(C File) 结构体在 $(LINK2 http://dlang.org/phobos/std_stdio.html, $(C std.stdio) 模块) 中。要使用它只需指定要打开的文件名称和访问权限或访问模式。它和 C 语言中的 $(C fopen) 函数的模式字符相同：
)

<table class="wide" border="1" cellpadding="4" cellspacing="0">
<tr align="center"><th scope="col">&nbsp;模式&nbsp;</th> <th scope="col">说明</th></tr>

<tr><td align="center">r</td><td>$(B 读取)权限$(BR)打开文件并从文件开头读取</td></tr>

<tr><td align="center">r+</td><td>$(B 读取和写入)权限$(BR)打开文件并从文件开头读取或写入</td></tr>

<tr><td align="center">w</td><td>$(B 写入)权限$(BR)如果文件不存在，则创建一个空文件$(BR)如果文件存在，则将其内容清空</td></tr>

<tr><td align="center">w+</td><td>$(B 读取和写入)权限$(BR)如果文件不存在，则创建一个空文件$(BR)如果文件存在，则将其内容清空</td></tr>

<tr><td align="center">a</td><td>$(B 追加)权限$(BR)如果文件不存在，则创建一个空文件$(BR)如果文件存在，则打开文件并在文件末尾写入，同时不会影响原有内容</td></tr>

<tr><td align="center">a+</td><td>$(B 读取和追加)权限$(BR)如果文件不存在，则创建一个空文件$(BR)如果文件存在，则打开文件并在文件末尾写入或从其开头读取，同时不会影响原有内容</td></tr>
</table>

$(P
除此之外，你还可以在模式字符中添加 ’b‘，例如 “rb”。如果平台支持程序将会以$(I 二进制模式)操作文件，但在 POSIX 系统中它将被忽略。
)

$(H6 写入文件)

$(P
首先，文件必须以一种写入模式打开：
)

---
import std.stdio;

void main() {
    File file = File("student_records", $(HILITE "w"));

    file.writeln("Name  : ", "Zafer");
    file.writeln("Number: ", 123);
    file.writeln("Class : ", "1A");
}
---

$(P
就像我们在 $(LINK2 /ders/d.cn/strings.html, Strings 一节) 中提到的，像 $(STRING "student_records") 这样的指定文件名的字符串的类型是 $(C string)，它包含的是不可变的字符。因此我们不能使用可变的文本（比如 $(C char[])）来指定文件名创建 $(C File) 对象。如果出于某种原因你必须使用可变的文本类型，那你应当使用其 $(C .idup) 属性来获得其不可变字符拷贝。
)

$(P
上面的程序创建或覆盖了一个与其处在相同文件夹（程序的$(I 工作目录)）的名为 $(C student_records) 的文件。
)

$(P
$(I $(B 注意：)文件名可以包含任意文件系统认为是合法的字符。为简便我们将只是用常见的 ASCII 字符作文件名。)
)

$(H6 读取文件)

$(P
在读取文件前文件必须以某种读取模式打开：
)

---
import std.stdio;
import std.string;

void main() {
    File file = File("student_records", $(HILITE "r"));

    while (!file.eof()) {
        string line = strip(file.readln());
        writeln("read line -> |", line);
    }
}
---

$(P
上面的程序读取了名为 $(C student_records) 的文件中的每一行并将其打印至标准输出。
)

$(PROBLEM_TEK

$(P
编写一个程序，从用户处获取文件名，打开文件并将其中所有非空行写入到另一个文件。新文件的名称应基于原文件。例如：如果源文件名为 $(C foo.txt)，那新文件名可为 $(C foo.txt.out)。
)

)

Macros:
        SUBTITLE=文件

        DESCRIPTION=基础文件操作。

        KEYWORDS=D 编程语言教程 file
