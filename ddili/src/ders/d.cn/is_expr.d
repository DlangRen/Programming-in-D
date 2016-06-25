Ddoc

$(DERS_BOLUMU $(IX is, 表达式) $(CH4 is) 表达式)

$(P
$(C is) $(I 表达式)与我们之前在 $(LINK2 /ders/d.cn/null_is.html, $(CH4 null) 值与 $(CH4 is) 运算符) 一章中所见的 $(C is) $(I 运算符)在语法或语义上均无任何关联：
)

---
    a is b            // 这是一个运算符，如我们之前所见过的一样

    is (/* ... */)    // 这是一个表达式
---

$(P
$(C is) 表达式是在编译时进行计算的。它生成一个取决于括号中表达式的为0或1的 $(C int) 值。尽管这其中的表达式并非一个逻辑表达式，$(C is) 表达式自身却被用作一个编译期的逻辑表达式。这在被用于 $(C static if) 条件语句或模板约束时特别有用。
)

$(P
它接受的条件总是关乎类型，这些条件必须以几种语法中的一种来书写。
)

$(H5 $(C is ($(I T))))

$(P
确定 $(C T) 是否是一个有效的类型。
)

$(P
当前举出这个用法的例子是比较困难的。而在之后有关模板参数的章节里它会被充分利用。
)

---
    static if (is (int)) {
        writeln("valid");

    } else {
        writeln("invalid");
    }
---

$(P
上面的 $(C int) 是一个有效的类型：
)

$(SHELL_SMALL
valid
)

$(P
另一个例子中，由于 $(C void) 不能作为关联数组键值的类型，下面的 $(C else) 语句块即被启用：
)

---
    static if (is (string[void])) {
        writeln("valid");

    } else {
        writeln("invalid");
    }
---

$(P
输出为：
)

$(SHELL_SMALL
invalid
)


$(H5 $(C is ($(I T Alias))))

$(P
与上一种语法效果相同，并附带着将 $(C NewAlias) 定义为了 $(C T) 的别名：
)

---
    static if (is (int NewAlias)) {
        writeln("valid");
        NewAlias var = 42; // int 与 NewAlias 相一致

    } else {
        writeln("invalid");
    }
---

$(P
正如下面我们将看到的，像这样的别名在更复杂的 $(C is) 表达式中特别有用。
)

$(H5 $(C is ($(I T) : $(I OtherT))))

$(P
判别 $(C T) 是否能自动转换为 $(C OtherT)。
)

$(P
这在之前 $(LINK2 /ders/d.cn/cast.html, 类型转换) 一章中被用于检测自动类型转换，亦可用于判别之前 $(LINK2 /ders/d.cn/inheritance.html, 继承) 一章中“这个类型根本上是那个类型”一类的关系。
)

---
import std.stdio;

interface Clock {
    void tellTime();
}

class AlarmClock : Clock {
    override void tellTime() {
        writeln("10:00");
    }
}

void myFunction(T)(T parameter) {
    static if ($(HILITE is (T : Clock))) {
        // 如果可以执行到此，那么 T 便能像 Clock 一样使用
        writeln("This is a Clock; we can tell the time");
        parameter.tellTime();

    } else {
        writeln("This is not a Clock");
    }
}

void main() {
    auto var = new AlarmClock;
    myFunction(var);
    myFunction(42);
}
---

$(P
若 $(C myFunction()) 以一个能像 $(C Clock) 一样使用的类型实例化，参数的成员函数 $(C tellTime()) 即被调用，否则就编译 $(C else) 语句块：
)

$(SHELL_SMALL
This is a Clock; we can tell the time  $(SHELL_NOTE for AlarmClock)
10:00                                  $(SHELL_NOTE for AlarmClock)
This is not a Clock                    $(SHELL_NOTE for int)
)

$(H5 $(C is ($(I T Alias) : $(I OtherT))))

$(P
与上一种语法效果相同，并附带着将 $(C Alias) 定义为了 $(C T) 的别名。
)

$(H5 $(C is ($(I T) == $(I Specifier))))

$(P
判断 $(C T) 是否与 $(C Specifier) $(I 是同一个类型)或与这个限定符相匹配。
)

$(H6 是否为同一个类型)

$(P
如果我们在前一个例子中使用 $(C ==) 而非 $(C :)，那么 $(C AlarmClock) 将不再能满足条件：
)

---
    static if (is (T $(HILITE ==) Clock)) {
        writeln("This is a Clock; we can tell the time");
        parameter.tellTime();

    } else {
        writeln("This is not a Clock");
    }
---

$(P
尽管 $(C AlarmClock) $(I 是一个) $(C Clock)，但是它并不完全与 $(C Clock) 相同。因此，现在 $(C AlarmClock) 和 $(C int) 都不满足条件：
)

$(SHELL_SMALL
This is not a Clock
This is not a Clock
)

$(H6 是否与相同的限定符相匹配)

