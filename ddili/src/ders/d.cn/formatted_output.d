Ddoc

$(DERS_BOLUMU $(IX output, 格式化) $(IX 格式化输出) 格式化输出)

$(P
本章的内容是标准库中的 $(C std.format) 模块，与 D 语言的语言核心无关。
)

$(P
$(IX std) $(IX Phobos) 与其它带有 $(C std) 前缀的模块一样，$(C std.format) 也来自 D 语言标准库 Phobos。由于 Phobos 过于庞大，我们无法在这本书中涉及其所有的部分。
)

$(P
D 语言的输入输出格式化说明符与 C 语言相同。
)

$(P
在深入学习之前我们先来看下最基本的标识和说明符，你可以保留此表以供日后参考：
)

$(MONO
$(B 标识) (可同时使用多个)
     -     左对齐
     +     输出整数时显示正号
     #     在八进制数前添加 `0`，在十六进制数前添加 `0x`，科学计数浮点型总是使用小数点
     0     使用 `0` 填充空位
   $(I 空格)   使用空格填充空位

$(B 格式化说明符)
     s     默认的（字符串）
     b     二进制
     d     十进制
     o     八进制
    x,X    无符号十六进制
    f,F    标准十进制计数法浮点数
    e,E    科学计数法浮点数
    a,A    十六进制浮点数
    g,G    与 e 和 f 相同

     (     格式化元素列表开始
     )     格式化元素列表结束
     |     元素分隔符
)

$(P
我们之前肯定用过像 $(C writeln) 这样的函数，那时我们需要传递给它多个参数来输出期望格式的信息。参数先会被转换为它们的字符串形式，然后
 才会被传递给标准输出流。
)

$(P
但有时这并不能满足需求。我们可能要求输出某种特殊的格式。比如下面这段打印发票项目的代码：
)

---
    items ~= 1.23;
    items ~= 45.6;

    students ~= Student(i, [80 + i, 90 + i]);
        writeln("Item ", i + 1, ": ", items[i]);
    }
---

$(P
输出为：
)

$(SHELL
Item 1: 1.23
Item 2: 45.6
)

$(P
尽管数据是正确的，但客户还要要将其以其指定的格式输出。比如，我们需要将小数点对齐（本例中的点）并确保小数点后有两位小数。下面是示例输出格式：
)

$(SHELL
Item 1:     1.23
Item 2:    45.60
)

$(P
这个时候我们就需要格式化输出了。在之前我们使用的输出函数名中添加一个字母 $(C f) 就得到了我们需要的函数：$(C writef()) 和 $(C writefln())。$(C f) 即为$(I 格式化（formatted）)的缩写。这些函数的第一个参数是$(I 格式化字符串)，它决定了之后的参数以何种格式被输出至屏幕。
)

$(P
对我们上面的需求来说，$(C writefln()) 可以通过使用这样的格式化字符串来将其实现：
)

---
        writefln("Item %d:%9.02f", i + 1, items[i]);
---

$(P
格式化字符串中既可包含被直接输出的普通字符，也可包含用于描述输出的特殊说明符。格式化说明符以 $(C %) 开头，以$(I 格式化字符)结束。上面的格式化字符串包含两个说明符：$(C %d) 和 $(C %9.02f)。
)

$(P
每一个说明符都分别关联了一个参数，其指代参数的顺序与说明符顺序相同。比如 $(C %d) 关联 $(C i&nbsp;+&nbsp;1)，$(C %9.02f) 关联 $(C items[i])。每一个说明符都将描述其关联参数的输出形式。（说明符也可能会带有参数。稍后我们会介绍。）
)

$(P
除此之外，格式化字符串中的其它字符均不是格式化说明符，它们将会按照原样显示。这是将格式化字符串中这种$(I 普通)字符高亮后的样子：$(C "$(HILITE Item&nbsp;)%d$(HILITE :)%9.02f")。
)

$(P
格式化说明符由六个部分组成，但其中的大部分都是可选的。我们之后会在本章介绍名为$(I 位置)的部分。而下面我们将介绍其它五个部分：（$(I $(B 注：)两部分之间的空格是为了帮助你阅读；它们不是说明符的一部分。)）
)

