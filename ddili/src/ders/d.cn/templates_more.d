Ddoc

$(DERS_BOLUMU $(IX template) 模板拓展)

$(P
我们已经在 $(LINK2 /ders/d.cn/templates.html, 模板) 一章中看到了模板的强大与便捷。将算法或数据结构定义为单一模板即可将其运用于多种类型。
)

$(P
那一章只涵盖了几种最通用的模板使用：以类型作为模板参数的函数、$(C struct) 与 $(C class) 模板。在本章中我们将看到有关模板的更多细节。在继续之前，建议你至少先复习一下那一章的小结部分。
)

$(H5 $(IX 快捷语法, template) 快捷语法)

$(P
D 模板不仅强大，而且还易于定义与阅读。定义一个函数、$(C struct) 或 $(C class) 模板简单到只需提供一个模板参数列表：
)

---
T twice$(HILITE (T))(T value) {
    return 2 * value;
}

class Fraction$(HILITE (T)) {
    T numerator;
    T denominator;

    // ...
}
---

$(P
像上面这样的模板定义是利用了 D 的快捷模板语法。
)

$(P
在它们的完整语法中，模板是由 $(C template) 关键字定义的。下面是与上面两个等价的模板定义：
)

---
template twice$(HILITE (T)) {
    T twice(T value) {
        return 2 * value;
    }
}

template Fraction$(HILITE (T)) {
    class Fraction {
        T numerator;
        T denominator;

        // ...
    }
}
---

$(P
尽管几乎所有的模板都是以快捷语法定义的，但是编译器却总是会使用完整语法。可以想象，编译器在幕后应用以下步骤来将一个快捷语法的定义转为完整形式：
)

$(OL
$(LI 用一个 template 语句块包裹该定义。)
$(LI 用相同的名称命名该语句块。)
$(LI 将模板参数列表移到 template 语句块上。)
)

$(P
这些步骤执行后所达到的完整语法叫做$(I 同名模板)，它也可以由程序员明确定义。我们稍后将在下面看见同名模板。
)

$(H6 $(IX 命名空间, template) 模板命名空间)

$(P
一个模板语句块内可以有多个定义。如下的模板同时包含了函数与 $(C struct) 定义：
)

---
template MyTemplate(T) {
    T foo(T value) {
        return value / 3;
    }

    struct S {
        T member;
    }
}
---

$(P
用一个特定的类型实例化该模板就实例化了语句块内的所有定义。如下代码以 $(C int) 和 $(C double) 实例化该模板：
)

---
    auto result = $(HILITE MyTemplate!int).foo(42);
    writeln(result);

    auto s = $(HILITE MyTemplate!double).S(5.6);
    writeln(s.member);
---

$(P
模板的一个特定实例引入了一个$(I 命名空间)。使用这个名称可以调用该实例内部的定义。然而，若合起来的名称太长，那么可以像在 $(LINK2 /ders/d.cn/alias.html, $(C alias)) 一章中所见的那样使用别名：
)

---
    alias MyStruct = MyTemplate!dchar.S;

// ...

    auto o = $(HILITE MyStruct)('a');
    writeln(o.member);
---

$(H6 $(IX 同名模板) 同名模板)

$(P
同名模板是包含一个与语句块同名的定义的 $(C template) 语句块。事实上，每一个快捷模板语法都是一个同名模板的快捷方式。
)

$(P
举例来说，假设一个程序需要将大于 20 byte 的类型判定为$(I 太大了)（too large)。这样的判定可以借一个模板中的 $(C bool) 常数来达到：
)

---
template isTooLarge(T) {
    enum isTooLarge = T.sizeof > 20;
}
---

$(P
注意 template 语句块与其中的唯一定义的名称是一样的。这个同名模板调用时使用的是快捷语法，而非完整的 $(C isTooLarge!int.isTooLarge)：
)

---
    writeln($(HILITE isTooLarge!int));
---

$(P
上面高亮的部分与语句块内部的 $(C bool) 值是一样的。由于 $(C int) 的大小小于 20，该代码的输出应是 $(C false)。
)

$(P
该同名模板亦可以使用如下的快捷语法定义：
)

---
enum isTooLarge$(HILITE (T)) = T.sizeof > 20;
---

$(P
同名模板的常见用途是根据特定的条件定义类型别名。例如，如下同名模板以定义别名的方式在两个类型中选出较大的那个：
)

---
$(CODE_NAME LargerOf)template LargerOf(A, B) {
    static if (A.sizeof < B.sizeof) {
        alias LargerOf = B;

    } else {
        alias LargerOf = A;
    }
}
---

$(P
由于 $(C long) 比 $(C int) 大（8 byte 比之 4 byte），$(C LargerOf!(int, long)) 应与 $(C long) 为同一个类型。这样的模板在其他将这两个类型作为其本身参数的模板中十分有用：
)

---
$(CODE_XREF LargerOf)// ...

/* 该函数的返回类型是它两个模板参数中大的那个：
 * 不是 A 就是 B。 */
auto calculate(A, B)(A a, B b) {
    $(HILITE LargerOf!(A, B)) result;
    // ...
    return result;
}

void main() {
    auto f = calculate(1, 2$(HILITE L));
    static assert(is (typeof(f) == $(HILITE long)));
}
---

$(H5 模板的种类)

$(H6 函数、class、struct 模板)

$(P
在 $(LINK2 /ders/d.cn/templates.html, 模板) 一章中，我们已经涵盖了函数、$(C class) 与 $(C struct) 模板，打那时开始我们就见到了许多相关的示例。
)

$(H6 $(IX 成员函数模板) 成员函数模板)

$(P
$(C struct) 和 $(C class) 成员函数同样可以是模板。例如，如下的 $(C put()) 成员函数模板适用于任何兼容该模板内操作的类型（针对这个特定的模板，该类型应能转换为 $(C string)）：
)

---
class Sink {
    string content;

    void put$(HILITE (T))(auto ref const T value) {
        import std.conv;
        content ~= value.to!string;
    }
}
---

$(P
然而，由于模板潜在具有无穷多的实例，它们不能成为 $(LINK2 /ders/d.cn/inheritance.html, 虚函数)，因为编译器不知道要在界面中包含哪个特定的模板实例。（由是，同样也不能使用 $(C abstract) 关键字了。）
)

$(P
例如，尽管如下派生类中 $(C put()) 模板的存在或将给人以重载的印象，但实际上它隐藏了父类中的 $(C put) 名称（详见 $$(LINK2 /ders/d.cn/alias.html, 别名) 一章中的(I 名字隐藏)）：
)

---
class Sink {
    string content;

    void put(T)(auto ref const T value) {
        import std.conv;
        content ~= value.to!string;
    }
}

class SpecialSink : Sink {
    /* 如下的模板定义没有重载基类中的模板实例；
     * 它隐藏了那些名称。 */
    void put(T)(auto ref const T value) {
        import std.string;
        super.put(format("{%s}", value));
    }
}

void fillSink($(HILITE Sink) sink) {
    /* 如下的函数调用不是虚的。因为
     * 参数'sink'的类型是'Sink'，这些调用将
     * 总是解析为 Sink 的'put'模板实例。 */

    sink.put(42);
    sink.put("hello");
}

void main() {
    auto sink = new $(HILITE SpecialSink)();
    fillSink(sink);

    import std.stdio;
    writeln(sink.content);
}
---

$(P
因此，尽管这个对象实际上是一 $(C SpecialSink)，在 $(C fillSink()) 的两处调用都解析到了 $(C Sink) 且内容都不包括 $(C SpecialSink.put()) 会加入的花括号：
)

