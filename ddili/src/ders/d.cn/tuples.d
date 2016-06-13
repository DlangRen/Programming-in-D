Ddoc

$(DERS_BOLUMU $(IX tuple) $(IX Tuple, std.typecons) 元组)

$(P
元组是用来合并多值并将其作为一个单一对象使用的。这是一个标准库所提供的功能，即模块 $(C std.typecons) 中的 $(C Tuple) 模板。
)

$(P
$(C Tuple) 凭借模块 $(C std.meta) 中的 $(C AliasSeq) 来实现它的一部分功能。
)

$(P
这一章只涵盖了元组较为常见的操作。更多有关元组及模板的信息详见 $(LINK2 https://github.com/PhilippeSigaud/D-templates-tutorial, Philippe Sigaud's $(I D Templates: A Tutorial))。
)

$(H5 $(C Tuple) 与 $(C tuple()))

$(P
元组常常用便捷的 $(C tuple()) 函数来构建：
)

---
import std.stdio;
import std.typecons;

void main() {
    auto t = $(HILITE tuple(42, "hello"));
    writeln(t);
}
---

$(P
上面对 $(C tuple) 的调用构造了一个包含值为 42 的 $(C int) 与值为 $(STRING "hello") 的 $(C string) 的对象。上述程序的输出包括该元组对象的类型与它的成员：
)

$(SHELL
Tuple!(int, string)(42, "hello")
)

$(P
上面的元组类型与下面 $(C struct) 的定义是等价的，而事实上也几乎是这样实现的：
)

---
// 与 Tuple!(int, string) 等价
struct __Tuple_int_string {
    int __member_0;
    string __member_1;
}
---

$(P
元组成员通常使用索引来访问。这种语法暗示了元组可以被视为包含不同类型元素的数组。
)

---
    writeln(t$(HILITE [0]));
    writeln(t$(HILITE [1]));
---

$(P
输出为：
)

$(SHELL
42
hello
)

$(H6 成员属性)

$(P
如果元组直接由 $(C Tuple) 模板构建而非调用 $(C tuple()) 函数，那么便可能以相应的成员属性来访问成员。成员的类型与名称可以以模板参数的方式来指定：
)

---
    auto t = Tuple!(int, "number",
                    string, "message")(42, "hello");
---

$(P
上述的定义使 $(C .number) 与 $(C .message) 也可以访问相应的成员：
)

---
    writeln("by index 0 : ", t[0]);
    writeln("by .number : ", t$(HILITE .number));
    writeln("by index 1 : ", t[1]);
    writeln("by .message: ", t$(HILITE .message));
---

$(P
输出为:
)

$(SHELL
by index 0 : 42
by .number : 42
by index 1 : hello
by .message: hello
)

$(H6 $(IX .expand) 展开成员为列表)

$(P
元组成员能被展开为一列值，举例来说，这能被用作调用函数时的参数列表。元组的 $(C .expand) 属性或是切片操作都可以用来展开成员：
)

---
import std.stdio;
import std.typecons;

void foo(int i, string s, double d, char c) {
    // ...
}

void bar(int i, double d, char c) {
    // ...
}

void main() {
    auto t = tuple(1, "2", 3.3, '4');

    // 下面的两行都等价于 foo(1, "2", 3.3, '4')：
    foo(t$(HILITE .expand));
    foo(t$(HILITE []));

    // 与 bar(1, 3.3, '4') 等价：
    bar(t$(HILITE [0]), t$(HILITE [$-2..$]));
}
---

$(P
上面的元组包含四个类型分别为 $(C int)、$(C string)、$(C double) 与 $(C char) 的值。由于这些类型与 $(C foo()) 的参数列表相匹配，它成员的展开能够被用作 $(C foo()) 的参数。当调用 $(C bar()) 时，一个匹配的参数列表由该元组的第一个与最后两个成员构成。
)

$(P
只要元组成员能够兼容成为同一个数组的元素，那么其成员的展开就可以作为一个数组字面量的元素：
)

---
import std.stdio;
import std.typecons;

void main() {
    auto t = tuple(1, 2, 3);
    auto a = [ t.expand, t[] ];
    writeln(a);
}
---

$(P
上述数组字面量根据同一个元组的两次展开初始化而成：
)

$(SHELL
[1, 2, 3, 1, 2, 3]
)

$(H6 $(IX foreach, 编译期) $(IX 编译期 foreach) 编译期 $(C foreach))

$(P
因为元组包含的值可以被展开，所以它们也可以被用于 $(C foreach) 语句中：
)

---
    auto t = tuple(42, "hello", 1.5);

    foreach (i, member; $(HILITE t)) {
        writefln("%s: %s", i, member);
    }
---

$(P
输出为：
)

$(SHELL
0: 42
1: hello
2: 1.5
)

$(P
$(IX 展开)
上述 $(C foreach) 语句或许会给人以一个错误的印象——被当成一个运行时的循环体。事实并非如此。一个基于元组的 $(C foreach) 语句会针对每一个元组成员进行$(I 展开)。由是，上述 $(C foreach) 语句等价于如下代码：
)

---
    {
        enum size_t i = 0;
        $(HILITE int) member = t[i];
        writefln("%s: %s", i, member);
    }
    {
        enum size_t i = 1;
        $(HILITE string) member = t[i];
        writefln("%s: %s", i, member);
    }
    {
        enum size_t i = 2;
        $(HILITE double) member = t[i];
        writefln("%s: %s", i, member);
    }
---

$(P
进行展开的根本原因在于元组的成员可能具有不同的类型， $(C foreach) 语句块必须根据每一个类型以不同的方式被编译。
)

$(H6 从函数中返回多个值)

$(P
$(IX findSplit, std.algorithm) 元组可以作为一个对函数必须返回单一值这一限制的简单解决方式。这样的一个例子是 $(C std.algorithm.findSplit)。$(C findSplit()) 在一个区间中搜索另一个区间并生成一个包含三个片段的结果，即在子区间之前的部分、找到的子区间、以及子区间之后的部分：
)

---
import std.algorithm;

// ...

    auto entireRange = "hello";
    auto searched = "ll";

    auto result = findSplit(entireRange, searched);

    writeln("before: ", result[0]);
    writeln("found : ", result[1]);
    writeln("after : ", result[2]);
---

$(P
输出为：
)

$(SHELL
before: he
found : ll
after : o
)

$(P
从函数中返回多个值的另一种选择是返回一个 $(C struct) 对象：
)

---
struct Result {
    // ...
}

$(HILITE Result) foo() {
    // ...
}
---

$(H5 $(IX AliasSeq, std.meta) $(C AliasSeq))

$(P
$(C AliasSeq) 定义于 $(C std.meta) 模块中。它用于表示一个通常情况下属于编译器的概念，换句话说，不是一个能被程序员掌控的实体：一个以逗号分隔的由值、类型、符号（即 $(C alias) 模板参数）组成的列表。下面是三个这种列表的例子：
)

$(UL
$(LI 函数参数列表)
$(LI 模板参数列表)
$(LI 数组字面量元素列表)
)

$(P
如下三行代码依次是上述列表的实例：
)

---
    foo($(HILITE 1, "hello", 2.5));         // 函数参数
    auto o = Bar!($(HILITE char, long))();  // 模板参数
    auto a = [ $(HILITE 1, 2, 3, 4) ];      // 数组字面量元素
---

$(P
$(C Tuple) 的展开就是对 $(C AliasSeq) 的充分利用。
)

$(P
$(IX TypeTuple, std.typetuple) $(C AliasSeq) 的名称来源于“alias sequence”即“别名序列”，它可以包含类型、值与符号。（$(C AliasSeq) 与 $(C std.meta) 曾经分别被称为 $(C TypeTuple) 与 $(C std.typetuple)）
)

$(P
本章只举出了完全由值或是完全由类型组成的 $(C AliasSeq) 之实例。同时包含了类型与值的例子将会在下一章中出现。$(C AliasSeq) 对于可变参数模板特别有用，这我们亦会在下一章中看到。
)

$(H6 由值组成的 $(C AliasSeq))

$(P
$(C AliasSeq) 所表示的值是通过模板参数的方式来指定的。
)

$(P
想象一个接受三个参数的函数：
)

---
import std.stdio;

void foo($(HILITE int i, string s, double d)) {
    writefln("foo is called with %s, %s, and %s.", i, s, d);
}
---

$(P
这个函数通常需用三个参数进行调用：
)

---
    foo(1, "hello", 2.5);
---

$(P
而 $(C AliasSeq) 能够合并这些参数为一个单一的实体，而且这个实体可以自动在调用函数的时候展开：
)

---
import std.meta;

// ...

    alias arguments = AliasSeq!(1, "hello", 2.5);
    foo($(HILITE arguments));
---

$(P
尽管看起来调用该函数只用了一个参数，上面对 $(C foo()) 的调用与之前那个相等价。因此，两者都产生相同的输出：
)

$(SHELL
foo is called with 1, hello, and 2.5.
)

$(P
还需注意的是 $(C arguments) 并非作为变量被定义，比如说以 $(C auto) 的形式。恰恰相反，它是一个特定 $(C AliasSeq) 模板实现的 $(C alias)。尽管定义 $(C AliasSeq) 的变量亦是可能的，本章中的例子只会将其作为别名使用。
)

$(P
如我们之前对 $(C Tuple) 的了解一样，当一个 $(C AliasSeq) 所有包含的值能够兼容成为同一个数组的元素，那么它就亦可以用于初始化数组字面量：
)

---
    alias elements = AliasSeq!(1, 2, 3, 4);
    auto arr = [ $(HILITE elements) ];
    assert(arr == [ 1, 2, 3, 4 ]);
---

$(H6 索引与切片)

$(P
与 $(C Tuple) 一样，$(C AliasSeq) 的成员可以通过索引与切片访问：
)

---
    alias arguments = AliasSeq!(1, "hello", 2.5);
    assert(arguments$(HILITE [0]) == 1);
    assert(arguments$(HILITE [1]) == "hello");
    assert(arguments$(HILITE [2]) == 2.5);
---

$(P
若有一个函数的参数与上述 $(C AliasSeq) 的最后两个成员相匹配，那么这个函数便可以用该 $(C AliasSeq) 的一个切片调用：
)

---
void bar(string s, double d) {
    // ...
}

// ...

    bar(arguments$(HILITE [$-2 .. $]));
---

$(H6 由类型组成的 $(C AliasSeq))

$(P
$(C AliasSeq) 可以包含类型。换句话说，不是一个特定类型的特定值，而是一个如 $(C int) 本身的类型。一个由类型组成的 $(C AliasSeq) 能用以表示一系列模板参数。
)

$(P
这里我们将一个 $(C AliasSeq) 用于一个有两个参数的 $(C struct) 模板。第一个参数决定其数组成员的元素类型，第二个参数决定其函数成员的返回值：
)

---
import std.conv;

struct S($(HILITE ElementT, ResultT)) {
    ElementT[] arr;

    ResultT length() {
        return to!ResultT(arr.length);
    }
}

void main() {
    auto s = S!$(HILITE (double, int))([ 1, 2, 3 ]);
    auto l = s.length();
}
---

$(P
在上述代码中，我们看到模板使用 $(C (double, int)) 进行实例化。而一个 $(C AliasSeq) 也可以用来表示同样的参数列表：
)

---
import std.meta;

// ...

    alias Types = AliasSeq!(double, int);
    auto s = S!$(HILITE Types)([ 1, 2, 3 ]);
---

$(P
尽管这看起来像是一个单一的模板参数，但由于 $(C Types) 会自动展开，模板实例如之前一样变为 $(C S!(double,&nbsp;int))。
)

$(P
$(C AliasSeq) 在$(I 可变参数模板)中特别有用。我们将会在下一章中看到这样的例子。
)

$(H6 将 $(C AliasSeq) 用于 $(C foreach))

$(P
与 $(C Tuple) 一样，基于 $(C AliasSeq) 的 $(C foreach) 语句并非一个运行时的循环，它会针对每一个成员展开循环体。
)

$(P
这是一个相应的例子，一个为上面定义的 $(C S) 结构所写的单元测试。如下代码以 $(C int)、$(C long) 与 $(C float) 作为元素类型来测试 $(C S)（这个例子中 $(C ResultT) 始终是 $(C size_t)）：
)

---
unittest {
    alias Types = AliasSeq!($(HILITE int, long, float));

    foreach (Type; $(HILITE Types)) {
        auto s = S!(Type, size_t)([ Type.init, Type.init ]);
        assert(s.length() == 2);
    }
}
---

$(P
$(C foreach) 变量 $(C Type) 依次对应 $(C int)、$(C long) 及 $(C float)。由是，该 $(C foreach) 语句将与如下语句等价地被编译：
)

---
    {
        auto s = S!($(HILITE int), size_t)([ $(HILITE int).init, $(HILITE int).init ]);
        assert(s.length() == 2);
    }
    {
        auto s = S!($(HILITE long), size_t)([ $(HILITE long).init, $(HILITE long).init ]);
        assert(s.length() == 2);
    }
    {
        auto s = S!($(HILITE float), size_t)([ $(HILITE float).init, $(HILITE float).init ]);
        assert(s.length() == 2);
    }
---

$(H5 $(IX .tupleof) $(C .tupleof) 属性)

$(P
$(C .tupleof) 表示一个类型或对象的全部成员。当被用于一个用户定义的类型时，$(C .tupleof) 提供对该类型成员定义的访问：
)

---
import std.stdio;

struct S {
    int number;
    string message;
    double value;
}

void main() {
    foreach (i, MemberType; typeof($(HILITE S.tupleof))) {
        writefln("Member %s:", i);
        writefln("  type: %s", MemberType.stringof);

        string name = $(HILITE S.tupleof)[i].stringof;
        writefln("  name: %s", name);
    }
}
---

$(P
$(C S.tupleof) 在此程序中出现了两次。首先，所有元素的类型由将 $(C typeof) 加于 $(C .tupleof) 取得，因而每一个类型都依次表现为变量 $(C MemberType)。其次，每个元素的名称由 $(C S.tupleof[i].stringof) 分别取得。
)

$(SHELL
Member 0:
  type: int
  name: number
Member 1:
  type: string
  name: message
Member 2:
  type: double
  name: value
)

$(P
$(C .tupleof) 也可以用于一个具体的对象。在这种情况下，它将生成一个包含该对象所有成员的值的元组：
)

---
    auto object = S(42, "hello", 1.5);

    foreach (i, member; $(HILITE object.tupleof)) {
        writefln("Member %s:", i);
        writefln("  type : %s", typeof(member).stringof);
        writefln("  value: %s", member);
    }
---

$(P
$(C foreach) 变量 $(C member) 表示该对象的每一个成员：
)

$(SHELL
Member 0:
  type : int
  value: 42
Member 1:
  type : string
  value: hello
Member 2:
  type : double
  value: 1.5
)

$(P
此处很重要的一点是由 $(C .tupleof) 返回的元组包含的是对象成员自身，而非其拷贝。换言之，该元组的成员是对实际对象成员的引用。
)

$(H5 总结)

$(UL

$(LI $(C tuple()) 合并不同类型的值，类似于一个 $(C struct) 对象。)

$(LI 直接使用 $(C Tuple) 能够以成员属性访问成员。)

$(LI 元组能用 $(C .expand) 或切片操作被展开为值列表。)

$(LI 基于元组的 $(C foreach) 不是运行时循环，而是将循环体进行展开。)

$(LI $(C AliasSeq) 表示诸如函数参数列表、模板参数列表、数组字面量元素列表之类的概念。)

$(LI $(C AliasSeq) 能够包含值和类型。)

$(LI 元组支持索引与切片。)

$(LI $(C .tupleof) 提供有关类型、对象之成员的信息。)

)

macros:
        SUBTITLE=元组

        DESCRIPTION=合并值与类型，并以访问同一个对象成员的方式访问它们。

        KEYWORDS=D 编程语言教程 Tuple AliasSeq tuple
