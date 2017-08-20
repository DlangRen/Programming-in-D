Ddoc

$(DERS_BOLUMU $(IX class) 类)

$(P
$(IX OOP) $(IX object oriented programming) $(IX user defined type) 与结构相似，$(C class) 具有定义新类型的功能。根据此定义，类是 $(I 自定义类型)。不同于结构的是，D 语言中的类提供的是 $(I 面向对象编程) （OOP）模型。OOP 的主要内容有以下几个方面：
)

$(UL

$(LI
$(B 封装：) 控制成员的访问（$(I 封装也可用于结构，只是到本章之前一直未提及。)）
)

$(LI
$(B 继承：) 获取另一个类型的成员
)

$(LI
$(B 多态性：) 能够使用较特定的类型取代较通用的类型
)

)

$(P
封装是通过 $(I 保护属性) 来实现的，关于这一点在 $(LINK2 /ders/d.en/encapsulation.html, 后面章节) 会看到。继承是用于获取其它类型的 $(I 实现)。$(LINK2 /ders/d.en/inheritance.html, 多态性) 是从类之间抽象出部分代码，通过 $(I 接口) 实现的。
)

$(P
本章将深入介绍类，特别强调一点，类是引用类型。稍后的章节中将展示类的更多细节。
)

$(H5 与结构对比)

$(P
一般情况下，类与结构非常相似。在下面的章节中我们已经看到结构的大部分特性也适用于类：
)

$(UL
$(LI $(LINK2 /ders/d.en/struct.html, 结构))
$(LI $(LINK2 /ders/d.en/member_functions.html, 成员函数))
$(LI $(LINK2 /ders/d.en/const_member_functions.html, $(CH4 const ref) 参数和 $(CH4 const) 成员函数))
$(LI $(LINK2 /ders/d.en/special_functions.html, 构造函数和其它特殊函数))
$(LI $(LINK2 /ders/d.en/operator_overloading.html, 运算符重载))
)

$(P
然而，类与结构之间有重要的区别。
)

$(H6 类是引用类型)

$(P
与结构的最大区别在于结构是 $(I 值类型)  而类是 $(I 引用类型)。下面的其它不同大部分与此有关。
)

$(H6 $(IX null, class) $(new, class) 类变量可以为 $(C null))

$(P
在 $(LINK2 /ders/d.en/null_is.html, $(CH4 null) 值和 $(CH4 is) 运算符一章)已提到过，类变量可以为 $(C null)。换句话说，类变量可以不提供对任何对象的访问。类变量并不拥有值本身；实际的类对象必须使用关键字 $(C new) 来构造。
)

$(P
大家都还记得吧，引用与运算符 $(C null) 不能通过运算符 $(C ==) 或 $(C !=) 进行比较。相反，必须相应地使用运算符 $(C is) 或 $(C !is)：
)

---
    MyClass referencesAnObject = new MyClass;
    assert(referencesAnObject $(HILITE !is) null);

    MyClass variable;   // 没有引用对象
    assert(variable $(HILITE is) null);
---

$(P
原因是，运算符 $(C ==) 会查询对象成员的值，并尝试通过一个潜在的 $(C null) 变量访问成员，这将引发一个内存访问错误。因此，类变量必须总是通过运算符 $(C is) 和 $(C !is) 进行比较。
)

$(H6 $(IX variable, class) $(IX object, class) 类变量与类对象)

$(P
类变量和类对象是独立的概念。
)

$(P
类对象由关键字 $(C new) 构造；它们没有名字。实际的概念是，在程序中，一个类类型由一个类对象表示。例如，有一个 $(C Student) 类，它通过姓名和成绩来表示学生， 此时 $(C Student) $(I 对象)的成员会存储这些信息。另一方面，类变量是用于访问类对象的一种语言特性。
)

$(P
A class variable on the other hand is a language feature for accessing class objects. 虽然语法上看起来是在类 $(I 变量) 上执行，但实际上调度了一个类 $(I object)。
)

$(P
一起来看看下面这段代码，之前在 $(LINK2 /ders/d.en/value_vs_reference.html, 值类型和引用类型一章)已见过，如下所示：
)

---
    auto variable1 = new MyClass;
    auto variable2 = variable1;
---

$(P
 $(C new) 关键字构造了一个匿名的类对象。上面的 $(C variable1) 和 $(C variable2) 只提供对那个匿名对象的访问：
)

$(MONO
 (匿名 MyClass 对象)    变量1    变量2
 ───┬───────────────────┬───  ───┬───┬───  ───┬───┬───
    │        ...        │        │ o │        │ o │
 ───┴───────────────────┴───  ───┴─│─┴───  ───┴─│─┴───
              ▲                    │            │
              │                    │            │
              └────────────────────┴────────────┘
)

$(H6 $(IX copy, class) 复制)

