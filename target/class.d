Ddoc

$(DERS_BOLUMU $(IX class) 类)

$(P
$(IX OOP) $(IX object oriented programming) $(IX user defined type) Similar to structs, $(C class) is a feature for defining new types. By this definition, classes are $(I user defined types). Different from structs, classes provide the $(I object oriented programming) (OOP) paradigm in D. The major aspects of OOP are the following:
)

$(UL

$(LI
$(B Encapsulation:) Controlling access to members ($(I Encapsulation is available for structs as well but it has not been mentioned until this chapter.))
)

$(LI
$(B Inheritance:) Acquiring members of another type
)

$(LI
$(B Polymorphism:) Being able to use a more special type in place of a more general type
)

)

$(P
Encapsulation is achieved by $(I protection attributes), which we will see in $(LINK2 /ders/d.en/encapsulation.html, a later chapter). Inheritance is for acquiring $(I implementations) of other types. $(LINK2 /ders/d.en/inheritance.html, Polymorphism) is for abstracting parts of programs from each other and is achieved by class $(I interfaces).
)

$(P
This chapter will introduce classes at a high level, underlining the fact that they are reference types. Classes will be explained in more detail in later chapters.
)

$(H5 Comparing with structs)

$(P
In general, classes are very similar to structs. Most of the features that we have seen for structs in the following chapters apply to classes as well:
)

$(UL
$(LI $(LINK2 /ders/d.en/struct.html, Structs))
$(LI $(LINK2 /ders/d.en/member_functions.html, Member Functions))
$(LI $(LINK2 /ders/d.en/const_member_functions.html, $(CH4 const ref) Parameters and $(CH4 const) Member Functions))
$(LI $(LINK2 /ders/d.en/special_functions.html, Constructor and Other Special Functions))
$(LI $(LINK2 /ders/d.en/operator_overloading.html, Operator Overloading))
)

$(P
However, there are important differences between classes and structs.
)

$(H6 Classes are reference types)

$(P
The biggest difference from structs is that structs are $(I value types) and classes are $(I reference types). The other differences outlined below are mostly due to this fact.
)

$(H6 $(IX null, class) $(new, class) Class variables may be $(C null))

$(P
As it has been mentioned briefly in $(LINK2 /ders/d.en/null_is.html, The $(CH4 null) Value and the $(CH4 is) Operator chapter), class variables can be $(C null). In other words, class variables may not be providing access to any object. Class variables do not have values themselves; the actual class objects must be constructed by the $(C new) keyword.
)

$(P
As you would also remember, comparing a reference to $(C null) by the $(C ==) or the $(C !=) operator is an error. Instead, the comparison must be done by the $(C is) or the $(C !is) operator, accordingly:
)

---
    MyClass referencesAnObject = new MyClass;
    assert(referencesAnObject $(HILITE !is) null);

    MyClass variable;   // does not reference an object
    assert(variable $(HILITE is) null);
---

$(P
The reason is that, the $(C ==) operator may need to consult the values of the members of the objects and that attempting to access the members through a potentially $(C null) variable would cause a memory access error. For that reason, class variables must always be compared by the $(C is) and $(C !is) operators.
)

$(H6 $(IX variable, class) $(IX object, class) Class variables versus class objects)

$(P
Class variable and class object are separate concepts.
)

$(P
Class objects are constructed by the $(C new) keyword; they do not have names. The actual concept that a class type represents in a program is provided by a class object. For example, assuming that a $(C Student) class represents students by their names and grades, such information would be stored by the members of $(C Student) $(I objects). Partly because they are anonymous, it is not possible to access class objects directly.
)

$(P
A class variable on the other hand is a language feature for accessing class objects. 虽然语法上看起来是在类 $(I 变量) 上执行，但实际上调度了一个类 $(I object)。
)

$(P
Let's consider the following code that we saw previously in the $(LINK2 /ders/d.en/value_vs_reference.html, Value Types and Reference Types chapter):
)

---
    auto variable1 = new MyClass;
    auto variable2 = variable1;
---

$(P
 $(C new) 关键字构造了一个匿名的类对象。上面的 $(C variable1) 和 $(C variable2) 只提供对那个匿名对象的访问：
)

$(MONO
 (匿名的 MyClass 对象)    variable1    variable2
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
在上面的代码中， $(C variable2) 由 $(C variable1) 初始化。这俩变量可访问同一对象。The two variables start providing access to the same object.
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
下面的代码演示 $(C dup()) 创建一个新的对象的用法：
)

---
    auto var1 = new Foo(S(1.5), "hello", 42);
    auto var2 = var1.dup();
---

$(P
结果是，$(C var1) 和 $(C var2) 相关联的对象是不同的。
)

$(P
Similarly, an $(C immutable) copy of an object can be provided by a member function appropriately named $(C idup()). In this case, the constructor must be defined as $(C pure) as well. We will cover the $(C pure) keyword in $(LINK2 /ders/d.en/functions_more.html, a later chapter).
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
$(IX finalizer versus destructor) However, different from structs, class destructors are not executed at the time when the lifetime of a class object ends. As we have seen above, the destructor is executed some time in the future during a garbage collection cycle. (By this distinction, class destructors should have more accurately been called $(I finalizers)).
)

$(P
As we will see later in $(LINK2 /ders/d.en/memory.html, the Memory Management chapter), class destructors must observe the following rules:
)

$(UL

$(LI A class destructor must not access a member that is managed by the garbage collector. This is because garbage collectors are not required to guarantee that the object and its members are finalized in any specific order. All members may have already been finalized when the destructor is executing.)

$(LI A class destructor must not allocate new memory that is managed by the garbage collector. This is because garbage collectors are not required to guarantee that they can allocate new objects during a garbage collection cycle.)

)

$(P
Violating these rules is undefined behavior. It is easy to see an example of such a problem simply by trying to allocate an object in a class destructor:
)

---
class C {
    ~this() {
        auto c = new C();    // ← WRONG: Allocates explicitly
                             //          in a class destructor
    }
}

void main() {
    auto c = new C();
}
---

$(P
The program is terminated with an exception:
)

$(SHELL
core.exception.$(HILITE InvalidMemoryOperationError)@(0)
)

$(P
It is equally wrong to allocate new memory $(I indirectly) from the garbage collector in a destructor. For example, memory used for the elements of a dynamic array is allocated by the garbage collector as well. Using an array in a way that would require allocating a new memory block for the elements is undefined behavior as well:
)

---
    ~this() {
        auto arr = [ 1 ];    // ← WRONG: Allocates indirectly
                             //          in a class destructor
    }
---

$(SHELL
core.exception.$(HILITE InvalidMemoryOperationError)@(0)
)

$(H6 Member access)

$(P
与结构一样，用 $(I 点) 运算符访问成员：
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

$(H5 摘要)

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
