Ddoc

$(DERS_BOLUMU $(IX Object) $(CH4 Object))

$(P
没有明确地继承自任何基类的类自动继承自 $(C Object) 类。
)

$(P
根据这一定义, 任何类继承结构中的最顶端基类继承自 $(C Object)：
)

---
// “: Object”没有写；它是自动的
class MusicalInstrument $(DEL : Object ) {
    // ...
}

// 间接继承自 Object
class StringInstrument : MusicalInstrument {
    // ...
}
---

$(P
由于顶端类继承自 $(C Object)，每个类也间接继承自 $(C Object)。 从某种意义上来讲， 每个类“是一个”$(C Object)。
)

$(P
每个类继承 $(C Object) 的成员函数：
)

$(UL
$(LI $(C toString)：对象的 $(C string) 表示。)
$(LI $(C opEquals)：与另一对象的相等性比较。)
$(LI $(C opCmp)： 与另一个对象的排序顺序比较。)
$(LI $(C toHash)：关联数组的Hash值。)
)

$(P
后三个函数强调对象的值。 他们还让一个类有资格作为关联数组的键类型。
)

$(P
因为这些函数是继承的， 所以子类重新定义的时候需要关键字 $(C override)。
)

$(P $(I $(B 注：)$(C Object) 也定义了别的成员。 这章将只涉及上面所提到的四个成员函数。)
)

$(H5 $(IX typeid) $(IX TypeInfo) $(C typeid) 和 $(C TypeInfo))

