Ddoc

$(DERS_BOLUMU $(CH4 const ref) 参数和 $(CH4 const) 成员函数)

$(P
本章主要是关于如何将参数和成员函数标记为 $(C const) 来配合 $(C immutabl) 变量使用的。我们已经在之前的章节中了解过 $(C const) 参数了，所以本章的某些部分其实只是对前面知识的复习。
)

$(P
虽然我们这里的例子使用的都是结构体，但实际上 $(C const) 成员函数也适用于类。
)

$(H5 $(C immutable) 对象)

$(P
我们都知道 $(C immutable) 变量是无法被修改的：
)

---
    immutable readingTime = TimeOfDay(15, 0);
---

$(P
$(C readingTime) 无法被修改：
)

---
    readingTime = TimeOfDay(16, 0);    $(DERLEME_HATASI)
    readingTime.minute += 10;          $(DERLEME_HATASI)
---

$(P
编译器不允许以任何方式修改 $(C immutable) 对象。
)

$(H5 非 $(C const) 的 $(C ref) 参数)

$(P
我们之前在 $(LINK2 /ders/d.cn/function_parameters.html, 函数参数) 一节中见到过这个概念。被标记为 $(C ref) 的参数可以被函数不受限制地随意修改。因此，即便函数实际上并没有修改参数，编译器也不允许对其传入 $(C immutable) 对象。
)

---
/* 虽然 'duration' 并没有被函数修改，
 * 它也不能被标记为 'const' */
int totalSeconds(ref Duration duration) {
    return 60 * duration.minute;
}
// ...
    $(HILITE immutable) warmUpTime = Duration(3);
    totalSeconds(warmUpTime);    $(DERLEME_HATASI)
---

$(P
编译器不允许向 $(C totalSeconds) 传递 $(C immutable) $(C warmUpTime)，因为函数没有保证参数一定不会被修改。
)

$(H5 $(IX const ref) $(IX ref const) $(IX parameter, const ref) $(C const ref) 参数)

$(P
$(C const ref) 表示参数不会被函数修改：
)

---
int totalSeconds(const ref Duration duration) {
    return 60 * duration.minute;
}
// ...
    immutable warmUpTime = Duration(3);
    totalSeconds(warmUpTime);    // ← 现在编译通过了
---

$(P
编译器将强制这种函数接收 $(C immutable) 对象：
)

---
int totalSeconds(const ref Duration duration) {
    duration.minute = 7;    $(DERLEME_HATASI)
// ...
}
---

$(P
$(IX in ref) $(IX ref in) $(IX parameter, in ref) 可用 $(C in ref) 替代 $(C const ref)。$(C in) 表示参数只是用来向函数传入信息，禁止对其进行任何修改。我们将会在 $(LINK2 /ders/d.cn/function_parameters.html, 后面的章节) 中见到它。
)

---
int totalSeconds($(HILITE in ref) Duration duration) {
    // ...
}
---

$(H5 非 $(C const) 成员函数)

$(P
对象可以被其成员函数修改，就像之前的 $(C TimeOfDay.increment) 成员函数。$(C increment()) 将修改调用它的对象中的成员变量：
)

---
struct TimeOfDay {
// ...
    void increment(in Duration duration) {
        minute += duration.minute;

        hour += minute / 60;
        minute %= 60;
        hour %= 24;
    }
// ...
}
// ...
    auto range = Range(10);
    start.increment(Duration(30));          // 'start' 已被修改
---

$(H5 $(IX const, 成员函数) $(C const) 成员函数)

$(P
我们也会遇到一些不会修改其调用对象的成员函数。比如 $(C toString())：
)

---
struct TimeOfDay {
// ...
    string toString() {
        return format("%02s:%02s", hour, minute);
    }
// ...
}
---

$(P
$(C toString()) 只是根据指定格式将对象转换为字符串，因此它不应该有修改对象的权限。
)

$(P
我们可以通过在成员函数的参数列表后添加 $(C const) 关键字来声明这一点：
)

