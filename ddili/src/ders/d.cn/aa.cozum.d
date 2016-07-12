Ddoc

$(COZUM_BOLUMU 关联数组)

$(OL

$(LI

$(UL

$(LI
$(C .keys) property（属性）返回一个切片(即 动态数组)，它包含了关联数组全部的键。迭代这个切片，通过为每个键调用 $(C .remove) 函数来移除元素，就会形成一个空的关联数组：

---
import std.stdio;

void main() {
    string[int] names =
    [
        1   : "one",
        10  : "ten",
        100 : "hundred",
    ];

    writeln("Initial length: ", names.length);

    int[] keys = names.keys;

    /* ‘foreach’类似于‘for’，但比它更有优势。在下一章我们将
     *看到‘foreach’循环。*/
    foreach (key; keys) {
        writefln("Removing the element %s", key);
        names.remove(key);
    }

    writeln("Final length: ", names.length);
}
---

$(P
对于大型数组这恐怕会非常慢。而下面的方法将用一步清空数组。
)

)

$(LI
另一种解法是用空数组赋值：

---
    string[int] emptyAA;
    names = emptyAA;
---

)

$(LI
由于数组的初始值无论如何都是一个空数组，那么下面的技术将得到一样的结果：

---
    names = names.init;
---

)

)

)

$(LI
目标是存储每个学生的多个成绩。由于多个成绩可以用一个动态数组存储，从 $(C string) 到 $(C int[]) 映射的关联数组将能用在这儿。成绩能附加到存储在关联数组中的动态数组上：

---
import std.stdio;

void main() {
    /* 该关联数组的键类型为 string，
     * 值类型为 int[] ，即整型数组。这个
     *关联数组在定义时附加了额外的空格，
     * 以易于区分值类型： */
    int[] [string] grades;

    /* 与“emre” 对应的整型数组
     * 将用于附加新成绩：*/
    grades["emre"] ~= 90;
    grades["emre"] ~= 85;

    /* 打印“emre”的成绩： */
    writeln(grades["emre"]);
}
---

$(P
成绩也可以作为数组字面量一次性赋值：
)

---
import std.stdio;

void main() {
    int[][string] grades;

    grades["emre"] = [ 90, 85, 95 ];

    writeln(grades["emre"]);
}
---

)

)

Macros:
        SUBTITLE=关联数组 习题解答

        DESCRIPTION=D语言习题解答：关联数组

        KEYWORDS=D语言教程 关联数组
