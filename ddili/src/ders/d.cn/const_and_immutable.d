Ddoc

$(DERS_BOLUMU $(IX const) $(IX immutable) 不可变性)

$(P
我们已经多次遇到过变量这个概念了。之所以叫变量是因为我们可以通过表达式修改它的值：
)

---
    // 支付账单
    totalPrice = calculateAmount(itemPrices);
    moneyInWallet $(HILITE -=) totalPrice;
    moneyAtMerchant $(HILITE +=) totalPrice;
---

$(P
我们把这种修改操作成为$(I 赋值)。对于大多数任务来说可变值都是必须的。但变量并不能适用于所有情况：
)

$(UL

$(LI
某些值一旦定义就不会在改变。比如说，一星期总是有七天、永远不会改变的数学常量 $(I pi)（π）、程序所支持的自然语言总是有限的（比如只支持英语和土耳其语）等等。
)

$(LI
如果所有的量都是可变的，那任何一段使用这些值的代码都可能会修改它们。虽然对这些值的修改完全没有必要，但这并不能保证不会发生意外的更改操作。如果没有不变性约定，程序将变得难以阅读和维护。

$(P
让我们来看一个例子，假设有一个用来让员工退休的函数 $(C retire(office, worker))。在变量均可变的情况下，这段代码并不能清晰的传递出它所要表达的意图（如果只看函数调用的话）。每一个变量都有可能被函数修改。我们可能的确需要减少 $(C office) 中活动员工的个数，但函数需要以相同的方式修改 $(C worker) 吗？
)

)

)

$(P
不变性能够帮助我们理解程序，因为它保证了操作一定不会修改变量的值。同时它也能降低程序出现错误的风险。
)

$(P
在 D 语言中，$(I 不变性) 是通过关键字 $(C const) 和 $(C immutable) 描述的。虽然这两个词的含义相近，但在程序中它们有着不同的作用且在某些情况下无法相互兼容。
)

$(P
$(IX 类型限定符) $(IX 限定符, type) $(C const)、$(C immutable)、$(C inout) 和 $(C shared) 是$(I 类型限定符)。
（我们会在之后的章节中学习 $(LINK2 /ders/d.cn/function_parameters.html, $(C inout)) 和 $(LINK2 /ders/d.cn/concurrency_shared.html, $(C shared))。）
)

$(H5 不可变变量)

$(P
如果你非要认为词组“immutable variable”和“constant variable”中的“variable”指的是$(I 某种可变的量)的话，那这两个词组就没有什么意义了。广义上来说，“variable”指的是程序中任何可变或不可变的值。
)

$(P
有三种定义不变量的方法。
)

$(H6 $(IX enum) $(C enum) 常量)

$(P
我们在之前的 $(LINK2 /ders/d.cn/enum.html, $(C enum)) 一章中介绍过 $(C enum) 常被用来定义命名常量：
)

---
    enum fileName = "list.txt";
---

$(P
如果函数返回值可在编译期确定，那我们也可以使用函数返回值来初始化 $(C enum) 常量：
)

---
int totalLines() {
    return 42;
}

int totalColumns() {
    return 7;
}

string name() {
    return "list";
}

void main() {
    enum fileName = name() ~ ".txt";
    enum totalSquares = totalLines() * totalColumns();
}
---

$(P
正如我们期望的那样，$(C enum) 常量无法被修改：
)

---
    ++totalSquares;    $(DERLEME_HATASI)
---

$(P
虽然 $(C enum) 能高效地定义不变量，但这种方法只能用在编译期已知的值上。
)

$(P
$(C enum) 实际上是$(I 一个宏)，即在编译时编译器将以枚举实际的值替换枚举名。来看下面这个例子，有一个 $(C enum) 定义和两个使用它的表达式：
)

---
    enum i = 42;
    writeln(i);
    foo(i);
---

$(P
上面这段代码和下面这段代码等价，实际上每一个使用 $(C i) 的地方都被替换为 $(C 42)：
)

---
    writeln(42);
    foo(42);
---

$(P
虽然对像 $(C int) 一样的简单类型来说这种替换不会影响程序的执行结果，但对于数组或关联数组来说 $(C enum) 常量将引入不易察觉的运行时开销：
)

