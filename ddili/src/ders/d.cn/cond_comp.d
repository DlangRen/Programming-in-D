Ddoc

$(DERS_BOLUMU $(IX 条件编译) 条件编译)

$(P
条件编译，顾名思义，就是指在编译时根据条件选择最后要编译哪一部分的代码。有时一整段程序都应从源代码中剔除无需编译。
)

$(P
条件编译包将在编译期执行条件检查。像 $(C if)、$(C for)、$(C while) 这种运行期条件检查不属于条件编译的范畴。
)

$(P
我们已经在之前的章节中见到过可被看作是条件编译的特性：
)

$(UL

$(LI
$(C unittest) 代码块只在有编译器开关 $(C -unittest) 打开时才会编译并运行 。
)

$(LI
契约编程中的 $(C in)、$(C out) 和 $(C invariant) 代码块只有在编译器开关 $(C -release) $(I 没有)被打开时才会编译执行。
)

)

$(P
单元测试和契约是用来保证程序的正确性的；它们就算被包含在程序中也不会改变程序的功能。
)

$(UL

$(LI
只有特定类型的模版特化会被编译入程序。如果特化从未在程序中被使用，它将不会被编译：

---
void swap(T)(ref T lhs, ref T rhs) {
    T temp = lhs;
    lhs = rhs;
    rhs = temp;
}

unittest {
    auto a = 'x';
    auto b = 'y';
    swap(a, b);

    assert(a == 'y');
    assert(b == 'x');
}

void swap(T $(HILITE : uint))(ref T lhs, ref T rhs) {
    lhs ^= rhs;
    rhs ^= lhs;
    lhs ^= rh;  // 错误的代码！
}

void main() {
}
---

$(P
上面这个针对 $(C uint) 的模版特化利用了 $(C ^)（$(I xor，异或)）运算符，它貌似比通用算法执行的更快。（$(I $(B 注：) 实际正好相反，在大多数现代微处理器上，这种方法比使用临时变量的方法慢。)）
)

$(P
虽然特化的最后一行代码出现了拼写错误，但由于 $(C uint) 特化从未被使用，因此程序可以顺利通过编译。
)

$(P
$(I $(B 注：) 这也是一个说明单元测试重要性的例子；如果编写了一个针对此特化的单元测试，这个错误将被发现：
)
)

---
unittest {
    $(HILITE uint) i = 42;
    $(HILITE uint) j = 7;
    swap(i, j);

    assert(i == 7);
    assert(j == 42);
}
---

$(P
这个例子表明在特定的条件下，模版特化的确会被编译。
)

)

)

$(P
下面这些 D 语言特性专门用于条件编译：
)

$(UL
$(LI $(C debug))
$(LI $(C version))
$(LI $(C static if))
$(LI $(C is) 表达式)
$(LI $(C __traits))
)

$(P
我们将在下一章学习 $(C is)，再下一章学习 $(C __traits)。
)

$(H5 $(IX debug) debug)

$(P
$(IX -debug, 编译器开关) 在程序开发过程中，$(C debug) 非常有用。被标记为 $(C debug) 的表达式和语句只有在编译开关 $(C -debug) 打开时才会被编译进程序：
)

---
debug $(I a_conditionally_compiled_expression);

debug {
    // ... 满足条件时编译的代码 ...

} else {
    // ... 不满足条件时编译的代码 ...
}
---

$(P
$(C else) 子句是可选的。
)

$(P
只有当编译开关 $(C -debug) 打开，那条单独的表达式和上方的代码块才会被编译。
)

$(P
我们可以为程序添加一下输出像“adding”，“subtracting”这样的语句。这种信息（又称 $(I logs) 和 $(I log) 信息）可视化了程序的执行流程，帮助我们找到错误。
)

$(P
还记得 $(LINK2 /ders/d.en/templates.html, 模版) 一章中的 $(C binarySearch()) 函数吗？下面这个版本故意留有错误：
)

---
import std.stdio;