$(MONO
    %  $(I$(C 标识  宽度  精度  格式化字符))
)

$(P
开头的 $(C %) 和结尾的格式化字符是必须的；其它部分则是可选的。
)

$(P
由于 $(C %) 在格式化字符串中的特殊含义，当我们需要像一个普通字符一样输出 $(C %) 时需要将其写作 $(C %%)。
)

$(H5 $(I 格式化字符))

$(P $(IX %b) $(C b)：以二进制的形式输出一个整数。
)

$(P $(IX %o, 输出) $(C o)：以八进制的形式输出一个整数。
)

$(P $(IX %x, 输出) $(IX %X) $(C x) 和 $(C X)：以十六进制的形式输出一个整数；若使用 $(C x) 则十六进制中的 x 也为小写，若使用 $(C X) 则十六进制中的 X 也为大写。
)

$(P $(IX %d, 输出) $(C d)：以十进制的形式输出一个整数；如果是有符号整数且其值小于零则显示负号。
)

---
    int value = 12;

    writefln("Binary     : %b", value);
    writefln("Octal      : %o", value);
    writefln("Hexadecimal: %x", value);
    writefln("Decimal    : %d", value);
---

$(SHELL
Binary     : 1100
Octal      : 14
Hexadecimal: c
Decimal    : 12
)

$(P $(IX %e) $(C e)：按照下面的规则输出一个浮点数。
)

$(UL
$(LI 小数点前必有一位数)
$(LI 如果$(I 精度)不为零则显示小数点)
$(LI 小数点后必须存在小数部分，小数位数取决于$(I 精度) （精度通常是 6）)
$(LI 字符 $(C e) （表示“以 10 为底的次方”）)
$(LI $(C -) 或 $(C +) 号，取决于指数是否大于零)
$(LI 指数，至少有两位)
)

$(P $(IX %E) $(C E)：与 $(C e) 相同，但将输出中的小写 $(C e) 换为大写 $(C E)。
)

$(P $(IX %f, 输出) $(IX %F) $(C f) 和 $(C F)：以十进制的形式输出一个浮点数；小数点前至少有两位数字，默认保留 6 位小数。
)

$(P $(IX %g) $(C g)：如果指数大于 -5 小于$(I 精度)则与 $(C f) 相同，反之则与 $(C e) 相同。$(I 精度)指定的是整个浮点数的有效数字，而不仅仅是小数点后的有效位数。若小数点后没有数字那则不会显示小数点。小数点后最右端的零不会显示。
)

$(P $(IX %G) $(C G)：与 $(C g) 相同，但 $(C E) 和 $(C F) 都会变为大写。
)

$(P $(IX %a) $(C a)：以十六进制浮点数表示法显示浮点数：
)

$(UL
$(LI 符号 $(C 0x))
$(LI 一个十六进制数字)
$(LI 若$(I 精度)不为零则显示小数点)
$(LI 小数点后的小数，位数由$(I 精度决定)；若没有指定$(I 精度)则尽可能显示更多的数字)
$(LI 符号 $(C p) （表示“以 2 为底的次方”）)
$(LI $(C -) 或 $(C +) 号，取决于指数是否大于零)
$(LI 指数，至少包含一个数字（0 指数即显示 0）)
)

$(P $(IX %A) $(C A)：与 $(C a) 相同，但 $(C 0X) 和 $(C P) 都会变为大写。
)

---
    double value = 123.456789;

    writefln("with e: %e", value);
    writefln("with f: %f", value);
    writefln("with g: %g", value);
    writefln("with a: %a", value);
---

$(SHELL
with e: 1.234568e+02
with f: 123.456789
with g: 123.457
with a: 0x1.edd3c07ee0b0bp+6
)

$(P $(IX %s, 输出) $(C s)：以常规形式输出数据，具体情况与类型有关：
)

