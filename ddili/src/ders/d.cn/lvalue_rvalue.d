Ddoc

$(DERS_BOLUMU $(IX 左值) $(IX 右值) 左值与右值)

$(P
$(IX 表达式, 左值与右值) 任何表达式的值都可以用左值或右值归类。要区分他们可以简单地认为左值是真实变量（包括数组和关联数组的元素），而右值是表达式（包括文字量）的临时结果。
)

$(P
例如，下面的第一个 $(C writeln()) 表达式只使用了左值，其他的只使用了右值：
)

---
import std.stdio;

void main() {
    int i;
    immutable(int) imm;
    auto arr = [ 1 ];
    auto aa = [ 10 : "ten" ];

    /* 下面所有参数都是左值。 */

    writeln(i,          // 可变变量
            imm,        // 不可变变量
            arr,        // 数组
            arr[0],     // 数组元素
            aa[10]);    // 关联数组元素
                        // 等

    enum message = "hello";

    /* 下面所有参数都是右值。 */

    writeln(42,               // 一个文字量
            message,          // 显然是一个常量
            i + 1,            // 一个临时值
            calculate(i));    // 函数的返回值
                              // 等
}

int calculate(int i) {
    return i * 2;
}
---

$(H5 右值的限制)

$(P
相对于左值，右值有下面三条限制。
)

$(H6 右值没有内存地址)

$(P
左值有可以引用的内存地址，但右值没有。
)

$(P
例如，下面的程序里不可能取到右值表达式 $(C a&nbsp;+&nbsp;b) 的值：
)

---
import std.stdio;

void main() {
    int a;
    int b;

    readf(" %s", &a);          $(CODE_NOTE 编译通过)
    readf(" %s", &(a + b));    $(DERLEME_HATASI)
}
---

$(SHELL
Error: a + b $(HILITE is not an lvalue)
)

$(H6 右值不能被赋新值)

$(P
左值如果为可变，则可以被赋予新值，但右值却不行：
)

---
    a = 1;          $(CODE_NOTE 编译通过)
    (a + b) = 2;    $(DERLEME_HATASI)
---

$(SHELL
Error: a + b $(HILITE is not an lvalue)
)

$(H6 右值不能通过引用方式传递给函数)

$(P
左值能传递给一个接受引用参数的函数，但右值不能：
)

---
void incrementByTen($(HILITE ref int) value) {
    value += 10;
}

// ...

    incrementByTen(a);        $(CODE_NOTE 编译通过)
    incrementByTen(a + b);    $(DERLEME_HATASI)
---

$(SHELL
Error: function deneme.incrementByTen (ref int value)
$(HILITE is not callable) using argument types (int)
)

$(P
有这个限制的主要原因是接受一个引用参数的函数可以保持这个引用在稍后使用，而在那个时间点右值却已经失效了。
)

$(P
与如 C++ 等语言不同，在 D 中就算函数$(I 不)改变实参，右值也不能传递给函数：
)

---
void print($(HILITE ref const(int)) value) {
    writeln(value);
}

// ...

    print(a);        $(CODE_NOTE 编译通过)
    print(a + b);    $(DERLEME_HATASI)
---

$(SHELL
Error: function deneme.print (ref const(int) value)
$(HILITE is not callable) using argument types (int)
)

$(H5 $(IX auto ref, 参数) $(IX 参数, auto ref) 使用 $(C auto ref) 参数可以同时接受左值和右值)

$(P
如前面章节中提到的，$(LINK2 /ders/d.cn/templates.html, 函数模板) 的 $(C auto ref) 参数可以同时接受左值和右值。
)

$(P
当参数是一个左值时，$(C auto ref) 表示$(I 传引用)。另一方面，因为右值不能通过引用传给函数，所以当参数是一个右值时，它表示是$(I 传值)。由于编译器要为两种不同的情况生成不同的代码，因此这个函数必须是一个模板。
)

$(P
我们会在后面的章节中看到模板。现在，请先了解下面高亮的括号让这个定义变成了一个$(I 函数)模板。
)

---
void incrementByTen$(HILITE ())($(HILITE auto ref) int value) {
    /* 警告：如果实参是一个右值则形参会是一个拷贝。也就是说下面的更改对
     * 对调用者来说不可见。 */

    value += 10;
}

void main() {
    int a;
    int b;

    incrementByTen(a);        $(CODE_NOTE 左值；引用传递)
    incrementByTen(a + b);    $(CODE_NOTE 右值；拷贝)
}
---

$(P
正如上面代码注释提到的，对形参的改动可能会对调用者不可见。因此，$(C auto ref) 最常用于形参不会被改变的场景；通常写作 $(C auto ref const)。
)

$(H5 术语)

$(P
“左值（lvalue）”和“右值（rvalue）”这两个名字并不能准确地表示两种值的特性。第一个字母 $(I l) 和 $(I r) 分别源自$(I 左（left）)和$(I 右（right）)，表示赋值运算符左边或右边表达式：
)

$(UL

$(LI 左值如果可变，则可以是赋值运算左边的表达式。)

$(LI 右值不能是赋值运算左边的表达式。)

)

$(P
术语“左值”和“右值”会有些混淆，因为通常左值和右值都可以出现在赋值运算的任何一边：
)

---
    // 右值“a + b”在左边，左值“a”在右边：
    array[a + b] = a;
---

Macros:
        SUBTITLE=左值与右值

        DESCRIPTION=左值与右值及它们的区别。

        KEYWORDS=d 编程 语言 教程 左值 右值