$(P
若 $(C Specifier) 是如下关键字之一，那么这种对 $(C is) 的运用便是在判断类型是否与该限定符相匹配（其中一些关键字我们在以后的章节中才会遇到）：
)

$(UL
$(LI $(IX struct, is 表达式) $(C struct))
$(LI $(IX union, is 表达式) $(C union))
$(LI $(IX class, is 表达式) $(C class))
$(LI $(IX interface, is 表达式) $(C interface))
$(LI $(IX enum, is 表达式) $(C enum))
$(LI $(IX function, is 表达式) $(C function))
$(LI $(IX delegate, is 表达式) $(C delegate))
$(LI $(IX const, is 表达式) $(C const))
$(LI $(IX immutable, is 表达式) $(C immutable))
$(LI $(IX shared, is 表达式) $(C shared))
)

---
void myFunction(T)(T parameter) {
    static if (is (T == class)) {
        writeln("This is a class type");

    } else static if (is (T == enum)) {
        writeln("This is an enum type");

    } else static if (is (T == const)) {
        writeln("This is a const type");

    } else {
        writeln("This is some other type");
    }
}
---

$(P
函数模板能利用此类信息以做出取决于用于实例化该模板的不同类型的不同表现。如下代码演示了上述的模板中的不同代码块是如何针对不同类型进行编译的：
)

---
    auto var = new AlarmClock;
    myFunction(var);

    // （枚举 WeekDays 定义于下面的例子中）
    myFunction(WeekDays.Monday);

    const double number = 1.2;
    myFunction(number);

    myFunction(42);
---

$(P
输出为：
)

$(SHELL_SMALL
This is a class type
This is an enum type
This is a const type
This is some other type
)

$(H5 $(C is ($(I T identifier) == $(I Specifier))))

$(P
$(IX super, is 表达式)
$(IX return, is 表达式)
$(IX __parameters, is 表达式)
与上一种语法效果相同。而 $(C identifier) 要么是此类型的一个别名，要么是取决于 $(C Specifier) 的某些信息：
)

<table class="wide" border="1" cellpadding="4" cellspacing="0">
<tr>	<th  style="padding-left:1em; padding-right:1em;" scope="col">$(C Specifier)</th>
<th scope="col">$(C identifier) 的含义</th>

</tr>

<tr>	<td>$(C struct)</td>
<td>满足条件类型的别名</td>
</tr>

<tr>	<td>$(C union)</td>
<td>满足条件类型的别名</td>
</tr>

<tr>	<td>$(C class)</td>
<td>满足条件类型的别名</td>
</tr>

<tr>	<td>$(C interface)</td>
<td>满足条件类型的别名</td>
</tr>

<tr>	<td>$(C super)</td>
<td>一个包含了所有基类与界面的$(I 元组)</td>
</tr>

<tr>	<td>$(C enum)</td>
<td>枚举的实际实现类型</td>
</tr>

<tr>	<td>$(C function)</td>
<td>一个包含了函数所有参数的$(I 元组)</td>
</tr>

<tr>	<td>$(C delegate)</td>
<td>$(C delegate) 的类型</td>
</tr>

<tr>	<td>$(C return)</td>
<td>普通函数、函数指针或 $(C delegate) 返回值的类型</td>
</tr>

<tr>	<td>$(C __parameters)</td>
<td>一个包含普通函数、函数指针或 $(C delegate) 所有参数的$(I 元组)</td>
</tr>

<tr>	<td>$(C const)</td>
<td>满足条件类型的别名</td>
</tr>

<tr>	<td>$(C immutable)</td>
<td>满足条件类型的别名</td>
</tr>

<tr>	<td>$(C shared)</td>
<td>满足条件类型的别名</td>
</tr>

</table>

$(P
让我们在试验这个语法之前先定义一系列的类型：
)

---
struct Point {
    // ...
}

interface Clock {
    // ...
}

class AlarmClock : Clock {
    // ...
}

enum WeekDays {
    Monday, Tuesday, Wednesday, Thursday, Friday,
    Saturday, Sunday
}

char foo(double d, int i, Clock c) {
    return 'a';
}
---

$(P
如下函数模板以不同的限定符来运用 $(C is) 表达式的这种语法：
)