---
    enum a = [ 42, 100 ];
    writeln(a);
    foo(a);
---

$(P
用 $(C a) 的值替换它自己之后，上面这段代码将会被编译成下面这样：
)

---
    writeln([ 42, 100 ]); // 在运行时创建一个数组
    foo([ 42, 100 ]);     // 又在运行时创建一个数组
---

$(P
此处的开销在于两个表达式分别创建了一个数组。因此如果程序中的数组和关联数组会被多次使用的话最好还是将其定义为 $(C immutable) 变量。
)

$(P
可用函数返回值初始化 $(C enum) 常量：
)

---
    enum a = makeArray();    // 在编译期调用
---

$(P
使用 D 语言的$(I 编译期函数执行)（CTFE）特性初始化枚举也是可行的，我们会在 $(LINK2 /ders/d.cn/functions_more.html, 之后的章节) 中学习。
)

$(H6 $(IX 变量, immutable) $(C immutable) 变量)

$(P
与 $(C enum) 相同，关键字 $(C immutable) 保证变量的值永远不会被改变。但与 $(C enum) 不同的是，$(C immutable) 变量是一个真实存在的变量，它有内存地址。也就是说我们可以在运行时设定它的值，或者引用它的内存地址。
)

$(P
下面这段代码比较了 $(C enum) 和 $(C immutable) 的用法。程序要求用户猜一个随机数。由于随机数不能在编译期确定，所以它不能被定义为 $(C enum)。但一旦确定后随机数将不再改变，所以 $(C immutable) 非常适合用在这里。
)

$(P
程序利用了我们之前写的 $(C readInt()) 函数：
)

---
import std.stdio;
import std.random;

int readInt(string message) {
    int result;
    write(message, "?");
    readf(" %s", &result);
    return result;
}

void main() {
    enum min = 1;
    enum max = 10;

    $(HILITE immutable) number = uniform(min, max + 1);

    writefln("I am thinking of a number between %s and %s.",
             min, max);

    auto isCorrect = false;
    while (!isCorrect) {
        $(HILITE immutable) guess = readInt("What is your guess");
        isCorrect = (guess == number);
    }

    writeln("Correct!");
}
---

$(P
显然：
)

$(UL

$(LI $(C min) 和 $(C max) 是程序行为的一部分，它们在编译期就已经确定了。所以它们被定义为 $(C enum) 常量。
)

$(LI $(C number) 之所以被定义为 $(C immutable) 是因为在运行时它一旦初始化就不会再被改变。就像用户猜的数一样：一旦被确定就不会再被修改。
)

$(LI 注意这些变量并没有显式指定类型。就像$(C auto) 和 $(C enum) 一样，$(C immutable) 变量的类型也可以从等号右侧的表达式中推导出来。
)

)

$(P
$(C immutable) 通常将变量的实际类型放在其后的圆括号中，就象这样：$(C immutable(int))。但大多数时候我们并不需要显式写出完整类型。下面这段程序的输出表明这三个变量的实际类型完全相同：
)

---
import std.stdio;

void main() {
    immutable      inferredType = 0;
    immutable int  explicitType = 1;
    immutable(int) wholeType    = 2;

    writeln(typeof(inferredType).stringof);
    writeln(typeof(explicitType).stringof);
    writeln(typeof(wholeType).stringof);
}
---

$(P
这三个类型实际上都包含 $(C immutable)：
)

$(SHELL
immutable(int)
immutable(int)
immutable(int)
)

$(P
圆括号可以更明确的指明类型的哪一部分是不可变的。之后我们在讨论整个 slice 的不变性与其元素的不变性的区别时再次看到它。
)

$(H6 $(IX 变量, const) $(C const) 变量)

$(P
在定义变量时 $(C const) 关键字与 $(C immutable) 作用相同。$(C const) 变量不能被修改：
)

---
    $(HILITE const) half = total / 2;
    half = 10;    $(DERLEME_HATASI)
---

$(P
我建议你使用最好使用 $(C immutable) 而不是 $(C const) 定义变量。因为 $(C immutable) 变量可以传递给函数的 $(C immutable) 形参。我们之后会见到相关的例子。
)

$(H5 不可变参数)