$(UL

$(LI $(C bool) 值将显示 $(C true) 或 $(C false)
)
$(LI 整数输出形式与 $(C %d) 相同
)
$(LI 浮点数输出形式与 $(C %g) 相同
)
$(LI 字符串以 UTF-8 编码；$(I 精度)决定最多可使用多少字节 （在 UTF-8 中字节数并不是字符数；比如 "ağ" 中有两个字符，但实际上包含 3 个字节）
)
$(LI 结构体和类将输出其 $(C toString()) 成员函数的返回值；$(I 精度)决定最多可使用多少字节
)
$(LI 数组则会将其所有值并排输出出来
)

)

---
    bool b = true;
    int i = 365;
    double d = 9.87;
    string s = "formatted";
    auto o = File("test_file", "r");
    int[] a = [ 2, 4, 6, 8 ];

    writefln("bool  : %s", b);
    writefln("int   : %s", i);
    writefln("double: %s", d);
    writefln("string: %s", s);
    writefln("object: %s", o);
    writefln("array : %s", a);
---

$(SHELL
bool  : true
int   : 365
double: 9.87
string: formatted
object: File(55738FA0)
array : [2, 4, 6, 8]
)

$(H5 $(IX width, 输出) $(I 宽度))

$(P
$(IX *, 格式化输出) 这部分参数决定了输出内容的宽度。如果使用 $(C *) 指定宽度，那它将从下一个参数读取宽度（那个参数必须是 $(C int)）。小于零的宽度会使其带有 $(C -) 标识的效果。
)

---
    int value = 100;

    writefln("In a field of 10 characters:%10s", value);
    writefln("In a field of 5 characters :%5s", value);
---

$(SHELL
In a field of 10 characters:       100
In a field of 5 characters :  100
)

$(H5 $(IX precision, 输出) $(I 精度))

$(P
精度通常写在标识符中的点号后面。对于浮点类型，它将决定输出的小数的位数。如果使用 $(C *) 指定精度，那那它将从下一个参数读取精度（那个参数必须是 $(C int)）。负精度将被忽略。
)

---
    double value = 1234.56789;

    writefln("%.8g", value);
    writefln("%.3g", value);
    writefln("%.8f", value);
    writefln("%.3f", value);
---

$(SHELL
1234.5679
1.23e+03
1234.56789000
1234.568
)

---
    auto number = 0.123456789;
    writefln("Number: %.*g", 4, number);
---

$(SHELL
Number: 0.1235
)

$(H5 $(IX flags, 输出) $(I 标识))

$(P
一个说明符中可以指定多个标识。
)

$(P $(C -)：输出的数据将被左对齐；它将使 $(C 0) 标识失效
)

---
    int value = 123;

    writefln("Normally right-aligned:|%10d|", value);
    writefln("Left-aligned          :|%-10d|", value);
---

$(SHELL
Normally right-aligned:|       123|
Left-aligned          :|123       |
)

$(P $(C +)：如果输出的数据是正数则在其开头添加 $(C +) 号；它将使$(I 空格)标识失效
)

---
    writefln("No effect for negative values    : %+d", -50);
    writefln("Positive value with the + flag   : %+d", 50);
    writefln("Positive value without the + flag: %d", 50);
---

$(SHELL
No effect for negative values    : -50
Positive value with the + flag   : +50
Positive value without the + flag: 50
)

