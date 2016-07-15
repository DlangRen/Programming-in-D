Ddoc

$(DERS_BOLUMU $(IX alias this) $(CH4 alias this))

$(P
在前面的章节中，我们已经看到独立的 $(C alias) 和 $(C this) 关键字的作用，然而，这两个关键字同时使用时，即 $(C alias&nbsp;this)，意思就完全不同了。
)

$(P
$(IX 自动类型转换) $(IX 类型转换, 自动) $(C alias this) 允许用户自定类型的 $(I 自动类型转换) (通常也作 $(I 隐式类型转换))。 我们已经在 $(LINK2 /ders/d.cn/operator_overloading.html, 运算符重载) 一章中看到另外一种类型转换的方式，即为要转到的类型定义 $(C opCast)。不同之处在于，$(C opCast) 用于显式类型转换，而 $(C alias this) 用于自动类型转换。
)

$(P
关键字 $(C alias) 和 $(C this) 要分开写，中间指定成员变量或者成员函数：
)

---
    alias $(I 成员变量或成员函数) this;
---

$(P
$(C alias this) 允许指定从用户自定义类型到该成员的转换，成员的值即转换的结果。
)

$(P
如下的 $(C Fraction) 例子中使用 $(C alias this) 的同时用到了一个 $(I 成员函数)。更下面的 $(C TeachingAssistant) 例子中将使用 $(I 成员变量)。
)

$(P
因为 $(C value()) 的返回值是 $(C double)，所以下面的 $(C alias this) 允许 $(C Fraction) 对象到 $(C double) 值的自动转换：
)

---
import std.stdio;

struct Fraction {
    long numerator;
    long denominator;

    $(HILITE double value()) const @property {
        return double(numerator) / denominator;
    }

    alias $(HILITE value) this;

    // ...
}

double calculate(double lhs, double rhs) {
    return 2 * lhs + rhs;
}

void main() {
    auto fraction = Fraction(1, 4);    // 表示 1/4
    writeln(calculate($(HILITE fraction), 0.75));
}
---

$(P
在 $(C Fraction) 对象出现的地方，如果需要的是一个 $(C double)，$(C value()) 就会被自动调用以产生一个 $(C double) 类型的值。这就是为什么 $(C fraction) 可以作为 $(C calculate()) 的参数的原因。$(C value()) 返回 1/4 的值，即 0.25，程序将会输出 2 * 0.25 + 0.75 的结果：
)

$(SHELL
1.25
)

$(H5 $(IX 多重继承) $(IX 继承, 多重) 多重继承)

$(P
我们已经在 $(LINK2 /ders/d.cn/inheritance.html, 继承) 一章中看到类（class）只能继承自一个 $(C class)。（另一方面，$(C 接口) 继承的数量并没有限制。）一些其他的面向对象语言允许同时继承自多个类，这叫做 $(I 多重继承)。
)

$(P
通过 $(C alias this)，用 D 的 class 也可以做多重继承的设计，多个 $(C alias this) 的声明用于表示多个不同的类型。
)

$(P
$(HILITE $(I $(B 注意:) dmd 2.071，编译此章节例子的最新编译器，只允许一个 $(C alias this) 声明。))
)

$(P
下面的 $(C TeachingAssistant) class 有两个成员成员变量，类型分别为 $(C Student) 和 $(C Teacher)，$(C alias this) 声明将允许这个类型用在任何需要 $(C Student) 或 $(C Teacher) 类型的地方：
)

---
import std.stdio;

class Student {
    string name;
    uint[] grades;

    this(string name) {
        this.name = name;
    }
}

class Teacher {
    string name;
    string subject;

    this(string name, string subject) {
        this.name = name;
        this.subject = subject;
    }
}

class TeachingAssistant {
    Student studentIdentity;
    Teacher teacherIdentity;

    this(string name, string subject) {
        this.studentIdentity = new Student(name);
        this.teacherIdentity = new Teacher(name, subject);
    }

    /* 下面的两个 ‘alias this’ 声明将允许 this 类型可以同时用作
     * Student 或 Teacher。
     *
     * 注意: dmd 2.071 不支持多个 ‘alias this’ 声明 */
    alias $(HILITE teacherIdentity) this;
    $(CODE_COMMENT_OUT compiler limitation)alias $(HILITE studentIdentity) this;
}

void attendClass(Teacher teacher, Student[] students)
in {
    assert(teacher !is null);
    assert(students.length > 0);

} body {
    writef("%s is teaching %s to the following students:",
           teacher.name, teacher.subject);

    foreach (student; students) {
        writef(" %s", student.name);
    }

    writeln();
}

void main() {
    auto students = [ new Student("Shelly"),
                      new Student("Stan") ];

    /* 对象可以同时用作 Teacher 或 Student： */
    auto tim = new TeachingAssistant("Tim", "math");

    // 'tim' 作为一个 teacher：
    attendClass($(HILITE tim), students);

    // 'tim' 作为一个 student：
    auto amy = new Teacher("Amy", "physics");
    $(CODE_COMMENT_OUT compiler limitation)attendClass(amy, students ~ $(HILITE tim));
}
---

$(P
程序输出表明相同的对象被用作两个不同的类型：
)

$(SHELL
$(HILITE Tim) is teaching math to the following students: Shelly Stan
Amy is teaching physics to the following students: Shelly Stan $(HILITE Tim)
)

Macros:
        SUBTITLE=alias this

        DESCRIPTION=通过 ‘alias this’ 提供到其他类型的自动转换。

        KEYWORDS=d 编程 语言 教程 学习 alias 别名 alias this

SOZLER=
$(kalitim)

