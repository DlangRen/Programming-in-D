Ddoc

$(DERS_BOLUMU $(IX array) 数组)

$(P
在上一章的一个练习中我们定义过五个变量，并用它们做过特定计算。下面各项是这些变量的定义：
)

---
    double value_1;
    double value_2;
    double value_3;
    double value_4;
    double value_5;
---

$(P
这种定义个别变量的方法不能扩展到需要更多变量的情况下。想象一下，需要一千个值；定义从 $(C value_1) 到 $(C value_1000) 一千个变量，这几乎是不可能的。
)

$(P
数组在这种情况下是有用的：数组功能允许我们定义一个把多个值存储到一起的单个变量。虽然简单，但数组是用于存储值的集合中最常见的数据结构。
)

$(P
本章仅涉及数组的部分功能。更多功能将在后面 $(LINK2 /ders/d.en/slices.html, 切片和别的数组功能) 一章中介绍。
)

$(H5 定义)

$(P
数组变量的定义与正常变量的定义非常相似。唯一的区别是，与变量相关联的值的个数在方括号中指定。我们可以对比两种定义如下：
)

---
    int     singleValue;
    int[10] arrayOfTenValues;
---

$(P
上面的第一行定义了一个存储单个值的变量，就像我们以前定义过的变量那样。第二行定义了一个存储连续十个值的变量。换句话说，它是一个可存储十个整数值的数组。你也可以把它定义为同类型的十个变量，或作为数组定义的简称。
)

$(P
因此，上面的五个独立的变量可以等效的使用下面的语法定义为含五个值的数组：
)

---
    double[5] values;
---

$(P
$(IX 标量) 这个定义可以理解为 $(I 5 个 double 值)。请注意，我选择了数组变量的名字为复数，以避免它与单值变量混淆。只存储一个值的变量称为标量变量。
)

$(P
总之，数组变量的定义包括值的类型、 值的个数和涉及数组值的变量名称：
)

---
    $(I 类型名称)[$(I 值的个数)] $(I 变量名称);
---

$(P
值的类型也可以是用户定义的类型。（我们将在后面看到用户定义类型。）例如：
)

---
    // 保存所有城市气象信息的
    // 数组。在这里，bool 值可能意味着
    //   false：阴天
    //   true ：晴天
    bool[cityCount] weatherConditions;

    // 保存一百个箱子重量的数组
    double[100] boxWeights;

    // 有关学校学生的信息
    StudentInformation[studentCount] studentInformation;
---

$(H5 $(IX container) $(IX element) 容器和元素)

$(P
聚集特定类型元素的数据结构称为 $(I 容器)。根据定义，数组就是容器。例如，一个保存了七月每天的气温的数组能汇集 31 个 double 值，形成一个 $(I $(C double) 类型元素的容器)。
)

$(P
容器的变量称为 $(I 元素)。数组元素的个数称为数组的 $(I length)。
)

$(H5 $(IX []) 元素的访问)

$(P
为了与前一章练习中的变量有所区别，我们给变量的名字加上了下划线与数字，像 $(C value_1) 这样。让一个数组在一个名字下存储所有的值，那是不可能也没必要的。相反，通过指定方括号内的元素位置数就可以访问元素：
)

---
    values[0]
---

$(P
这个表达式可以理解为 $(I 数组 values 位置 0 处的元素)。换句话说，对数组输入 $(C values[0]) 而不是键入 $(C value_1) 。
)

$(P
还有两点值得强调：
)

$(UL

$(LI $(B 从零开始编号：) 虽然人们习惯于从 1 开始给项目分配编号，但数组是从 0 开始的。以前被我们编号为 1、2、3、4 和 5 的值在数组中编号为 0、1、2、3 和 4。这种变化可能会让编程新手感到困惑。
)

$(LI $(B$(C[]) 的两种不同用法：) 不要混淆 $(C []) 的两种独特用法。当我们定义数组时，$(C []) 写在元素类型之后，并指定元素个数。访问元素时，$(C []) 写在数组名称之后，并指定要访问的元素位置数：

---
    // 这个是数组的定义。它定义了一个可以存储
    // 12个元素的数组。这个数组用于存储
    // 每个月的天数。
    int[12] monthDays;

    // 这个是数组的访问。它访问对应于
    // 十二月的元素，并设置它的值为 31。
    monthDays[11] = 31;

    // 这是另一个访问。它访问对应于
    // 一月的元素，并把它的值传给
    // writeln 函数。
    writeln("January has ", monthDays[0], " days.");
---

$(P
$(B 提醒：) 一月和十二月的元素位置数分别是 0 和 11；而不是 1 和 12。
)

)

)