$(SHELL
42hello    $(SHELL_NOTE Sink 的行为，而不是 SpecialSink 的)
)

$(H6 $(IX union 模板) union 模板)

$(P
union 模板类似于 struct 模板。快捷语法也同样适用于它们。
)

$(P
举例来说，让我们为在 $(LINK2 /ders/d.cn/union.html, union) 一章中曾见到的 $(C IpAdress) $(C union) 设计一个更加通用的版本。在那章中，IPv4 地址的值是早先版本 $(C IpAddress) 的一个 $(C uint) 成员，且分段数组的元素类型为 $(C ubyte)：
)

---
union IpAddress {
    uint value;
    ubyte[4] bytes;
}
---

$(P
$(C bytes) 数组提供了对 IPv4 地址四个分段的便捷访问。
)

$(P
同样的概念能像如下 union 模板一样成为一个更通用的实现：
)

---
union SegmentedValue($(HILITE ActualT, SegmentT)) {
    ActualT value;
    SegmentT[/* number of segments */] segments;
}
---

$(P
这个模板允许自由地指定其值与分段的类型。
)

$(P
所需的分段个数是由值与分段的真正类型所决定的。由于一个 IPv4 地址有四个 $(C ubyte) 分段，分段个数在早先版本 $(C IpAddress) 中被编码为 $(C 4)。对于 $(C SegmentedValue) 模板，一旦模板被两个特定的类型实例化，其分段个数必须在编译时计算得出
)

$(P
如下的同名模板利用两个类型的 $(C .sizeof) property 来计算所需的分段数量：
)

---
$(CODE_NAME segmentCount)template segmentCount(ActualT, SegmentT) {
    enum segmentCount = ((ActualT.sizeof + (SegmentT.sizeof - 1))
                         / SegmentT.sizeof);
}
---

$(P
它的快捷语法的可读性或许更高一些：
)

---
enum segmentCount(ActualT, SegmentT) =
    ((ActualT.sizeof + (SegmentT.sizeof - 1))
     / SegmentT.sizeof);
---

$(P
$(I $(B 注：)表达式 $(C SegmentT.sizeof - 1) 是为类型大小不能整除的情况所做的设置。例如，当实际类型是 5 字节而分段类型是 2 字节时，总共需要 3 个分段，但此时整数除法 5/2 的结果却错误地是 2。)
)

$(P
union 模板的定义现在就完整了：
)

---
$(CODE_NAME SegmentedValue)$(CODE_XREF segmentCount)union SegmentedValue(ActualT, SegmentT) {
    ActualT value;
    SegmentT[segmentCount!(ActualT, SegmentT)] segments;
}
---

$(P
该模板对于 $(C uint) 与 $(C ubyte) 的实例应与早先 $(C IpAddress) 的定义相等价：
)

---
$(CODE_XREF SegmentedValue)import std.stdio;

void main() {
    auto address = SegmentedValue!($(HILITE uint, ubyte))(0xc0a80102);

    foreach (octet; address.segments) {
        write(octet, ' ');
    }
}
---

$(P
该程序的输出与其在 $(LINK2 /ders/d.cn/union.html, 模板) 一章中的输出应是一样的：
)

$(SHELL_SMALL
2 1 168 192
)

$(P
为了展现这个模板的灵活性，假设需要以两个 $(C ushort) 值对该 IPv4 地址的进行访问。这简单到只需要将 $(C ushort) 设置为分段类型：
)

---
    auto address = SegmentedValue!(uint, $(HILITE ushort))(0xc0a80102);
---

$(P
尽管这对于 IPv4 地址来说不常用，程序输出确实包含了两个 $(C ushort) 分段值：
)

$(SHELL_SMALL
258 49320
)

$(H6 $(IX interface 模板) interface 模板)

$(P
interface 模板提供了用于其中的类型灵活性（以及像静态数组的长度值、interface 的其他功能等等）。
)

$(P
让我们定义一个有色对象，颜色的类型取决于模板参数：
)

---
interface ColoredObject(ColorT) {
    void paint(ColorT color);
}
---

$(P
这个 interface 模板规定了它的派生类型必须定义函数 $(C paint())，但同时它又没有指定颜色的类型。
)

$(P
一个表示网页框架的 class 或会选择使用一个以红、绿、蓝组成的颜色类型：
)

---
struct RGB {
    ubyte red;
    ubyte green;
    ubyte blue;
}

class PageFrame : ColoredObject$(HILITE !RGB) {
    void paint(RGB color) {
        // ...
    }
}
---

$(P
而另一边，一个使用光频率的 class 能选择一个完全不同的类型来表示颜色：
)

---
alias Frequency = double;

class Bulb : ColoredObject$(HILITE !Frequency) {
    void paint(Frequency color) {
        // ...
    }
}
---

$(P
然而，如在 $(LINK2 /ders/d.cn/templates.html, 模板) 一章中所说的一样，“模板的每一个不同实例都是一个不同的类型”。依此，$(C ColoredObject!RGB) 与 $(C ColoredObject!Frequency) 是不相关的 interface，同时 $(C PageFrame) 与 $(C Bulb) 也是不相关的 class。
)

$(H5 $(IX 参数, template) 模板参数的种类)

$(P
到现在为止，我们所见到的模板参数都是$(I 类型)。到现在为止，参数诸如 $(C T) 与 $(C ColorT) 都表示的是类型。例如，$(C T) 根据该模板的不同实例，分别表示 $(C int)、$(C double) 或 $(C Student) 等等。
)

$(P
存在其他种类的模板参数：值、$(C this)、$(C alias) 以及元组。
)

$(H6 $(IX 类型模板参数) 类型模板参数)

$(P
这一部分只是出于完整性而出现。我们至今为止见到的所有模板都拥有类型参数。
)

$(H6 $(IX 值模板参数) 值模板参数)

$(P
值模板参数允许了在模板实现中使用特定灵活的值。
)

$(P
由于模板是编译期特性，值模板参数中的值必须在编译时就能确定；而不能使用必须在运行时进行计算的值。
)

$(P
为了体现值模板参数的优势，让我们从用以表示几何图形的一系列 struct 开始：
)

---
struct Triangle {
    Point[3] corners;
// ...
}

struct Rectangle {
    Point[4] corners;
// ...
}

struct Pentagon {
    Point[5] corners;
// ...
}
---

$(P
假设这些类型的其他成员变量与成员函数是完全相同的，唯一的区别仅仅是表示边个数的$(I 值)。
)

$(P
值模板参数有助于此类情况。如下的 struct 模板就足以表示上面所有的类型以及更多此类类型：
)

---
struct Polygon$(HILITE (size_t N)) {
    Point[N] corners;
// ...
}
---

$(P
这个 struct 模板仅有的模板参数为一个名为 $(C N) 的 $(C size_t) 值。值 $(C N) 能被用作一个模板内部的编译期常数。
)

$(P
这个模板足以表示任何边数的多边形：
)

---
    auto centagon = Polygon!100();
---

$(P
如下的别名与之前的 struct 定义一一对应：
)

---
alias Triangle = Polygon!3;
alias Rectangle = Polygon!4;
alias Pentagon = Polygon!5;

// ...

    auto triangle = Triangle();
    auto rectangle = Rectangle();
    auto pentagon = Pentagon();
---

$(P
上述模板参数$(I 值)类型为 $(C size_t)。只要该值可以在编译时确定，一个模板参数值可以是任何类型：基本类型、struct 类型、数组、string 等等。
)

---
struct S {
    int i;
}

// struct S 类型的模板参数值
void foo($(HILITE S s))() {
    // ...
}

