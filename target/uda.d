Ddoc

$(DERS_BOLUMU $(IX user defined attributes) $(IX UDA) 自定义属性（UDA）)

$(P
所有声明（如结构、类和变量等）都可以加上属性，以便在编译时访问这些属性来调整该部分代码的编译方式。自定义属性完全是一项编译时功能。
)

$(P
$(IX @)自定义属性的语法格式：符号 $(C @)  的后面紧跟属性名，并且需要放置在与之相关的那个声明前面。例如，下面代码会将 $(C Encrypted) 属性赋予 $(C name) 声明：
)

---
    $(HILITE @Encrypted) string name;
---

$(P
多个属性可以分别指定，也可以采用括号列表形式。例如，下面的变量拥有的属性是相同的：
)

---
    @Encrypted @Colored string lastName;     $(CODE_NOTE 单独分开)
    @$(HILITE $(PARANTEZ_AC))Encrypted, Colored$(HILITE $(PARANTEZ_KAPA)) string address;    $(CODE_NOTE 组合一起)
---

$(P
属性除了可以是自定义类型值或基础类型值以外，还可是以类型名。不过，因为它们的含义可能不是很清楚，因此不赞成大家使用文字量值（如 $(C 42) ）构成的属性：
)

---
$(CODE_NAME Encrypted)struct Encrypted {
}

enum Color { black, blue, red }

struct Colored {
    Color color;
}

void main() {
    @Encrypted           int a;    $(CODE_NOTE 类型名)
    @Encrypted()         int b;    $(CODE_NOTE 对象)
    @Colored(Color.blue) int c;    $(CODE_NOTE 对象)
    @(42)                int d;    $(CODE_NOTE 文字量（不赞成）)
}
---

$(P
上面 $(C a) 和 $(C b) 的属性属于不同类别：$(C a) 的属性是 $(C Encrypted) 类型，而 $(C b) 的属性是 $(C Encrypted) 类型的一个$(I 对象)。它们有着明显的差异，它会对编译时属性的使用方式产生影响。下面来看一个与该差异有关的例子。
)

$(P
$(IX __traits) $(IX getAttributes) 属性的实际含义完全由程序员根据程序的需要来决定。编译时可以通过 $(C __traits(getAttributes)) 来判定属性，而相应代码则会根据那些属性来编译。
)

$(P
下面代码展示的是如何使用使用$(C __traits(getAttributes))来访问某个特定 $(C struct) 成员（如 $(C Person.name)）的属性：
)

---
$(CODE_NAME Person)import std.stdio;

// ...

struct Person {
    @Encrypted @Colored(Color.blue) string name;
    string lastName;
    @Colored(Color.red) string address;
}

void $(CODE_DONT_TEST)main() {
    foreach (attr; __traits($(HILITE getAttributes), Person.name)) {
        writeln(attr.stringof);
    }
}
---

$(P
这个程序的输出内容是 $(C Person.name) 的各个属性：
)

$(SHELL
Encrypted
Colored(cast(Color)1)
)

$(P
在处理自定义属性时，还有其他两个 $(C __traits) 表达式可以使用：
)

$(UL

$(LI $(IX allMembers) $(C __traits(allMembers)) 会以字符串列表的形式生成某个类型（或模块）的所有成员。)

$(LI $(IX getMember) $(C __traits(getMember)) 会生成一个 $(I 符号)，可以在访问某个成员时使用它。它的第一个参数是符号（如类型或者变量名），第二个参数是字符串。它会生成一个符号，其组成部分包含了它的第一个参数、一个小数点和它的第二个参数。例如，$(C __traits(getMember, Person, $(STRING "name"))) 生成的符号是 $(C Person.name)。
)

)

---
$(CODE_XREF Encrypted)$(CODE_XREF Person)import std.string;

// ...

void main() {
    foreach (memberName; __traits($(HILITE allMembers), Person)) {
        writef("The attributes of %-8s:", memberName);

        foreach (attr; __traits(getAttributes,
                                __traits($(HILITE getMember),
                                         Person, memberName))) {
            writef(" %s", attr.stringof);
        }

        writeln();
    }
}
---

$(P
此程序的输出会列出 $(C Person) 的所有成员的所有属性：
)

$(SHELL
The attributes of name    : Encrypted Colored(cast(Color)1)
The attributes of lastName:
The attributes of address : Colored(cast(Color)2)
)

