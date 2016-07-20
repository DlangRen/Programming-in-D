Ddoc

$(DERS_BOLUMU 字符串)

$(P
迄今为至，我们已经看到，好多程序都用到了字符串。字符串是在过去三章中介绍的两种功能的组合：字符和数组。在最简单的定义中，字符串只不过是字符数组。例如，$(C char[]) 是一个字符串类型。
)

$(P
这个简单的定义可能是个误导。正如我们在 $(LINK2 /ders/d.cn/characters.html, 字符) 一章中看到的，D 具有三种独立的字符类型。这些字符类型的数组对应着三种独立的字符串类型，其中一些可能会在一些字符串操作上有出人意料的结果。
)

$(H5 $(IX readln) $(IX strip) 使用 $(C readln) 和 $(C strip)，而非 $(C readf))

$(P
从终端读字符串您会有一些惊奇。
)

$(P
作为字符数组，字符串能包含像 $(STRING '\n') 这样的控制字符。当从输入中读取字符串，输入结束时按的 Enter 键对应的控制字符将变成字符串的一部分。另外，因为没有办法告诉 $(C readf()) 要读取多少字符，它持续读，直到整个输入结束。因而，$(C readf()) 不能如愿读取字符串：
)

---
import std.stdio;

void main() {
    char[] name;

    write("What is your name? ");
    readf(" %s", &name);

    writeln("Hello ", name, "!");
}
---

$(P
用户在名字之后按的 Enter 键并没有结束输入。$(C readf()) 继续等待新输入的字符以添加到字符串：
)

$(SHELL
What is your name? Mert
   $(SHELL_NOTE 虽然按了 Enter 键，但输入没有中断)
   $(SHELL_NOTE （让我们假设在这儿第二次按了 Enter 键）)
)

$(P
在终端结束标准输入流的方法随系统而不同，在 Unix 系统下按 Ctrl-D，在 Windows 系统下按 Ctrl-Z。如果用户最后这样结束输入，我们看到换行符已作为字符串的一部分被读取：
)

$(SHELL
Hello Mert
   $(SHELL_NOTE_WRONG 名字之后的换行符)
!  $(SHELL_NOTE_WRONG （在感叹号前还有一个）)
)

$(P
感叹号出现在了那些字符之后，而不是在名字之后立即被输出。
)

$(P
$(C readln()) 更适合读取字符串。它是“read line”的缩写，$(C readln()) 读取到行尾。不同的是没有 $(STRING " %s") 格式字符串并且不需要 $(C &) 运算符：
)

---
import std.stdio;

void main() {
    char[] name;

    write("What is your name? ");
    $(HILITE readln(name));

    writeln("Hello ", name, "!");
}
---

$(P
$(C readln()) 也存储换行符。这就让程序有办法确定输入是否包含一条完整语句或者输入是否已结束： 
)

$(SHELL
What is your name?Mert
Hello Mert
!  $(SHELL_NOTE_WRONG 感叹号前有换行符)
)

$(P
这样的控制字符，就像所有位于字符串两端的空白字符一样，能被 $(C std.string.strip) 移除：
)

---
import std.stdio;
$(HILITE import std.string;)

void main() {
    char[] name;

    write("What is your name? ");
    readln(name);
    $(HILITE name = strip(name);)

    writeln("Hello ", name, "!");
}
---

$(P
上面的 $(C strip()) 表达式返回一个不包含尾部控制符的新字符串。返回值再赋值给 $(C name)，得到预期的输出：
)

$(SHELL
What is your name? Mert
Hello Mert!    $(SHELL_NOTE 没有换行符)
)

$(P
$(C readln()) 没有参数也可以使用。在这种情况下它$(I 返回)刚刚读入的行。将 $(C readln()) 的结果放到 $(C strip())中，能得到更短且可读性更好的语法：
)

---
    string name = strip(readln());
---

$(P
在介绍了下面的 $(C string) 类型之后，我们将开始使用这种格式。
)

$(H5 $(IX formattedRead) 使用 $(C formattedRead) 函数来解析字符串)