$(H5 $(IX index) Index（索引）)

$(P
元素的位置数称为 $(I index)，访问元素的行为称为$(I 索引)。
)

$(P
索引不必是恒定值；变量的值也能用作索引，这会让数组更有用。例如，下面通过变量 $(C monthIndex) 的值来确定该月：
)

---
    writeln("This month has ", monthDays[monthIndex], " days.");
---

$(P
当 $(C monthIndex) 的值为 2，上面的表达式将输出 $(C monthDays[2]) 的值，即三月的天数。
)

$(P
只有与数组长度的差值在 0 与 1 之间的索引才有效。例如，一个具有三个元素的数组的有效索引是 0、1 和 2。访问具有无效索引的数组将导致出错从而终止程序。
)

$(P
数组是容器，其中的元素在计算机的内存中是逐个放置的。例如，下面数组的元素保存了每个月的天数（假定一年中二月有 28 天）：
)

$(MONO
  索引 →     0    1    2    3    4    5    6    7    8    9   10   11
 元素 →  | 31 | 28 | 31 | 30 | 31 | 30 | 31 | 31 | 30 | 31 | 30 | 31 |
)

$(P
$(I $(B 注意：) 上面的索引仅用于演示；并没有存储在计算机的内存中。)
)

$(P
索引 0 处元素的值为 31（一月的天数）；索引1 处元素的值为 28（二月的天数）依次类推。
)

$(H5 $(IX 定长数组) $(IX 动态数组) $(IX 静态数组) 定长数组与动态数组)

$(P
当数组的长度是在写程序时指定时，该数组就是一个$(I 定长数组)。当长度可以在程序的执行过程中进行修改时，该数组就是一个$(I 动态数组)。
)

$(P
上面我们定义的数组都为定长数组，因为元素的个数在写程序时已指定为 5 和 12。在程序的执行过程中数组的长度不可修改。要修改长度，就必须修改源代码，而且程序必须重新编译。
)

$(P
因为省略了长度，所以定义动态数组比定长数组简单：
)

---
    int[] dynamicArray;
---

$(P
在程序的执行过程中这种数组的长度可以增加或减少。
)

$(P
定长数组也被称为静态数组。
)

$(H5 $(IX .length) 使用 $(C .length) 来获取或设置元素的个数)

$(P
数组也有 properties（属性），在这儿我们只会看到 $(C .length)。$(C .length) 返回数组元素的个数：
)

---
    writeln("The array has ", array.length, " elements.");
---

$(P
另外，通过对这个 property 指定一个值就可以修改动态数组的 length：
)

---
    int[] array;            // 初始时为空
    array.length = 5;       // 现在有 5 个元素
---

$(H5 一个数组例子)

$(P
现在我们重温一下使用五个值的例子，用数组重写一下它：
)

---
import std.stdio;

void main() {
    // 该变量用作循环计数器
    int counter;

    // 定义了一个可包含五个 double 
    // 类型元素的数组
    double[5] values;

    // 在循环中从输入流读取元素值
    while (counter < values.length) {
        write("Value ", counter + 1, ": ");
        readf(" %s", &values[counter]);
        ++counter;
    }

    writeln("Twice the values:");
    counter = 0;
    while (counter < values.length) {
        writeln(values[counter] * 2);
        ++counter;
    }

    // 经过计算的五个数值
    //将在循环中输出
}
---

$(P $(B 观测：) $(C counter) 的值决定了循环的重复次数（迭代）。当它的值小于 $(C values.length) 时，迭代循环可以保证每个元素只执行了一次。在每个迭代结束时该变量值都会递增，$(C values[counter]) 表达式指的是数组的逐个元素：$(C values[0])、$(C values[1]) 等等。
)