$(P
$(IX hasUDA, std.traits) 另一个有用的工具是 $(C std.traits.hasUDA)，它可检测某个符号是否拥有某个特定的属性。下面的 $(C static assert) 会顺利通过，因为 $(C Person.name) 拥有 $(C Encrypted) 属性：
)

---
import std.traits;

// ...

static assert(hasUDA!(Person.name, Encrypted));
---

$(P
$(C hasUDA) 除了可以与属性类型的特定值一起使用外，还可以与属性类型一起使用。下面的两个 $(C static assert) 都会顺利通过，因为 $(C Person.name) 拥有 $(C Colored(Color.blue)) 属性：
)

---
static assert(hasUDA!(Person.name, $(HILITE Colored)));
static assert(hasUDA!(Person.name, $(HILITE Colored(Color.blue))));
---

$(H5 样例)

$(P
一起来设计一个函数模板，让它以XML格式输出一个 $(C struct) 对象的所有成员的值。下面这个函数在生成输出内容时会使用到每个成员的 $(C Encrypted) 和 $(C Colored) 属性：
)

---
void printAsXML(T)(T object) {
// ...

    foreach (member; __traits($(HILITE allMembers), T)) {             // (1)
        string value =
            __traits($(HILITE getMember), object, member).to!string;  // (2)

        static if ($(HILITE hasUDA)!(__traits(getMember, T, member),  // (3)
                           Encrypted)) {
            value = value.encrypted.to!string;
        }

        writefln(`  <%1$s color="%2$s">%3$s</%1$s>`, member,
                 $(HILITE colorAttributeOf)!(T, member), value);      // (4)
    }
}
---

$(P
下面来解释一下这段代码的高亮部分：
)

$(OL

$(LI 该类型的所有成员可以通过 $(C __traits(allMembers)) 获得。)

$(LI 每个成员值都被转换为 $(C string)，以便后面输出时使用。例如，当成员为 $(STRING "name") 时，对应的表达式会变成 $(C object.name.to!string)。)

$(LI 每个成员都使用 $(C hasUDA) 来测试，以便确定它是否拥有 $(C Encrypted) 特性。如果该成员拥有此属性，则它的值会被加密。（因为 $(C hasUDA) 需要 $(I 符号) 才能工作，请参考一下如何使用 $(C __traits(getMember)) 以符号方式（如 $(C Person.name)）获取成员的。）)

$(LI 每个成员的 color 属性可以使用 $(C colorAttributeOf()) 来检测。下面便来看看这个方法。)

)

$(P
函数模板 $(C colorAttributeOf()) 可以实现成下面的样子：
)

---
Color colorAttributeOf(T, string memberName)() {
    foreach (attr; __traits(getAttributes,
                            __traits(getMember, T, memberName))) {
        static if (is ($(HILITE typeof(attr)) == Colored)) {
            return attr.color;
        }
    }

    return Color.black;
}
---

$(P
当编译时计算完成时，函数模板 $(C printAsXML()) 会根据 $(C Person) 类型实例化，并与下面这个函数相似：
)

---
/* printAsXML!Person 实例的等同函数。*/
void printAsXML_Person(Person object) {
// ...

    {
        string value = object.$(HILITE name).to!string;
        $(HILITE value = value.encrypted.to!string;)
        writefln(`  <%1$s color="%2$s">%3$s</%1$s>`,
                 "name", Color.blue, value);
    }
    {
        string value = object.$(HILITE lastName).to!string;
        writefln(`  <%1$s color="%2$s">%3$s</%1$s>`,
                 "lastName", Color.black, value);
    }
    {
        string value = object.$(HILITE address).to!string;
        writefln(`  <%1$s color="%2$s">%3$s</%1$s>`,
                 "address", Color.red, value);
    }
}
---

$(P
列出整个程序代码更能说明问题：
)

---
import std.stdio;
import std.string;
import std.algorithm;
import std.conv;
import std.traits;

/* 特别要求加密应用此自定义属性
 * 的那个符号。*/
struct Encrypted {
}

enum Color { black, blue, red }

/* 特别指定应用此自定义属性的那个符号的颜色。
 * 默认颜色为 Color.black。*/
struct Colored {
    Color color;
}

struct Person {
    /* 此成员被特定要求加密，并且输出为
     * 蓝色。*/
    @Encrypted @Colored(Color.blue) string name;

    /* 这个成员没有自定义
     * 属性。*/
    string lastName;

    /* 此成员被特定要求输出为红色。*/
    @Colored(Color.red) string address;
}

