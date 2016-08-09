Ddoc

$(DERS_BOLUMU $(IX template) 模板)

$(P
模板是以模型来描述代码、从而让编译器来自动地生成程式代码的功能。源码的一些部分可以直到在程序中真正使用时才由编译器来完成。
)

$(P
模板能够用来写通用的算法与数据结构，而非针对一个特定的类型，因此模板特别有用，尤其是在代码库中。
)

$(P
与其他语言中的模板支持相比，D 的模板非常强大与广泛。然而我并不会在本章中展开所有有关模板的细节。我将只涵盖函数、结构与类，并只针对以类型为参数的模板。我们将在 $(LINK2 /ders/d.cn/templates_more.html, 更多模板) 一章中看到有关模板的更多信息。完整的 D 模板参考说明详见 $(LINK2 https://github.com/PhilippeSigaud/D-templates-tutorial, Philippe Sigaud's $(I D Templates: A Tutorial))。
)

$(P
以见识模板的诸多好处，让我们从一个打印括号中值的函数开始：
)

---
void printInParens(int value) {
    writefln("(%s)", value);
}
---

$(P
因为参数被指定为了 $(C int)，这个函数只能被用于类型为 $(C int) 或是能被自动转换为 $(C int) 的值。比如说，编译器不会允许以浮点值调用这个函数。
)

$(P
假使程序的需求变化了，括号中其他类型一样需要被打印出来，解决方式之一是利用函数重载、提供所有所需类型的重载函数：
)

---
// 原先存在的函数
void printInParens(int value) {
    writefln("(%s)", value);
}

// 针对‘double’类型进行重载
void printInParens($(HILITE double) value) {
    writefln("(%s)", value);
}
---

$(P
这种解决方式并没有很好的适应性，因为此时该函数不能被用于诸如 $(C real) 以及任何自定义类型。尽管针对其他类型重载仍旧是可能的，这么做的代价却是令人望而却步的。
)

$(P
很重要的一个现象是无关乎参数的类型，重载的内容始终是一样的：一个单一的 $(C writefln()) 表达式。
)

$(P
像这样的单一性在算法和数据结构中十分常见。例如二分查找算法与元素的类型无关——搜索的特定步骤和操作才是关键所在。与此相似地，链表数据结构亦与元素类型无关：链表仅仅关乎元素在容器中的储存方式，不论它们的类型如何。
)

$(P
这种情况下模板十分有用：一旦代码被写为模板，编译器将根据其在程序中的具体调用自动地生成同一代码的不同重载。
)

$(P
与上面提及的一样，在本章中，我将只涵盖函数、结构与类，并只针对以类型为参数的模板。
)

$(H5 $(IX 函数模板) 函数模板)

$(P
$(IX 参数，模板) 定义函数模板是引入一个或多个不明的类型来在函数中使用，这些类型将由编译器推断得出。
)

$(P
这些不明的类型定义于函数名与函数参数列表之间的模板参数列表中。因此，函数模板有两个参数列表——模板参数列表与函数参数列表：
)

---
void printInParens$(HILITE (T))(T value) {
    writefln("(%s)", value);
}
---

$(P
在上述模板参数列表中的 $(C T) 意味着 $(C T) 可以是任何类型。尽管 $(C T) 是一个随意的名称，但它是“类型（type）”的缩写形式，因此在模板中很寻常。
)

$(P
因为 $(C T) 表示任何类型，所以上述 $(C printInParens()) 模板定义足以应用于包括自定义的几乎每个类型：
)

---
import std.stdio;

void printInParens(T)(T value) {
    writefln("(%s)", value);
}

void main() {
    printInParens(42);           // 以 int
    printInParens(1.2);          // 以 double

    auto myValue = MyStruct();
    printInParens(myValue);      // 以 MyStruct
}

struct MyStruct {
    string toString() const {
        return "hello";
    }
}
---

$(P
编译器概览 $(C printInParens()) 所有在程序中的使用并生成代码来支持所有相应的调用。程序被如同该函数明确地为 $(C int)、$(C double) 与 $(C MyStruct) 重载一样地编译：
)

$(MONO
/* 注：这些函数并不是源代码的一部分。
 * 　　它们与编译器自动生成的函数相等价。 */

void printInParens($(HILITE int) value) {
    writefln("(%s)", value);
}

void printInParens($(HILITE double) value) {
    writefln("(%s)", value);
}

void printInParens($(HILITE MyStruct) value) {
    writefln("(%s)", value);
}
)

$(P
程序的输出是由该函数模板的不同$(I 实例)生成的：
)

$(SHELL
(42)
(1.2)
(hello)
)

$(P
每一个模板参数能确定不止一个的函数参数。例如，如下函数的两个函数参数及其返回类型都取决于它单一的模板参数：
)

---
/* 返回“slice”除去与“value”相等元素的一份拷贝。 */
$(HILITE T)[] removed(T)(const($(HILITE T))[] slice, $(HILITE T) value) {
    T[] result;

    foreach (element; slice) {
        if (element != value) {
            result ~= element;
        }
    }

    return result;
}
---

$(H5 多于一个的模板参数)

$(P
变化函数模板来加上首尾字符:
)

---
void printInParens(T)(T value, char opening, char closing) {
    writeln(opening, value, closing);
}
---

$(P
现在我们能以不同的首尾字符调用该函数:
)

---
    printInParens(42, '<', '>');
---

$(P
尽管能指定首尾字符使得该函数更加实用，限定首尾字符的类型为 $(C char) 却下降了它的灵活性，因为它无法以 $(C wchar) 或 $(C dchar) 等类型调用：
)

---
    printInParens(42, '→', '←');      $(DERLEME_HATASI)
---

$(SHELL_SMALL
Error: template deneme.printInParens(T) cannot deduce
template function from argument types !()(int,$(HILITE wchar),$(HILITE wchar))
)

$(P
一个解决方式是指定首尾的类型为 $(C dchar)，但这还不够，此时函数无法运用比如 $(C string) 或自定义类型。
)

$(P
$(IX , (逗号)，模板参数列表) 另一种解决方式是将首尾字符类型同样交给编译器来确定。定义一个附加的模板参数以替代指定的 $(C char) 就足矣：
)

---
void printInParens(T$(HILITE , ParensType))(T value,
                                  $(HILITE ParensType) opening,
                                  $(HILITE ParensType) closing) {
    writeln(opening, value, closing);
}
---

$(P
新模板参数的意义与 $(C T) 的一致：$(C ParensType) 可以是任何类型。
)

$(P
现在就可以用许多不同类型的首尾字符。如下分别以 $(C wchar) 与 $(C string) 进行调用：
)

---
    printInParens(42, '→', '←');
    printInParens(1.2, "-=", "=-");
---

$(SHELL
→42←
-=1.2=-
)

$(P
$(C printInParens()) 的灵活性被大大增加了，只要是 $(C writeln()) 可以打印的类型，对于任何 $(C T) 和 $(C ParensType) 的组合它都可以正确工作。
)

$(H5 $(IX 类型推断) $(IX 推断，类型) 类型推断)

$(P
编译器决定模板参数的具体类型的过程就叫做$(I 类型推断)。
)

$(P
继续看上面最后一个示例，编译器分别根据对该函数模板的两次不同调用来确定下述类型:
)

$(UL
$(LI 输出 42 时的 $(C int) 与 $(C wchar))
$(LI 输出 1.2 时的 $(C double) 与 $(C string))
)

$(P
编译器只能在对函数模板的调用中由参数的值类型进行类型推断。尽管大多数情况下编译器能毫无歧义地推断类型，但有时相应类型还是必须明确地由编程者指定。
)

$(H5 明确指定类型)

$(P
有时编译器不可能自动推断相应的模板参数。比如当所需的类型不出现在函数参数列表中时。若模板参数与函数参数没有关联，那么编译器便不能推断出模板类型参数。
)

$(P
作为这种情况的一个实例，让我们设计一个向用户提出问题、接纳一个值作为回应、并返回该值的函数。另外，把它写为函数模板来用以读取任何类型的回应：
)

---
$(HILITE T) getResponse$(HILITE (T))(string question) {
    writef("%s (%s): ", question, T.stringof);

    $(HILITE T) response;
    readf(" %s", &response);

    return response;
}
---

$(P
这个函数模板或在需要读入不同类型输入的程序中非常有用。例如，读入一些用户信息，就可以像下面一行一样调用它：
)

---
    getResponse("What is your age?");
---

$(P
不幸的是这个调用没有给编译器任何关于模板参数 $(C T) 是什么的线索。它唯一知道的是传递给该函数的是一个 $(C string)，但返回类型却不能借此被推断出来：
)

$(SHELL_SMALL
Error: template deneme.getResponse(T) $(HILITE cannot deduce) template
function from argument types !()(string)
)

$(P
$(IX !, 模板实例化) 在这类情况下，模板参数必须由编程者明确指定。模板参数指定于感叹号之后的括号中：
)

---
    getResponse$(HILITE !(int))("What is your age?");
---

$(P
上述代码现在便能被编译器采纳，$(C T) 作为了 $(C int) 在模板内的一个别名。
)

$(P
当仅需要指定一个模板参数时，它周围的括号可以被省略：
)

---
    getResponse$(HILITE !int)("What is your age?");    // 同上
---

$(P
你或能由已经在早先的程序中使用过的 $(C to!string) 认出这种语法。$(C to()) 是一个函数模板，它以模板参数的形式接受转换的目标类型。由于只有一个待指定的模板参数，它通常被写作 $(C to!string) 而非 $(C to!(string))。
)

$(H5 $(IX 实例, 模板) 模板实例)

$(P
为一组特定的模板参数自动生成代码称之为该模板对于这一组参数的一个$(实例)。例如，$(C to!string) 和 $(C to!int) 就是函数模板 $(C to) 的两个不同的实例。
)

$(P
如在下面单独的片段中提及的一样，模板的不同实例生成不同且不相兼容的类型。
)

$(H5 $(IX 特化, 模板) 模板特化)

$(P
尽管函数模板 $(C getResponse()) 理论上可以用于任何类型，编译器生成的代码却未必适合每一种类型。假定有如下表示二维空间上点的类型：
)

---
struct Point {
    int x;
    int y;
}
---

$(P
尽管 $(C getResponse()) 对于 $(C Point) 类型的实例化本身是没问题的，其生成的对 $(C readf()) 的调用却不能通过编译。这是因为标准库中的函数 $(C readf()) 不知道如何从输入中读取一个 $(C Point) 对象。而实际上用于读入输入的两行代码就如同如下在 $(C getResponse()) 函数模板的 $(C Point) 类型实例中的一样：
)

---
    Point response;
    readf(" %s", &response);    $(DERLEME_HATASI)
---

$(P
一种读入 $(C Point) 对象的方式是单独地读入 $(C x) 与 $(C y) 成员的值，再以此$(构建)一个 $(C Point) 对象。
)

$(P
为特定模板参数值提供特殊的模板定义称之为一个$(模板特化)。特化的定义方式为在模板参数列表中的 $(C :) 字符后指定类型。一个为 $(C Point) 特化的 $(C getResponse()) 函数模板定义如下：
)

---
// 函数模板的通用定义（与之前一样）
T getResponse(T)(string question) {
    writef("%s (%s): ", question, T.stringof);

    T response;
    readf(" %s", &response);

    return response;
}

// 针对 Point 的函数模板特化定义
T getResponse(T $(HILITE : Point))(string question) {
    writefln("%s (Point)", question);

    auto x = getResponse!int("  x");
    auto y = getResponse!int("  y");

    return Point(x, y);
}
---

$(P
注意这个特化利用了 $(C getResponse()) 的通用定义来读入成员 $(C x) 和 $(C y)。
)

$(P
现在编译器不再自己实例化该模板，而是在 $(C getResponse()) 以 $(C Point) 调用时使用上面的特化：
)

---
    auto center = getResponse!Point("Where is the center?");
---

$(P
假设用户输入了 11 与 22：
)

$(SHELL_SMALL
Where is the center? (Point)
  x (int): 11
  y (int): 22
)

$(P
对 $(C getResponse!int()) 的调用指向了该模板的通用定义，对 $(C getResponse!Point()) 的调用则指向了它针对 $(C Point) 的特化。
)

$(P
作为另一个示例，考虑一下以 $(C string) 使用同样模板的情况。如同你在 $(LINK2 /ders/d.cn/strings.html, 字符串) 一章中学到的那样，$(C readf()) 会将所有的输入字符用作一个单一的 $(C string)，直至输入结束。因此，$(C getResponse()) 的默认定义在读入 $(C string) 回应时是无济于事的：
)

---
    // 这会读入整个输入，而不仅仅是名字而已
    auto name = getResponse!string("What is your name?");
---

$(P
我们同样可以为 $(C string) 提供一个模板特化。以下的特化仅读入一行：
)

---
T getResponse(T $(HILITE : string))(string question) {
    writef("%s (string): ", question);

    // 读取并忽略想必是从之前的用户输入中遗留的空白字符
    string response;
    do {
        response = strip(readln());
    } while (response.length == 0);

    return response;
}
---

$(H5 $(IX struct 模板) $(IX class 模板) struct 与 class 模板)

$(P
$(C Point) struct 或有一个限制：由于两个成员被指定为了 $(C int) 类型，它不能表示小数坐标值。若将 $(C Point) struct 定义为模板即可豁免这个限制。
)

$(P
先添加一个返回到另一个 $(C Point) 对象距离的成员函数：
)

---
import std.math;

// ...

struct Point {
    int x;
    int y;

    int distanceTo(in Point that) const {
        immutable real xDistance = x - that.x;
        immutable real yDistance = y - that.y;

        immutable distance = sqrt((xDistance * xDistance) +
                                  (yDistance * yDistance));

        return cast(int)distance;
    }
}
---

$(P
这个 $(C Point) 的定义适用于所需精确度较低的情况：它能计算精确到千米的两点距离，例如一个组织的总部与其分支机构间的距离：
)

---
    auto center = getResponse!Point("Where is the center?");
    auto branch = getResponse!Point("Where is the branch?");

    writeln("Distance: ", center.distanceTo(branch));
---

$(P
不幸的是，$(C Point) 无法满足精度需求比 $(C int) 类型所提供的精度更高的情形。
)

$(P
struct 和 class 同样可以被定义为模板，只需要在名称之后附加一个模板参数列表即可。例如，$(C Point) 能被定义为 struct 模板，仅需提供一个取代 $(C int) 的模板参数：
)

---
struct Point$(HILITE (T)) {
    $(HILITE T) x;
    $(HILITE T) y;

    $(HILITE T) distanceTo(in Point that) const {
        immutable real xDistance = x - that.x;
        immutable real yDistance = y - that.y;

        immutable distance = sqrt((xDistance * xDistance) +
                                  (yDistance * yDistance));

        return cast($(HILITE T))distance;
    }
}
---

$(P
由于 struct 和 class 不是函数，它们不能以参数调用。这使得编译器不能自动推断它们的模板参数。 struct 和 class 模板的模板参数列表必须每次都手动指定：
)

---
    auto center = Point$(HILITE !int)(0, 0);
    auto branch = Point$(HILITE !int)(100, 100);

    writeln("Distance: ", center.distanceTo(branch));
---

$(P
上述定义使得编译器针对 $(C Point) 模板的 $(C int) 实例生成代码，这与先前的非模板定义是等价的。然而，现在它可以用于任何类型。例如，当需要更高精度时使用 $(C double)：
)

---
    auto point1 = Point$(HILITE !double)(1.2, 3.4);
    auto point2 = Point$(HILITE !double)(5.6, 7.8);

    writeln(point1.distanceTo(point2));
---

$(P
尽管模板本身不依赖于任何特定的类型，但这单一的定义却使得它可以表示各个精度的点。
)

$(P
仅将 $(C Point) 转为模板将在为它的非模板定义写就的代码中造成编译错误。例如，现在 $(C getResponse()) 模板针对 $(C Point) 的特化将不再能通过编译：
)

---
T getResponse(T : Point)(string question) {  $(DERLEME_HATASI)
    writefln("%s (Point)", question);

    auto x = getResponse!int("  x");
    auto y = getResponse!int("  y");

    return Point(x, y);
}
---

$(P
编译出错的原因是 $(C Point) 本身不再是一个类型了：$(C Point) 现在是一个 $(I struct template)。这个模板的实例才是类型。需要如下的变更来正确地为 $(C Point) 提供 $(C getResponse()) 的特化：
)

---
Point!T getResponse(T : Point!T)(string question) {  // 2, 1
    writefln("%s (Point!%s)", question, T.stringof); // 5

    auto x = getResponse!T("  x");                   // 3a
    auto y = getResponse!T("  y");                   // 3b

    return Point!T(x, y);                            // 4
}
---

$(OL

$(LI
以便让这个模板特化支持所有的 $(C Point) 实例，模板参数列表中必须提及 $(C Point!T)。这简明地表示该 $(C getResponse()) 特化针对的是 $(C Point!T)，不论 $(C T) 是什么。这个特化会匹配 $(C Point!int)、$(C Point!double)、等等。
)

$(LI
相似地，为了返回正确的类型作为回应，返回类型也必须被指定为 $(C Point!T)。
)

$(LI
由于 $(C Point!T) 的成员 $(C x) 与 $(C y) 的类型现在为 $(C T)，与 $(C int) 相当，成员必须以调用 $(C getResponse!T()) 的形式进行读入，而非 $(C getResponse!int())，否则这将仅能适用于 $(C Point!int)。
)

$(LI
如 1 与 2 说的一样，返回值的类型为 $(C Point!T)。
)

$(LI
以精确地输出每个类型的名称，诸如 $(C Point!int)、$(C Point!double)、等等，使用 $(C T.stringof)。
)

)

$(H5 $(IX 默认模板参数) 默认模板参数)

$(P
有时每次都提供模板类型参数是十分累赘的，尤其是当该类型几乎总是同一个特定类型的时候。譬如，$(C getResponse()) 或几乎总是为 $(C int) 类型在程序中调用，而仅有几处使用 $(C double) 类型。
)

$(P
可以为模板参数指定默认类型，在没有显式指定类型时即采用默认类型。默认类型指定于 $(C =) 字符之后：
)

---
T getResponse(T $(HILITE = int))(string question) {
    // ...
}

// ...

    auto age = getResponse("What is your age?");
---

$(P
由于上面对 $(C getResponse()) 的调用没有指定类型，$(C T) 成为默认类型 $(C int)，这个调用即等价于 $(C getResponse!int())。
)

$(P
亦能为 struct 和 class 模板指定默认参数，但在这种情况下，尽管模板参数列表是空的，我们却仍然必须总是写出它：
)

---
struct Point(T = int) {
    // ...
}

// ...

    Point!$(HILITE ()) center;
---


$(P
与在 $(LINK2 /ders/d.cn/parameter_flexibility.html, 可变参数) 一章中看到的函数默认参数相似，可以为全部参数或仅为末尾参数指定模板默认参数：
)

---
void myTemplate(T0, T1 $(HILITE = int), T2 $(HILITE = char))() {
    // ...
}
---

$(P
该函数的最后两个模板参数可以不显式指定，但第一个参数是必须指定的：
)

---
    myTemplate!string();
---

$(P
那么，第二第三个参数便分别是 $(C int) 与 $(C char)。
)

$(H5 每个不同的模板实例都是一个独特的类型)

$(P
模板对于每一组类型的实例都是一个不同的类型。例如，$(C Point!int) 和 $(C Point!double) 就是区别的两个类型：
)

---
Point!int point3 = Point!double(0.25, 0.75); $(DERLEME_HATASI)
---

$(P
这样不同的类型不能被用于上面的赋值操作：
)

$(SHELL_SMALL
Error: cannot implicitly convert expression (Point(0.25,0.75))
of type $(HILITE Point!(double)) to $(HILITE Point!(int))
)

$(H5 是一种编译期功能)

$(P
模板根本上是一种编译期功能。模板实例是在编译期由编译器生成的。
)

$(H5 class 模板示例：堆栈数据结构)

$(P
struct 和 class 模板被广泛运用于数据结构的实现中。让我们设计一个可以容纳任意类型的堆栈容器。
)

$(P
堆栈是最简单的数据结构之一。它表示一个将元素概念上堆叠于其他元素之上的容器，就像一叠纸张一样。新的元素放置于顶端，并且只有在最顶端的元素可以被访问。若一个元素被移除，它总是最顶端的那个。
)

$(P
若我们再定义一个返回堆栈中元素总数的 property，那么这个数据结构的全部操作如下：
)

$(UL
$(LI 添加元素 ($(C push())))
$(LI 移除元素 ($(C pop())))
$(LI 访问顶端元素 ($(C .top)))
$(LI 查询元素数量 ($(C .length)))
)

$(P
可以用一个数组来存储这些元素，这样数组的最后一个元素将表示堆栈的顶端元素。最后，它可以被定义为一个 class 模板以用于容纳任何类型的元素：
)

---
$(CODE_NAME Stack)class Stack$(HILITE (T)) {
private:

    $(HILITE T)[] elements;

public:

    void push($(HILITE T) element) {
        elements ~= element;
    }

    void pop() {
        --elements.length;
    }

    $(HILITE T) top() const @property {
        return elements[$ - 1];
    }

    size_t length() const @property {
        return elements.length;
    }
}
---

$(P
作为一个设计考虑，$(C push()) 和 $(C pop()) 被定义为普通的成员函数，而 $(C .top) 和 $(C .length) 则被定义为了 property，因为它们能被看作是提供了该堆栈的简单信息。
)

$(P
这里是一个测试改类的 $(C unittest) 语句块，使用了它的 $(C int) 实例：
)

---
unittest {
    auto stack = new Stack$(HILITE !int);

    // 新添加的元素必须位于顶端
    stack.push(42);
    assert(stack.top == 42);
    assert(stack.length == 1);

    // .top 和 .length 不应该影响元素
    assert(stack.top == 42);
    assert(stack.length == 1);

    // 新添加的元素必须位于顶端
    stack.push(100);
    assert(stack.top == 100);
    assert(stack.length == 2);

    // 移除末尾元素后必须暴露出前一个元素
    stack.pop();
    assert(stack.top == 42);
    assert(stack.length == 1);

    // 最后一个元素移除后堆栈必须变空
    stack.pop();
    assert(stack.length == 0);
}
---

$(P
为了利用这个 class 模板，让我们这次试着以一个自定义类型使用它。作为示例，此处是一个修改过的 $(C Point) 版本：
)

---
struct Point(T) {
    T x;
    T y;

    string toString() const {
        return format("(%s,%s)", x, y);
    }
}
---

$(P
一个包含 $(C Point!double) 类型元素的 $(C Stack) 可以以如下方式定义：
)

---
    auto points = new Stack!(Point!double);
---

$(P
这里是一个向这个堆栈中加入十个元素并一一移除的程序：
)

---
$(CODE_XREF Stack)import std.string;
import std.stdio;
import std.random;

struct Point(T) {
    T x;
    T y;

    string toString() const {
        return format("(%s,%s)", x, y);
    }
}

// 返回在 -0.50 与 0.50 之间的一个随机值。
double random_double()
out (result) {
    assert((result >= -0.50) && (result < 0.50));

} body {
    return (double(uniform(0, 100)) - 50) / 100;
}

// 返回一个包含‘count’个随机 Point!double 元素的 Stack。
Stack!(Point!double) randomPoints(size_t count)
out (result) {
    assert(result.length == count);

} body {
    auto points = new Stack!(Point!double);

    foreach (i; 0 .. count) {
        immutable point = Point!double(random_double(),
                                       random_double());
        writeln("adding  : ", point);
        points.push(point);
    }

    return points;
}

void main() {
    auto stackedPoints = randomPoints(10);

    while (stackedPoints.length) {
        writeln("removing: ", stackedPoints.top);
        stackedPoints.pop();
    }
}
---

$(P
如这个程序的输出，元素以与添加相反的顺序被移除：
)

$(SHELL_SMALL
adding  : (-0.02,-0.01)
adding  : (0.17,-0.5)
adding  : (0.12,0.23)
adding  : (-0.05,-0.47)
adding  : (-0.19,-0.11)
adding  : (0.42,-0.32)
adding  : (0.48,-0.49)
adding  : (0.35,0.38)
adding  : (-0.2,-0.32)
adding  : (0.34,0.27)
removing: (0.34,0.27)
removing: (-0.2,-0.32)
removing: (0.35,0.38)
removing: (0.48,-0.49)
removing: (0.42,-0.32)
removing: (-0.19,-0.11)
removing: (-0.05,-0.47)
removing: (0.12,0.23)
removing: (0.17,-0.5)
removing: (-0.02,-0.01)
)

$(H5 函数模板示例：二分查找算法)

$(P
二分查找是在有序序列中最快的搜索算法。它是一个非常简单的算法：仅考虑中位元素；若该元素就是搜索目标，那么结束搜索。若不是，那么依据该元素与搜索目标的大小关系在中位元素的左侧或右侧重复该算法。
)

$(P
在初始元素的子集中重复本身的算法是迭代式的。让我们以调用自身的方式实现该二分查找算法的迭代。
)

$(P
在将其转换为模板之前，让我们先实现仅支持 $(C int) 数组的该函数。以此为基础，加入模板参数列表并在定义中用 $(C T) 替代 $(C int)，便能轻易地将其转化为一个模板。如下便是工作于 $(C int) 数组上的二分查找算法：
)

---
/* 若目标值存在于数组中，那么该函数就返回其索引值，
 * 否则便返回 size_t.max。 */
size_t binarySearch(const int[] values, in int value) {
    // 若数组是空的，那么目标值便不可能在数组中
    if (values.length == 0) {
        return size_t.max;
    }

    immutable midPoint = values.length / 2;

    if (value == values[midPoint]) {
        // 找到了。
        return midPoint;

    } else if (value < values[midPoint]) {
        // 目标值只可能存在于左手侧；
        // 在表示那一半的切片中继续查找。
        return binarySearch(values[0 .. midPoint], value);

    } else {
        // 目标值仅可能存在于右手侧；
        // 在右手侧中继续查找。
        auto index =
            binarySearch(values[midPoint + 1 .. $], value);

        if (index != size_t.max) {
            // 调整索引值；
            // 在右手侧切片上它是基于 0 的。
            index += midPoint + 1;
        }

        return index;
    }

    assert(false, "We should have never gotten to this line");
}
---

$(P
上述函数分四个步骤实现了这个简单的算法：
)

$(UL
$(LI 若数组是空的，返回 $(C size_t.max) 以表示没有找到目标值。)
$(LI 若中位元素与目标值相等，那么返回该元素的索引。)
$(LI 若目标值较中位元素小，那么便在左手侧重复同样的算法。)
$(LI 反之，在右手侧重复同样的算法。)
)

$(P
这是一个用于测试该函数的 unittest 语句块:
)

---
unittest {
    auto array = [ 1, 2, 3, 5 ];
    assert(binarySearch(array, 0) == size_t.max);
    assert(binarySearch(array, 1) == 0);
    assert(binarySearch(array, 4) == size_t.max);
    assert(binarySearch(array, 5) == 3);
    assert(binarySearch(array, 6) == size_t.max);
}
---

$(P
现在这个函数已为 $(C int) 类型实现并测试，我们可以将其转换为模板了。$(C int) 只出现在了函数定义中的两处：
)

---
size_t binarySearch(const int[] values, in int value) {
    // ……int 在这里没有出现过……
}
---

$(P
在参数列表中出现的 $(C int) 是集合元素与目标值的类型。将这些指定为模板参数就足以将这个算法变为一个模板并使其也能被用于其他类型：
)

---
size_t binarySearch$(HILITE (T))(const $(HILITE T)[] values, in $(HILITE T) value) {
    // ...
}
---

$(P
这个函数模板能应用于支持模板中所涉及操作的任何类型。在 $(C binarySearch()) 中，只有两个涉及到元素的操作，$(C ==) 与 $(C <)：
)

---
    if (value $(HILITE ==) values[midPoint]) {
        // ...

    } else if (value $(HILITE <) values[midPoint]) {

        // ...
---

$(P
由是，$(C Point) 尚不能使用 $(C binarySearch())：
)

---
import std.string;

struct Point(T) {
    T x;
    T y;

    string toString() const {
        return format("(%s,%s)", x, y);
    }
}

void $(CODE_DONT_TEST)main() {
    Point!int[] points;

    foreach (i; 0 .. 15) {
        points ~= Point!int(i, i);
    }

    assert(binarySearch(points, Point!int(10, 10)) == 10);
}
---

$(P
上述程序将导致一个编译错误：
)

$(SHELL_SMALL
Error: need member function $(HILITE opCmp()) for struct
const(Point!(int)) to compare
)

$(P
根据错误消息，需要为 $(C Point) 定义 $(C opCmp())。$(C opCmp()) 详见 $(LINK2 /ders/d.cn/operator_overloading.html, 运算符重载) 一章：
)

---
struct Point(T) {
// ...

    int opCmp(const ref Point that) const {
        return (x == that.x
                ? y - that.y
                : x - that.x);
    }
}
---

$(H5 小结)

$(P
我们将在 $(LINK2 /ders/d.cn/templates_more.html, 之后的一章) 中看到模板的更多特性。下面是本章中涵盖的内容：
)

$(UL

$(LI 模板像模型一样定义代码，以让编译器来根据它在程序中的实际使用生成实例。)

$(LI 模板是一个编译期功能。)

$(LI 指定模板参数列表就足以将函数、struct 和 class 定义变为模板。

---
void functionTemplate$(HILITE (T))(T functionParameter) {
    // ...
}

class ClassTemplate$(HILITE (T)) {
    // ...
}
---

)

$(LI 模板参数能在感叹号后显式指定。当括号中仅有一个符号时可以省略括号。

---
    auto object1 = new ClassTemplate!(double);
    auto object2 = new ClassTemplate!double;    // 等价
---

)

$(LI 每一个不同的模板实例都是一个不同的类型。

---
    assert(typeid(ClassTemplate!$(HILITE int)) !=
           typeid(ClassTemplate!$(HILITE uint)));
---

)

$(LI 只有函数模板参数能进行自动推断。

---
    functionTemplate(42);  // 推断为 functionTemplate!int
---

)

$(LI 模板能针对 $(C :) 字符之后的类型进行特化。

---
class ClassTemplate(T $(HILITE : dchar)) {
    // ...
}
---

)

$(LI 默认模板参数指定于 $(C =) 字符之后。

---
void functionTemplate(T $(HILITE = long))(T functionParameter) {
    // ...
}
---

)

)

Macros:
        SUBTITLE=模板

        DESCRIPTION=介绍 D 的泛型编程功能。模板能够像模型一样定义代码，并让编译器根据该模板在程序中的使用自动生成真正的代码。

        KEYWORDS=d 编程 语言 教程 模板
