Ddoc

$(DERS_BOLUMU $(IX property) 属性)

$(P
属性能让我们使用像访问成员变量一样的语法调用成员函数。
)

$(P
在学习分片的时候我们已经多次用到它。slice 的 $(C length) 属性返回了其包含元素的个数：
)

---
    int[] slice = [ 7, 8, 9 ];
    assert(slice$(HILITE .length) == 3);
---

$(P
如果只看它的语法，你可能会认为 $(C .length) 是一个成员变量：
)

---
struct SliceImplementation {
    int length;

    // ...
}
---

$(P
但属性提供了成员变量所不能提供的功能：对 $(C .length) 赋值将会改变 slice 的真实长度。向数组中添加新元素时就包含这一过程：
)

---
    slice$(HILITE .length = 5);    // slice 现在有 5 个元素
    assert(slice.length == 5);
---

$(P $(I $(B 注：)无法修改定长数组的 $(C .length) 属性。)
)

$(P
对 $(C .length) 赋值并不是简单的改变某个变量，实际上语言在后台做了很多复杂的工作：判断数组是否有足够的空间容纳新的元素，如果没有则在内存中分配更大的空间并将已存在的元素移动到新位置；最后再将添加的新元素以 $(C .init) 的方式初始化。
)

$(P
就像你看到的那样，对 $(C .length) 的赋值就像是调用了一个函数。
)

$(P
$(IX @property) 属性实际上就是成员函数，但我们却可以像使用成员变量一样调用它们。所需的额外工作就是在函数的前面加一个 $(C @property)。
)

$(H5 不使用圆括号的函数调用)

$(P
$(IX ()) 我们在之前的章节中提到过，如果调用函数时不需要传递参数，那我们可以省略圆括号：
)

---
    writeln();
    writeln;      // 与上一行相同
---

$(P
这个特性和属性很像，它们都不需要圆括号。
)

$(H5 读属性)

$(P
我们使用下面这个包含两个成员的矩形结构体作为示例：
)

---
struct Rectangle {
    double width;
    double height;
}
---

$(P
现在假设我们需要为这个类型添加一个新属性用于表示这个矩形的面积：
)

---
    auto garden = Rectangle(10, 20);
    writeln(garden$(HILITE .area));
---

$(P
一种方案是在矩形结构体中定义第三个成员变量：
)

---
struct Rectangle {
    double width;
    double height;
    double area;
}
---

$(P
这种设计的缺点是对象很容易出现不一致性：虽然矩形永远都是“长 × 宽 == 面积”，但是如果成员变量能被随意修改的话，对象的一致性将极易被破坏。
)

$(P
作为一个极端的例子，对象在其生命期开始时就已经处在不一致的状态了：
)

---
    // 不一致的对象：面积不是 10 * 20 == 200。
    auto garden = Rectangle(10, 20, $(HILITE 1111));
---

$(P
所以我们最好用属性来实现面积。我们要定义一个名为 $(C area) 的函数来计算面积而不是定义成员变量来表示面积：
)

---
struct Rectangle {
    double width;
    double height;

    double area() const $(HILITE @property) {
        return width * height;
    }
}
---

$(P $(I $(B 注：)如果你还记得我们在 $(LINK2 /ders/d.cn/const_member_functions.html, $(CH4 const ref) 参数和 $(CH4 const) 成员函数) 一章中所讲的，函数声明中的 $(C const) 说明符表示函数不会修改其对象。)
)

$(P
属性函数让我们能像使用成员变量一样使用它：
)

---
    auto garden = Rectangle(10, 20);
    writeln("The area of the garden: ", garden$(HILITE .area));
---

$(P
$(C area) 是由矩形的长宽相乘计算得到的，所以这次它将始终与长宽保持一致：
)

$(SHELL
The area of the garden: 200
)

$(H5 写属性)

$(P
和 slices 的 $(C length) 属性一样，用户定义的属性也可以用于赋值：
)

---
    garden.area = 50;
---

$(P
改变矩形面积时也要将长和宽修改为对应的值。为了能够提供这样的功能，我们假设矩形的边长是$(I 可变的)。这样这个矩形就保持恒等式“长 × 宽 == 面积”成立。
)

$(P
只需你将函数命名为 $(C area) 并将其标记为 $(C @property)，你就能够使用赋值语法调用它。等号右侧的值将作为函数唯一的参数传入函数。
)