$(P
函数可以声明自己不会修改传入的参数，编译器将会确保这种承诺生效。在这之前我们先来看一个的确会修改传入的 slice 参数的函数。
)

$(P
slice 并不是拥有元素，它只是能够访问到元素。关于这点我们已经在 $(LINK2 /ders/d.cn/slices.html, Slice 和其它数组特性) 一章中介绍过了。对于一组数据，同一时间可能有多个 slice 能够访问到它们。
)

$(P
虽然本节都是 slice 的例子，但实际上这些问题也适用于关联数组和类，因为他们都是$(I 引用类型)。
)

$(P
实际上函数被调用时传入的 slice 并非参数列表中作实参的那个 slice。传入的 slice 是它的副本：
)

---
import std.stdio;

void main() {
    int[] slice = [ 10, 20, 30, 40 ];  // 1
    halve(slice);
    writeln(slice);
}

void halve(int[] numbers) {            // 2
    foreach (ref number; numbers) {
        number /= 2;
    }
}
---

$(P
当程序执行到 $(C halve()) 函数内部时，内存中将会有两个可以访问相同元素的 slice。
)

$(OL

$(LI $(C main()) 中定义的那个名为 $(C slice) 的 slice，被作为参数传给 $(C halve())
)

$(LI $(C halve()) 接收到的名为 $(C numbers) 的 slice 能够与 $(C slice) 访问同一组元素。
)

)

$(P
由于两个 slice 都指向同一组元素且我们在 $(C foreach) 中使用了 $(C ref) 关键字，所以输出的结果中每一个元素的值都变为原来的一半了：
)

$(SHELL
[5, 10, 15, 20]
)

$(P
当我们需要使用函数修改传入的 slice 时这个特性很有用。就像我们的例子一样，某些函数存在的意义就是为了实现这样的功能。
)

$(P
编译器不允许我们将 $(C immutable) 作为参数传入这种函数，因为我们不能修改一个 immutable 量：
)

---
    $(HILITE immutable) int[] slice = [ 10, 20, 30, 40 ];
    halve(slice);    $(DERLEME_HATASI)
---

$(P
编译器的错误信息明确的告诉我们 $(C immutable(int[])) 类型的量不能被用作 $(C int[]) 型的参数：
)

$(SHELL
Error: function deneme.halve ($(HILITE int[]) numbers) is not callable
using argument types ($(HILITE immutable(int[])))
)

$(H6 $(IX 参数, const) $(C const) 参数)

$(P
不能给像 $(C halve()) 一样的函数传递 $(C immutable) 变量是很自然的事情，毕竟它们需要修改参数。然而，对于那些的确不会修改参数的函数来说，这条限制又显得有些多余：
)

---
import std.stdio;

void main() {
    immutable int[] slice = [ 10, 20, 30, 40 ];
    print(slice);    $(DERLEME_HATASI)
}

void print(int[] slice) {
    writefln("%s elements: ", slice.length);

    foreach (i, element; slice) {
        writefln("%s: %s", i, element);
    }
}
---

$(P
对于上面这个例子来说，函数只是显示 slice，并不会修改它。由于 $(C immutable) 的存在而无法传入 slice 是没有意义的。我们需要一种优雅地解决类似问题的方式，这就是 $(C const)：
)

$(P
$(C const) 关键字创建了一个$(I 特殊的引用)（比如 slice）来确保变量不会被修改。对一个参数指定 $(C const) 意味着函数保证不会修改 slice 中的元素。只要 $(C print()) 提供了这样的保证，程序就能通过编译：
)

---
    print(slice);    // 现在编译通过了
// ...
void print($(HILITE const) int[] slice)
---

$(P
有了这种保证，函数参数不仅可以接收可变变量也可接收 $(C immutable) 变量。
)

---
    immutable int[] slice = [ 10, 20, 30, 40 ];
    print(slice);           // 编译通过

    int[] mutableSlice = [ 7, 8 ];
    print(mutableSlice);    // 编译通过
---

$(P
如果不对那些函数不会修改的参数指定 $(C const) 会限制的函数的适用范围。除此之外，$(C const) 参数还能为程序员提供有价值的信息。若已知传入函数的变量不会被修改，代码将更易理解。它也会消除潜在的出现错误的可能，因为编译器会检查是否存在对 $(C const) 参数的修改操作：
)