$(P
一旦从输入流或其他任何来源中读取了一行字符，就可以用 $(C std.format) 模块的 $(C formattedRead()) 函数来解析并转换它所包含的独立数据。它的第一个参数是包含数据的输入行，而其余的参数就与用于 $(C readf()) 中的一模一样：
)

---
import std.stdio;
import std.string;
$(HILITE import std.format;)

void main() {
    write("Please enter your name and age," ~
          " separated with a space: ");

    string line = strip(readln());

    string name;
    int age;
    $(HILITE formattedRead)(line, " %s %s", &name, &age);

    writeln("Your name is ", name,
            ", and your age is ", age, '.');
}
---

$(SHELL
Please enter your name and age, separated with a space: $(HILITE Mert 30)
Your name is $(HILITE Mert), and your age is $(HILITE 30).
)

$(P
$(C readf()) 和 $(C formattedRead()) 函数都$(I 返回)它们所能够成功解析及转换的项目个数。该值可与所期望的数据个数相比较，以便确定输入的有效性。例如，像上面的 $(C formattedRead()) 函数期望去读$(I 两个)数据（一个 $(C string) 型 name 和一个 $(C int) 型 age），下面的检查能够确保它确实如此：
)

---
    $(HILITE uint items) = formattedRead(line, " %s %s", &name, &age);

    if ($(HILITE items != 2)) {
        writeln("Error: Unexpected line.");

    } else {
        writeln("Your name is ", name,
                ", and your age is ", age, '.');
    }
---

$(P
当输入不能转换到 $(C name) 和 $(C age) 时，程序将打印一个错误：
)

$(SHELL
Please enter your name and age, separated with a space: $(HILITE Mert)
Error: Unexpected line.
)

$(H5 $(IX &quot;) 使用双引号，而非单引号)

$(P
我们已经看到单引号用于定义字符字面量。字符串字面量用双引号定义。$(STRING 'a') 是一个字符；$(STRING "a") 是一个包含单字符的字符串。
)

$(H5 $(IX string) $(IX wstring) $(IX dstring) $(IX char[]) $(IX wchar[]) $(IX dchar[]) $(IX immutable) $(C string)、$(C wstring) 和 $(C dstring) 是 immutable（不可变）的)

$(P
对应着三种字符类型，分别存在三种字符串类型：$(C char[])、$(C wchar[]) 和 $(C dchar[])。
)

$(P
这些类型的 $(I immutable) 版本有三个$(I 别名)：$(C string)、$(C wstring) 和 $(C dstring)。由这些别名定义的变量中的字符不可修改。例如，可以修改一个 $(C wchar[]) 中的字符，但不可以修改一个 $(C wstring) 中的字符。（在稍后的章节我们将看到 D 的$(I 不可变性)概念。）
)

$(P
例如，下面这段代码尝试着修改 $(C string) 的首字母为大写，这将引发一个编译错误： 
)

---
    string cannotBeMutated = "hello";
    cannotBeMutated[0] = 'H';             $(DERLEME_HATASI)
---

$(P
我们可能想到把变量定义为 $(C char[]) 而不是别名 $(C string)，但这也不能通过编译：
)

---
    char[] a_slice = "hello";  $(DERLEME_HATASI)
---

$(P
这次的编译错误是因为两个因素的联合作用：
)

$(OL
$(LI 像 $(STRING "hello") 这样的字符串字面量的类型是 $(C string)，而不是 $(C char[])，因此它们是不可变的。
)
$(LI 左手侧的 $(C char[]) 是一个切片，这意味着，一旦代码编译成功，它将会提供对右手侧全部字符的访问。
)
)

$(P
由于 $(C char[]) 可变而 $(C string) 不可变，两者不批配。编译器不允许通过可变的切片访问不可变的字符数组。
)

$(P
此处的解决办法是通过 $(C .dup) property（属性）得到一个不可变字符串的副本：
)

---
import std.stdio;

void main() {
    char[] s = "hello"$(HILITE .dup);
    s[0] = 'H';
    writeln(s);
}
---

