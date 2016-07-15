Ddoc

$(DERS_BOLUMU $(IX alias) $(CH4 alias) 与 $(CH4 with))

$(H5 $(C alias))

$(P
The $(C alias) 关键字为已有名字生成一个别名。 $(C alias) 与 $(C alias this) 不同，之间没有明确联系。
)

$(H6 缩短名字)

$(P
正如我们在前面章节中遇到的，许多名字变得很长而难于使用。如下面这个函数：
)

---
Stack!(Point!double) randomPoints(size_t count) {
    auto points = new Stack!(Point!double);
    // ...
}
---

$(P
多次显式地指定类型 $(C Stack!(Point!double)) 有许多缺点：
)

$(UL
$(LI
名字太长难以阅读。
)

$(LI
没必要在所有的地方都说明，该类型是一个由 $(C double) 实例化的 $(C Point) struct 模板对象组成的 $(C Stack) 数据结构。
)

$(LI
如果程序需求变更，比如 $(C double) 改成 $(C real)，那你就需要更改多个位置。
)

)

$(P
可以给 $(C Stack!(Point!double)) 一个新的名字来消除这些缺点：
)

---
alias $(HILITE Points) = Stack!(Point!double);

// ...

$(HILITE Points) randomPoints(size_t count) {
    auto points = new $(HILITE Points);
    // ...
}
---

$(P
更进一步，定义两个 alias 可能会更有用，其中一个在另一个基础上定义。
)

---
alias PrecisePoint = Point!double;
alias Points = Stack!PrecisePoint;
---

$(P
$(C alias) 的语法如下:
)

---
    alias $(I 新名字) = $(I 已有名字);
---

$(P
定义之后，新名字和已有名字等同：在程序里是相同的东西。
)

$(P
你可能会在一些程序里遇到这个特性的旧语法：
)

$(MONO
    // 不推荐使用旧语法：
    alias $(I 已有名字) $(I 新名字);
)

$(P
在一些需要讲明模块名字的情况，用 $(C alias) 来缩短名字也会很有用。假定名字 $(C Queen) 同时存在于两个不同的模块： $(C chess) 和 $(C palace)。如果两个模块同时被导入，仅仅输入 $(C Queen) 会导致一个编译错误：
)

---
import chess;
import palace;

// ...

    Queen person;             $(DERLEME_HATASI)
---

$(P
编译器无法判断 $(C Queen) 指的是哪一个：
)

$(SHELL_SMALL
Error: $(HILITE chess.Queen) at chess.d(1) conflicts with
$(HILITE palace.Queen) at palace.d(1)
)

$(P
要解决这个冲突，一个便利的方式就是给这些名字定义 alias：
)

---
import palace;

alias $(HILITE PalaceQueen) = palace.Queen;

void main() {
    $(HILITE PalaceQueen) person;
    // ...
    $(HILITE PalaceQueen) anotherPerson;
}
---

$(P
$(C alias) 也可以用于其他地方的名字。下面的代码为变量定义了一个新名字：
)

---
    int variableWithALongName = 42;

    alias var = variableWithALongName;
    var = 43;

    assert(variableWithALongName == 43);
---

$(H6 设计灵活性)

$(P
为了灵活性，就算是基本类型，比如 $(C int) 都可以有 alias：
)

---
alias CustomerNumber = int;
alias CompanyName = string;
// ...

struct Customer {
    CustomerNumber number;
    CompanyName company;
    // ...
}
---

$(P
如果这个 struct 的用户一直使用 $(C CustomerNumber) 和 $(C CompanyName) 而不是 $(C int) 和 $(C string)，那将来扩展导致设计变更的时候就不会影响用户的代码了。
)

$(P
这也会提高代码的可读性，把变量的类型写做 $(C CustomerNumber) 会比 $(C int) 传递更多变量的信息。
)

$(P
有时候这样的类型会定义在 struct 或 class 中，成为它们的一部分。下面这个 class 有一个叫 $(C weight) 的 property：
)

---
class Box {
private:

    double weight_;

public:

    double weight() const @property {
        return weight_;
    }
    // ...
}
---

$(P
因为 class 中的成员变量和 property 都定义成了 $(C double)，用户也就必须使用 $(C double)：
)

---
    $(HILITE double) totalWeight = 0;

    foreach (box; boxes) {
        totalWeight += box.weight;
    }
---

$(P
我们来比较一下另外一种设计，把 $(C weight) 定义为一个 alias：
)

---
class Box {
private:

    $(HILITE Weight) weight_;

public:

    alias $(HILITE Weight) = double;

    $(HILITE Weight) weight() const @property {
        return weight_;
    }
    // ...
}
---

$(P
现在，用户代码可以正常地使用 $(C Weight) 了：
)

---
    $(HILITE Box.Weight) totalWeight = 0;

    foreach (box; boxes) {
        totalWeight += box.weight;
    }
---

$(P
这样的设计，将来改变 $(C Weight) 的真实类型就不再会影响用户代码了。（新的类型也要支持 $(C +=) 运算符。)
)

