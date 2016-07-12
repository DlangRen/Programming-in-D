Ddoc

$(DERS_BOLUMU $(IX 关联数组) $(IX AA) 关联数组)

$(P
关联数组是大多数现代高级编程语言所具有的功能。它们是高速的数据结构，如迷你数据库一样地运作，在很多程序里都用到了。
)

$(P
在 $(LINK2 /ders/d.cn/arrays.html, 数组) 一章中我们已经看到简单数组作为容器逐个存储元素，按索引访问它们。一个存储了星期的英文名称的数组可以这样定义：
)

---
    string[] dayNames =
        [ "Monday", "Tuesday", "Wednesday", "Thursday",
          "Friday", "Saturday", "Sunday" ];
---

$(P
在数组里通过索引访问特定的英文日期名：
)

---
    writeln(dayNames[1]);   // 打印 “Tuesday”
---

$(P
事实上简单数组通过索引访问值可以被描述为索引与值的$(I 关联) 。换句话说，数组映射索引到值。简单数组只能使用整型做索引。
)

$(P
关联数组允许索引不只是整型而是任何类型。它们映射一种类型的值到另一种类型的值上。关联数组用于$(I 映射)的类型的值叫$(I 键)，而不是索引。关联数组通过键值对存储它们的元素。
)

$(P
在D语言中，关联数组是一个 $(I hash 表) 实现。Hash 表是存储和访问元素的最快的集合。除极个别情况外，一般存取单个元素所花费的时间不依赖于关联数组中元素的个数。
)

$(P
hash 表的高性能的代价是元素的存储是无序的。不像数组，hash 表的元素不是逐个排列存储的。
)

$(P
对于简单数组，索引值根本就没有存储。因为在内存中数组元素是逐个存储的，索引值就是元素位置与数组的起始位置的相对值。
)

$(P
另一方面，关联数组既存储键又存储元素值。虽然这种不同让关联数组使用更多内存，但它也允许它们使用$(I 稀疏)键值。例如，对于键 0 和 999，当只有两个元素要存储时，关联数组就只存储两个元素，而不像简单数组那样必须 1000 个。
)

$(H5 定义)

$(P
关联数组的语法与数组相似。不同的是方框号中指定的是键的类型，而不是数组的长度：
)

---
    $(I 值类型)[$(I 键类型)] $(I 关联数组名);
---

$(P
例如，下面这个关联数组这样定义，它把日期名的类型 $(C string) 映射到日期的数字类型 $(C int) ：
)

---
    int[string] dayNumbers;
---

$(P
上面的 $(C dayNumbers) 变量是一个关联数组，它能用来作为从日期名映射到日期数字的表。换句话说，它能用作本章开始处 $(C dayNames) 数组的逆转。在下面的例子中我们将使用 $(C dayNumbers) 关联数组。
)

$(P
关联数组的键可以是任何类型，包括用户定义的 $(C struct) 和 $(C class) 类型。在稍后的章节中我们将看到用户定义类型。
)

$(P
定义时，不能指定关联数组的长度。它们随着键值对的添加而自动增长。
)

$(P
$(I $(B 注：) 已定义的没有任何元素的关联数组是 $(LINK2 /ders/d.cn/null_is.html, $(C null))，而不是空。当 $(LINK2 /ders/d.cn/function_parameters.html, 传关联数组给函数) 时，这种区分具有重要意义。在稍后的章节中我们将涵盖这些概念。)
)

$(H5 添加键值对)

$(P
使用赋值运算符就足以构建键与值的关联：
)

---
    // 关联值 0 与 键 “Monday”
    dayNumbers["Monday"] $(HILITE =) 0;

    // 关联值 1 与 键 “Tuesday”
    dayNumbers["Tuesday"] $(HILITE =) 1;
---

$(P
随着每次的关联，该表会自动增长。例如，上面的操作结束后 $(C dayNumbers) 将有两个键值对。这可以通过打印整个表来验证：
)

---
    writeln(dayNumbers);
---

$(P
下面的输出表明了元素值 0 和 1 分别对应着键 “Monday” 和 “Tuesday”：
)

$(SHELL
["Monday":0, "Tuesday":1]
)

$(P
每个键有且仅有一个对应值。因而，给一个存在的键赋值，表不增长，而现有键所对应的值会发生变化：
)

---
    dayNumbers["Tuesday"] = 222;
    writeln(dayNumbers);
---

$(P
The output:
)

$(SHELL
["Monday":0, "Tuesday":222]
)


$(H5 初始化)

$(P
$(IX :, 关联数组) 有时候一些键与值的映射在定义关联数组的时候就已经明确。关联数组的初始化与常规数组相似，不同的是用冒号分隔每个键与相应的值：
)

---
    // key : value
    int[string] dayNumbers =
        [ "Monday"   : 0, "Tuesday" : 1, "Wednesday" : 2,
          "Thursday" : 3, "Friday"  : 4, "Saturday"  : 5,
          "Sunday"   : 6 ];

    writeln(dayNumbers["Tuesday"]);    // 打印 1
---

$(H5 $(IX remove) 移除键值对)

