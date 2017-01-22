Ddoc

$(DERS_BOLUMU $(IX 类型转换) $(IX 转换, 类型) 类型转换)

$(P
表达式中的变量的类型必须与表达式所要求的类型相匹配。就像我们在之前的程序中见到的那样，D 语言是一个$(I 静态类型语言)，也就是说所有变量的类型在编译期就已经确定了。
)

$(P
之前我们写过的表达式都使用与之相匹配的类型的变量，否则编译器会拒绝编译。下面这个例子中的代码就包含不匹配的类型：
)

---
    char[] slice;
    writeln(slice + 5);    $(DERLEME_HATASI)
---

$(P
编译器将会拒绝编译这段代码，因为对加运算符来说 $(C char[]) 和 $(C int) 无法相互兼容。
)

$(SHELL
Error: $(HILITE incompatible types) for ((slice) + (5)): 'char[]' and 'int'
)

$(P
并不是类型不同就意味这不匹配；实际上不同的类型也可以在同一个表达式中安全使用。比如，下面这个本应该是 $(C double) 型变量的位置就可以用 $(C int) 型变量替换：
)

---
    double sum = 1.25;
    int increment = 3;
    sum += increment;
---

$(P
即使 $(C sum) 和 $(C increment) 是不同类型的变量，上面这个表达式也是有效的，因为将一个 $(C int) 加到 $(C double) 上是合法的。
)

$(H5 $(IX 自动类型转换) $(IX 隐式类型转换) 自动类型转换)

$(P
自动类型转换也可称作$(I 隐式类型转换)。
)

$(P
虽然上面这个表达式中 $(C double) 和 $(C int) 能相互匹配，但在微处理器上这个加法依旧需要使用一个明确的类型以进行计算。$(LINK2 /ders/d.cn/floating_point.html, 浮点型) 一章曾经说过，64-bit 的 $(C double) 比 32-bit 的 $(C int) $(I 更宽)（或者说$(I 更大)）。因此任何能用 $(C int) 储存的值均可用 $(C double) 储存。
)

$(P
当编译器遇到一个含有不匹配类型的表达式时，它会先试着将表达式中的类型不同变量都转换成相同的类型再进行运算。由编译器执行的自动类型转换的原则是会不损失数据。比如说 $(C double) 能储存所有 $(C int) 能储存的值，但反过来就不行。之所以上面那个 $(C +=) 运算符能正常工作是因为 $(C int) 能被安全的转换为 $(C double)。
)

$(P
由自动类型转换生成的值是匿名的（通常是临时变量）。而原来参与表达式运算的变量的类型并没有改变。就像上面那个 $(C +=) 运算，它并不会改变 $(C increment) 的类型；$(C increment) 一直都是 $(C int)。编译器只是生成了一个与 $(C increment) 的值相同的类型为 $(C double) 的临时变量。下面这段代就与这个隐式转换过程等价：
)

---
    {
        double $(I an_anonymous_double_value) = increment;
        sum += $(I an_anonymous_double_value);
    }
---

$(P
编译器将 $(C int) 值转换成了一个临时的 $(C double) 值来参与运算。在这个例子中，这个临时变量仅在 $(C +=) 运算过程中存在。
)

$(P
自动类型转换不仅限于数学运算。也有其他适用于自动类型转换的情况。只要能进行有效的转换，我们就可以利用编译器的自动类型转换让我们能在表达式中使用我们想要使用的那个变量。比如向一个 $(C int) 形参传递 $(C byte) 型变量：
)

---
void func(int number) {
    // ...
}

void main() {
    byte smallValue = 7;
    func(smallValue);    // 此处执行自动类型转换
}
---

$(P
在上面这段代码中，编译器会先构造一个 $(C int) 类型的临时变量，再用这个临时变量调用函数。
)

$(H6 $(IX 整型提升) $(IX 提升, 整型) 整型提升)

$(P
下表中左侧的类型永远不能参与数学运算。他们先会被转换成表中右侧对应的类型，然后才能进行运算。
)

<table class="narrow" border="1" cellpadding="4" cellspacing="0">
<tr><th scope="col">源类型</th> <th scope="col">目标类型</th>
</tr>

        <tr align="center">
	<td>bool</td>
	<td>int</td>
	</tr>

        <tr align="center">
	<td>byte</td>
	<td>int</td>
	</tr>

	<tr align="center">
	<td>ubyte</td>
	<td>int</td>
	</tr>

        <tr align="center">
	<td>short</td>
	<td>int</td>
	</tr>

	<tr align="center">
	<td>ushort</td>
	<td>int</td>
	</tr>

	<tr align="center">
	<td>char</td>
	<td>int</td>
	</tr>

        <tr align="center">
	<td>wchar</td>
	<td>int</td>
	</tr>

        <tr align="center">
	<td>dchar</td>
	<td>uint</td>
	</tr>