// 警告！此算法是错误的
size_t binarySearch(const int[] values, in int value) {
    if (values.length == 0) {
        return size_t.max;
    }

    immutable midPoint = values.length / 2;

    if (value == values[midPoint]) {
        return midPoint;

    } else if (value < values[midPoint]) {
        return binarySearch(values[0 .. midPoint], value);

    } else {
        return binarySearch(values[midPoint + 1 .. $], value);
    }
}

void main() {
    auto numbers = [ -100, 0, 1, 2, 7, 10, 42, 365, 1000 ];

    auto index = binarySearch(numbers, 42);
    writeln("Index: ", index);
}
---

$(P
虽然 42 的索引是 6，但程序错误输出了 1：
)

$(SHELL_SMALL
Index: 1
)

$(P
一种定位 bug 的方法是在程序中添加几行输出信息的代码：
)

---
size_t binarySearch(const int[] values, in int value) {
    $(HILITE writefln)("searching %s among %s", value, values);

    if (values.length == 0) {
        $(HILITE writefln)("%s not found", value);
        return size_t.max;
    }

    immutable midPoint = values.length / 2;

    $(HILITE writefln)("considering index %s", midPoint);

    if (value == values[midPoint]) {
        $(HILITE writefln)("found %s at index %s", value, midPoint);
        return midPoint;

    } else if (value < values[midPoint]) {
        $(HILITE writefln)("must be in the first half");
        return binarySearch(values[0 .. midPoint], value);

    } else {
        $(HILITE writefln)("must be in the second half");
        return binarySearch(values[midPoint + 1 .. $], value);
    }
}
---

$(P
现在程序的输出中包含了其执行的每一步操作：
)

$(SHELL_SMALL
searching 42 among [-100, 0, 1, 2, 7, 10, 42, 365, 1000]
considering index 4
must be in the second half
searching 42 among [10, 42, 365, 1000]
considering index 2
must be in the first half
searching 42 among [10, 42]
considering index 1
found 42 at index 1
Index: 1
)

$(P
我们假设上面这段输出的确帮助了程序员定位 bug。显然在 bug 已被修复后就这些 $(C writefln()) 表达式就没用了。然而，删除这几行却有点浪费，因为我们将来可能还需要用到它们。
)

$(P
可以将其标记为 $(C debug) 而不是移除他们：
)

---
        $(HILITE debug) writefln("%s not found", value);
---

$(P
只有在编译器开关 $(C -debug) 打开时这几行才会被编译进程序：
)

$(SHELL_SMALL
dmd deneme.d -ofdeneme -w $(HILITE -debug)
)

$(H6 $(C debug（$(I 标签)）))

$(P
如果程序中有许多不相干的 $(C debug) 关键字，输出可能会一片混乱。为了解决这类问题，我们可以为 $(C debug) 语句加上名字（标签），选择那一部分需要添加进程序：
)

---
        $(HILITE debug(binarySearch)) writefln("%s not found", value);
---

$(P
命名的 $(C debug) 语句应使用编译开关 $(C -debug=$(I tag)) 来启用：
)


$(SHELL_SMALL
dmd deneme.d -ofdeneme -w $(HILITE -debug=binarySearch)
)

$(P
也可以为 $(C debug) 代码块指定标签：
)

---
    debug(binarySearch) {
        // ...
    }
---

$(P
一次性启用多个 $(C debug) 标签是可行的：
)

$(SHELL_SMALL
$ dmd deneme.d -w $(HILITE -debug=binarySearch) $(HILITE -debug=stackContainer)
)

$(P
在上面这种编译条件下，标签为 $(C binarySearch) 和 $(C stackContainer) 的语句和代码块都会被包含进程序。
)

$(H6 $(C debug（$(I 等级)）))

$(P
有时我们可以把 $(C debug) 语句和数字的等级联系在一起。通过增高等级可获得更详细的信息：
)

---
$(HILITE debug) import std.stdio;