void main() {
    foo!(S(42))();    // 用字面量 S(42) 进行实例化
}
---

$(P
如下的例子用了一个 $(C string) 模板参数来表示一个 XML 标签以生成一个简单的 XML 输出：
)

$(UL
$(LI 首先是在 $(C &lt;)&nbsp;$(C &gt;) 字符之间的标签：$(C &lt;tag&gt;))
$(LI 然后是值)
$(LI 最后是在 $(C &lt;/)&nbsp;$(C &gt;) 字符之间的标签：$(C &lt;/tag&gt;))
)

$(P
例如，一个表示 $(I location 42) 的 XML 标签应被输出为 $(C &lt;location&gt;42&lt;/location&gt;)。
)

---
$(CODE_NAME XmlElement)import std.string;

class XmlElement$(HILITE (string tag)) {
    double value;

    this(double value) {
        this.value = value;
    }

    override string toString() const {
        return format("<%s>%s</%s>", tag, value, tag);
    }
}
---

$(P
注意该模板参数不再是一个模板实现中的类型，它是一个 $(C string) $(I 值)。这个值能作为一个 $(C string) 被用于模板内部的任何位置。
)

$(P
程序所需的 XML 元素能想如下代码中一样被定义为别名：
)

---
$(CODE_XREF XmlElement)alias Location = XmlElement!"location";
alias Temperature = XmlElement!"temperature";
alias Weight = XmlElement!"weight";

void main() {
    Object[] elements;

    elements ~= new Location(1);
    elements ~= new Temperature(23);
    elements ~= new Weight(78);

    writeln(elements);
}
---

$(P
输出为：
)

$(SHELL_SMALL
[&lt;location&gt;1&lt;/location&gt;, &lt;temperature&gt;23&lt;/temperature&gt;, &lt;weight&gt;78&lt;/weight&gt;]
)

$(P
模板参数值同样可以拥有默认值。例如，如下表示多维空间中点的 struct 模板中维度数量的默认值为 3：
)

---
struct Point(T, size_t dimension $(HILITE = 3)) {
    T[dimension] coordinates;
}
---

$(P
不指定 $(C dimension) 模板参数时该模板同样可以使用：
)

---
    Point!double center;    // 一个三维空间中的点
---

$(P
当需要时依然可以指定维度数量：
)

---
    Point!(int, 2) point;   // 一个平面中的点
---

$(P
我们已经在 $(LINK2 /ders/d.cn/parameter_flexibility.html, 变参) 一章中了解到$(特殊关键字)能根据它们在代码或函数默认值中的出现产生不同的效果。
)

$(P
相似的是，当作为模板默认参数时，这些特殊关键字将指向模板实例化的位置，而非关键字出现的位置：
)

---
import std.stdio;

void func(T,
          string functionName = $(HILITE __FUNCTION__),
          string file = $(HILITE __FILE__),
          size_t line = $(HILITE __LINE__))(T parameter) {
    writefln("Instantiated at function %s at file %s, line %s.",
             functionName, file, line);
}

void main() {
    func(42);    $(CODE_NOTE $(HILITE line 14))
}
---

$(P
尽管这些特殊关键字出现于模板的定义之中，它们的值指向的是 $(C main())，也就是该模板实例化的位置：
)

$(SHELL
Instantiated at function deneme.$(HILITE main) at file deneme.d, $(HILITE line 14).
)

$(P
我们将在下面的多维操作符重载示例中使用 $(C __FUNCTION__)。
)

$(H6 $(IX this, 模板参数) 成员函数的 $(C this) 模板参数)

$(P
成员函数也能是模板。他们的模板参数的意义与在其他模板中的相同。
)

$(P
然而，不像其他模板，成员函数模板参数还能是 $(I $(C this) 参数)。在此时，$(C this) 关键字之后的 identifier 表示 $(C this) 引用的准确类型。（$(I $(C this) 引用)表示该对象自身，就像常常在构建函数中写为的 $(C this.member&nbsp;=&nbsp;value) 一样。）
)

---
struct MyStruct(T) {
    void foo($(HILITE this OwnType))() const {
        writeln("Type of this object: ", OwnType.stringof);
    }
}
---

$(P
$(C OwnType) 模板参数是调用该成员函数的对象的实际类型：
)

---
    auto m = MyStruct!int();
    auto c = const(MyStruct!int)();
    auto i = immutable(MyStruct!int)();

    m.foo();
    c.foo();
    i.foo();
---

$(P
输出为：
)

$(SHELL_SMALL
Type of this object: MyStruct!int
Type of this object: const(MyStruct!int)
Type of this object: immutable(MyStruct!int)
)

$(P
就像看到的一样，这个类型不仅包括了 $(C T) 对应的类型，还包含了诸如 $(C const) 与 $(C immutable) 之类的类型限定符。
)

$(P
$(C struct)（或是 $(C class)）不一定要是模板。$(C this) 模板参数同样能在非模板类型的成员函数模板中出现。
)

$(P
$(C this) 模板参数也能在 $(I mixin template) 中起作用，这我们将在之后的两章中见到。
)

$(H6 $(IX alias, 模板参数) $(C alias) 模板参数)

$(P
$(C alias) 模板参数可以对应程序中使用的任何符号或表达式。这种模板参数唯一的限制是该参数必须与它在模板中的使用相兼容。
)

$(P
$(C filter()) 与 $(C map()) 使用 $(C alias) 模板参数来确定它们需要执行的操作。
)

$(P
这是一个简单示例，它使用一个 $(C struct) 模板来修改一个已存在的变量。该 $(C struct) 模板以 $(C alias) 参数的形式接受变量：
)

---
struct MyStruct(alias variable) {
    void set(int value) {
        variable = value;
    }
}
---

$(P
该成员函数简单地将参数赋值于该 $(C struct) 模板实例化所用的变量。这个变量需在模板实例化时进行指定：
)

---
    int x = 1;
    int y = 2;

    auto object = MyStruct!$(HILITE x)();
    object.set(10);
    writeln("x: ", x, ", y: ", y);
---

$(P
在这个实例中，$(C variable) 模板参数对应着变量 $(C x)：
)

$(SHELL_SMALL
x: $(HILITE 10), y: 2
)

$(P
相对地，该模板的 $(C MyStruct!y) 实例就应将 $(C variable) 与 $(C y) 相关联。
)

$(P
现在让我们使 $(C alias) 参数表示一个可调用的实体，这与 $(C filter()) 及 $(C map()) 相似：
)

---
void caller(alias func)() {
    write("calling: ");
    $(HILITE func());
}
---

$(P
从 $(C ()) 括号上可以看出，$(C caller()) 将其模板参数视为了一个函数。进一步来说，由于括号是空的，该函数必须能够在不指定任何参数时进行调用。
)

$(P
设计如下两个满足该描述的函数。它们都表现为 $(C func)，这是由于它们都是作为 $(C func()) 在模板中进行调用的：
)

---
void foo() {
    writeln("foo called.");
}

void bar() {
    writeln("bar called.");
}
---

$(P
这些函数可以作为 $(C caller()) 的 $(C alias) 参数：
)

---
    caller!foo();
    caller!bar();
---

$(P
输出为：
)

$(SHELL_SMALL
calling: foo called.
calling: bar called.
)

$(P
只要它与它在模板中的用法相匹配，任何符号都能用作 $(C alias) 模板参数。反例为，在 $(C caller()) 中使用 $(C int) 变量将导致一个编译错误：
)

---
    int variable;
    caller!variable();    $(DERLEME_HATASI)
---

