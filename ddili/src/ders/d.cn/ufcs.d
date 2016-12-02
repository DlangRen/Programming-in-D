Ddoc

$(DERS_BOLUMU $(IX UFCS) $(IX 通用 函数 调用 语法) 通用函数调用语法(UFCS))

$(P
UFCS 是编译器自动应用的特性。它能让普通函数使用成员函数的语法。语法可以用两个表达的对比来简单描述：
)

---
    variable.foo($(I 参数))
---

$(P
当编译器遇到如上的表达式，如果使用给定的参数，变量 $(C variable) 没有能调用的成员函数 $(C foo)，那么编译器会尝试如下的表达式：
)

---
    foo(variable, $(I 参数))
---

$(P
如果能够被编译，那编译器就会简单的接受这个新的表达式。因此，尽管 $(C foo()) 显然是一个普通函数，但是用成员函数的调用语法同样也能被接受。
)

$(P
我们知道与类型紧密相关的函数都通常定义为这个类型的成员函数。这一点对于封装而言尤其重要，只有类型的成员函数(以及类型所在的模块)才能访问其$(C 私有)成员。
)

$(P
来看一个 $(C Car) 类的实例，这个类维护着燃油的数量：
)

---
$(CODE_NAME Car)class Car {
    enum economy = 12.5;          // 千米/升（平均）
    private double fuelAmount;    // 升

    this(double fuelAmount) {
        this.fuelAmount = fuelAmount;
    }

    double fuel() const {
        return fuelAmount;
    }

    // ...
}
---

$(P
尽管成员函数非常有用，有时候也是必须的，但并不是所有操作某类型的函数都应当是成员函数。对于真正的程序，有些类型的操作非常特殊，因而不能作为成员函数。例如，确定一辆车是否能行驶指定的距离这样的函数定义为普通函数会更为合适：
)

---
$(CODE_NAME canTravel)bool canTravel(Car car, double distance) {
    return (car.fuel() * car.economy) >= distance;
}
---

$(P
这种自然的定义会让与类相关的函数的调用方式产生分歧：在这两种语法里，对象出现在了不同的位置：
)

---
$(CODE_XREF Car)$(CODE_XREF canTravel)void main() {
    auto car = new Car(5);

    auto remainingFuel = $(HILITE car).fuel();  // 成员函数调用语法

    if (canTravel($(HILITE car), 100)) {        // 普通函数调用语法
        // ...
    }
}
---

$(P
UFCS 通过允许普通函数的调用使用成员函数的语法消除了这种分歧：
)

---
    if ($(HILITE car).canTravel(100)) {  // 普通函数，调用采用成员函数调用语法
        // ...
    }
---

$(P
该特性对于基础类型同样适用，包括字面量：
)

---
int half(int value) {
    return value / 2;
}

void main() {
    assert(42.half() == 21);
}
---

$(P
在下一章我们会看到，当函数没有传入的参数时，函数调用可以省略括号。与这个特性一起使用是，上面的表达式会变得更加小巧。下面的三种语句是等同的：
)

---
    result = half(value);
    result = value.half();
    result = value.half;
---

$(P
$(IX 链式, 函数调用) $(IX 函数调用链) 当函数调用是$(I 链式)形式时，UFCS 尤其好用。我们来看个例子，例子中包含了一组操作 $(C int) 切片的函数：
)

---
$(CODE_NAME functions)// 返回所有元素除以‘divisor’的结果
int[] divide(int[] slice, int divisor) {
    int[] result;
    result.reserve(slice.length);

    foreach (value; slice) {
        result ~= value / divisor;
    }

    return result;
}

// 返回所有元素乘以‘multiplier’的结果
int[] multiply(int[] slice, int multiplier) {
    int[] result;
    result.reserve(slice.length);

    foreach (value; slice) {
        result ~= value * multiplier;
    }

    return result;
}

// 筛选出所有偶数
int[] evens(int[] slice) {
    int[] result;
    result.reserve(slice.length);

    foreach (value; slice) {
        if (!(value % 2)) {
            result ~= value;
        }
    }

    return result;
}
---

$(P
如果用普通函数语法，而不是 UFCS，链式调用这三个函数的表达式可以如下写出：
)

---
$(CODE_XREF functions)import std.stdio;

// ...

void main() {
    auto values = [ 1, 2, 3, 4, 5 ];
    writeln(evens(divide(multiply(values, 10), 3)));
}
---

$(P
values 首先乘以 10，然后除以 3，最后只有偶数会被输出：
)

$(SHELL
[6, 10, 16]
)

$(P
上面表达式的问题在于，尽管 $(C multiply) 和 $(C 10) 对是相关的，$(C divide) 和 $(C 3) 对是相关的，结果最终两者都写得很开。UFCS 消除了这个问题，允许用更自然的方式反映实际的操作顺序：
)

---
    writeln(values.multiply(10).divide(3).evens);
---

$(P
一些程序员甚至对像 $(C writeln()) 这样的调用都使用 UFCS：
)

---
    values.multiply(10).divide(3).evens.writeln;
---

$(P
顺便提一下，上面的程序完全可以用 $(C map()) 和 $(C filter()) 写的极其简短：
)

---
import std.stdio;
import std.algorithm;

void main() {
    auto values = [ 1, 2, 3, 4, 5 ];

    writeln(values
            .map!(a => a * 10)
            .map!(a => a / 3)
            .filter!(a => !(a % 2)));
}
---

$(P
上面的程序使用了 $(LINK2 /ders/d.cn/templates.html, 模板)，$(LINK2 /ders/d.cn/ranges.html, ranges)，以及 $(LINK2 /ders/d.cn/lambda.html, lambda 函数)，所有这些都会在下面的章节中阐述。
)

Macros:
        SUBTITLE=通用函数调用语法 (UFCS)

        DESCRIPTION=通用函数调用语法：普通函数使用成员函数调用语法的能力。

        KEYWORDS=d 编程 课程 教程 封装