$(P $(C #)：根据不同的$(I 格式化字符)显示$(I 不同的)输出格式
)

$(UL
$(LI $(C o)：八进制数的第一个数字一般都是 0)

$(LI $(C x) 和 $(C X)：如果是非零值则在其开头处添加 $(C 0x) 或 $(C 0X))

$(LI 浮点数：即使小数点后没有有效数字也会显示小数点)

$(LI $(C g) 和 $(C G)：小数点后的非有效数字（即 0）也会显示)
)

---
    writefln("Octal starts with 0                        : %#o", 1000);
    writefln("Hexadecimal starts with 0x                 : %#x", 1000);
    writefln("Contains decimal mark even when unnecessary: %#g", 1f);
    writefln("Rightmost zeros are printed                : %#g", 1.2);
---

$(SHELL
Octal starts with 0                        : 01750
Hexadecimal starts with 0x                 : 0x3e8
Contains decimal mark even when unnecessary: 1.00000
Rightmost zeros are printed                : 1.20000
)

$(P $(C 0)：用零填充空白（除非传入的值是 $(C nan) 或 $(C infinity)）；如果同时指定了$(I 精度)那这个标志会被忽略
)

---
    writefln("In a field of 8 characters: %08d", 42);
---

$(SHELL
In a field of 8 characters: 00000042
)

$(P $(I 空格)符：如果传入的值是正数，那它将会在正数前插入空格使其能与负数对齐)

---
    writefln("No effect for negative values: % d", -34);
    writefln("Positive value with space    : % d", 56);
    writefln("Positive value without space : %d", 56);
---

$(SHELL
No effect for negative values: -34
Positive value with space    :  56
Positive value without space : 56
)


$(H5 $(IX %1$) $(IX positional parameter, 输出) $(IX $, 格式化输出) 位置参数)

$(P
之前我们编写的程序中格式化字符串中的说明符与参数是按照顺序一个一个相关联的。除此之外我们也可以在格式化说明符中使用位置编号。这样说明符就能与指定的参数相关联。参数的序号从 1 开始递增。参数序号应写在 $(C %) 后，并以 $(C $) 结尾：
)

$(MONO
    %  $(I$(C $(HILITE 位置$)  标识  宽度  精度  格式化字符))
)

$(P
参数序号的作用之一是允许一个格式化字符串中的多个说明符关联同一个参数：
)

---
    writefln("%1$d %1$x %1$o %1$b", 42);
---

$(P
上面这个格式化字符串在 4 个说明符中使用一个参数序号 1 来将同一个数分别以十进制、十六进制、八进制和二进制的形式显示：
)

$(SHELL
42 2a 52 101010
)

$(P
还有就是位置编号能让程序支持多种自然语言。有了位置编号，程序只需在格式化字符串中移动参数位置就可以适应多种人类语言。举个例子，按照下面的格式显示指定教室中的学生个数：
)

---
    writefln("There are %s students in room %s.", count, room);
---

$(SHELL
There are 20 students in room 1A.
)

$(P
我们假设现在程序要支持土耳其语。为了应对这种需求，程序需要根据活动语言来选择格式化字符串。下面这种方法运用了三元运算符：
)

---
    auto format = (language == "en"
                   ?"There are %s students in room %s."
                   : "%s sınıfında %s öğrenci var.");

    writefln(format, count, room);
---

$(P
然而这样的话土耳其语信息中的教室和学生信息的顺序是错误的；教教室信息的位置显示的是学生数，而学生数的位置显示的则是教室：
)

$(SHELL
20 sınıfında 1A öğrenci var.  $(SHELL_NOTE_WRONG 错误的：表示的是 “room 20” 和 “1A students”！)
)

$(P
为了避免出现这种情况，我们通常为说明符指定像 $(C 1$) 或 $(C 2$) 这样的参数编号使其能与正确的参数相关联：
)

---
    auto format = (language == "en"
                   ?"There are %1$s students in room %2$s."
                   : "%2$s sınıfında %1$s öğrenci var.");

    writefln(format, count, room);
---

$(P
现在无论选择那个语言参数都能出现在正确的位置了：
)

$(SHELL
There are 20 students in room 1A.
)

$(SHELL
1A sınıfında 20 öğrenci var.
)

$(H5 $(IX %$(PARANTEZ_AC)) $(IX %$(PARANTEZ_KAPA)) 元素格式化输出)

$(P
在 $(STRING %$(PARANTEZ_AC)) 和 $(STRING %$(PARANTEZ_KAPA)) 之间的格式化说明符将会被应用到其关联的容器中的每个参数（比如数组或 range）：
)

---
    auto numbers = [ 1, 2, 3, 4 ];
    writefln("%(%s%)", numbers);
---

$(P
上面这个格式化字符串由三个部分组成：
)

$(UL
$(LI $(STRING %$(PARANTEZ_AC))：开始元素格式)
$(LI $(STRING %s)：每一个元素的格式)
$(LI $(STRING %$(PARANTEZ_KAPA))：结束元素格式)
)

$(P
容器中的元素会以 $(STRING %s) 格式挨个输出：
)

$(SHELL
1234
)

$(P
元素格式两侧的普通字符都会在每一个元素中重复。比如使用 $(STRING {%s},) 说明符，将元素包裹在花括号中并以逗号分隔的格式输出：
)

---
    writefln("%({%s},%)", numbers);
---

$(P
但元素右侧的普通字符将会被当作元素分隔符，它们只会在两个元素之间显示而不会显示在最后：
)

$(SHELL
{1},{2},{3},{4  $(SHELL_NOTE ‘}’ 和 ‘,’ 都不会在最后一个元素后显示)
)

$(P
$(IX %|) $(STRING %|)是用来说明允许在最后一个元素后显示的字符的。$(STRING %|) 右侧的字符将会被当作分隔符，它们将不会在最后一个元素后显示。而 $(STRING %|) 左侧的字符将为最后一个元素显示。
)

$(P
比如下面这个格式化说明符，花括号会显示在输出信息的最后而逗号不会：
)
---
    writefln("%({%s}%|,%)", numbers);
---

$(SHELL
{1},{2},{3},{4}  $(SHELL_NOTE 现在最后一个元素后也有 ‘}’ 了)
)