$(P
这个编译错误表示该变量不匹配它在模板中的使用：
)

$(SHELL_SMALL
Error: $(HILITE function expected before ()), not variable of type int
)

$(P
尽管这个错误是伴随着 $(C caller!variable) 实例化发生的，该编译错误必要地指向了 $(C caller()) 模板内部的 $(C func())，这是因为从编译器的角度来看，这个错误是由尝试像函数一样调用 $(C variable)。解决这个问题的一种途径是使用$(I 模板约束)，这将在下面陈述。
)

$(P
若这个变量支持函数调用语法，或是因为它定义了 $(C opCall())、或是因为它是一个函数字面量，那么它将仍旧适用于该 $(C caller()) 模板。如下的示例演示了这两种情况：
)

---
class C {
    void opCall() {
        writeln("C.opCall called.");
    }
}

// ...

    auto o = new C();
    caller!o();

    caller!({ writeln("Function literal called."); })();
---

$(P
输出为：
)

$(SHELL
calling: C.opCall called.
calling: Function literal called.
)

$(P
$(C alias) 参数同样可以进行特化。然而它们拥有一种不同的特化语法。特化类型必须指定于 $(C alias) 关键字与参数名称之间：
)

---
import std.stdio;

void foo(alias variable)() {
    writefln("The general definition is using '%s' of type %s.",
             variable.stringof, typeof(variable).stringof);
}

void foo(alias $(HILITE int) i)() {
    writefln("The int specialization is using '%s'.",
             i.stringof);
}

void foo(alias $(HILITE double) d)() {
    writefln("The double specialization is using '%s'.",
             d.stringof);
}

void main() {
    string name;
    foo!name();

    int count;
    foo!count();

    double length;
    foo!length();
}
---

$(P
同样需要注意的是 $(C alias) 参数使得实际的变量名也可以在模板内部进行访问：
)

$(SHELL
The general definition is using 'name' of type string.
The int specialization is using 'count'.
The double specialization is using 'length'.
)

$(H6 $(IX 元组模板参数) 元组模板参数)

$(P
我们已经在 $(LINK2 /ders/d.cn/parameter_flexibility.html, 变参) 一章中看到了可以接纳任何数量以及任何类型参数的可变参数函数。例如，$(C writeln()) 就能以任意数量的任意类型参数进行调用。
)

$(P
$(IX ..., 模板参数) $(IX 可变参数模板) 模板同样可以接受变参。一个包含一个尾随着 $(C ...) 的名称的模板参数在该位置允许了任何数量及类型的参数。这些参数在模板内部表现为一个元组，它能被用为一个 $(C AliasSeq)。
)

$(P
这是一个示例，一个简单地输出实例化所用的每一个参数信息的模板：
)

---
$(CODE_NAME info)void info(T...)(T args) {
    // ...
}
---

$(P
模板参数 $(C T...) 让 $(C info) 成为了一个$(I 可变参数模板)。$(C T) 与 $(C args) 均是元组：
)

$(UL
$(LI $(C T) 表示各参数的类型。)
$(LI $(C args) 表示各参数自身。)
)

$(P
如下的示例使用三个不同类型的值实例化这个函数模板：
)

---
$(CODE_XREF info)import std.stdio;

// ...

void main() {
    info($(HILITE 1, "abc", 2.3));
}
---

$(P
如下的实现简单地在一个 $(C foreach) 循环中分别输出各个参数的信息：
)

---
void info(T...)(T args) {
    // 'args' 被用作一个元组：
    foreach (i, arg; $(HILITE args)) {
        writefln("%s: %s argument %s",
                 i, typeof(arg).stringof, arg);
    }
}
---

$(P
输出为：
)

$(SHELL_SMALL
0: int argument 1
1: string argument abc
2: double argument 2.3
)

$(P
注意除了可以使用 $(C typeof(arg)) 获取每个参数的类型之外，也能使用 $(C T[i])。
)

$(P
我们知道，函数模板的模板参数可以自动推断。这是为什么编译器在之前的程序中能推断出诸如 $(C int)、$(C string) 和 $(C double) 之类的类型。
)

$(P
然而，显式地指定这些模板参数也是可以的。例如，$(C std.conv.to) 以显式模板参数的形式接受目标类型：
)

---
    to!$(HILITE string)(42);
---

$(P
当模板参数被显式指定时，它们可以是值、类型以及其他种类的混合体。这种灵活性使得确定每一个模板参数是否为类型成为必要，这样模板的主体才能依此进行编码。这可以借由将参数视为一个 $(C AliasSeq) 来达到。
)

$(P
这是一个关于此的示例，一个生成 $(C struct) 定义源代码文本的函数模板。这个函数将生成的源代码返回为一个 $(C string) 值。该函数先接纳 $(C struct) 的名称，接着是一对对其成员的类型与名称：
)

---
import std.stdio;

void $(CODE_DONT_TEST)main() {
    writeln(structDefinition!("Student",
                              string, "name",
                              int, "id",
                              int[], "grades")());
}
---

$(P
这个 $(C structDefinition) 实例应生成如下的 $(C string) 值：
)

$(SHELL
struct Student {
    string name;
    int id;
    int[] grades;
}
)

$(P
$(I $(B 注：)生成源代码的函数是用于 $(C mixin) 关键字的，这我们将在 $(LINK2 /ders/d.cn/mixin.html, 之后的一章) 中见到。)
)

$(P
如下是一个生成需要的输出的实现。注意该函数模板使用了 $(C is) 表达式。当 $(C arg) 是一个有效类型时表达式 $(C is&nbsp;(arg)) 生成 $(C true)：
)

---
import std.string;

string structDefinition(string name, $(HILITE Members)...)() {
    /* 保证成员是按对指定的：
     * 先是类型再是名称。 */
    static assert(($(HILITE Members).length % 2) == 0,
                  "Members must be specified as pairs.");

    /* struct 定义的第一部分。 */
    string result = "struct " ~ name ~ "\n{\n";

    foreach (i, arg; $(HILITE Members)) {
        static if (i % 2) {
            /* 奇数编号的参数应是成员
             * 的名称。与其在这里处理
             * 变量名，我们将在下面的
             * ‘else’中在以 Members[i+1] 使用它们。
             *
             * 最起码要确保成员名称指
             * 定为了一个 string 值。 */
            static assert(is (typeof(arg) == string),
                          "Member name " ~ arg.stringof ~
                          " is not a string.");

        } else {
            /* 在这种情况下，‘arg’是成员的
             * 类型。保证它确实是一个类型。 */
            static assert(is (arg),
                          arg.stringof ~ " is not a type.");

            /* 由它的类型与名称生成该成员
             * 的定义。
             *
             * 注：下面可以用‘arg’来代替
             * Members[i]。 */
            result ~= format("    %s %s;\n",
                             $(HILITE Members[i]).stringof, $(HILITE Members[i+1]));
        }
    }

    /* struct 定义的尾部花括号。 */
    result ~= "}";

    return result;
}

import std.stdio;

void main() {
    writeln(structDefinition!("Student",
                              string, "name",
                              int, "id",
                              int[], "grades")());
}
---

$(H5 $(IX typeof(this)) $(IX typeof(super)) $(IX typeof(return))$(C typeof(this))、$(C typeof(super))、以及 $(C typeof(return)))

$(P
在某些情况下，模板的动态的天性使得在模板中往往很难得知或确定特定的类型。如下的三个特殊的 $(C typeof) 变体在这种情况下非常有用。尽管它们是在本章中引入的，它们同样适用于非模板代码中。
)