$(P
$(C Object) 的定义在文件 $(LINK2 http://dlang.org/phobos/object.html, $(C object) 模块) (它不是 $(C std) 包的一部分)。该 $(C object) 模块定义 $(C TypeInfo) ，它是一个提供有关类型的信息的类。 每个类型具有不同的 $(C TypeInfo) 对象。 $(C typeid) $(I expression) 提供对与特定类型有关联的 $(C TypeInfo) 对象的访问。 随后我们将看到，$(C TypeInfo) 类能用于确定两个类型是否相同， 以及用于访问类型的特殊函数 ($(C toHash)、 $(C postblit) 等等， 其中的大部分本书并不包括)。
)

$(P
$(C TypeInfo) 通常是指实际运行时类型。例如， 虽然 $(C Violin) 和 $(C Guitar) 都直接继承自 $(C StringInstrument)  并间接继承自 $(C MusicalInstrument),  但是 $(C Violin) 和 $(C Guitar) 的$(C TypeInfo) 不一样。它们恰恰是 $(C Violin) 和 $(C Guitar) 类型, 分别为：
)

---
class MusicalInstrument {
}

class StringInstrument : MusicalInstrument {
}

class Violin : StringInstrument {
}

class Guitar : StringInstrument {
}

void main() {
    TypeInfo v = $(HILITE typeid)(Violin);
    TypeInfo g = $(HILITE typeid)(Guitar);
    assert(v != g);    $(CODE_NOTE 这两个类型不同)
}
---

$(P
上面的$(C typeid) 表达式用于像 $(C Violin) 这样的 $(I types) 自身。 $(C typeid) 也能带出一个 $(I expression)，这种情况下，它为那个表达式的运行时类型返回 $(C TypeInfo) 对象。 举例来说，下列的函数有两个不同参数但类型相关：
)

---
import std.stdio;

// ...

void foo($(HILITE MusicalInstrument) m, $(HILITE StringInstrument) s) {
    const isSame = (typeid(m) == typeid(s));

    writefln("The types of the arguments are %s.",
             isSame ? "the same" : "different");
}

// ...

    auto a = new $(HILITE Violin)();
    auto b = new $(HILITE Violin)();
    foo(a, b);
---

$(P
虽然 $(C foo())调用的两个参数都是 $(C Violin) 对象， $(C foo()) 决定它们的类型相同：
)

$(SHELL
The types of the arguments are $(HILITE the same).
)

$(P
不像 $(C .sizeof) 和 $(C typeof)， 从来不执行它们的表达式， $(C typeid) 总是执行它接收的表达式：
)

---
import std.stdio;

int foo(string when) {
    writefln("Called during '%s'.", when);
    return 0;
}

void main() {
    const s = foo("sizeof")$(HILITE .sizeof);     // foo() 不被调用
    alias T = $(HILITE typeof)(foo("typeof"));    // foo() 不被调用
    auto ti = $(HILITE typeid)(foo("typeid"));    // foo()  被调用
}
---

$(P
输出表明只有含$(C typeid)的表达式被执行：
)

$(SHELL
Called during 'typeid'.
)

$(P
不同的原因是表达式的实际运行时类型只在表达式被执行时才能知道。举例来说，下面函数返回的准确类型将是 $(C Violin) 还是 $(C Guitar) 取决于参数的实际值：
)

---
MusicalInstrument foo(int i) {
    return ($(HILITE i) % 2) ? new Violin() : new Guitar();
}
---

$(H5 $(IX toString) $(C toString))

$(P
跟结构一样， $(C toString) 也能把类对象用作字符串：
)

---
    auto clock = new Clock(20, 30, 0);
    writeln(clock);         // 调用 clock.toString()
---

$(P
继承的 $(C toString()) 通常没用；它只产生类型的名称：
)

$(SHELL
deneme.Clock
)

$(P
类型名称的前部是模块名称。 上面的输出表明 $(C Clock) 已被定义在 $(C deneme) 模块。
)

$(P
在前面的章节我们已经看到，为产生更有意义的$(C string)表达，函数总是被重写：
)

---
import std.string;

class Clock {
    override string toString() const {
        return format("%02s:%02s:%02s", hour, minute, second);
    }

    // ...
}

class AlarmClock : Clock {
    override string toString() const {
        return format("%s ♫%02s:%02s", super.toString(),
                      alarmHour, alarmMinute);
    }

    // ...
}

// ...

    auto bedSideClock = new AlarmClock(20, 30, 0, 7, 0);
    writeln(bedSideClock);
---

$(P
输出：
)

$(SHELL
20:30:00 ♫07:00
)

$(H5 $(IX opEquals) $(C opEquals))

$(P
如我们在 $(LINK2 /ders/d.cn/operator_overloading.html, 运算符重载) 一章中看到的一样，这个成员函数是关于 $(C ==) 运算符（和 $(C !=) 不等运算符）的行为。如果对象被认为是相等的，运算符的返回值是 $(C true) 否则为 $(C false)。
)

$(P
$(B 注意：)该函数的定义必须符合 $(C opCmp())；对两个对象 $(C opEquals()) 返回 $(C true)， $(C opCmp()) 一定返回0。
)

$(P
跟结构相反， 编译器见到 $(C a&nbsp;==&nbsp;b)时不立即调用 $(C a.opEquals(b))。 当两个对象用 $(C ==) 运算符比较时， 将执行一个四步算法：
)

---
bool opEquals(Object a, Object b) {
    if (a is b) return true;                          // (1)
    if (a is null || b is null) return false;         // (2)
    if (typeid(a) == typeid(b)) return a.opEquals(b); // (3)
    return a.opEquals(b) && b.opEquals(a);            // (4)
}
---

$(OL

$(LI 如果两个变量提供对同一对象的访问 (或者他们都是 $(C null)), 那么它们相等。)

$(LI 紧接着前面的检查，如果仅有一个是 $(C null) 那么它们不等。)

$(LI 如何两个对象类型相同, 那么 $(C a.opEquals(b)) 被调用来决定相等。)

$(LI 另外，对两个被认为相等的对象，一定曾经为它们的类型以及 $(C a.opEquals(b)) 和 $(C b.opEquals(a)) 定义了 $(C opEquals)，一定同意对象是相等的。)

)

$(P
因此， 如果一个类没有提供 $(C opEquals())，那么对象的值就不被考虑；然而，相等性决定于检查两个类变量是否访问同一对象：
)

---
    auto variable0 = new Clock(6, 7, 8);
    auto variable1 = new Clock(6, 7, 8);

    assert(variable0 != variable1); // 它们不相等
                                    // 因为对象
                                    // 不同
---

$(P
即使这两个对象构造于上面的同一参数，因为不与同一对象关联，所以变量不相等。
)

$(P
另一方面，因为下面两个变量访问同一对象，所以它们是 $(I equal)：
)

---
    auto partner0 = new Clock(9, 10, 11);
    auto partner1 = partner0;

    assert(partner0 == partner1);   // 它们是相等的，因为
                                    // 是同一个对象
---

$(P
有时它给人更多的感觉是比较对象的值而不是它们的身份。举例来说， 可以想到，上面的 $(C variable0) 和 $(C variable1)  比较的结果是相等的，因为它们的值一样。
)

$(P
与结构不同， $(C opEquals) 对类的参数类型为 $(C Object)：
)

---
class Clock {
    override bool opEquals($(HILITE Object o)) const {
        // ...
    }

    // ...
}
---

$(P
正如您将在下面看到的，该参数几乎从未直接使用。出于这个原因，将它简单的命名为 $(C o)，应该是可以接受的。大部分时间，该参数所做的第一件事是在类型转换中使用它。
)

$(P
$(C opEquals) 的参数是在$(C ==) 运算符的右手侧出现的对象：
)

---
    variable0 == variable1;    // o 表示 variable1
---

$(P
由于 $(C opEquals()) 的目的是比较类类型的两个对象，要做的第一件事是转换 $(C o) 为该类的同类型的一个变量。因为在一个相等性的比较中，修改右手侧的对象是不恰当的，所以转换它的类型为 $(C const) 也是合适的：
)

---
    override bool opEquals(Object o) const {
        auto rhs = cast(const Clock)o;

        // ...
    }
---

$(P
正如您所记得的，$(C rhs) 是 $(I right-hand side) 的通用缩写。同时，$(C std.conv.to) 用于转换：
)

---
import std.conv;
// ...
        auto rhs = to!(const Clock)(o);
---

$(P
如果在右手侧上的原始对象可转换为 $(C Clock)，则 $(C rhs) 变为非 $(C null) 类变量。否则，$(C rhs) 被设置为 $(C null)，这表明这俩对象不是同一类型。
)

$(P
根据程序的设计，它给人的感觉就像比较两个不相干的类型。在这儿我假设比较有效，$(C rhs) 不能是 $(C null)；因此，在下面的第一个逻辑表达式 $(C return) 语句检查，它非 $(C null)。否则，尝试访问 $(C rhs) 的成员将会产生错误：
)

---
class Clock {
    int hour;
    int minute;
    int second;

    override bool opEquals(Object o) const {
        auto rhs = cast(const Clock)o;

        return ($(HILITE rhs) &&
                (hour == rhs.hour) &&
                (minute == rhs.minute) &&
                (second == rhs.second));
    }

    // ...
}
---

$(P
根据定义， $(C Clock) 对象现在能根据它们的值做比较：
)

---
    auto variable0 = new Clock(6, 7, 8);
    auto variable1 = new Clock(6, 7, 8);

    assert(variable0 == variable1); // 现在它们相等
                                    // 因为它们的值
                                    // 相等
---

$(P
当定义 $(C opEquals) 时一定要记住，超类的成员是非常重要的。 例如，当比较 $(C AlarmClock) 时，给人感觉就是它也考虑到了继承的成员：
)

---
class AlarmClock : Clock {
    int alarmHour;
    int alarmMinute;

    override bool opEquals(Object o) const {
        auto rhs = cast(const AlarmClock)o;

        return (rhs &&
                (alarmHour == rhs.alarmHour) &&
                (alarmMinute == rhs.alarmMinute) &&
                $(HILITE super.opEquals(o)));
    }

    // ...
}
---

$(P
表达式将会写成 $(C super&nbsp;==&nbsp;o) 这样。然而，这将再次开始一个四步算法，结果就是代码可能有点慢。
)

$(H5 $(IX opCmp) $(C opCmp))

$(P
这个运算符会在排序类对象时用到。$(C opCmp) 函数将在后面 $(C <), $(C <=), $(C >), and $(C >=) 这些场景中被调用。
)

$(P
当左手侧对象在前时，该运算符返回负值，在后时，返回正值。当两个对象具有一致的排序顺序时为零。
)

$(P
$(B 注意：)函数的定义一定与 $(C opEquals()) 一致的；对象间的 $(C opEquals()) 返回 $(C true), $(C opCmp()) 一定返回0。
)

$(P
不像 $(C toString) 和 $(C opEquals)，$(C Object) 里没有这个函数的默认实现。如果实现不可用，为排序而比较对象会抛出异常：
)

---
    auto variable0 = new Clock(6, 7, 8);
    auto variable1 = new Clock(6, 7, 8);

    assert(variable0 <= variable1);    $(CODE_NOTE Causes exception)
---

$(SHELL
object.Exception: need opCmp for class deneme.Clock
)

$(P
当左、右手侧对象的类型不同时，它取决于程序的设计怎么做。一种方式是利用编译器自动保持的类型排序。这通过对两个类型的 $(C typeid) 值调用 $(C opCmp) 函数来实现：
)

---
class Clock {
    int hour;
    int minute;
    int second;

    override int opCmp(Object o) const {
        /* 利用自动保持的
         * 类型排序。 */
        if (typeid(this) != typeid(o)) {
            return typeid(this).opCmp(typeid(o));
        }

        auto rhs = cast(const Clock)o;
        /* 没有必要检查 rhs 是 null, 因为已经知道
         * 它与 o 具有同一类型。*/

        if (hour != rhs.hour) {
            return hour - rhs.hour;

        } else if (minute != rhs.minute) {
            return minute - rhs.minute;

        } else {
            return second - rhs.second;
        }
    }

    // ...
}
---

$(P
上面的定义首先检查两个对象的类型是否一致。若不一致，它使用他们自己的类型顺序。否则，它通过它们的 $(C hour), $(C minute), and $(C second) 成员值来比较对象。
)

$(P
A chain of ternary operators may also be used:
)

---
    override int opCmp(Object o) const {
        if (typeid(this) != typeid(o)) {
            return typeid(this).opCmp(typeid(o));
        }

        auto rhs = cast(const Clock)o;

        return (hour != rhs.hour
                ? hour - rhs.hour
                : (minute != rhs.minute
                   ? minute - rhs.minute
                   : second - rhs.second));
    }
---

$(P
如果重要，也一定要考虑比较成员的超类。下面 $(C AlarmClock.opCmp) 先被 $(C Clock.opCmp) 调用：
)

---
class AlarmClock : Clock {
    override int opCmp(Object o) const {
        auto rhs = cast(const AlarmClock)o;

        const int superResult = $(HILITE super.opCmp(o));

        if (superResult != 0) {
            return superResult;

        } else if (alarmHour != rhs.alarmHour) {
            return alarmHour - rhs.alarmHour;

        } else {
            return alarmMinute - rhs.alarmMinute;
        }
    }

    // ...
}
---

$(P
如前，如果超类的比较返回一个非零值，因为对象的排序已经由值决定，那结果就可用。
)

$(P
$(C AlarmClock) objects 因为它们的排序顺序现在可以比较：
)

---
    auto ac0 = new AlarmClock(8, 0, 0, 6, 30);
    auto ac1 = new AlarmClock(8, 0, 0, 6, 31);

    assert(ac0 < ac1);
---

$(P
$(C opCmp) 也被其它语言的特征和库使用。例如，$(C sort()) 函数利用 $(C opCmp) 排序元素。
)

$(H6 字符串成员的 $(C opCmp))

$(P
当一些成员是字符串时，它们能被明确比较来返回负值，正徝，或零值：
)

---
import std.exception;

class Student {
    string name;

    override int opCmp(Object o) const {
        auto rhs = cast(Student)o;
        enforce(rhs);

        if (name < rhs.name) {
            return -1;

        } else if (name > rhs.name) {
            return 1;

        } else {
            return 0;
        }
    }

    // ...
}
---

$(P
另外，也可以使用现有的 $(C std.algorithm.cmp) 函数，这恐怕更快：
)

---
import std.algorithm;

class Student {
    string name;

    override int opCmp(Object o) const {
        auto rhs = cast(Student)o;
        enforce(rhs);

        return cmp(name, rhs.name);
    }

    // ...
}
---

$(P
注意，$(C Student) 不支持比较不相容的类型，通过执行由 $(C Object) 到 $(C Student) 的转换，那就可以了。
)

$(H5 $(IX toHash) $(C toHash))

$(P
该函数允许类的类型的对象做为关联数组的 $(I keys)。 它不影响类型用作关联数组的 $(I values)。
)

$(P
$(B 注意：)只定义这个函数是不够的。为了让类类型能被用做关联数组的键，也一定要做 $(C opEquals) 和 $(C opCmp) 的一致性定义。
)

$(H6 $(IX hash table) 哈希表索引)

$(P
关联数组是一个哈希表实现。哈希表是一个在表中搜索元素时速度非常快的数据结构。($(I 注：像软件界大部分别的事情一样，速度决定价值：哈希表一定保持元素无序，而且它们占据超过完全必需的空间。))
)

$(P
哈希表的高速来自于它们最初为键产生整数值。这些整数值叫做 $(I hash values). 哈希值被用作索引，放在由表维护的整数数组里。
)

$(P
这种方法的好处是能为它们的对象产生唯一整数值的任何类型都能用作关联数组的键类型。$(C toHash) 是为对象返回哈希值的函数。
)

$(P
甚至 $(C Clock) 对象能被用作关联数组的键值：
)

---
    string[$(HILITE Clock)] timeTags;
    timeTags[new Clock(12, 0, 0)] = "Noon";
---

$(P
$(C toHash) 的默认定义是继承自 $(C Clock)，对不同的对象产生不同的哈希值，不涉及它们的值。这个跟 $(C opEquals) 把不同对象视为不相等的默认行为很相似。
)

$(P
对 $(C Clock) 即使没有特殊的 $(C toHash) 定义，上面的代码也编译运行。然而，它的默认行为几乎没有必要。为看到默认行为，当插入元素时，我们来尝试访问一个对象的元素，该对象不同于已有对象。然而，当把下面新的 $(C Clock) 对象插入上面的关联数组时，虽与已有的 $(C Clock) 对象有相同的值，但值还是没找到：
)

---
    if (new Clock(12, 0, 0) in timeTags) {
        writeln("Exists");

    } else {
        writeln("Missing");
    }
---

$(P
由 $(C in) 运算符得知，表中没有元素符合 $(C Clock(12,&nbsp;0,&nbsp;0)) 的值：
)

$(SHELL
Missing
)

$(P
这个让人惊讶的行为的原因是那个插入元素时已有的键对象与访问元素时那个已有的键对象并不相同。
)

$(H6 为 $(C toHash) 选取成员)

$(P
虽然哈希值计算自对象的成员，但并不是每个成员都适合作这个任务。
)

$(P
候选成员应能分清各个对象。例如，$(C Student) 中的 $(C name) 和  $(C lastName) 适合作能识别对象类型的成员。
)

$(P
另一方面， $(C Student) 类中的 $(C grades) 数组是不适合的，因为好多对象有一样的数组而且 $(C grades) 数组也有可能随着时间的变化而改变。
)

$(H6 哈希值的计算)

$(P
哈希值的选择对关联数组的性能有直接的影响。此外，一个数据类型的哈希计算有效，并不代表另一个同样有效。As $(I hash 算法) 超出了本书的范围，在这儿我将只给一个引导：通常，最好是有不同值的对象产生不同的哈希值。然而，有不同值的对象产生同一索引值并不是一个错误；只是因为性能原因而不受欢迎。
)

$(P
可以想到，对于区分不同对象， $(C Clock) 的所有成员都一样。因此，可从三个成员的值来计算哈希值。对于表示不同时间点的对象，$(I 午夜后的秒钟数) 将是有效的哈希值：
)

---
class Clock {
    int hour;
    int minute;
    int second;

    override size_t toHash() const {
        /* Because there are 3600 seconds in an hour and 60
         * seconds in a minute: */
        return (3600 * hour) + (60 * minute) + second;
    }

    // ...
}
---

$(P
只要 $(C Clock) 被用作关联数组的键类型， $(C toHash) 的特殊定义就可用。 因此，尽管上面两个 $(C Clock(12,&nbsp;0,&nbsp;0)) 键对象截然不同，它们也将产生同一个哈希值。
)

$(P
新的输出：
)

$(SHELL
Exists
)

$(P
类似于其它成员函数，可能需要考虑一下超类。例如，在索引计算期间， $(C AlarmClock.toHash) 可以利用 $(C Clock.toHash) ：
)

---
class AlarmClock : Clock {
    int alarmHour;
    int alarmMinute;

    override size_t toHash() const {
        return $(HILITE super.toHash()) + alarmHour + alarmMinute;
    }

    // ...
}
---

$(P
$(I $(B 注：)以上所做的计算只是一个例子。一般情况下，填加整数值并不是一种有效的产生哈希值的方式。)
)

$(P
现有的计算哈希值的高效算法主要是针对浮点变量、数组、结构类型。这些算法对程序员来说是可用的。
)

$(P
$(IX getHash) 所作的就是对每个成员的 $(C typeid) 调用 $(C getHash()) 。这种方法的语法对浮点、数组、类结构都是一样的。
)

$(P
例如，在下面的代码中， $(C Student) 类型的哈希值可以使用$(C name) 成员来计算：
)

---
class Student {
    string name;

    override size_t toHash() const {
        return typeid(name).getHash(&name);
    }

    // ...
}
---

$(H6 结构的哈希值)

$(P
由于结构是值类型，对它们的对象的哈希值通过一个高效算法来自动计算。那个算法把对象的所有成员都考虑进去了。
)

$(P
特殊情况下，像哈希计算时需要排除某些确定成员，也可重写结构的 $(C toHash()) 。 
)

$(PROBLEM_COK

$(PROBLEM
首先用下面的类表示带颜色的点：

---
enum Color { blue, green, red }

class Point {
    int x;
    int y;
    Color color;

    this(int x, int y, Color color) {
        this.x = x;
        this.y = y;
        this.color = color;
    }
}
---

$(P
对该类用忽略颜色的方法实现 $(C opEquals) 。在实现之后，下面的 $(C assert) 检查应该通过：
)

---
    // 不同的颜色
    auto bluePoint = new Point(1, 2, Color.blue);
    auto greenPoint = new Point(1, 2, Color.green);

    // 它们仍然相等
    assert(bluePoint == greenPoint);
---

)

$(PROBLEM
通过先考虑$(C x) 然后 $(C y) 来实现 $(C opCmp) 。随后的 $(C assert) 检查应该通过：

---
    auto redPoint1 = new Point(-1, 10, Color.red);
    auto redPoint2 = new Point(-2, 10, Color.red);
    auto redPoint3 = new Point(-2,  7, Color.red);

    assert(redPoint1 < bluePoint);
    assert(redPoint3 < redPoint2);

    /* 在 enum Color 中，即使 蓝色在绿色之前，
     *因为颜色已被忽略，bluePoint 不一定
     * 在greenPoint之前。*/
    assert(!(bluePoint < greenPoint));
---

$(P
像上面的 $(C Student) 类，在 $(C enforce) 的帮助下，通过排除不符合的类型，你能实现 $(C opCmp)。
)

)

$(PROBLEM
考虑一下下面的类，在一个数组中有三个 $(C Point)  对象：

---
class TriangularArea {
    Point[3] points;

    this(Point one, Point two, Point three) {
        points = [ one, two, three ];
    }
}
---

$(P
对该类实现 $(C toHash) 。紧接着 $(C assert) 检查应该再次通过：
)

---
    /* area1 和 area2 由明显不同的点构造
     * 即使有相同的值。(记得
     * bluePoint 和 greenPoint 应该被认为是相等的。) */
    auto area1 = new TriangularArea(bluePoint, greenPoint, redPoint1);
    auto area2 = new TriangularArea(greenPoint, bluePoint, redPoint1);

    // 它们应该是相等的
    assert(area1 == area2);

    // 一个关联数组
    double[TriangularArea] areas;

    //  由area1存进一个值
    areas[area1] = 1.25;

    // area2访问这个值
    assert(area2 in areas);
    assert(areas[area2] == 1.25);
---

$(P
记住在定义 $(C toHash) 的时候也一定要定义 $(C opEquals) 和 $(C opCmp) 。
)

)

)

Macros:
        SUBTITLE=Object

        DESCRIPTION=Object，D语言里类继承结构中最顶层的类

        KEYWORDS=D 语言编程教程 class Object opEquals opCmp toHash toString