$(H6 $(IX 名字隐藏) 暴露父类中隐藏的名字)

$(P
当相同的名字同时出现在父类与子类中时，父类中的名字就会被隐藏，即使只是子类中的一个名字也足以隐藏父类中所有匹配的名字：
)

---
class Super {
    void foo(int x) {
        // ...
    }
}

class Sub : Super {
    void foo() {
        // ...
    }
}

void main() {
    auto object = new Sub;
    object.foo(42);            $(DERLEME_HATASI)
}
---

$(P
因为调用参数是整型 42，你可能会认为接受 $(C int) 参数的 $(C Super.foo) 会被调用。然而，$(C Sub.foo) 会 $(I 隐藏) $(C Super.foo) 并导致一个编译错误，虽然他们的参数列表不同。编译器完全忽略了 $(C Super.foo)，并且报告说不能用 $(C int) 去调用 $(C Sub.foo)：
)

$(SHELL_SMALL
Error: function $(HILITE deneme.Sub.foo ()) is not callable
using argument types $(HILITE (int))
)

$(P
注意，这与重写父类中的函数不一样。重写要求函数的签名必须完全一样，并且需要使用 $(C override) 关键字。（$(C override) 关键字已经在 $(LINK2 /ders/d.cn/inheritance.html, 继承) 章节中介绍过了。）
)

$(P
这里并不是重写，而是一个语言特性，叫做$(I 名字隐藏)。如果没有名字隐藏，在这些 class 中添加或者删除名字 $(C foo) 就可能会改变本该调用的函数，名字隐藏阻止了这样的情况发生。这也是其他 OOP 语言中常见的特性。
)

$(P
$(C alias) 可以在需要的时候暴露被隐藏的名字：
)

---
class Super {
    void foo(int x) {
        // ...
    }
}

class Sub : Super {
    void foo() {
        // ...
    }

    alias $(HILITE foo) = Super.foo;
}
---

$(P
如上所示，$(C alias) 将名字 $(C foo) 从父类引入成为子类接口。因此，代码现在能够编译了，$(C Super.foo) 也会被正确调用。
)

$(P
若需要，也在可以引入的同时改变名字：
)

---
class Super {
    void foo(int x) {
        // ...
    }
}

class Sub : Super {
    void foo() {
        // ...
    }

    alias $(HILITE generalFoo) = Super.foo;
}

// ...

void main() {
    auto object = new Sub;
    object.$(HILITE generalFoo)(42);
}
---

$(P
名字隐藏同样也会影响成员变量。当然，$(C alias) 也可以引入这些名字：
)

---
class Super {
    int city;
}

class Sub : Super {
    string city() const @property {
        return "Kayseri";
    }
}
---

$(P
虽然一个是成员变量，一个是成员函数，子类中的名字 $(C city) 也会隐藏父类中的名字 $(C city)：
)

---
void main() {
    auto object = new Sub;
    object.city = 42;        $(DERLEME_HATASI)
}
---

$(P
同样的，父类中成员变量的名字可以通过 $(C alias) 引入为子类接口，并改名：
)

---
class Super {
    int city;
}

class Sub : Super {
    string city() const @property {
        return "Kayseri";
    }

    alias $(HILITE cityCode) = Super.city;
}

void main() {
    auto object = new Sub;
    object.$(HILITE cityCode) = 42;
}
---

$(H5 $(IX with) $(C with))

$(P
$(C with) 用于避免重复的引用一个对象或者符号。只用在括号里输入一个表达式或者符号，就可以在 $(C with) 的作用域内通过这个表达式或者符号来查找其他的符号：
)

---
struct S {
    int i;
    int j;
}

void main() {
    auto s = S();

    with ($(HILITE s)) {
        $(HILITE i) = 1;    // 表示 s.i
        $(HILITE j) = 2;    // 表示 s.j
    }
}
---

$(P
允许在括号内创建一个临时对象。这时，这个临时对象是一个 $(LINK2 /ders/d.cn/lvalue_rvalue.html, 左值)，一旦离开作用域，生命期就结束：
)

---
    with (S()) {
        i = 1;    // 临时对象的 i 成员
        j = 2;    // 临时对象的 j 成员
    }
---

$(P
以后我们将在 $(LINK2 /ders/d.en/pointers.html, 指针) 章节重看到，可以用 $(C new) 创建临时对象，这时对象的生命期就可以超过作用域。
)

$(P
在 $(C case) 块中，删除重复的引用，比如 $(C enum) 类型时，$(C with) 会特别有用：
)

---
enum Color { red, orange }

// ...

    final switch (c) $(HILITE with (Color)) {

    case red:       // 表示 Color.red
        // ...

    case orange:    // 表示 Color.orange
        // ...
    }
---

$(H5 总结)

$(UL

$(LI $(C alias) 为已有名字取别名。)

$(LI $(C with) 避免重复引用相同的对象或符号。)

)

Macros:
        SUBTITLE=alias

        DESCRIPTION=alias 关键字可以为已有名字创建新的名字。

        KEYWORDS=d 编程 教程 封装