$(UL

$(LI $(C typeof(this)) 生成 $(C this) 引用的类型。它适用于任何 $(C struct) 或 $(C class) 中，甚至是在成员函数之外的地方：

---
struct List(T) {
    // 当 T 是 int 时‘next’的类型是 List!int
    typeof(this) *next;
    // ...
}
---

)

$(LI $(C typeof(super)) 生成 $(C class) 的基类型（即 $(C super) 的类型）

---
class ListImpl(T) {
    // ...
}

class List(T) : ListImpl!T {
    // 当 T 是 int 时‘next’的类型是 ListImpl!int
    typeof(super) *next;
    // ...
}
---

)

$(LI $(C typeof(return)) 在函数内部生成该函数的返回值类型。

$(P
举例而言，与其将上面的 $(C calculate()) 函数定义为一个 $(C auto) 函数，我们可以在其定义中用 $(C LargerOf!(A, B)) 来代替 $(C auto)。（变得更显式至少可以避免它一部分的函数备注。）
)

---
$(HILITE LargerOf!(A, B)) calculate(A, B)(A a, B b) {
    // ...
}
---

$(P
$(C typeof(return)) 避免了在函数体中不得不将返回类型重复多次的情况。
)

---
LargerOf!(A, B) calculate(A, B)(A a, B b) {
    $(HILITE typeof(return)) result;    // 这个类型不是 A 就是 B
    // ...
    return result;
}
---

)

)

$(H5 模板特化)

$(P
我们已经在 $(LINK2 /ders/d.cn/templates.html, 模板) 一章中见到了许多模板特化。就如同类型参数一样，其他种类的模板参数同样可以进行特化。如下模板同时具有通用定义以及它对于 0 的特化：
)

---
void foo(int value)() {
    // ……通用定义……
}

void foo(int value $(HILITE : 0))() {
    // ……针对零的特殊定义……
}
---

$(P
我们将在下面的$(元编程)部分中利用模板特化。
)

$(H5 $(IX 元编程) 元编程)

$(P
由于它们是有关代码生成的，模板是 D 语言高级特性之一。模板当然是生成代码的代码。写生成代码的代码叫做$(元编程)。
)

$(P
由于模板是编译时功能，一些常常在运行时进行的操作可以作为模板实例化在编译时完成。
)

$(P
($(I $(B 注：)编译时计算) （CTFE，即 Compile time function execution） $(I 是另一个达到同样目标的特性。我们将在之后的一章中看到 CTFE。))
)

$(P
在编译期$(I 执行)模板通常是基于模板的递归实例化的。
)

$(P
这是这个的一个示例，让我们先看一个计算从 0 到特定值的普通函数。例如，当它的参数是 4 时，这个函数应返回 0+1+2+3+4 的结果：
)

---
int sum(int last) {
    int result = 0;

    foreach (value; 0 .. last + 1) {
        result += value;
    }

    return result;
}
---

$(P
$(IX 递归) 这是一个该函数的迭代实现。同样的函数也能被实现为递归：
)

---
int sum(int last) {
    return (last == 0
            ? last
            : last + $(HILITE sum)(last - 1));
}
---

$(P
这个递归函数返回当前数与前一个总和的和。正如所见，这个函数以特殊对待 0 而终止了递归。
)

$(P
函数通常数运行时特性。寻常地，$(C sum()) 能在运行时执行：
)

---
    writeln(sum(4));
---

$(P
当在编译时需要其结果时，达到相同的计算的一种方法是定义一个函数模板。在这种情况下，该参数必须为一个模板参数，而不是一个函数参数：
)

---
// 警告：这是不正确的代码。
int sum($(HILITE int last))() {
    return (last == 0
            ? last
            : last + sum$(HILITE !(last - 1))());
}
---

$(P
这个函数模板以 $(C last - 1) 实例化自身，并尝试用递归再次计算它的和。然而，这个代码是错误的。
)

$(P
由于该三元操作符应被编译以在运行时执行，在编译时是没有终止递归的条件检查的：
)

---
    writeln(sum!4());    $(DERLEME_HATASI)
---

$(P
编译器发现模板实例将无限递归，于是它在任意次递归时进行终止：
)

$(SHELL_SMALL
Error: template instance deneme.sum!($(HILITE -296)) recursive expansion
)

$(P
想一想模板参数 4 与 -296 间的差值，那么就是说编译器默认于 300 处限制模板展开。
)

$(P
在元编程中，递归是由模板特化终止的。如下针对 0 的特化生成预期的结果：
)

---
$(CODE_NAME sum)// 通用定义
int sum(int last)() {
    return last + sum!(last - 1)();
}

// 针对零的特殊定义
int sum(int last $(HILITE : 0))() {
    return 0;
}
---

$(P
如下是一个测试 $(C sum()) 的程序：
)

---
$(CODE_XREF sum)import std.stdio;

void main() {
    writeln(sum!4());
}
---

$(P
现在该程序编译成功并生成 4+3+2+1+0 的结果：
)

$(SHELL_SMALL
10
)

$(P
这里很重要的一点是函数 $(C sum!4()) 是完全在编译时执行的。编译成的代码与以字面量 10 调用 $(C writeln()) 是等价的：
)

---
    writeln(10);         // 与 writeln(sum!4()) 等价
---

$(P
因此，编译成的代码是尽可能快及简单的。尽管 10 依旧计算自 4+3+2+1+0，但整个计算都发生在编译期。
)

$(P
前一个示例展现了元编程的好处之一：将运行时的操作移至了编译时。而在 D 中 CTFE 则避免了一些元编程的惯用语法。
)

$(H5 $(IX 多态性, 编译期) $(IX 编译期多态性) 编译期多态性)

$(P
在面向对象编程（OOP）中，多态性是由继承所达到的。例如，若一个函数接受一个 interface，它即接受继承于这个 interface 的任何 class 的对象。
)

$(P
让我们回忆一下早先之前一章中的一个示例：
)

---
import std.stdio;

interface SoundEmitter {
    string emitSound();
}

class Violin : SoundEmitter {
    string emitSound() {
        return "♩♪♪";
    }
}

class Bell : SoundEmitter {
    string emitSound() {
        return "ding";
    }
}

void useSoundEmittingObject($(HILITE SoundEmitter object)) {
    // ……一些操作……
    writeln(object.emitSound());
    // ……更多操作……
}

void main() {
    useSoundEmittingObject(new Violin);
    useSoundEmittingObject(new Bell);
}
---

$(P
$(C useSoundEmittingObject()) 得益于多态性。它接纳一个 $(C SoundEmitter)，因此它能被用于由这个 interface 所衍生的任何类型。
)

$(P
由于$(I 适用于任何类型)是模板的功能，它们亦能被看作是提供了某种多态性。作为一个编译期特性，这种模板提供的多态性叫做$(I 编译期多态性)。相对地，OOP 的多态性叫做$(I 运行时多态性)。
)

$(P
实际上，两者都不可以用于$(I 任何类型)，因为这些类型均必须满足特定的条件。
)

$(P
运行时多态性需要该类型实现一个特定的接口（interface）。
)

$(P
编译期多态性需要该类型与其在模板群中的使用相兼容。只要代码能够通过编译，这个模板参数就能够被用于该模板。（$(I $(B 注：)若需要，参数也必须满足模板约束。我们将在下面稍后看见模板约束。)）
)

$(P
例如，若 $(C useSoundEmittingObject()) 被实现为一个函数模板而不是一个函数，那么它将适用于任何支持 $(C object.emitSound()) 调用的类型：
)