</table>

$(P
$(C enum) 也有整型提升。
)

$(P
整型提升的存在不仅是由于历史原因（来自 C 语言的规则），也是因为对微处理器来说 $(C int) 才是最自然的或者说运算效率最高的算术类型。就像下面这个例子，虽然参与运算的两个变量都是 $(C ubyte)，但必须先将其分别转换为 $(C int) 后才可进行运算：
)

---
    ubyte a = 1;
    ubyte b = 2;
    writeln(typeof(a + b).stringof);  // 不是 ubyte 的加法运算
---

$(P
输出为：
)

$(SHELL
int
)

$(P
注意变量 $(C a) 和 $(C b) 的类型并没有改变；只是在执行加法运算时它们的值被临时提升为 $(C int)。
)

$(H6 $(IX 算术转换) 算术转换)

$(P
还有其他几种用于数学运算的类型转换规则。通常情况下，自动算数类型转换只会向着安全的方向进行：从$(I 窄)类型到$(I 宽)类型。虽然这条规则简单易懂且在大多数情况下都能得到正确的结果，但实际上自动转换的规则是相当复杂的。在某些时候从带符号类型转换为无符号类型将带来引入 bug 的风险。
)

$(P
算术转换规则如下：
)

$(OL

$(LI 如果表达式中存在 $(C real) 变量，则其它所有值被转换为 $(C real))

$(LI 若不符合第一条且表达式中存在 $(C double) 变量，则其它所有值被转换为 $(C double))

$(LI 若不符合前两条且表达式中存在 $(C float) 变量，则所有值被转换为 $(C float))

$(LI 若前三条均不符合，则先使用上表中的$(I 整型提升)规则，之后再按照下面的规则转换：

$(OL
$(LI 如果所有变量类型相同，则不进行转换)
$(LI 如果所有变量都是带符号的或都是无符号的，则将窄类型转换为宽类型)
$(LI 如果带符号的类型比无符号的类型宽，则将无符号类型转换为带符号类型)
$(LI 否则将带符号类型转换为无符号类型)
)
)
)

$(P
不幸的是最后一条规则很可能会引入不易察觉的 bug：
)

---
    int    a = 0;
    int    b = 1;
    size_t c = 0;
    writeln(a - b + c);  // 意料之外的结果！
---

$(P
输出不是 -1，而是 $(C size_t.max)：
)

$(SHELL
18446744073709551615
)

$(P
没错 $(C (0 - 1 + 0)) 的结果的确是 -1，但是根据上面的规则，整个表达式的类型应为 $(C size_t) 而不是 $(C int)；由于 $(C size_t) 无法储存负数，所以结果溢出变成了 $(C size_t.max)。
)

$(H6 slice 转换)

$(P
$(IX 定长数组, 转换为 slice) $(IX 静态数组, 转换为 slice) 为了方便使用，调用函数时传递的定长数组将被自动转换为 slice：
)

---
import std.stdio;

void foo() {
    $(HILITE int[2]) array = [ 1, 2 ];
    bar(array);    // 定长数组将作为 slice 传入
}

void bar($(HILITE int[]) slice) {
    writeln(slice);
}

void main() {
    foo();
}
---

$(P
$(C bar()) 将在控制台中显示收到的定长数组的所有元素：
)

$(SHELL
[1, 2]
)

$(P
$(B 注意：)如果函数需要将定长数组储存起来以备它用，则不要对其传递$(I 局部)定长数组。下面这个例子就存在这样的 bug，$(C bar()) 储存的 slice 会在 $(C foo()) 结束后失效：
)

---
import std.stdio;

void foo() {
    int[2] array = [ 1, 2 ];
    bar(array);    // 定长数组将作为 slice 传入

}  // ← 注：运行到此处后‘array’将不再有效

int[] sliceForLaterUse;

void bar(int[] slice) {
    // 储存了一个失效的 slice
    sliceForLaterUse = slice;
    writefln("Inside bar : %s", sliceForLaterUse);
}

void main() {
    foo();

    /* BUG：访问了那块已经不再是数组的内存 */
    writefln("Inside main: %s", sliceForLaterUse);
}
---