$(P
要看一看这个程序怎样才能比以前的更好，让我们设想需要读取 20 个值。修改一下上面的程序：用 20 替换 5。另一方面，这个程序若不使用数组那将必须定义 20 个变量。此外，因为您无法使用循环遍历 20 个值，您也不得不把那几行代码重复 20 次，每个单值变量来一次。
)

$(H5 $(IX 初始化,数组) 初始化元素)

$(P
像在 D 语言中的每个变量，数组的元素自动初始化。元素的初始值取决于元素类型：$(C int) 的为 0，$(C double) 的为 $(C double.nan) 等等。
)

$(P
上面 $(C values) 数组的所有元素都初始化为 $(C double.nan)：
)

---
    double[5] values;     // 元素都是 double.nan
---

$(P
显然，元素的值可以在以后程序执行期间发生变化。这在上面给数组的元素赋值时我们已经看到：
)

---
    monthDays[11] = 31;
---

$(P
从输入流中读取值时也发生了：
)

---
    readf(" %s", &values[counter]);
---

$(P
有时在数组定义时元素的期望值是已知的。在这种情况下，元素的初始值可以在分配操作的右手侧方括号内指定。让我们来看一看这个程序，读取来自用户的月数，并输出当月的天数：
)

---
import std.stdio;

void main() {
    // Assuming that February has 28 days
    int[12] monthDays =
        [ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ];

    write("Please enter the number of the month: ");
    int monthNumber;
    readf(" %s", &monthNumber);

    int index = monthNumber - 1;
    writeln("Month ", monthNumber, " has ",
            monthDays[index], " days.");
}
---

$(P
正如你所看到的，$(C monthDays) 数组在定义的时候就已初始化。另外请注意， <span style="white-space: nowrap">1-12</span> 范围内的月份数字转换为了有效的数组索引范围 <span style="white-space: nowrap">0-11</span>。<span style="white-space: nowrap">1-12</span> 范围外的任何值都将导致程序出现错误而终止。
)

$(P
当初始化数组时，也可以在右手侧使用单个值。在这种情况下，所有的数组元素都初始化为该值：
)

---
    int[10] allOnes = 1;    // 所有的元素都设置为 1
---

$(H5 数组的基本操作)

$(P
数组提供了适用于所有元素的方便操作。
)

$(H6 $(IX 复制, 数组) 复​​制定长数组)

$(P
赋值运算符将所有元素从右手侧复制到左手侧：
)
---
    int[5] source = [ 10, 20, 30, 40, 50 ];
    int[5] destination;

    destination $(HILITE =) source;
---

$(P
$(I $(B 注意：) 赋值运算符的含义与动态数组完全不同。我们将在后面的章节中看到这一点。)
)

$(H6 $(IX ~=) $(IX 附加, 数组) $(IX 添加元素, 数组) 给动态数组添加元素)

$(P
$(C ~=) 运算符是指在动态数组的尾部添加新的元素：
)

---
    int[] array;                // 空数组
    array ~= 7;                 // 数组现在等于 [7]
    array ~= 360;               // 数组现在等于 [7, 360]
    array ~= [ 30, 40 ];        // 数组现在等于 [7, 360, 30, 40]
---

$(P
不可能给定长数组添加元素：
)

---
    int[$(HILITE 10)] array;
    array ~= 7;                 $(DERLEME_HATASI)
---

$(H6 $(IX remove, array) 从动态数组里删除元素)

$(P
可以使用模块 $(C std.algorithm) 里的 $(C remove()) 函数删除数组元素。由于数组里可能拥有多个具有相同元素的 $(I 分片) ，$(C remove()) 实际上不会改变原有数组的元素个数。由此，它不得不将原数组的某些元素向左移动一个或多个位置。基于此，删除操作的结果必须回赋给同一个数组变量。
)

$(P
$(C remove()) 的使用方式有以下两种：
)

$(OL
$(LI
提供需要删除的那个元素的索引。例如，下面这段代码将删除索引1上的那个元素。
)

---
import std.stdio;
import std.algorithm;

void main() {
    int[] array = [ 10, 20, 30, 40 ];
    $(HILITE array =) array.remove($(HILITE 1));                // 回赋给 array
    writeln(array);
}
---

$(SHELL
[10, 30, 40]
)

$(LI
使用一个 $(I 匿名函数) （在 $(LINK2 /ders/d.cn/lambda.html, 后面章节) 会讲解它）来指定需要删除的元素。例如，下面这段代码将删除数组里等于 42 的所有元素。
)

---
import std.stdio;
import std.algorithm;

void main() {
    int[] array = [ 10, 42, 20, 30, 42, 40 ];
    $(HILITE array =) array.remove!(a => $(HILITE a == 42));    // 回赋给 array
    writeln(array);
}
---

$(SHELL
[10, 20, 30, 40]
)
)