---
void useSoundEmittingObject$(HILITE (T))(T object) {
    // ……一些操作……
    writeln(object.emitSound());
    // ……更多操作……
}

class Car {
    string emitSound() {
        return "honk honk";
    }
}

// ...

    useSoundEmittingObject(new Violin);
    useSoundEmittingObject(new Bell);
    useSoundEmittingObject(new Car);
---

$(P
注意尽管 $(C Car) 和其他任何类型都没有继承关系，代码仍将成功编译，并且每一个类型的 $(C emitSound()) 成员函数都得到了调用。
)

$(P
$(IX 鸭子类型) 编译期多态性又叫做$(I 鸭子类型)，一个幽默的词，强调着重行为强过本身类型。
)

$(H5 $(IX 代码膨胀) 代码膨胀)

$(P
对于每一个不同的类型参数、值参数……编译器生成的代码都不同。)

$(P
这种现象的原因可以借分别以 $(C int) 和 $(C double) 作为类型模板参数看出来。每一个类型需要经过不同种类的 CPU 寄存器。因此，同一个模板需要为不同的模板参数进行不同的编译。换而言之，编译器需要为一个模板的每一个实例生成不同的代码。
)

$(P
例如，若 $(C useSoundEmittingObject()) 被实现为一个模板，它应根据不同实例的个数被多次进行编译。
)

$(P
由于它造成了巨大的程序体积，该现象叫做$(I 代码膨胀)。尽管这对于大多数程序不是问题，它是一个模板必须了解的副作用。
)

$(P
相对地，$(C useSoundEmittingObject()) 的非模板版本将不会有任何代码重复。编译器将一次性地编译该函数并为所有类型的 $(C SoundEmitter) interface 执行相同的代码。在运行时多态性中，让相同的代码产生不同的效果是通过幕后的函数指针来达到的。尽管函数指针在运行时有轻微的消耗，在大多数程序中这种消耗并不明显。
)

$(P
由于代码膨胀与运行时多态性都对程序性能有所影响，对于特定的程序，究竟运行时多态性或编译时多态性是更好的途径，这是无法预先知晓的。
)

$(H5 $(IX 约束, template) $(IX 模板约束) 模板约束)

$(P
模板能被任何参数实例化，却不是每一个参数都能够兼容其在模板中的使用，这一点造成了不便。若一个模板参数不兼容于一个特定的模板，那么该不兼容性是在模板代码针对该参数的编译中检测到的。因此，该编译错误指向的是模板实现中的一行。
)

$(P
让我们借以一个不支持 $(C object.emitSound()) 调用的类型使用 $(C useSoundEmittingObject()) 来观察这一点：
)

---
class Cup {
    // ……并没有 emitSound()……
}

// ...

    useSoundEmittingObject(new Cup);   // ← 不兼容的类型
---

$(P
尽管按理说这个错误是由以一个不兼容的类型使用该模板引起的，这个编译错误指向的却是模板内部的一行：
)

---
void useSoundEmittingObject(T)(T object) {
    // ……一些操作……
    writeln(object.emitSound());    $(DERLEME_HATASI)
    // ……更多操作……
}
---

$(P
一个所不希望的后果是当该模板是第三方库模块的一部分时，编译错误将显示为该库内部的一个问题。
)

$(P
注意这个问题在界面中是不存在的：一个接纳 interface 的函数只能被一个实现了该界面的类型调用。尝试以其他类型调用这个函数将在调用方上导致一个错误。
)

$(P
模板约束是用来禁止不正确的模板实例的。它们被定义为紧接在模板体之前的一个 $(C if) 条件逻辑表达式。
)

---
void foo(T)()
        if (/* ……约束…… */) {
    // ...
}
---

$(P
仅当对于一个特定的实例其约束计算为 $(C true) 时模板定义才会被纳入编译器。否则，该模板定义对于该用途将被忽略。
)

$(P
由于模板是编译期特性，模板约束必须在编译时进行计算。我们在 $(LINK2 /ders/d.cn/is_expr.html, $(C is) 表达式) 一章中见到的 $(C is) 表达式常用于模板约束中。我们也将在下面的示例中使用 $(C is) 表达式。
)

$(H6 $(IX 单元素元组模板参数) $(IX 元组模板参数, 单元素) 单元素的元组参数)

$(P
有时一个模板的单个参数需要是类型、值或 $(C alias) 这些种类之一。这可以借长度为一的元组参数来实现：
)

---
template myTemplate(T...)
        $(HILITE if (T.length == 1)) {
    static if (is ($(HILITE T[0]))) {
        // 该单一参数是一个类型
        enum bool myTemplate = /* ... */;

    } else {
        // 该单一参数是其他种类的
        enum bool myTemplate = /* ... */;
    }
}
---

$(P
$(C std.traits) 模块中的一些模板利用了这个惯用语法。我们将在之后的一章中见到 $(C std.traits)。
)

$(H6 $(IX 命名模板约束) 命名约束)

$(P
有时约束会十分复杂，这使得模板参数的需求变得难以理解。这种复杂性可以由将约束高效命名的惯用语法来处理。该惯用语法合并了 D 语言的四个特性：匿名函数、$(C typeof)、$(C is) 表达式、以及同名模板。
)

$(P
这一点可以借一个拥有一个类型参数的函数模板看出。该模板用几种特定的方式使用了它的函数参数：
)

---
void use(T)(T object) {
    // ...
    object.prepare();
    // ...
    object.fly(42);
    // ...
    object.land();
    // ...
}
---

$(P
从模板实现中可以明显看出，这个函数能工作的类型必须支持该对象之上的三个特定函数调用：$(C prepare())、$(C fly(42))、及 $(C land())。
)

$(P
对于该类型指定模板约束的一种方式是对每一个模板内的函数调用使用 $(C is) 与 $(C typeof) 表达式：
)

---
void use(T)(T object)
        if (is (typeof(object.prepare())) &&
            is (typeof(object.fly(1))) &&
            is (typeof(object.land()))) {
    // ...
}
---

$(P
我将在下面解释这种语法。而现在，请先接受 $(C is&nbsp;(typeof(object.prepare()))) 一并表示$(I 该类型是否支持调用 $(C .prepare()))。
)

$(P
尽管这样的约束达到了预期目标，有时这读起来太过繁琐。取而代之，给予整个约束一个自描述的名称是可能的：
)

---
void use(T)(T object)
        if (canFlyAndLand!T) {
    // ...
}
---

$(P
这个约束更可读，因为它更明确地表示了该模板适用于$(I 既能飞（fly）又能降落（land）)的类型。
)

$(P
这样的约束是由像如下同名模板一样实现的惯用语法达到的：
)

---
template canFlyAndLand(T) {
    enum canFlyAndLand = is (typeof(
    {
        T object;
        object.prepare();  // 应能准备飞行
        object.fly(1);     // 应能飞一段特定的距离
        object.land();     // 应能降落
    }()));
}
---

$(P
在这个惯用语法中的 D 语言特性与它们之间的影响有如下解析：
)

---
template canFlyAndLand(T) {
    //        (6)        (5)  (4)
    enum canFlyAndLand = is (typeof(
    $(HILITE {) // (1)
        T object;         // (2)
        object.prepare();
        object.fly(1);
        object.land();
 // (3)
    $(HILITE })()));
}
---