$(P
这种 bug 将导致未定义行为。比如下面这种情况证实了之前用于储存 $(C array) 的内存已被移作它用：
)

$(SHELL
Inside bar : [1, 2]        $(SHELL_NOTE 实际元素)
Inside main: [4396640, 0]  $(SHELL_NOTE_WRONG 未定义行为的一种表现)
)

$(H6 $(C const) 转换)

$(P
$(LINK2 /ders/d.cn/function_parameters.html, 函数参数) 一章中我们曾提到过，引用类型可被自动转换为对应的 $(C const) 类型。转换到 $(C const) 是安全的，因为类型的宽度未被改变且 $(C const) 保证了变量不会再被修改：
)

---
char[] parenthesized($(HILITE const char[]) text) {
    return "{" ~ text ~ "}";
}

void main() {
    $(HILITE char[]) greeting;
    greeting ~= "hello world";
    parenthesized(greeting);
}
---

$(P
可变的 $(C greeting) 在传入 $(C parenthesized()) 时被自动转换为 $(C const char[])。
)

$(P
反向转换无法自动进行，关于这点我们之前已经见过很多次了。$(C const) 引用无法被转换为可变引用：
)

---
char[] parenthesized(const char[] text) {
    char[] argument = text;  $(DERLEME_HATASI)
// ...
}
---

$(P
注意我们讨论的问题只针对引用；因为对于值类型来说，修改复制结果并不会对原变量造成任何影响：
)

---
    const int totalCorners = 4;
    int theCopy = totalCorners;      // 编译通过（值类型）
---

$(P
上面这个将 $(C const) 转换为可变类型是合法的，因为复制不是对原变量的引用。
)

$(H6 $(C immutable) 转换)

$(P
由于 $(C immutable) 变量的不可变性，无论是从 $(C immutable) 转换为其它类型还是将其它类型转换为 $(C immutable) 都可以自动进行：
)

---
    string a = "hello";    // immutable 字符
    char[] b = a;          $(DERLEME_HATASI)
    string c = b;          $(DERLEME_HATASI)
---

$(P
和上面的 $(C const) 转换一样，这条规则只针对引用类型。值类型在任何地方都是通过复制的方式传递，因而从 $(C immutable) 转换为可变是有效的：
)

---
    immutable a = 10;
    int b = a;           // 通过编译（值类型）
--

$(H6 $(C enum) 转换)

$(P
$(LINK2 /ders/d.cn/enum.html, $(C enum)) 一章中我们已经提到过，$(C enum) 通常被用作$(I 命名常量)：
)

---
    enum Suit { spades, hearts, diamonds, clubs }
---

$(P
由于上面并没有显式指定枚举的值，所以 $(C enum) 成员默认从零开始，每一个成员依次在上一个成员的值的基础上加一。因此，$(C Suit.clubs) 的值是 3。
)

$(P
$(C enum) 能被自动转换为整型。比如下面这个例子，$(C Suit.hearts) 会在计算中被隐式转换为 1，即最后的结果是 11：
)

---
    int result = 10 + Suit.hearts;
    assert(result == 11);
---

$(P
然而反向转换则不是自动的：整型值不会被自动转换为对应的 $(C enum) 值。就比如说下面这个 $(C suit)，你可能认为它能被转换为 $(C Suit.diamonds)，而实际上下面这段代码不能被编译：
)

---
    Suit suit = 2;    $(DERLEME_HATASI)
---

$(P
实际上从整型到 $(C enum) 的转换是允许的，但你必须显式转换。
)

$(H6 $(IX bool, 自动转换) $(C bool) 转换)

$(P
$(C false) 和 $(C true) 可被分别自动转换为 0 和 1。
)

---
    int a = false;
    assert(a == 0);

    int b = true;
    assert(b == 1);
---

$(P
而反过来只有 0 和 1 这两个$(I 字面量)能分别自动转换到 $(C false) 和 $(C true)：
)

---
    bool a = 0;
    assert(!a);     // false

    bool b = 1;
    assert(b);      // true
---

$(P
其它字面量不能被自动转换为 $(C bool)：
)

---
    bool b = 2;    $(DERLEME_HATASI)
---

$(P
某些语句使用了逻辑表达式，比如：$(C if)，$(C while) 等。对于这些逻辑语句，除了 $(C bool) 值，其它类型的值也可以作为逻辑表达式使用。零将被自动转换为 $(C false)，其它非零值则会自动转换为 $(C true)。
)