$(H6 $(IX ~, 连接) $(IX 连接, 数组) 连接数组)

$(P
 $(C ~) 运算符通过连接两个数组从而创建一个新数组。$(C ~=) 将两边的数组连接起来，并把结果赋给左边那个数组：
)

---
import std.stdio;

void main() {
    int[10] first = 1;
    int[10] second = 2;
    int[] result;

    result = first ~ second;
    writeln(result.length);     // 输出 20

    result ~= first;
    writeln(result.length);     // 输出 30
}
---

$(P
左侧数组是定长数组时 $(C ~=) 运算符不能使用：
)

---
    int[20] result;
    // ...
    result $(HILITE ~=) first;          $(DERLEME_HATASI)
---

$(P
如果数组大小不一致，会导致赋值期间出错而终止程序：
)

---
    int[10] first = 1;
    int[10] second = 2;
    int[$(HILITE 21)] result;

    result = first ~ second;
---

$(SHELL
object.Error@(0): Array lengths don't match for copy: $(HILITE 20 != 21)
)

$(H6 $(IX sort（排序）) 排序元素)

$(P
$(C std.algorithm.sort) 可以对许多类型集合中的元素进行排序。对于整数，元素按从小到大排序。为了使用 $(C sort()) 函数，必须先导入 $(C std.algorithm) 模块。（在后面的章节我们将看到这些函数。）
)

---
import std.stdio;
import std.algorithm;

void main() {
    int[] array = [ 4, 3, 1, 5, 2 ];
    $(HILITE sort)(array);
    writeln(array);
}
---

$(P
输出：
)

$(SHELL
[1, 2, 3, 4, 5]
)

$(H6 $(IX reverse（反转）) 反转元素)

$(P
$(C std.algorithm.reverse) 反转元素的位置（第一个元素成为最后一个元素，以此类推）：
)

---
import std.stdio;
import std.algorithm;

void main() {
    int[] array = [ 4, 3, 1, 5, 2 ];
    $(HILITE reverse)(array);
    writeln(array);
}
---

$(P
输出：
)

$(SHELL
[2, 5, 1, 3, 4]
)

$(PROBLEM_COK

$(PROBLEM
编写一个程序，要求用户输入多少值，然后全部读取。让程序使用 $(C sort()) 函数排序元素，然后使用 $(C reverse()) 函数反转排序的元素。
)

$(PROBLEM
编写一个程序，从输入流中读取数字，并先后按顺序分别输出奇数和偶数。并专门用值 <span style="white-space: nowrap">-1</span> 来确定数字的结束；不处理该值。

$(P
例如，当输入了下面的数字，
)

$(SHELL
1 4 7 2 3 8 11 -1
)

$(P
程序会输出以下内容：
)

$(SHELL
1 3 7 11 2 4 8
)

$(P
$(B 提示：) 你可以把元素放入单独的数组。使用 $(C %)（求余数）运算符来确定数字是奇数还是偶数。
)

)

$(PROBLEM
以下为预期不起作用的程序。程序要求从输入流中读取五个数字，并把这些数字放入一个数组。然后程序会输出这些平方。若有错误，程序会终止。

$(P
请修复程序的 bug，让它按预期的方式执行：
)

---
import std.stdio;

void main() {
    int[5] squares;

    writeln("Please enter 5 numbers");

    int i = 0;
    while (i <= 5) {
        int number;
        write("Number ", i + 1, ": ");
        readf(" %s", &number);

        squares[i] = number * number;
        ++i;
    }

    writeln("=== The squares of the numbers ===");
    while (i <= squares.length) {
        write(squares[i], " ");
        ++i;
    }

    writeln();
}
---

)

)

Macros:
        SUBTITLE=数组

        DESCRIPTION=D 语言的数组基本操作

        KEYWORDS=D 编程语言 教程 定长 动态


$(Ergin)