$(P
复制只影响变量，而不是对象。
)

$(P
因为类是引用类型，定义一个新的类变量做为另一个副本，将产生两个访问同一对象的变量。实际的对象没有被复制。
)

$(P
由于没有复制对象， postblit 函数 $(C this(this)) 不能用于类变量。
)

---
    auto variable2 = variable1;
---

$(P
在上面的代码中， $(C variable2) 由 $(C variable1) 初始化。这两个变量可访问同一个对象。
)

$(P
当需要复制实际的对象时，类必须有一个针对此目的的成员函数。为与数组兼容，该函数可以命名为 $(C dup()). 该函数必须创建并返回一个新的类对象。让我们在有各种类型成员的类上看看它：:
)

---
class Foo {
    S      o;  // 假设 S 是一个结构类型
    char[] s;
    int    i;

// ...

    this(S o, const char[] s, int i) {
        this.o = o;
        this.s = s.dup;
        this.i = i;
    }

    Foo dup() const {
        return new Foo(o, s, i);
    }
}
---

$(P
$(C dup())  成员函数利用 $(C Foo) 的构造函数，创建并返回新的对象。注意，构造函数通过数组的  $(C .dup) 属性显式复制 $(C s) 成员。做为值类型，$(C o) 和 $(C i) 自动被复制。
)

$(P
下面的代码利用 $(C dup()) 创建一个新的对象：
)

---
    auto var1 = new Foo(S(1.5), "hello", 42);
    auto var2 = var1.dup();
---

$(P
最后，与 $(C var1) 和 $(C var2) 关联的那些对象并不相同。
)

$(P
同样地，可以通过名为 $(C idup()) 的成员函数的提供对象的  $(C immutable) 副本：此时，构造函数必须同时定义为 $(C pure) 。我们会在$(LINK2 /ders/d.en/functions_more.html, 后面章节)对关键字 $(C pure) 进行讲解。
)

---
class Foo {
// ...
    this(S o, const char[] s, int i) $(HILITE pure) {
        // ...

    }
    immutable(Foo) idup() const {
        return new immutable(Foo)(o, s, i);
    }
}

// ...

    immutable(Foo) imm = var1.idup();
---

$(H6 $(IX assignment, class) 赋值)

$(P
就像复制，赋值只影响变量。
)

$(P
给类变量赋值，会解除变量与当前对象的关联，并关联到一个新对象。
)

$(P
如何没有别的类变量能访问已解除关联对象，那该对象将由垃圾回收器在将来某个时候销毁。
)

---
    auto variable1 = new MyClass();
    auto variable2 = new MyClass();
    variable1 $(HILITE =) variable2;
---

$(P
上面的赋值让 $(C variable1) 离开其对象并且开始提供对 $(C variable2) 的对象的访问。由于 $(C variable1) 的原始对象没有别的变量，该对象将由垃圾回收器销毁。
)

$(P
赋值操作不能改变类。换句话说，$(C opAssign) 不能因为它们而被重载。
)

$(H6 定义)

$(P
类由 $(C class) 关键字定义而不是 $(C struct) 关键字：
)

---
$(HILITE class) ChessPiece {
    // ...
}
---

$(H6 构造函数)

$(P
与结构一样，构造函数的名称是 $(C this) 。不像结构，类对象不能由 $(C {&nbsp;}) 语法构造。
)

---
class ChessPiece {
    dchar shape;

    this(dchar shape) {
        this.shape = shape;
    }
}
---

$(P
不像结构，构造函数参数按顺序分配给成员时，类没有自动构造对象：
)

---
class ChessPiece {
    dchar shape;
    size_t value;
}

void main() {
    auto king = new ChessPiece('♔', 100);  $(DERLEME_HATASI)
}
---

$(SHELL
Error: no constructor for ChessPiece
)

$(P
那样的语法要通过编译，就需要程序员显式的定义构造函数。
)

$(H6 析构函数)

$(P
像结构一样，析构函数的名称是 $(C ~this):
)

---
    ~this() {
        // ...
    }
---

$(P
$(IX finalizer versus destructor) 不过，与结构有所不同的是，类的析构函数在类对象的生命期结束时并不会被执行。正如上面看到的，析构函数会在未来垃圾回收周期内的某个时候被执行。（基于此点差异，类的析构函数被叫作 $(I 终结函数) 会更加确切）。
)

$(P
在后面的 $(LINK2 /ders/d.en/memory.html, 内存管理一章) 将会看到，类的析构函数必须遵循以下几条规则：
)

$(UL

$(LI 类的析构函数不能访问由垃圾回收器管理的成员。这是因为垃圾回收器没有被要求保证该对象及其成员按任何特定顺序终结。当析构函数执行时，全部成员应该已经终结。)

$(LI 类的析构函数一定不要分配由垃圾回收器管理的新内存。这是因为垃圾回收器没有被要求保证在垃圾回收周期内能分配新的对象。)

)