---
    int i;
    // ...

    if (i) {    // ← int 值作为逻辑表达式
        // ... 'i' 非零

    } else {
        // ... 'i' 为零
    }
---

$(P
与此相同的是 $(C null) 引用，它将被自动转换为 $(C false)，而非 $(C null) 引用将被自动转换为 $(C true)。利用它我们可以确保将要使用的引用是一个非 $(C null) 值：
)

---
    int[] a;
    // ...

    if (a) {    // ← 自动转换为 bool
        // ... 非 null，‘a’可以使用 ...

    } else {
        // ... null，‘a’不能使用 ...
    }
---

$(H5 $(IX 显式类型转换) $(IX 类型转换, 显式) 显式类型转换)

$(P
就像我们之前看到的那样，对某些情况来说自动转换并不适用：
)

$(UL
$(LI 从宽类型到窄类型的转换)
$(LI 从 $(C const) 到可变类型的转换)
$(LI $(C immutable) 转换)
$(LI 从整形到 $(C enum) 的转换)
$(LI 以及其它上述未提到的情况)
)

$(P
如果你能保证上述转换是安全的，那你可以使用下面这几种方法显式执行类型转换：
)

$(UL
$(LI 构造语法)
$(LI $(C std.conv.to) 函数)
$(LI $(C std.exception.assumeUnique) 函数)
$(LI $(C cast) 运算符)
)

$(H6 $(IX 构造, 类型转换) 构造语法)

$(P
$(C struct) 和 $(C class) 的构造语法也适用于其它类型：
)

---
    $(I DestinationType)(value)
---

$(P
比如下面这个例子将 $(C int) $(I 转换为) $(C double)，想必是为了保留除法运算结果的小数部分：
)

---
    int i;
    // ...
    const result = $(HILITE double(i)) / 2;
---

$(H6 $(IX to, std.conv) 最常用的 $(C to()) 转换)

$(P
$(C to()) 函数经常被用来将某个类型的值转换为 $(C string)，但实际上除了转换到字符串它还可以转换到其它类型。完整的语法如下：
)

---
    to!($(I DestinationType))(value)
---

$(P
作为一个模版，$(C to()) 可以利用模版参数的语法糖简化代码编写：如果目标类型的名字只有一个标记（即通常情况下只有$(I 一个单词)），我们就可以省略第一对圆括号：
)

---
    to!$(I DestinationType)(value)
---

$(P
下面这段程序试图将一个 $(C double) 值转换为 $(C short) 并将一个 $(C string) 转换为 $(C int)：
)

---
void main() {
    double d = -1.75;

    short s = d;     $(DERLEME_HATASI)
    int i = "42";    $(DERLEME_HATASI)
}
---

$(P
由于并不是每一个 $(C double) 都能用 $(C short) 储存，并不是每一个 $(C string) 都能用 $(C int) 储存，所以上述转换无法自动执行。只有当程序员认为转换是安全的或转换的结果在预期内时才可以使用 $(C to()) 进行转换：
)

---
import std.conv;

void main() {
    double d = -1.75;

    short s = to!short(d);
    assert(s == -1);

    int i = to!int("42");
    assert(i == 42);
}
---

$(P
由于 $(C short) 不能储存小数，所以转换的结果将是 -1。
)

$(P
$(C to()) 是安全的：在转换无法执行时它将抛出异常。
)

$(H6 $(IX assumeUnique, std.exception) 使用 $(C assumeUnique()) 进行快速 $(C immutable) 转换)

$(P
也可以使用 $(C to()) 进行 $(C immutable) 转换：
)

---
    int[] slice = [ 10, 20, 30 ];
    auto immutableSlice = to!($(HILITE immutable int[]))(slice);
---

$(P
为了确保 $(C immutableSlice) 中的元素不会被改变，它将无法与 $(C slice) 共享储存元素的内存。所以上面这个 $(C to()) 将创建一个独立的 slice 来储存 $(C immutable) 元素。否则，改变 $(C slice) 中的元素将同时改变 $(C immutableSlice) 中的元素。这与数组的 $(C .idup) 属性的行为一致。
)

$(P
通过查看第一个元素的地址，我们可以看出 $(C immutableSlice) 中的元素实际上是 $(C slice) 中元素的拷贝：
)

---
    assert(&(slice[0]) $(HILITE !=) &(immutableSlice[0]));
---

$(P
然而有时在某些情况下这种非必需的拷贝将显著降低程序的运行效率。来看下下面这个示例，其中有一个函数接收 $(C immutable) slice 参数：
)