---
void print($(HILITE const) int[] slice) {
    slice[0] = 42;    $(DERLEME_HATASI)
---

$(P
这样程序员就能知道函数中出现了错误，或者也许需要重新设计接口移除 $(C const) 声明。
)

$(P
通过 $(C const) 参数能够接收可变变量和 $(C immutable) 变量这个设计我们可以得到一个有趣的结论。我们会在“参数是否应该声明为 $(C const) 或 $(C immutable)？”一节中说明。
)

$(H6 $(IX 参数, immutable) $(C immutable) 参数)

$(P
就像我们刚刚看到的那样，可变变量和 $(C immutable) 变量都可以传递给函数的 $(C const) 参数。在某种程度上，$(C const) 参数很受欢迎。
)

$(P
而与它相对的是，$(C immutable) 参数一共了一种非常强的要求：只有 $(C immutable) 变量可以传给 $(C immutable) 参数：
)

---
void func($(HILITE immutable) int[] slice) {
    // ...
}

void main() {
    immutable int[] immSlice = [ 1, 2 ];
              int[]    slice = [ 8, 9 ];

    func(immSlice);      // 编译通过
    func(slice);         $(DERLEME_HATASI)
}
---

$(P
因此，只有在明确这种需求时才使用 $(C immutable) 声明。在使用 string 类型时，我们会间接的声明 $(C immutable)。等下我们会讲到的。
)

$(P
我们已经了解到 $(C const) 或 $(C immutable) 声明保证了被传入参数的$(I 变量的实际值)不会被改变。这种声明只针对引用类型，因为我们讨论的不可变性都是针对引用类型的$(I 实际值)的。
)

$(P
我们会在之后的章节中介绍$(I 引用类型)和$(I值类型)。在目前已经见到的所有类型中，只有 slice 和关联数组是引用类型，其它均为值类型。
)

$(H6 $(IX 参数, const vs. immutable) 是否应该将形参声明为 $(C const) 或 $(C immutable)？)

$(P
上面两个小节可能会给你一种暗示，让你觉得 $(C const) 形参比 $(C immutable) 形参更灵活。实际上并非总是如此。
)

$(P
$(C const) $(I 抹去)了原变量可变或 $(C immutable) 的信息。甚至连编译器都不再考虑这些信息。
)

$(P
其后果就是函数的 $(C const) 形参无法再作为实参传给另一个函数的 $(C immutable) 形参。就像下面这个例子，$(C foo()) 函数不能把 $(C const) 参数再传给 $(C bar())：
)

---
void main() {
    /* 原变量被声明为 immutable */
    immutable int[] slice = [ 10, 20, 30, 40 ];
    foo(slice);
}

/* 为了提高可可用性，函数将其形参
 * 定义为 const。*/
void foo(const int[] slice) {
    bar(slice);    $(DERLEME_HATASI)
}

/* 由于某种原因，函数将其形参
 * 定义为 immutable。*/
void bar(immutable int[] slice) {
    // ...
}
---

$(P
$(C bar()) 要求实参为 $(C immutable)。然而，在大多数情况下它并不知道 $(C foo()) 的 $(C const) 形参对应的引用是否为 $(C immutable)。
)

$(P
$(I $(B 注：) 从上面的代码中可以清楚的看出 $(C main()) 中的原变量是 $(C immutable)。但编译器实际上并不会去关注函数被调用的位置，它会将这些函数分别单独编译。对编译器来说，传入 $(C foo()) 函数的 $(C slice) 的实参既可能是可变变量也可能是 $(C immutable) 变量。
)
)

$(P
一种解决方案是向 $(C bar()) 传入其 immutable 拷贝。
)

---
void foo(const int[] slice) {
    bar(slice$(HILITE .idup));
}
---

$(P
虽然这种方案看起来很合理，但它会引入拷贝 slice 及其元素带来的性能损失。尤其是一开始就传入 $(C immutable) 时，这种拷贝显然时没有必要的。
)

$(P
通过上面这个例子我们可以清晰的认识到，$(C const) 形参并不能完美的适用于所有情况。毕竟如果 $(C foo()) 将参数定义为 $(C immutable)，它就不需要在调用 $(C bar()) 前复制整个 slice：
)

---
void foo(immutable int[] slice) {  // 这次是 immutable
    bar(slice);    // 不再需要拷贝
}
---

$(P
虽然这段代码通过了编译，但若最初传入 $(C foo()) 的变量不是 immutable，那将形参定义为 $(C immutable) 依旧需要对原变量进行一次 immutable 拷贝。
)

---
    foo(mutableSlice$(HILITE .idup));
---

$(P
模版可以帮助解决这个问题。（我们会在之后的章节中学习模版）我并不强求你此时就能理解以下全部代码，但我依旧将其作为此问题的一个解决方案。下面这个函数模版 $(C foo()) 即可传入可变变量也可传入 $(C immutable) 变量。只有当原变量是可变变量时，参数才会被复制；如果原变量为 $(C immutable)，那此处不会执行任何复制操作：
)

---
import std.conv;
// ...

/* 以为 foo() 是模版，它既可传入可变变量
 * 又可传入 immutable 变量。*/
void foo(T)(T[] slice) {
    /* 如果原变量已经是 immutable，‘to()’
     * 不会进行复制。*/
    bar(to!(immutable T[])(slice));
}
---

$(H5 不可变 slice 与不可变元素)

$(P
就像我们之前见到的那样，$(C immutable) slice 的完整类型是 $(C immutable(int[]))。$(C immutable) 之后的圆括号表明整个 slice 都是 $(C immutable)。这样的 slice 不能被任何方式修改：不能添加或删除元素，不能修改元素的值，slice 也不能指向另一组元素：
)

---
    immutable int[] immSlice = [ 1, 2 ];
    immSlice ~= 3;               $(DERLEME_HATASI)
    immSlice[0] = 3;             $(DERLEME_HATASI)
    immSlice.length = 1;         $(DERLEME_HATASI)

    immutable int[] immOtherSlice = [ 10, 11 ];
    immSlice = immOtherSlice;    $(DERLEME_HATASI)
---

$(P
如此极致的不可变性可能并不适用于某些情况。在大多数情况下，我们只需要元素的不可变性。由于 slice 只是一个访问元素的工具，只要元素不能被修改，slice 本身能否被改变并不重要。尤其是先前那种函数接收 slice 拷贝的情况。
)

$(P
$(C immutable) 关键字后的括号只括起元素类型即可实现这种需求。经过这样的修改，现在只有元素是不可变的，而不再是 slice：
)

---
    immutable$(HILITE (int))[] immSlice = [ 1, 2 ];
    immSlice ~= 3;               // 可以增加元素
    immSlice[0] = 3;             $(DERLEME_HATASI)
    immSlice.length = 1;         // 可以移除元素

    immutable int[] immOtherSlice = [ 10, 11 ];
    immSlice = immOtherSlice;    /* 可以提供到
                                  * 其它数组的访问 */
---

$(P
虽然这两种语法很相似，但它们却有着截然不同的含义。总结一下：
)

---
    immutable int[]  a = [1]; /* 无论是元素本身还是
                               * slice 都不可以修改 */

    immutable(int[]) b = [1]; /* 同上 */

    immutable(int)[] c = [1]; /* 元素不可被修改
                               * 但 slice 可以 */
---

$(P
这种差异已经体现在之前我们写过的程序中了。你应该还记得这三种不可变字符串别名：
)

$(UL
$(LI $(C string) 是 $(C immutable(char)[])) 的别名
$(LI $(C wstring) 是 $(C immutable(wchar)[])) 的别名
$(LI $(C dstring) 是 $(C immutable(dchar)[])) 的别名
)

$(P
字符串字面量也是不可变的：
)

$(UL
$(LI 字面量 $(STRING "hello"c) 的类型 $(C string))
$(LI 字面量 $(STRING "hello"w) 的类型 $(C wstring))
$(LI 字面量 $(STRING "hello"d) 的类型 $(C dstring))
)

$(P
基于这样的定义，正常情况下 D 语言的字符串是$(I 不可变字符)数组。
)

$(H6 $(IX 传递性, immutability) $(C const) 和 $(C immutable) 具有传递性)

$(P
正如之前 slice $(C a) 和 $(C b) 的注释所说的那样，slice 本身及其元素均为 $(C immutable)。
)

$(P
对 $(LINK2 /ders/d.cn/struct.html, 结构体) 和 $(LINK2 /ders/d.cn/class.html, 类) 来说，这个结论也是正确的。关于这两种语法我们会在之后的章节中介绍。举个例子，$(C const) $(C struct) 的所有成员均为 $(C const)，$(C immutable) $(C struct) 的所有成员均为 $(C immutable)。（类也是一样的。）
)

$(H6 $(IX .dup) $(IX .idup) $(C .dup) 和 $(C .idup))

$(P
当函数传入 string 参数时，参数可能不匹配函数指定的不可变性。$(C .dup) 和 $(C .idup) 属性提供了满足可变性要求的数组拷贝：
)

$(UL
$(LI $(C .dup) 提供一个可变的数组拷贝；它的名字来源于英文单词 ”duplicate”)
$(LI $(C .idup) 提供一个不可变的数组拷贝)
)

$(P
就像下面这个例子，要求传入不可变参数的函数可用可变变量的不可变拷贝调用：
)

---
void foo($(HILITE string) s) {
    // ...
}

void main() {
    char[] salutation;
    foo(salutation);                $(DERLEME_HATASI)
    foo(salutation$(HILITE .idup));           // ← 编译通过
}
---

$(H5 使用方法小结)

$(UL

$(LI
作为一个通用规则，优先使用不可变变量。
)

$(LI
如果某个值可在编译期计算，将其定义为 $(C enum)。比如 常量$(I 一分钟有 60 秒) 即可被定义为 $(C enum)：

---
    enum int secondsPerMinute = 60;
---

$(P
如果能从等号右侧的表达式中推导出变量类型，那就无需显示指定：
)

---
    enum secondsPerMinute = 60;
---

)

$(LI
注意 $(C enum) 数组和 $(C enum) 关联数组带来的隐藏开销。如果数组很大并在程序中多次使用应将其定义为 $(C immutable) 变量。
)

$(LI
如果变量一经定义不会再改变而且在编译期无法计算出它们的值，将其定义为 $(C immutable)。它也可以使用类型推倒：

---
    immutable guess = readInt("What is your guess");
---

)

$(LI
如果函数保证不修改参数，应为参数指定 $(C const)。它既允许传入可变实参也允许传入 $(C immutable) 实参。

---
void foo(const char[] s) {
    // ...
}

void main() {
    char[] mutableString;
    string immutableString;

    foo(mutableString);      // ← 编译通过
    foo(immutableString);    // ← 编译通过
}
---

)

$(LI
上面这条规则还需要考虑 $(C const) 参数无法传入接收 $(C immutable) 参数的函数的情况。参见“是否应该将形参声明为 $(C const) 或 $(C immutable)？”小节。
)

$(LI
如果函数的确需要修改参数，形参应为可变类型（$(C const) 和 $(C immutable) 都不允许任何形式的修改）：

---
import std.stdio;

void reverse(dchar[] s) {
    foreach (i; 0 .. s.length / 2) {
        immutable temp = s[i];
        s[i] = s[$ - 1 - i];
        s[$ - 1 - i] = temp;
    }
}

void main() {
    dchar[] salutation = "hello"d.dup;
    reverse(salutation);
    writeln(salutation);
}
---

$(P
输出为：
)

$(SHELL
olleh
)

)

)

$(H5 小结)

$(UL

$(LI $(C enum) 常量表示能在编译期得到的值。)

$(LI $(C immutable) 变量表示只有通过运行期计算才能获取到的常量或需要内存地址能通过引用访问的常量。)

$(LI $(C const) 形参保证函数不会修改传入的实参。可变变量和 $(C immutable) 变量均可作为 $(C const) 形参的实参。)

$(LI $(C immutable) 形参则代表了一种函数要求。只有 $(C immutable) 变量才能作为实参传给 $(C immutable) 形参。)

$(LI $(C immutable(int[])) 指明无论是 slice 本身还是元素都不可以被修改。)

$(LI $(C immutable(int)[]) 仅指明元素不可被修改。)

)

Macros:
        SUBTITLE=不可变性

        DESCRIPTION=D 语言中的 const 和 immutable 关键字，提供不可变性概念。

        KEYWORDS=D 编程语言教程 immutable const
