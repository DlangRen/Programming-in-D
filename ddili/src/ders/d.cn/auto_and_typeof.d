Ddoc

$(DERS_BOLUMU $(CH4 auto) 和 $(CH4 typeof))

$(H5 $(IX auto, 变量) $(C auto))

$(P
在前一章中定义 $(C File) 变量时， 我们在 $(C =) 运算符的两边重复了类型名：
)

---
    $(HILITE File) file = $(HILITE File)("student_records", "w");
---

$(P
这显得很多余。在类型名较长的时候，这不仅麻烦而且易错：
)

---
    VeryLongTypeName var = VeryLongTypeName(/* ... */);
---

$(P
幸运的是，左边的类型名不是必需的，因为编译器可以从右边的表达式推断出左边的类型。想要编译器来推断类型，可以使用关键字 $(C auto)：
)

---
    $(HILITE auto) var = VeryLongTypeName(/* ... */);
---

$(P
$(C auto) 可被用作任意类型，即使右边的类型没有拼写出来：
)

---
    auto duration = 42;
    auto distance = 1.2;
    auto greeting = "Hello";
    auto vehicle = BeautifulBicycle("blue");
---

$(P
尽管 "auto" 是自动 $(I automatic) 的缩写，但它不是来自于自动类型推理 $(I automatic type inference)。它来自于自动存储类别 $(I automatic storage class)，这是一个跟变量生命周期相关的概念。$(C auto) 适用于没有使用其它说明符时使用。例如，下面的定义就无需使用 $(C auto)：
)

---
    immutable i = 42;
---

$(P
上面的代码中，编译器将 $(C i) 的类型自动推断为 $(C immutable int)。（我们将会在稍后的章节中看到 $(C immutable) 。）
)

$(H5 $(IX typeof) $(C typeof))

$(P
$(C typeof) 提供表达式的类型（包括单个变量，对象，字母常量等）而不必对表达式进行实际计算。
)

$(P
下面这个例子演示了 $(C typeof) 是如何在不需要显示拼写的情况下被用来指定类型的：
)

---
    int value = 100;      // 已经定义为 'int'

    typeof(value) value2; // 意思是 “value 的类型”
    typeof(100) value3;   // 意思是 “字面常量 100 的类型”
---

$(P
上面后两个变量的定义等同于下列代码：
)

---
    int value2;
    int value3;
---

$(P
显然，像上面那种实际类型已知的情况下，$(C typeof) 并不是必需的。相反，你通常会在更复杂的情况下才使用它，比如当你希望你的变量类型同它处代码中的可以改变的类型保持一致的时候。该关键字在 $(LINK2 /ders/d.cn/templates.html, 模板) 和 $(LINK2 /ders/d.cn/mixin.html, 混入) 中特别有用，此二者将在后面的章节中介绍。
)

$(PROBLEM_TEK

$(P
如上所见，如 100 这样的字面常量的类型为 $(C int)（而不是 $(C short)，$(C long)，或任何其它类型）。像 1.2 那样来写一个程序用以确定浮点数字面常量的类型。 $(C typeof) 和 $(C .stringof) 对该程序会很有用。
)

)

Macros:
        SUBTITLE=关键字 auto 和 typeof

        DESCRIPTION=关键字 'auto' 是 D 语言中常用的隐式类型推断特征，而 'typeof' 用来获取表达式的类型。

        KEYWORDS=D 编程语言教程 auto typeof