---
void calculate(immutable int[] coordinates) {
    // ...
}

void main() {
    int[] numbers;
    numbers ~= 10;
    // ... 多种修改 ...
    numbers[0] = 42;

    calculate(numbers);    $(DERLEME_HATASI)
}
---

$(P
上面这段代码无法通过编译因为调用者向 $(C calculate()) 传递了非 $(C immutable) 的参数。就像我们之前看到的那样，我们可以使用 $(C to()) 来创建 $(C immutable) slice：
)

---
import std.conv;
// ...
    auto immutableNumbers = to!(immutable int[])(numbers);
    calculate(immutableNumbers);    // ← 现在通过编译了
---

$(P
但如果 $(C numbers) 只是被用来作参数且在函数调用完成前并没有被修改，那复制到 $(C immutableNumbers) 的操作就显得没有必要。$(C assumeUnique()) 无需复制即可将 slice 中的元素转换为 $(C immutable)：
)

---
import std.exception;
// ...
    auto immutableNumbers = assumeUnique(numbers);
    calculate(immutableNumbers);
    assert(numbers is null);    // 原来的 slice 变为 null
---

$(P
$(C assumeUnique()) 返回一个新的 slice，将传入的元素直接转换为 $(C immutable)。它同时会将传入的 slice 变为 $(C null) 以防止通过它对 $(C immutable) 元素的修改。
)

$(H6 $(IX cast) The $(C cast) 运算符)

$(P
$(C to()) 和 $(C assumeUnique()) 都是使用 $(C cast) 运算符实现的，当然除了标准库程序员也可以使用这个运算符。
)

$(P
$(C cast) 运算符后紧跟一对圆括号，括号中的类型即为目标类型：
)

---
    cast($(I DestinationType))value
---

$(P
$(C cast) 非常强大，它能做很多 $(C to()) 无法安全执行的转换。比如说 $(C to()) 无法在运行时执行以下转换：
)

---
    Suit suit = to!Suit(7);    $(CODE_NOTE_WRONG 抛出异常)
    bool b = to!bool(2);       $(CODE_NOTE_WRONG 抛出异常)
---

$(SHELL
std.conv.ConvException@phobos/std/conv.d(1778): Value (7)
$(HILITE does not match any member) value of enum 'Suit'
)

$(P
有的时候只有程序员知道某个整型是否对应有效的 $(C enum) 或将一个数字转换为 $(C bool) 是否是有意义的。$(C cast) 运算符则可在任何程序逻辑认为是正确的地方执行转换：
)

---
    // 可能得到错误的结果但转换本身是可行的：
    Suit suit = cast(Suit)7;

    bool b = cast(bool)2;
    assert(b);
---

$(P
对于转换到指针或从指针转换为其它类型的情况，$(C cast) 是唯一的选择：
)

---
    $(HILITE void *) v;
    // ...
    int * p = cast($(HILITE int*))v;
---

$(P
某些 C 语言库可能需要将指针以非指针的类型储存，当然这种情况很少见。如果它保证转换能保留正确的值，$(C cast) 可以在指针和非指针类型间转换：
)

---
    size_t savedPointerValue = cast($(HILITE size_t))p;
    // ...
    int * p2 = cast($(HILITE int*))savedPointerValue;
---

$(H5 小结)

$(UL

$(LI 自动类型转换通常只会向着安全的方向进行：从窄类型转换到宽类型，从可变转换到 $(C const)。)

$(LI 但转换到无符号类型时可能会得到意料之外的结果，因为无符号类型无法储存负数。)

$(LI $(C enum) 可被隐式转换为整型，但反过来却不行。)

$(LI $(C false) 和 $(C true) 可被分别隐式转换为 0 和 1。同样的是，0 会被隐式转换为 $(C false)，非零值将被隐式转换为 $(C true)。)

$(LI $(C null) 引用能被隐式转换为 $(C false)，非 $(C null) 引用能被隐式转换为 $(C true)。)

$(LI 可以使用构造语法进行显式转换。)

$(LI $(C to()) 可以用在大多数显式转换中。)

$(LI $(C assumeUnique()) 可在不经复制的情况下将可变类型转换为 $(C immutable)。)

$(LI $(C cast) 运算符是最有用的转换工具。)

)

Macros:
        SUBTITLE=类型转换

        DESCRIPTION=D 编程语言中的隐式和显式转换。


        KEYWORDS=D 编程语言教程 类型转换