$(P
与单独显示字符串不同的是，以元素的方式输出的字符串都会被包裹在双引号中：
)

---
    auto vegetables = [ "spinach", "asparagus", "artichoke" ];
    writefln("%(%s, %)", vegetables);
---

$(SHELL
"spinach", "asparagus", "artichoke"
)

$(P
$(IX %-$(PARANTEZ_AC)) 如果我们不需要双引号，那我们需要将开头处的 $(STRING %$(PARANTEZ_AC)) 替换为 $(STRING %-$(PARANTEZ_AC))：
)

---
    writefln("%-(%s, %)", vegetables);
---

$(SHELL
spinach, asparagus, artichoke
)

$(P
单个字符也有类似的情况。$(STRING %$(PARANTEZ_AC)) 会对其每一个元素两侧添加双引号：
)

---
    writefln("%(%s%)", "hello");
---

$(SHELL
'h''e''l''l''o'
)

$(P
$(STRING %-$(PARANTEZ_AC)) 则不会添加双引号：
)

---
    writefln("%-(%s%)", "hello");
---

$(SHELL
hello
)

$(P
对于关联数组来说格式化字符串中必须有两个格式化说明符，一个对应键，一个对应值。下面这个例子中的说明符 $(STRING %s&nbsp;(%s)) 会将值放在键后的圆括号中：
)

---
    auto spelled = [ 1 : "one", 10 : "ten", 100 : "hundred" ];
    writefln("%-(%s (%s)%|, %)", spelled);
---

$(P
注意由于指定了 $(STRING %|)，逗号将不会出现在最后一个元素后。
)

$(SHELL
1 (one), 100 (hundred), 10 (ten)
)

$(H5 $(IX format, std.string) $(C format))

$(P
我们也可以使用 $(C std.string) 模块中的 $(C format()) 函数来实现格式化输出。$(C format()) 与 $(C writef()) 的作用相似，不同的是它将$(I 返回)格式化后的得到的 $(C string) 而不是将其输出：
)

---
import std.stdio;
import std.string;

void main() {
    write("What is your name?");
    auto name = strip(readln());

    auto result = $(HILITE format)("Hello %s!", name);
}
---

$(P
我们可以在程序之后的表达式中使用格式化后的结果字符串。
)

$(PROBLEM_COK

$(PROBLEM
编写一个程序，让用户输入一个数并将其以十六进制形式输出。
)

$(PROBLEM
编写一个程序，让用户输入一个浮点数，将得到的浮点数转换为百分比形式并保留两位小数输出。比如输入 1.2345，程序将显示 $(C %1.23)。
)

)

Macros:
        SUBTITLE=格式化输出

        DESCRIPTION=以确定的格式显示数据

        KEYWORDS=D 编程语言教程 格式化 输出