$(OL

$(LI $(B 匿名函数：)我们已经在 $(LINK2 /ders/d.cn/lambda.html, 函数指针、代理与 lambda) 一章中见过了匿名函数。上面高亮出的一对花括号定义了一个匿名函数。
)

$(LI $(B 函数语句块：)函数语句块内使用了应在真正模板中使用的类型。首先，该类型的一个对象（object）被定义，并接着由几种特定的方式使用。（这些代码将永远不会被执行；见下文）
)

$(LI $(B 函数调用：)在匿名函数末尾的空括号在正常情况下执行该函数。然而，由于这个调用语法是在 $(C typeof) 内的，它永远不会被执行。
)

$(LI $(IX typeof) $(B $(C typeof) 表达式：)$(C typeof) 提供表达式的类型。

$(P
关于 $(C typeof) 很重要的一个事实是它从来不会执行该表达式。相反，它产生$(I 若)该表达式被执行应得出的类型：
)

---
    int i = 42;
    typeof(++i) j;    // 与‘int j;’一样

    assert(i == 42);  // ++i 没有被执行
---

$(P
就像前一个 $(C assert) 所证实的那样，表达式 $(C ++i) 并未被执行。$(C typeof) 只是得出了该表达式的类型为 $(C int)。
)

$(P
若 $(C typeof) 接受的是一个不正确的表达式，那么 $(C typeof) 完全不产生任何类型（甚至不是 $(C void)）。所以，若在 $(C canFlyAndLand) 内部的匿名函数能为 $(C T) 编译成功，那么 $(C typeof) 即产生一个有效的类型。否则，它将不产生任何类型。
)

)

$(LI $(B $(C is) 表达式：)我们已经在 $(LINK2 /ders/d.cn/is_expr.html, $(C is) 表达式) 一章中看到了很多 $(C is) 表达式的用途。语法 $(C is&nbsp;($(I Type))) 在 $(C Type) 有效时得出 $(C true)：

---
    int i;
    writeln(is (typeof(i)));                  // true
    writeln(is (typeof(nonexistentSymbol)));  // false
---

$(P
尽管上面的第二个 $(C typeof) 收到了一个不存在（nonexistent）的符号（symbol），编译器却不触发一个编译错误。相反，其影响是该 $(C typeof) 表达式不产生任何类型，因此这个 $(C is) 表达式得出 $(C false)：
)

$(SHELL_SMALL
true
false
)

)

$(LI $(B 同名模板：)就如同上面描述的一样，由于 $(C canFlyAndLand) 模板包含一个同名的定义，该模板的实例就是该定义自身。
)

)

$(P
在最后，$(C use()) 得到了一个更描述性的约束：
)

---
void use(T)(T object)
        if (canFlyAndLand!T) {
    // ...
}
---

$(P
让我们尝试以两个使用该模板，一个是符合该约束的，而另一个却不是：
)

---
// 一个与模板操作相匹配的类型
class ModelAirplane {
    void prepare() {
    }

    void fly(int distance) {
    }

    void land() {
    }
}

// 一个不与模板操作相匹配的类型
class Pigeon {
    void fly(int distance) {
    }
}

// ...

    use(new ModelAirplane);    // ← 通过编译
    use(new Pigeon);           $(DERLEME_HATASI)
---

$(P
不论命名与否，由于该模板拥有一个约束，其编译错误指向的是使用模板的那一行而不是它的实现之处。
)

$(H5 $(IX 重载, 操作符) $(IX 多维操作符重载) $(IX 操作符重载, 多维) 在多维操作符重载中使用模板)

$(P
我们已经在 $(LINK2 /ders/d.cn/operator_overloading.html, 操作符重载) 一章中看到 $(C opDollar)、$(C opIndex)、与 $(C opSlice) 是用来进行元素索引与切片的。当为一维集合进行重载时，这些操作符有如下的义务：
)

$(UL

$(LI $(C opDollar)：返回集合的元素个数。)

$(LI $(C opSlice)：返回一个表示集合的一部分或全部元素的对象。)

$(LI $(C opIndex)：提供对单个元素的访问。)

)

$(P
这些操作符函数也有模板版本，它们与上面非模板的义务有所不同。注意尤其是在多维操作符重载时重载 $(C opIndex) 即假定了 $(C opSlice) 的义务。
)

$(UL

$(LI $(IX opDollar 模板) $(C opDollar) 模板：返回集合特定维度的长度。该维度由其模板参数确定的：

---
    size_t opDollar$(HILITE (size_t dimension))() const {
        // ...
    }
---

)

$(LI $(IX opSlice 模板) $(C opSlice) 模板：返回指定元素区间的区间信息（例如 $(C array[begin..end]) 中的 $(C begin) 与 $(C end)）。该信息能被返回为 $(C Tuple!(size_t, size_t)) 或一个等价的类型。区间的维度是由其模板参数确定的：

---
    Tuple!(size_t, size_t) opSlice$(HILITE (size_t dimension))(size_t begin,
                                                     size_t end) {
        return tuple(begin, end);
    }
---

)

$(LI $(IX opIndex 模板) $(C opIndex) 模板：返回表示集合一部分的区间对象。元素的区间是由其模板参数确定的：

---
    Range opIndex$(HILITE (A...))(A arguments) {
        // ...
    }
---

)

)

$(P
$(IX opIndexAssign 模板) $(IX opIndexOpAssign 模板) $(C opIndexAssign) 与 $(C opIndexOpAssign) 同样拥有模板版本，它们对集合中的一系列元素进行处理：
)

$(P
定义了这些运算符的自定义类型能适用于这些多维索引与切片语法：
)

---
              // 将 42 赋值于由这些索引与
              // 切片操作所指定的元素：
              m[a, b..c, $-1, d..e] = 42;
//              ↑   ↑     ↑    ↑
// 维度：       0   1     2    3
---

$(P
这样的表达式首先被转化为对运算符函数的调用。这样的转换具体操作为，以调用 $(C opDollar!dimension()) 代替 $(C $)，以调用 $(C opSlice!dimension(begin, end)) 代替索引区间。这些函数所返回的长度与区间信息依次作为调用诸如 $(C opIndexAssign) 的参数。依此，上面的表达式以下面的等价形式被执行（维度值被高亮标出）：
)

---
    // 与上面的等价：
    m.opIndexAssign(
        42,                    // ← 需被赋以的值
        a,                     // ← 0 维参数
        m.opSlice!$(HILITE 1)(b, c),     // ← 1 维参数
        m.opDollar!$(HILITE 2)() - 1,    // ← 2 维参数
        m.opSlice!$(HILITE 3)(d, e));    // ← 3 维参数
---

$(P
所以，$(C opIndexAssign) 借这些参数确定了相应的一系列元素。
)

$(H6 多维运算符重载示例)

$(P
如下的 $(C Matrix) 示例演示了这些运算符可以为一个二维类型进行重载。
)

$(P
注意这些代码完全可以由许多更高效的方式实现。例如，可以直接对元素进行运算，而不是每次，甚至在进行单元素运算时，都构建一个$(I 单元素的子矩阵)。
)

$(P
除此之外，函数内部的 $(C writeln(__FUNCTION__)) 表达式对于实际代码需求是没有任何作用的。它们仅仅是为了使被调用的函数从运算符使用的幕后显化出来。
)

$(P
同时需要注意的是维度值的正确性是由模板约束保证的。
)

---
import std.stdio;
import std.format;
import std.string;

/* 像一个二维 int 数组一样工作。 */
struct Matrix {
private:

    int[][] rows;

    /* 表示行或列区间。 */
    struct Range {
        size_t begin;
        size_t end;
    }

    /* 返回由行列区间确定的子矩阵。 */
    Matrix subMatrix(Range rowRange, Range columnRange) {
        writeln(__FUNCTION__);

        int[][] slices;

        foreach (row; rows[rowRange.begin .. rowRange.end]) {
            slices ~= row[columnRange.begin .. columnRange.end];
        }

        return Matrix(slices);
    }

public:

    this(size_t height, size_t width) {
        writeln(__FUNCTION__);

        rows = new int[][](height, width);
    }

    this(int[][] rows) {
        writeln(__FUNCTION__);

        this.rows = rows;
    }

    void toString(void delegate(const(char)[]) sink) const {
        formattedWrite(sink, "%(%(%5s %)\n%)", rows);
    }

    /* 将指定值赋于矩阵的每一个元素。 */
    Matrix opAssign(int value) {
        writeln(__FUNCTION__);

        foreach (row; rows) {
            row[] = value;
        }

        return this;
    }

    /* 将每个元素与一个值进行二元运算
     * 并将结果赋值于原元素。 */
    Matrix opOpAssign(string op)(int value) {
        writeln(__FUNCTION__);

        foreach (row; rows) {
            mixin ("row[] " ~ op ~ "= value;");
        }

        return this;
    }

    /* 返回特定维度的长度。 */
    size_t opDollar(size_t dimension)() const
            if (dimension <= 1) {
        writeln(__FUNCTION__);

        static if (dimension == 0) {
            /* 0 维度的长度即
             * ‘rows’数组的长度。 */
            return rows.length;

        } else {
            /* 1 维的长度即
             * ‘rows’元素的长度。 */
            return rows.length ? rows[0].length : 0;
        }
    }

    /* 返回一个表示从‘begin’至‘end’区间的对象。
     *
     * 注：尽管模板参数‘dimension’
     * 未在此处使用，对于其他类型
     * 这或许是有用的。 */
    Range opSlice(size_t dimension)(size_t begin, size_t end)
            if (dimension <= 1) {
        writeln(__FUNCTION__);

        return Range(begin, end);
    }

    /* 返回一个由参数定义的子矩阵。 */
    Matrix opIndex(A...)(A arguments)
            if (A.length <= 2) {
        writeln(__FUNCTION__);

        /* 我们以表示整个矩阵的区间
         * 进行开始，这样 opIndex
         * 的无参数形式就表示“全部元素”。 */
        Range[2] ranges = [ Range(0, opDollar!0),
                            Range(0, opDollar!1) ];

        foreach (dimension, a; arguments) {
            static if (is (typeof(a) == Range)) {
                /* 这个维度已经指定为了如
                 * ‘matrix[begin..end]’这
                 * 样能够直接使用的区间。 */
                ranges[dimension] = a;

            } else static if (is (typeof(a) : size_t)) {
                /* 这个维度被指定为一个单一
                 * 的像‘matrix[i]’这样的参数
                 * 值，这表示为一个单元素区间。 */
                ranges[dimension] = Range(a, a + 1);

            } else {
                /* 我们不期望其他类型。 */
                static assert(
                    false, format("Invalid index type: %s",
                                  typeof(a).stringof));
            }
        }

        /* 返回由‘arguments’指定的
         * 子矩阵。 */
        return subMatrix(ranges[0], ranges[1]);
    }

    /* 将指定的值赋于子矩阵的
     * 的每一个元素。 */
    Matrix opIndexAssign(A...)(int value, A arguments)
            if (A.length <= 2) {
        writeln(__FUNCTION__);

        Matrix subMatrix = opIndex(arguments);
        return subMatrix = value;
    }

    /* 使用子矩阵的每一个元素与一个值于
     * 二元运算中并将其结果赋于该元素。 */
    Matrix opIndexOpAssign(string op, A...)(int value,
                                            A arguments)
            if (A.length <= 2) {
        writeln(__FUNCTION__);

        Matrix subMatrix = opIndex(arguments);
        mixin ("return subMatrix " ~ op ~ "= value;");
    }
}

/* 执行以字符串指定的表达式，并
 * 输出其结果与矩阵的新状态。 */
void execute(string expression)(Matrix m) {
    writefln("\n--- %s ---", expression);
    mixin ("auto result = " ~ expression ~ ";");
    writefln("result:\n%s", result);
    writefln("m:\n%s", m);
}

void main() {
    enum height = 10;
    enum width = 8;

    auto m = Matrix(height, width);

    int counter = 0;
    foreach (row; 0 .. height) {
        foreach (column; 0 .. width) {
            writefln("Initializing %s of %s",
                     counter + 1, height * width);

            m[row, column] = counter;
            ++counter;
        }
    }

    writeln(m);

    execute!("m[1, 1] = 42")(m);
    execute!("m[0, 1 .. $] = 43")(m);
    execute!("m[0 .. $, 3] = 44")(m);
    execute!("m[$-4 .. $-1, $-4 .. $-1] = 7")(m);

    execute!("m[1, 1] *= 2")(m);
    execute!("m[0, 1 .. $] *= 4")(m);
    execute!("m[0 .. $, 0] *= 10")(m);
    execute!("m[$-4 .. $-2, $-4 .. $-2] -= 666")(m);

    execute!("m[1, 1]")(m);
    execute!("m[2, 0 .. $]")(m);
    execute!("m[0 .. $, 2]")(m);
    execute!("m[0 .. $ / 2, 0 .. $ / 2]")(m);

    execute!("++m[1..3, 1..3]")(m);
    execute!("--m[2..5, 2..5]")(m);

    execute!("m[]")(m);
    execute!("m[] = 20")(m);
    execute!("m[] /= 4")(m);
    execute!("(m[] += 5) /= 10")(m);
}
---

$(H5 小结)

$(P
早先的模板一章中有如下几点：
)

$(UL

$(LI 模板将代码定义为模型，以让编译器根据其在程序中的实际应用来生成它的实例。)

$(LI 模板是编译期特性。)

$(LI 指定模板参数列表就足以将函数、struct、class 定义转为模板。)

$(LI 模板参数能在一个感叹号之后被显式指定。当括号中只存在一个标记时括号可以被省略。)

$(LI 一个模板的每一个不同实例都是不同的类型。)

$(LI 只能为函数模板进行模板参数推断。)

$(LI 模板能以在 $(C :) 字符之后的类型进行特化。)

$(LI 默认模板参数是在 $(C =) 字符之后指定的。)

)

$(P
本章增加了以下概念：
)

$(UL

$(LI 模板能由完整语法或快捷语法定义。)

$(LI 模板语句块是一个命名空间。)

$(LI 一个包含与该模板同名的定义的模板叫做同名模板。这个模板即代表那个定义。)

$(LI 模板可以是函数、class、struct、union、interface，并且任何模板体中可以包含任意数量的定义。)

$(LI 模板参数可以是类型、值、$(C this)、$(C alias) 以及元组。)

$(LI $(C typeof(this))、$(C typeof(super))、以及 $(C typeof(return)) 在模板中很有用。)

$(LI 模板能为特定的参数特化。)

$(LI 元编程是一种在编译期执行运算操作的方式。)

$(LI 模板允许了$(I 编译期多态性)。)

$(LI 对于不同的实例生成分离代码会造成$(I 代码膨胀)。)

$(LI 模板约束对特定的模板参数实行了模板使用限制。它们将模板实现中的编译错误移至了实际上模板被错误使用的地方。)

$(LI 将模板约束命名会使其更加可读。)

$(LI $(C opDollar)、$(C opSlice)、$(C opIndex)、$(C opIndexAssign)、与 $(C opIndexOpAssign) 的模板版本是用于多维索引与切片的。)

)

Macros:
        SUBTITLE=模板扩展

        DESCRIPTION=更详细地阐明 D 语言中最通用的编程特性之一。

        KEYWORDS=d 编程 语言 教程 书 模板