---
void myFunction(T)(T parameter) {
    static if (is (T LocalAlias == struct)) {
        writefln("\n--- struct ---");
        // LocalAlias 与 T 一样。
        // “parameter”是传入本函数的 struct 对象。

        writefln("Constructing a new %s object by copying it.",
                 LocalAlias.stringof);
        LocalAlias theCopy = parameter;
    }

    static if (is (T baseTypes == super)) {
        writeln("\n--- super ---");
        // “baseTypes”元组包含了所有 T 的基类。
        // “parameter”是传入本函数的 class 变量。

        writefln("class %s has %s base types.",
                 T.stringof, baseTypes.length);

        writeln("All of the bases: ", baseTypes.stringof);
        writeln("The topmost base: ", baseTypes[0].stringof);
    }

    static if (is (T ImplT == enum)) {
        writeln("\n--- enum ---");
        // “ImplT”是该枚举类型的实际实现类型。
        // “parameter”是传入本函数的枚举值。

        writefln("The implementation type of enum %s is %s",
                 T.stringof, ImplT.stringof);
    }

    static if (is (T ReturnT == return)) {
        writeln("\n--- return ---");
        // “ReturnT”是传入本函数的函数指针的返回值类型。

        writefln("This is a function with a return type of %s:",
                 ReturnT.stringof);
        writeln("    ", T.stringof);
        write("calling it... ");

        // 注：调用函数指针的方式与调用函数一样
        ReturnT result = parameter(1.5, 42, new AlarmClock);
        writefln("and the result is '%s'", result);
    }
}
---

$(P
现在以我们上面定义的类型来调用这个函数模板：
)

---
    // 用 struct 对象调用
    myFunction(Point());

    // 用 class 引用调用
    myFunction(new AlarmClock);

    // 用枚举值调用
    myFunction(WeekDays.Monday);

    // 用函数指针调用
    myFunction(&foo);
---

$(P
输出为：
)

$(SHELL_SMALL
--- struct ---
Constructing a new Point object by copying it.

--- super ---
class AlarmClock has 2 base types.
All of the bases: (in Object, in Clock)
The topmost base: Object

--- enum ---
The implementation type of enum WeekDays is int

--- return ---
This is a function with a return type of char:
    char function(double d, int i, Clock c)
calling it... and the result is 'a'
)

$(H5 $(C is (/* ... */ $(I Specifier), $(I TemplateParamList))))

$(P
共有四种使用模板参数列表的 $(C is) 表达式语法：
)

$(UL

$(LI $(C is ($(I T) : $(I Specifier), $(I TemplateParamList))))

$(LI $(C is ($(I T) == $(I Specifier), $(I TemplateParamList))))

$(LI $(C is ($(I T identifier) : $(I Specifier), $(I TemplateParamList))))

$(LI $(C is ($(I T identifier) == $(I Specifier), $(I TemplateParamList))))

)

$(P
这些语法允许了更复杂的情况。
)

$(P
这里的 $(C identifier)、$(C Specifier)、$(C :) 以及 $(C ==) 都和上面所描述的含义一样。
)

$(P
$(C TemplateParamList) 均是需要被满足的条件的一部分，亦是在条件完全被满足时定义附加别名的措施。它与推导模板类型的方式是一样的。
)

$(P
作为一个简单的例子，让我们假定一个 $(C is) 表达式需要与键值类型为 $(C string) 的关联数组相匹配：
)

---
    static if (is (T == Value[Key],   // (1)
                   Value,             // (2)
                   Key : string)) {   // (3)
---

$(P
这个条件可以分为三个部分来阐释，而后两个部分就是 $(C TemplateParamList) 的一部分：
)

$(OL
$(LI 若 $(C T) 匹配于语法 $(C Value[Key]))
$(LI 若 $(C Value) 是一个类型)
$(LI 若 $(C Key) 是 $(C string)（想想 $(LINK2 /ders/d.cn/templates.html, 模板特化语法)）)
)

$(P
以 $(C Value[Key]) 作为 $(C Specifier) 要求 $(C T) 是一个关联数组。让 $(C Value) 单独出现则意味着它可以是任何类型。并且该关联数组键值的类型必须为 $(C string)。由是，之前的那个 $(C is) 表达式便表示“$(C T) 是否为一个键值类型为 $(C string) 的关联数组”。
)

$(P
如下的程序用四个不同的类型来测试该 $(C is) 表达式：
)

---
import std.stdio;

void myFunction(T)(T parameter) {
    writefln("\n--- Called with %s ---", T.stringof);

    static if (is (T == Value[Key],
                   Value,
                   Key : string)) {

        writeln("Yes, the condition has been satisfied.");

        writeln("The value type: ", Value.stringof);
        writeln("The key type  : ", Key.stringof);

    } else {
        writeln("No, the condition has not been satisfied.");
    }
}

void main() {
    int number;
    myFunction(number);

    int[string] intTable;
    myFunction(intTable);

    double[string] doubleTable;
    myFunction(doubleTable);

    dchar[long] dcharTable;
    myFunction(dcharTable);
}
---

$(P
当且仅当键值类型为 $(C string) 时满足条件：
)

$(SHELL_SMALL
--- Called with int ---
No, the condition has not been satisfied.

--- Called with int[string] ---
Yes, the condition has been satisfied.
The value type: int
The key type  : string

--- Called with double[string] ---
Yes, the condition has been satisfied.
The value type: double
The key type  : string

--- Called with dchar[long] ---
No, the condition has not been satisfied.
)

Macros:
        SUBTITLE=is 表达式

        DESCRIPTION=is 表达式是D语言的自检功能之一。

        KEYWORDS=D 编程语言教程 is 表达式