---
struct TimeOfDay {
// ...
    string toString() $(HILITE const) {
        return format("%02s:%02s", hour, minute);
    }
}
---

$(P
$(C const) 保证了对象不会被其自己的成员函数修改。通过这种方式 $(C immutable) 对象也可以调用 $(C toString()) 成员函数了。否则，编译器将不允许调用 $(C immutable) 对象的 $(C toString())：
)

---
struct TimeOfDay {
// ...
    // 较差的设计：没有被标记为 'const'
    string toString() {
        return format("%02s:%02s", hour, minute);
    }
}
// ...
    $(HILITE immutable) start = TimeOfDay(5, 30);
    writeln(start);    // TimeOfDay.toString() 不会被调用！
---

$(P
输出并不是我们想要的 $(C 05:30)，也就是说实际上 $(C writeln) 只是调用了那个默认的转换函数而不是我们定义的 $(C TimeOfDay.toString)：
)

$(SHELL
immutable(TimeOfDay)(5, 30)
)

$(P
如果在 $(C immutable) 对象上显式调用 $(C toString()) 则会引发编译错误：
)

---
    auto s = start.toString(); $(DERLEME_HATASI)
---

$(P
因此我们在之前章节定义的 $(C toString()) 函数的设计都不够好，它们都应该增加一个 $(C const) 声明。
)

$(P $(I $(B 注：)$(C const) 关键字也可放在函数声明前：)
)

---
    // 与之前的定义相同
    $(HILITE const) string toString() {
        return format("%02s:%02s", hour, minute);
    }
---

$(P $(I 由于这种形式会让人误以为 $(C const) 是返回值的一部分，所以我推荐将其放在参数列表后。)
)

$(H5 $(IX inout, 成员函数) $(C inout) 成员函数)

$(P
$(C inout) 将参数的可变性转移给了返回值，这一点我们已经在 $(LINK2 /ders/d.en/function_parameters.html, 函数参数) 一节中介绍过了。
)

$(P
而成员函数的 $(C inout) 也同样会将$(I 对象)的可变性转移给函数返回值：
)

---
import std.stdio;

struct Container {
    int[] elements;

    $(HILITE inout)(int)[] firstPart(size_t n) $(HILITE inout) {
        return elements[0 .. n];
    }
}

void main() {
    {
        // 一个 immutable container
        auto container = $(HILITE immutable)(Container)([ 1, 2, 3 ]);
        auto slice = container.firstPart(2);
        writeln(typeof(slice).stringof);
    }
    {
        // 一个 const container
        auto container = $(HILITE const)(Container)([ 1, 2, 3 ]);
        auto slice = container.firstPart(2);
        writeln(typeof(slice).stringof);
    }
    {
        // 一个可变的 container
        auto container = Container([ 1, 2, 3 ]);
        auto slice = container.firstPart(2);
        writeln(typeof(slice).stringof);
    }
}
---

$(P
这三个由不同可变性对象返回的 slices 包含了返回它们的对象：
)

$(SHELL
$(HILITE immutable)(int)[]
$(HILITE const)(int)[]
int[]
)

$(P
由于我们需要调用 $(C const) 和 $(C immutable) 对象的 $(C inout) 成员函数，编译器会自动为其添加 $(C const) 声明。
)

$(H5 使用方法小结)

$(UL

$(LI
将参数标记为 $(C in)、$(C const) 或 $(C const ref) 以确保其不会被函数修改。
)

$(LI
将不会修改其对象的成员函数标记为 $(C const)：

---
struct TimeOfDay {
// ...
    string toString() $(HILITE const) {
        return format("%02s:%02s", hour, minute);
    }
}
---

$(P
这能帮助你避免一些不必要的限制以扩大结构体或类的适用范围。本书之后的章节都会遵守这个约定。
)

)

)

Macros:
        SUBTITLE=const ref 参数和 const 成员函数

        DESCRIPTION=D 语言中的 const ref 参数和 const 成员函数

        KEYWORDS=D 编程语言教程 const 成员函数