/* 如果被特定要求的成员拥有 Colored 属性，
 * 则输出它的值，否则输出 Color.black。*/
Color colorAttributeOf(T, string memberName)() {
    auto result = Color.black;

    foreach (attr;
             __traits(getAttributes,
                      __traits(getMember, T, memberName))) {
        static if (is (typeof(attr) == Colored)) {
            result = attr.color;
        }
    }

    return result;
}

/* 返回指定字符串的 Caesar 加密
 * 版本。（警告：Caesar cipher 是一种强度很弱的
 * 加密方法。） */
auto encrypted(string value) {
    return value.map!(a => dchar(a + 1));
}

unittest {
    assert("abcdefghij".encrypted.equal("bcdefghijk"));
}

/* 根据指定对象的各个成员的属性
 * 以 XML 格式输出它。*/
void printAsXML(T)(T object) {
    writefln("<%s>", T.stringof);
    scope(exit) writefln("</%s>", T.stringof);

    foreach (member; __traits(allMembers, T)) {
        string value =
            __traits(getMember, object, member).to!string;

        static if (hasUDA!(__traits(getMember, T, member),
                           Encrypted)) {
            value = value.encrypted.to!string;
        }

        writefln(`  <%1$s color="%2$s">%3$s</%1$s>`,
                 member, colorAttributeOf!(T, member), value);
    }
}

void main() {
    auto people = [ Person("Alice", "Davignon", "Avignon"),
                    Person("Ben", "de Bordeaux", "Bordeaux") ];

    foreach (person; people) {
        printAsXML(person);
    }
}
---

$(P
上面程序的输出内容包含那些拥有正确颜色的成员和被加密过的  $(C name) 成员：
)

$(SHELL
&lt;Person&gt;
  &lt;name color="blue"&gt;Bmjdf&lt;/name&gt;                $(SHELL_NOTE 蓝色且加密)
  &lt;lastName color="black"&gt;Davignon&lt;/lastName&gt;
  &lt;address color="red"&gt;Avignon&lt;/address&gt;         $(SHELL_NOTE 红色)
&lt;/Person&gt;
&lt;Person&gt;
  &lt;name color="blue"&gt;Cfo&lt;/name&gt;                  $(SHELL_NOTE 蓝色且加密)
  &lt;lastName color="black"&gt;de Bordeaux&lt;/lastName&gt;
  &lt;address color="red"&gt;Bordeaux&lt;/address&gt;        $(SHELL_NOTE 红色)
&lt;/Person&gt;
)

$(H5 自定义属性的好处)

$(P
自定义属性的好处在于能够更改声明的属性，且不需要更改程序的其他部分。例如，$(C Person) 的所有成员在 XML 格式输出里都会被加密，类似下面内容：
)

---
struct Person {
    $(HILITE @Encrypted) {
        string name;
        string lastName;
        string address;
    }
}

// ...

    printAsXML(Person("Cindy", "de Cannes", "Cannes"));
---

$(P
输出：
)

$(SHELL
&lt;Person&gt;
  &lt;name color="black"&gt;Djoez&lt;/name&gt;              $(SHELL_NOTE 已加密)
  &lt;lastName color="black"&gt;ef!Dbooft&lt;/lastName&gt;  $(SHELL_NOTE 已加密)
  &lt;address color="black"&gt;Dbooft&lt;/address&gt;       $(SHELL_NOTE 已加密)
&lt;/Person&gt;
)

$(P
此外，$(C printAsXML()) 和它涉及到的属性还可以与其他类型一起使用：
)

---
struct Data {
    $(HILITE @Colored(Color.blue)) string message;
}

// ...

    printAsXML(Data("hello world"));
---

$(P
输出：
)

$(SHELL
&lt;Data&gt;
  &lt;message color="blue"&gt;hello world&lt;/message&gt;    $(SHELL_NOTE 蓝色)
&lt;/Data&gt;
)

$(H5 小结)

$(UL

$(LI 自定义属性可用于任何声明。)

$(LI 自定义属性可以是类型名，也可以是具体值。)

$(LI 自定义属性在编译时可以通过 $(C hasUDA) 和 $(C __traits(getAttributes)) 来访问，以便达到更改程序编译方式的目的。)

)

macros:
        SUBTITLE=自定义属性（UDA）

        DESCRIPTION=为声明加上自定义属性、在编译时检测属性，并根据那些属性编译代码。

        KEYWORDS=d programming language tutorial book user defined attributes UDA D 编程语言 教程 书籍 自定义属性