$(P
通过 $(C .remove()) 可以移除键值对：
)

---
    dayNumbers.remove("Tuesday");
    writeln(dayNumbers["Tuesday"]);    // ← 运行时错误
---

$(P
上面第一行移除了键值对 "Tuesday" / $(C 1). 由于键已不存在于容器中， 因而第二行将引发一个异常，如果异常没有被捕获，程序将终止。在 $(LINK2 /ders/d.cn/exceptions.html, 稍后的一章) 中我们将看到异常。
)

$(P
$(C .clear) 移除全部元素：
)

---
    dayNumbers.clear;    // 清空关联数组
---

$(H5 $(IX in, 关联数组) 确定键的存在)

$(P
$(C in) 运算符确定一个给定的键是否存在于关联数组中：
)

---
    int[string] colorCodes = [ /* ... */ ];

    if ("purple" $(HILITE in) colorCodes) {
        // 键 “purple” 在表中

    } else {
        //表中不存在 键 “purple” 
    }
---

$(P
有时候在关联数组中，为不存在的键使用一个默认值是有道理的。例如，特殊值 -1 用作不在 $(C colorCodes) 中的  colors 代码。$(C .get()) 在这样的样例中是有用的：如果指定键存在则返回相应值，否则返回默认值。默认值被指定为 $(C .get()) 的第2个参数：
)

---
    int[string] colorCodes = [ "blue" : 10, "green" : 20 ];
    writeln(colorCodes.get("purple", $(HILITE -1)));
---

$(P
由于键 $(STRING "purple") 的值不在数组中，$(C .get()) 返回 -1：
)

$(SHELL
-1
)

$(H5 Properties（属性）)

$(UL

$(LI $(IX .length) $(C .length) 返回键值对的个数。)

$(LI $(IX .keys) $(C .keys) 返回全部键的动态数组副本。)

$(LI $(IX .byKey) $(C .byKey) 提供对键的直接访问；在下一章我们将看到在 $(C foreach) 循环中如何使用 $(C .byKey) 。)

$(LI $(IX .values) $(C .values) 返回全部值的动态数组副本。)

$(LI $(IX .byValue) $(C .byValue) 提供对值的直接访问。)

$(LI $(IX .byKeyValue) $(C .byKeyValue) 提供对键值对的直接访问。)

$(LI $(IX .rehash) $(C .rehash) 在一些例子中可以让数组更有效率，比如在插入大量的键值对之后。)

$(LI $(IX .sizeof, associative array) $(C .sizeof) 数组$(I 引用)大小（它不受表中键值对个数的影响，对所有的关联数组来说值都是一样的）。)

$(LI $(IX .get) $(C .get) 值存在即返回相应值，否则返回默认值。)

$(LI $(IX .remove) $(C .remove) 从数组中移除指定的键和值。)

$(LI $(IX .clear) $(C .clear) 移除全部元素。)

)

$(H5 样例)

$(P
这是一段打印英文颜色的土耳其语表达的程序，它的键指定为英文：
)

---
import std.stdio;
import std.string;

void main() {
    string[string] colors = [ "black" : "siyah",
                              "white" : "beyaz",
                              "red"   : "kırmızı",
                              "green" : "yeşil",
                              "blue"  : "mavi" ];

    writefln("I know the Turkish names of these %s colors: %s",
             colors.length, colors.keys);

    write("Please ask me one: ");
    string inEnglish = strip(readln());

    if (inEnglish in colors) {
        writefln("\"%s\" is \"%s\" in Turkish.",
                 inEnglish, colors[inEnglish]);

    } else {
        writeln("I don't know that one.");
    }
}
---

$(PROBLEM_COK

$(PROBLEM
除 $(C .clear) 函数外还有什么方法能移除关联数组的全部键值对？ ($(C .clear) 是最自然的方法。) 至少还有三种方法：

$(UL

$(LI 从关联数组中逐个移除它们。)

$(LI 用一个空的关联数组赋值。)

$(LI 与前一方法相似，用数组的 $(C .init) 属性赋值。

$(P
$(IX .init, 清除一个变量) $(I $(B 注：) 任何变量或类型的 $(C .init) 属性是类型的初始值：)
)

---
    number = int.init;    // int 值：0 
---
)

)

)

$(PROBLEM
与数组一样，每个键有且仅有一个值。对某些程序来说可能是个限制。

$(P
假设使用关联数组来存储学生成绩。例如，我们假设存储学生“emre”的成绩 90，85，95 等等。
)

$(P
在 $(C grades["emre"]) 中通过学生姓名关联数组让它很容易访问到成绩。然而，不能像下面的代码这样插入成绩，因为后来的成绩将覆盖前一个：
)

---
    int[string] grades;
    grades["emre"] = 90;
    grades["emre"] = 85;   // ← 覆盖前一个成绩！
---

$(P
怎么解决这个问题？定义一个能存储每个学生的多个成绩的关联数组。
)

)

)

Macros:
        SUBTITLE=关联数组

        DESCRIPTION=D语言的关联数组。

        KEYWORDS=D 编程语言教程 关联数组