void myFunction(string fileName, int[] values) {
    $(HILITE debug(1)) writeln("entered myFunction");

    $(HILITE debug(2)) {
        writeln("the arguments:");
        writeln("  file name: ", fileName);

        foreach (i, value; values) {
            writefln("  %4s: %s", i, value);
        }
    }

    // ... 函数实现 ...
}

void main() {
    myFunction("deneme.txt", [ 10, 4, 100 ]);
}
---

$(P
低于或等于指定等级的 $(C debug) 表达式或代码块将会被编译：
)

$(SHELL_SMALL
$ dmd deneme.d -w $(HILITE -debug=1)
$ ./deneme 
$(SHELL_OBSERVED entered myFunction)
)

$(P
下面这次编译能提供更多调试信息：
)

$(SHELL_SMALL
$ dmd deneme.d -w $(HILITE -debug=2)
$ ./deneme 
$(SHELL_OBSERVED entered myFunction
the arguments:
  file name: deneme.txt
     0: 10
     1: 4
     2: 100)
)

$(H5 $(IX version) $(C version（$(I 标签)）) 和 $(C version（$(I 等级)）))

$(P
$(C version) 的用途和 $(C debug) 类似：
)

---
    version(testRelease) /* ... 一个表达式 ... */;

    version(schoolRelease) {
        /* ... 与将要发给学校的
         *     那个版本有关的代码 ... */

    } else {
        // ... 不满足条件时编译的代码 ...
    }

    version(1) aVariable = 5;

    version(2) {
        // ... 版本 2 包含的特性 ...
    }
---

$(P
$(C else) 子句是可选的。
)

$(P
虽然 $(C version) 实质上与 $(C debug) 作用相同，但这两个关键字有助于区分不同的功能。
)

$(P
$(IX -version, 编译开关) 和 $(C debug) 一样，我们可以一次性启用多个 $(C version)：
)

$(SHELL_SMALL
$ dmd deneme.d -w $(HILITE -version=record) $(HILITE -version=precise_calculation)
)