$(P
现在程序能通过编译并且打印修改后的字符串：
)

$(SHELL
Hello
)

$(P
同样的，$(C char[]) 不能被用到需要 $(C string) 的地方。这种情况下，$(C .idup) property 能被用来从一个可变的 $(C char[]) 变量中获取一个不可变的 $(C string) 变量。例如，如果 $(C s) 的变量类型是 $(C char[])，下面这行将编译失败：
)

---
    string result = s ~ '.';          $(DERLEME_HATASI)
---

$(P
当 $(C s) 的类型是 $(C char[])，上面右手侧赋值的表达式类型即也是 $(C char[])，$(C .idup) 可用来从存在的字符串中生成不可变的字符串：
)

---
    string result = (s ~ '.')$(HILITE .idup);   // ← 现在可以编译
---

$(H5 $(IX length, string) 有可能让人困惑的字符串长度)

$(P
我们已经知道一些 Unicode 字符串由多个字节表示。例如，字符‘é’ (拉丁字母‘e’包含了一个重音符) 由 Unicode 编码表示，至少用了两个字节。这个事实反映在字符串的 $(C .length) property 上：
)

---
    writeln("résumé".length);
---

$(P
虽然 "résumé" 包含6个$(I 字母)，但$(C 字符串)的长度是它包含的 UTF-8 编码单元的个数：
)

$(SHELL
8
)

$(P
像 $(STRING "hello") 这样的字符串字面量的元素类型是 $(C char)，并且每个 $(C char) 值对应一个 UTF-8 编码单元。当我们试着用一个单字节字符替换一个双字节字符时问题就来了：
)

---
    char[] s = "résumé".dup;
    writeln("Before: ", s);
    s[1] = 'e';
    s[5] = 'e';
    writeln("After : ", s);
---

$(P
两个‘e’字符不能代替两个‘é’字符；用单字节编码单元替换后，结果就是得到一个无效的 UTF-8 编码：
)

$(SHELL
Before: résumé
After : re�sueé    $(SHELL_NOTE_WRONG 不正确)
)

$(P
当直接处理字母、符号或其它 Unicode 字符的时候，比如在上面代码中，应该使用正确的类型 $(C dchar)：
)

---
    dchar[] s = "résumé"d.dup;
    writeln("Before: ", s);
    s[1] = 'e';
    s[5] = 'e';
    writeln("After : ", s);
---

$(P
输出：
)

$(SHELL
Before: résumé
After : resume
)

$(P
请注意新代码的两个不同：
)
$(OL
$(LI 字符串的类型是 $(C dchar[])。
$(LI 有一个 $(C d) 在字面量 $(STRING "résumé"d) 的末尾，指定了它的类型是一个 $(C dchar) 型数组。)
)
)

$(P
无论如何，请记住使用 $(C dchar[]) 和 $(C dstring) 并不能解决所有的操作 Unicode 字符的问题。例如，如果用户输入文本“résumé”，即使使用 $(C dchar) 字符串，你和你的程序仍然不能确保字符串的长度会是 6。如果至少其中一个‘é’字符编码为单个编码单元，而是一个‘e’与一个重音符组合单元的组合，那么它就可能会更长。为避免处理这种以及许多其它的 Unicode 问题，在你的程序里就要考虑使用一个支持 Unicode 的文本处理库。
)

$(H5 $(IX literal, string) 字符串字面量)

$(P
在字符串字面量之后指定的可选字符决定了字符串的元素类型：
)

---
import std.stdio;

void main() {
     string s = "résumé"c;   // 与“résumé”一样
    wstring w = "résumé"w;
    dstring d = "résumé"d;

    writeln(s.length);
    writeln(w.length);
    writeln(d.length);
}
---

$(P
输出：
)

$(SHELL
8
6
6
)

$(P
因为所有的“résumé”的 Unicode 字符都能用单个 $(C wchar) 或者 $(C dchar) 表示，所以最后两个的长度与字符个数是一致的。
)

$(H5 $(IX concatenation, string) 字符串连接)