$(P
违反这些规则即会产生未定义行为。尝试在类的析构函数中分配一个对象，通过这种方式可以轻易地重现这种的问题：
)

---
class C {
    ~this() {
        auto c = new C();    // ← 错误：在类的析构函数里
                             //          显式分配内存
    }
}

void main() {
    auto c = new C();
}
---

$(P
这个程序会抛一个异常，并中断：
)

$(SHELL
core.exception.$(HILITE InvalidMemoryOperationError)@(0)
)

$(P
在析构函数里 $(I 间接地) 从垃圾回收器里分配新的内存，这种做法同样是错的。例如，用于一个动态数组的元素的内存由垃圾回收器来分配。用这种方式使用一个数组，那将需要为未定义行为的元素分配一个新的内存块：
)

---
    ~this() {
        auto arr = [ 1 ];    // ← 错误：在类的析构函数里
                             //          显式分配内存
    }
---

$(SHELL
core.exception.$(HILITE InvalidMemoryOperationError)@(0)
)

$(H6 成员访问)

$(P
与结构一样，可以使用 $(I 点) 运算符来访问成员：
)

---
    auto king = new ChessPiece('♔');
    writeln(king$(HILITE .shape));
---

$(P
虽然语法上看起来像访问 $(I 变量) 的成员，实际上是 $(I 对象) 的成员。类变量没有成员，类对象有。$(C king) 变量并没有 $(C shape) 成员，匿名对象有。
)

$(P
$(I $(B 注：) 在上面的代码中，一般不这样直接访问成员。若确实需要这样的语法，应该首选属性，这将在 $(LINK2 /ders/d.cn/property.html, 后面的章节) 中解释。)
)

$(H6 运算符重载)

$(P
虽然 $(C opAssign) 不能被类重载，但与结构一样，可以实现运算符重载。对于类， $(C opAssign) 意味着 $(I 一个类变量总是关联着一个类对象)。
)

$(H6 成员函数)

$(P
虽然成员函数的定义与用法与结构相同，有个重要的不同：类成员函数默认是 $(I 可重写的) 。在 $(LINK2 /ders/d.cn/inheritance.html,继承章节) 我们将看到相关内容。
)

$(P
$(IX final) 由于可重写的成员函数有一个运行时性能消耗，在这儿不讨论更多细节，我推荐您定义全部没必要用 $(C final) 关键字重写的 $(C class) 成员函数。若没有编译错误，您可以闭着眼睛按教程来：
)

---
class C {
    $(HILITE final) int func() {    $(CODE_NOTE 推荐)
        // ...
    }
}
---

$(P
与结构不同的是一些成员函数自动继承自 $(C Object) 类。在 $(LINK2 /ders/d.cn/inheritance.html, 下一章节) 我们将看到怎样通过$(C override) 关键字来修改 $(C toString) 的定义。
)

$(H6 $(IX is, 运算符) $(IX !is)   $(C is) 和 $(C !is) 运算符)

$(P
这些运算符应用在类变量上。
)

$(P
$(C is) 确定两个类变量是否提供对同一对象的访问。如果是同一对象，返回 $(C true) ，否则为 $(C false) 。$(C !is) 与 $(C is) 相反。
)

---
    auto myKing = new ChessPiece('♔');
    auto yourKing = new ChessPiece('♔');
    assert(myKing !is yourKing);
---

$(P
由于 $(C myKing) 和 $(C yourKing) 变量来自不同的对象，$(C !is) 运算符返回 $(C true)。即使这两个对象由同一字符 $(C'♔')  参数构造，, 它们仍是两个单独的对象。
)

$(P
当变量提供对同一对象的访问时，$(C is) 返回 $(C true)：
)

---
    auto myKing2 = myKing;
    assert(myKing2 is myKing);
---

$(P
上面的两个变量都提供对同一对象的访问。
)

$(H5 小结)

$(UL

$(LI 类和结构虽然有共同特点，但还是有很大的差异。
)

$(LI  类是引用类型。The $(C new) 关键字构造一个匿名 $(I class 对象) 并返回一个 $(I class 变量)。
)

$(LI 不与任何对象相关联的类变量为 $(C null)。检查 $(C null) 必须使用 $(C is) 或 $(C !is)，而不是 $(C ==) 或 $(C !=)。
)

$(LI 复制操作将增加一个与对象关联的变量。为了复制类对象，类型必须有一个类似于命名为 $(C dup()) 的特殊函数。
)

$(LI 赋值会把一个变量与一个对象相关联。该行为不能被修改。
)

)

Macros:
        SUBTITLE=类

        DESCRIPTION=D语言基本的面向对象编程 (OOP) 功能。

        KEYWORDS=D 语言编程教程 class
