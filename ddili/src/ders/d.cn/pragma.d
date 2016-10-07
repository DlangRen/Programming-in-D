Ddoc

$(DERS_BOLUMU $(IX pragma) Pragmas)

$(P
Pragma 是一种与编译器交互的方法。可以通过他们向编译器提供或获取特殊的信息。$(C pragma(msg)) 在非模板代码中非常有用，调试模板亦然。
)

$(P
每一个编译器生产商都可以任意添加他们的特殊 $(C pragma) 指令，但以下指令是强制实现的：
)

$(H5 $(C pragma(msg)))

$(P
在编译期向 $(C stderr) 打印消息。编译后的程序在执行过程中不会输出任何消息。
)

$(P
例如，如下的 $(C pragma(msg)) 通常用于在调试期暴露模板参数的类型：
)

---
import std.string;

void func(A, B)(A a, B b) {
    pragma($(HILITE msg), format("Called with types '%s' and '%s'",
                       A.stringof, B.stringof));
    // ...
}

void main() {
    func(42, 1.5);
    func("hello", 'a');
}
---

$(SHELL
Called with types 'int' and 'double'
Called with types 'string' and 'char'
)

$(H5 $(C pragma(lib)))

$(P
命令编译器将程序与一个特别的库链接。这是将程序链接到一个已经安装到系统里的库的最方便的做法。
)

$(P
例如，下面的程序会被链接到 $(C curl) 而不用在命令行指定这个库：
)

---
import std.stdio;
import std.net.curl;

pragma($(HILITE lib), "curl");

void main() {
    // Get this chapter
    writeln(get("ddili.org/ders/d.en/pragma.html"));
}
---

$(H5 $(IX 内联) $(IX 函数内联) $(IX 优化, 编译器) $(C pragma(inline)))

$(P
指定函数是否被$(I 内联)。
Specifies whether a function should be $(I inlined) or not.
)

$(P
每一次函数调用都有性能损耗。函数调用需要处理函数的参数传递，返回调用者函数的返回值，还需要处理记录一些函数调用位置的书签信息，因而可以在函数返回后继续执行。
)

$(P
通常函数调用开销相比较调用者和函数本身的工作而言并不算什么。但是，在一些场景调用函数的行为会对程序的性能有重要影响。例如，函数体的执行相对很快，或者是函数是在一个很短的循环里重复被调用。
)

$(P
如下的程序会在循环里调用一个很小的函数，在函数返回值满足条件时增加计数器：
)

---
import std.stdio;
import std.datetime;

// 函数体执行速度很快：
ubyte compute(ubyte i) {
    return cast(ubyte)(i * 42);
}

void main() {
    size_t counter = 0;

    StopWatch sw;
    sw.start();

    // 重复很多此的小循环：
    foreach (i; 0 .. 100_000_000) {
        const number = cast(ubyte)i;

        if ($(HILITE compute(number)) == number) {
            ++counter;
        }
    }

    sw.stop();

    writefln("%s milliseconds", sw.peek.msecs);
}
---

$(P
$(IX StopWatch, std.datetime) 代码使用 $(C std.datetime.StopWatch) 来测量整个循环执行的时间：
)

$(SHELL
$(HILITE 674) milliseconds
)

$(P
$(IX -inline, 编译器开关) 编译器开关 $(C -inline) 命令编译器执行$(I 函数内联)优化：
)

$(SHELL
$ dmd deneme.d -w $(HILITE -inline)
)

$(P
当一个函数被内联，则函数体会被注入到函数被调用的地方，而不是函数调用发生的时候。下面的代码与编译器内联后的代码等价：
)

---
    // An equivalent of the loop when compute() is inlined:
    foreach (i; 0 .. 100_000_000) {
        const number = cast(ubyte)i;

        const result = $(HILITE cast(ubyte)(number * 42));
        if (result == number) {
            ++counter;
        }
    }
---

$(P
在我测试程序的平台上，消除这个函数调用减少了 40% 的执行时间：
)

$(SHELL
$(HILITE 407) milliseconds
)

$(P
尽管函数内联看起来是巨大的收获，但是它却不能应用与所有函数调用，因为内联的函数体会使代码过大而不能塞进 CPU 的$(I 指令缓存)。这样会让代码更慢。因此，决定函数调用是否内联通常都交给编译器了。
)

$(P
但是，也有一些场景帮助编译器做决定会从中受益。$(C inline) pragma 命令编译器做出内联的决定：
)

$(UL

$(LI $(C pragma(inline, false))： 命令编译器不要内联函数，即使指定了编译器开关 $(C -inline)。)

$(LI $(C pragma(inline, true))： 当指定了编译器开关 $(C -inline)，命令编译器强制内联函数。如果编译器无法内联这个函数会导致编译错误（这个 pragma 确切的行为在你的编译器上可能不同。）)

$(LI $(C pragma(inline))： 让内联行为由编译器命令行决定：$(C -inline) 是否被指定。)

)

$(P
下面这些 pragma 会影响引入点的函数，同样可以用 scope 和冒号来影响更多的函数：
)

---
pragma(inline, false)
$(HILITE {)
    // 定义在这个 scope 内的函数不应该内联
    // ...
$(HILITE })

int foo() {
    pragma(inline, true);  // 这个函数应该内联
    // ...
}

pragma(inline, true)$(HILITE :)
// 在这个段的函数定义应该被内联
// ...

pragma(inline)$(HILITE :)
// 在这个段的函数定义是否被内联取决于 -inline 编译器开关
// ...
---

$(P
$(IX -O, 编译器开关) 另外一个可以使程序运行得更快的编译器开关是 $(C -O)，它命令编译器执行更优化的算法。但是，更快的程序运行速度导致更慢的编译速度，这是因为这些算法需要大量的时间。
)

$(H5 $(IX 起始地址) $(C pragma(startaddress)))

$(P
指定程序的起始地址。因为起始地址正常情况下会被 D 运行时环境重新设置，所以你不太会用到这个 pragma。
)

$(H5 $(IX mangle, pragma) $(IX 名字改编) $(C pragma(mangle)))

$(P
指定一个需要$(I 名字改编)的符号，以不同于默认名字改编的方法。名字改变主要用于让连接器辨别函数以及他们的调用者。当 D 代码需要调用一个用 D 关键字命名的库函数时，这个 pragma 会非常有用。
)

$(P
例如，如果 C 库里面有一个函数叫做 $(C body)，因为 $(C body) 是 D 的关键字，在 D 中调用的唯一的办法就是通过一个不同的名字。但是这个不同的名字依然需要改编成库中实际的函数名字，连接器才能找到它：
)

---
/* 如果 C 库有一个函数名字叫做“body”，在 D 里只能通过像“c_body”
 * 这样的名字来调用，然后改编成实际的函数名字：*/
pragma($(HILITE mangle), "body")
extern(C) string c_body(string);

void main() {
    /* D 代码用 c_body() 来调用这个函数，但连接器依然会找到其
     * 正确的 C 库名字“body”： */
    auto s = $(HILITE c_body)("hello");
}
---

Macros:
        SUBTITLE=Pragma

        DESCRIPTION=介绍 pragma —— 一种与编译器交互的方法。

        KEYWORDS=d 编程 语言 教程 pragma inline 内联