$(P
下面新增的 $(C area()) 让我们可以对 $(C area) 使用赋值运算符，而且对它赋值的确会改变 $(C Rectangle) 对象的面积：
)

---
import std.stdio;
import std.math;

struct Rectangle {
    double width;
    double height;

    double area() const @property {
        return width * height;
    }

    $(HILITE void area(double newArea) @property) {
        auto scale = sqrt(newArea / area);

        width *= scale;
        height *= scale;
    }
}

void main() {
    auto garden = Rectangle(10, 20);
    writeln("The area of the garden: ", garden.area);

    $(HILITE garden.area = 50);

    writefln("New state: %s x %s = %s",
             garden.width, garden.height, garden.area);
}
---

$(P
新增的属性函数利用 $(C std.math) 模块中的 $(C sqrt) 函数来开平方根。如果长和宽都是面积的平方根，那它们的乘积就一定是我们指定的面积。
)

$(P
对这个版本的 $(C area) 赋值时矩形两边的长度都会改变：
)

$(SHELL
The area of the garden: 200
New state: 5 x 10 = 50
)

$(H5 属性不是唯一的解决方案)

$(P
之前我们通过定义属性为 $(C Rectangle) 添加了“第三个变量”。当然，除了属性普通，成员函数也可以实现我们需要的功能：
)

---
import std.stdio;
import std.math;

struct Rectangle {
    double width;
    double height;

    double $(HILITE area()) const {
        return width * height;
    }

    void $(HILITE setArea(double newArea)) {
        auto scale = sqrt(newArea / area);

        width *= scale;
        height *= scale;
    }
}

void main() {
    auto garden = Rectangle(10, 20);
    writeln("The area of the garden: ", garden$(HILITE .area()));

    garden$(HILITE .setArea(50));

    writefln("New state: %s x %s = %s",
             garden.width, garden.height, garden$(HILITE .area()));
}
---

$(P
就像我们在 $(LINK2 /ders/d.cn/function_overloading.html, 函数重载) 一章中提到过的，这两个函数可以有相同的名字。
)

---
    double area() const {
        // ...
    }

    void area(double newArea) {
        // ...
    }
---

$(H5 何时使用属性)

$(P
并没有一种简单的方法能帮你快速在常规成员函数和属性间做出选择。有时常规成员函数更加自然，有时属性更加简洁。
)

$(P
我们曾在 $(LINK2 /ders/d.cn/encapsulation.html, 封装和访问控制) 一章中告诉过你：限制外部代码对成员变量的访问是非常重要的。允许外部代码随意修改成员变量可能会对将来的维护工作造成极大的不便。所以，我们最好将对成员变量的访问封装在常规成员函数或属性函数中。
)

$(P
像 $(C width) 和 $(C height) 简单类型的成员变量，$(C public) 访问权限也是可以接受的。但最好还是使用属性函数包装：
)

---
struct Rectangle {
$(HILITE private:)

    double width_;
    double height_;

public:

    double area() const @property {
        return width * height;
    }

    void area(double newArea) @property {
        auto scale = sqrt(newArea / area);

        width_ *= scale;
        height_ *= scale;
    }

    double $(HILITE width()) const @property {
        return width_;
    }

    double $(HILITE height()) const @property {
        return height_;
    }
}
---

$(P
现在成员变量被封装为 $(C private)，所以只有与之相关联的属性函数可以访问它。
)

$(P
注意不要混淆了变量和函数的名字：成员变量的名字多了一个 $(C _)。在面向对象编程中，$(I 修饰)变量名是十分常用的技巧。
)

$(P
$(C Rectangle) 的定义依旧存在 $(C width) 和 $(C height)，它们也依旧表现的像是成员变量。
)

---
    auto garden = Rectangle(10, 20);
    writefln("width: %s, height: %s",
             garden$(HILITE .width), garden$(HILITE .height));
---

$(P
如果成员变量没有写属性，那在对象外部看来它将是只读的：
)

---
    garden.width = 100;    $(DERLEME_HATASI)
---

$(P
对成员变量的写入控制也是非常重要的。只有 $(C Rectangle) 的成员函数能修改成员变量可以保证对象的一致性。
)

$(P
如果将来的某一天这个成员变量需要在外部修改，那我们仅需为其添加一个属性函数。
)

Macros:
        SUBTITLE=属性

        DESCRIPTION=像访问成员变量一样调用成员函数

        KEYWORDS=D 编程语言教程 属性