$(P
由于它们实际上是数组，所有数组的操作也都能应用到字符串上。$(C ~) 可以连接两个字符串，$(C ~=) 则能够附加字符串到一个已存在的字符串上：
)

---
import std.stdio;
import std.string;

void main() {
    write("What is your name? ");
    string name = strip(readln());

    // 连接：
    string greeting = "Hello " ~ name;

    // Append:
    greeting ~= "! Welcome...";

    writeln(greeting);
}
---

$(P
输出：
)

$(SHELL
What is your name? Can
Hello Can! Welcome...
)

$(H5 比较字符串)

$(P
$(I $(B 注：)除了 Unicode 编码顺序之外，Unicode 不定义字符的排列顺序。因此，下面的输出结果不是你所期望的那样。)
)

$(P
我们以前把比较运算符 $(C <)、$(C >=) 等等用于整型和浮点数值。同样的操作也能用于字符串，但含义不同：字符串按$(I 字典顺序)排序。这种排序需要在一个假设的大字母表中让每个字符的 Unicode 编码找到它的位置。在这个假设的字母表中，$(I 更少)和$(I 更多)的概念就被$(I 之前)和$(I 之后)代替：
)

---
import std.stdio;
import std.string;

void main() {
    write("      Enter a string: ");
    string s1 = strip(readln());

    write("Enter another string: ");
    string s2 = strip(readln());

    if (s1 $(HILITE ==) s2) {
        writeln("They are the same!");

    } else {
        string former;
        string latter;

        if (s1 $(HILITE <) s2) {
            former = s1;
            latter = s2;

        } else {
            former = s2;
            latter = s1;
        }

        writeln("'", former, "' comes before '", latter, "'.");
    }
}
---

$(P
由于 Unicode 采用来自于 ASCII 表的基本拉丁字母，仅包含 ASCII 字母的字符串将会正确排序。
)

$(H5 小写与大写不同)

$(P
因为每个字母都有一个唯一的编码，每个字母变体都与其它的不同。例如，当直接比较 Unicode 字符串时，‘A’和‘a’是不同的字母。
)

$(P
另外，受 ASCII 编码值的影响，所有拉丁大写字母都排在小写字母的前面。例如，‘B’排在‘a’之前。无论小写大写，$(C std.string) 模块中的 $(C icmp()) 函数可用于字符串比较。在 $(LINK2 http://dlang.org/phobos/std_string.html, 它的在线文档) 中你可以看到这个模块的各个函数。
)

$(P
因为字符串是数组（进一步而言，是 $(I range)），所以 $(C std.array)、$(C std.algorithm) 和 $(C std.range) 模块中的函数对与于字符串也都非常有用。
)

$(PROBLEM_COK

$(PROBLEM
浏览 $(C std.string)、$(C std.array)、$(C std.algorithm) 和 $(C std.range) 模块的文档。
)

$(PROBLEM
写一个使用 $(C ~) 运算符的程序：让用户都以小写键入英文名字和姓氏。生成一个姓名首字母大写的全名。例如，字符串是“ebru”和“domates”，程序应该打印出“Ebru&nbsp;Domates”。
)

$(PROBLEM
从输入中读取一行并打印该行的第一个和最后一个‘e’字母之间的部分。例如，若这行是“this line has five words”程序就应该打印出“e has five”。

$(P
你或许会发现 $(C indexOf()) 和 $(C lastIndexOf()) 函数对生成切片所需要的两个索引很有用。
)

$(P
与它们的文档中所指出一样，$(C indexOf()) 和 $(C lastIndexOf()) 的返回类型不是 $(C int)，也不是 $(C size_t)，而是 $(C ptrdiff_t)。您可能就需要定义该类型的变量：
)

---
    ptrdiff_t first_e = indexOf(line, 'e');
---

$(P
也可以使用 $(C auto) 关键字定义变量，这个我们将在后面的一章中看到：
)

---
    auto first_e = indexOf(line, 'e');
---

)

)

Macros:
        SUBTITLE=字符串

        DESCRIPTION=D语言的字符串

        KEYWORDS=D 语言教程 string