$(P
D 语言预先定义了许多 $(C version) 标签，完整的标签列表参见 $(LINK2 http://dlang.org/version.html, 条件编译规范)。下面这个简短的表格只是一个其中一部分：
)

<table class="full" border="1" cellpadding="4" cellspacing="0"><caption>预定义 $(C version) 标签</caption>

<tr><td>编译器</td> <td>$(B DigitalMars GNU LDC SDC)</td></tr>

<tr><td>操作系统</td> <td>$(B Windows Win32 Win64 linux OSX Posix FreeBSD
OpenBSD
NetBSD
DragonFlyBSD
BSD
Solaris
AIX
Haiku
SkyOS
SysV3
SysV4
Hurd)</td></tr>

<tr><td>CPU 字节序</td><td>$(B LittleEndian BigEndian)</td></tr>
<tr><td>打开编译开关</td> <td> $(B D_Coverage D_Ddoc D_InlineAsm_X86 D_InlineAsm_X86_64 D_LP64 D_PIC D_X32
D_HardFloat
D_SoftFloat
D_SIMD
D_Version2
D_NoBoundsChecks
unittest
assert
)</td></tr>

<tr><td>CPU 架构</td> <td>$(B X86 X86_64)</td></tr>
<tr><td>平台</td> <td>$(B Android
Cygwin
MinGW
ARM
ARM_Thumb
ARM_Soft
ARM_SoftFP
ARM_HardFP
ARM64
PPC
PPC_SoftFP
PPC_HardFP
PPC64
IA64
MIPS
MIPS32
MIPS64
MIPS_O32
MIPS_N32
MIPS_O64
MIPS_N64
MIPS_EABI
MIPS_NoFloat
MIPS_SoftFloat
MIPS_HardFloat
SPARC
SPARC_V8Plus
SPARC_SoftFP
SPARC_HardFP
SPARC64
S390
S390X
HPPA
HPPA64
SH
SH64
Alpha
Alpha_SoftFP
Alpha_HardFP
)</td></tr>
<tr><td>...</td> <td>...</td></tr>
</table>

$(P
除此之外，还有以下两种特殊 $(C version) 标签：
)

$(UL
$(LI $(IX none, version) $(C none)：这个标签永远不会被定义；它常用于禁用代码块。)
$(LI $(IX all, version) $(C all)：这个标签始终已被定义；它常用于启用代码。)
)

$(P
我们用一个例子来讲解如何使用预定义 $(C version)。下面这段代码摘录自 $(C std.ascii) 模块（此处格式不同），用于确定当前操作系统的换行符（之后我们会讲解 $(C static assert)）：
)

---
version(Windows) {
    immutable newline = "\r\n";

} else version(Posix) {
    immutable newline = "\n";

} else {
    static assert(0, "Unsupported OS");
}
---

$(H5 为 $(C debug) 和 $(C version) 赋值)

$(P
与变量一样，可给 $(C debug) 和 $(C version) 赋值某个标签。但与变量不同的是，这种赋值并不会改变任何值，它$(I 只是)激活指定的标签。
)

---
import std.stdio;

debug(everything) {
    debug $(HILITE =) binarySearch;
    debug $(HILITE =) stackContainer;
    version $(HILITE =) testRelease;
    version $(HILITE =) schoolRelease;
}

void main() {
    debug(binarySearch) writeln("binarySearch is active");
    debug(stackContainer) writeln("stackContainer is active");

    version(testRelease) writeln("testRelease is active");
    version(schoolRelease) writeln("schoolRelease is active");
}
---

$(P
$(C debug(everything)) 代码块中的赋值激活了所有指定的标签：
)

$(SHELL_SMALL
$ dmd deneme.d -w -debug=everything
$ ./deneme 
$(SHELL_OBSERVED binarySearch is active
stackContainer is active
testRelease is active
schoolRelease is active)
)

$(H5 $(IX static if) $(C static if))

$(P
$(C static if) 在编译期等于 $(C if) 语句。
)

$(P
与 $(C if) 一样，$(C static if) 接受一个逻辑表达式并进行判断。与 $(C if) 语句不同的是，$(C static if) 并不是选择执行某个流程，它是用来判断一段代码是否应被编译并包含在程序中。
)

$(P
逻辑表达式必须能在编译期求值。如果逻辑表达式判断为 $(C true)，$(C static if) 中的代码将被编译。如果被判断为 $(C false)，那段代码将不会被包含入程序，就好像它们从未被写下一样。此处的逻辑表达式通常会使用 $(C is) 语句和 $(C __traits)。
)

$(P
$(C static if) 既可以放在模块作用域下，亦可以写在 $(C struct)、$(C class) 或模版等定义中。它也可以带有一个可选的 $(C else) 子句。
)

$(P
让我们配合 $(C is) 表达式使用 $(C static if) 实现一个简单的模版。我们会在下一章见到 $(C static if) 的其他例子：
)

---
import std.stdio;

struct MyType(T) {
    static if (is (T == float)) {
        alias ResultType = double;

    } $(HILITE else static if) (is (T == double)) {
        alias ResultType = real;

    } else {
        static assert(false, T.stringof ~ " is not supported");
    }

    ResultType doWork() {
        writefln("The return type for %s is %s.",
                 T.stringof, ResultType.stringof);
        ResultType result;
        // ...
        return result;
    }
}

void main() {
    auto f = MyType!float();
    f.doWork();

    auto d = MyType!double();
    d.doWork();
}
---

$(P
根据代码，$(C MyType) 只能用于 $(C float) 或 $(C double) 这两种类型。$(C doWork()) 的返回值类型取决于模版被实例为 $(C float) 还是 $(C double)：
)

$(SHELL
The return type for float is double.
The return type for double is real.
)

$(P
注意如果需要多个 $(C static if) 成链则需写作 $(C else static if)。否则的话，只写 $(C else if) 则会向代码中添加运行期执行的 $(C if) 语句。
)

$(H5 $(IX static assert) $(C static assert))

$(P
虽然 $(C static assert) 属于条件编译的范畴，但我还是决定在此处介绍它。
)

$(P
$(C static assert) 是 $(C assert) 编译期求值版本。如果条件表达式是 $(C false)，此断言将会失败从而中止编译。
)

$(P
与 $(C static if) 类似，$(C static assert) 可以出现在程序中任何作用域。
)

$(P
我们已经在之前的程序中见到过 $(C static assert) 的例子了：如果 $(C T) 的类型不是 $(C float) 或 $(C double) 中的一个，编译将会中止：
)

---
    auto i = MyType!$(HILITE int)();
---

$(P
编译终止时编译器将会给出传给 $(C static assert) 的提示消息：
)

$(SHELL
Error: static assert  "int is not supported"
)

$(P
下面这个例子中，我们假设这个特殊的算法只有在参数类型的大小是指定大小的整数倍时才能正常工作。使用 $(C static assert) 在编译期检查是否满足条件：
)

---
T myAlgorithm(T)(T value) {
    /* 算法要求参数类型 T 的大小是
     * 4 的整数倍。*/
    static assert((T.sizeof % 4) == 0);

    // ...
}
---

$(P
如果使用 $(C char) 调用这个函数，编译将会中止并给出以下错误信息：
)

$(SHELL_SMALL
Error: static assert  (1LU == 0LU) is false
)

$(P
这个测试防止出现函数接收到不兼容的类型从而得出错误结果的情况。
)

$(P
$(C static assert) 能使用所有可在编译期求值的逻辑表达式。
)

$(H5 $(IX 类型特征) $(IX traits) 类型特征)

$(P
$(IX __traits) $(IX std.traits) $(C __traits) 关键字和 $(C std.traits) 模块提供了能在编译期使用的类型信息。
)

$(P
$(C __traits) 让程序能使用那些编译器在编译时收集到的信息。它的语法包括一个 traits $(I 关键字) 和与关键字相关的$(I 参数)：
)

---
    __traits($(I keyword), $(I parameters))
---

$(P
$(I keyword) 指定需要查询的信息。$(I parameters) 则为任一个类型或表达式，其意义取决于特殊的关键字。
)

$(P
对模版来说，由 $(C __traits) 获取到的信息非常有用。比如关键字 $(C isArithmetic) 可以判断模版参数 $(C T) 是否为算术类型：
)

---
    static if (__traits($(HILITE isArithmetic), T)) {
        // ... 是算术类型 ...

    } else {
        // ... 不是算术类型 ...
    }
---

$(P
通过 $(C std.traits) 模块的模版也能在编译期提供相同的信息。例如：当模版参数是字符类型时，$(C std.traits.isSomeChar) 返回 $(C true)：
)

---
import std.traits;

// ...

    static if ($(HILITE isSomeChar)!T) {
        // ... char、wchar 或 dchar ...

    } else {
        // ... 非字符类型 ...
    }
---

$(P
更多信息请查阅 $(LINK2 http://dlang.org/traits.html, $(C __traits) 文档) 和 $(LINK2 http://dlang.org/phobos/std_traits.html, $(C std.traits) 文档)。
)

$(H5 小结)

$(UL

$(LI
被定义为 $(C debug) 的代码只有在编译开关 $(C -debug) 打开时才会被编译进程序。
)

$(LI
被定义为 $(C version) 的代码只有在对应的编译开关 $(C -version) 打开时才会被编译进程序。
)

$(LI
$(C static if) 与 $(C if) 语句作用相似，但它执行在编译期。它根据编译期条件判断是否编译并包含代码。
)

$(LI
$(C static assert) 在编译期保证断言成功。
)

$(LI $(C __traits) 和 $(C std.traits) 在编译期提供类型信息。)

)

Macros:
        SUBTITLE=条件编译

        DESCRIPTION=通过编译期求值的逻辑表达式指定那一部分程序需要编译。

        KEYWORDS=D 编程语言教程 条件编译
