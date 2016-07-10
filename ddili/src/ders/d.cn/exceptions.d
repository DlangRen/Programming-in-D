Ddoc

$(DERS_BOLUMU $(IX 异常) 异常)

$(P
意外情况是程序的一部分：用户错误、编程错误、程序运行环境的改变等等。程序面临异常情况时必须以一定的方式来避免生成错误的结果。
)

$(P
这些情况中有些可能严重到足以停止程序的执行。例如，所需的信息可能丢失或无效、或设备可能无法正常工作。D 语言的异常处理机制用以在必要时停止程序的执行，以及在可能时从意外状况中恢复。
)

$(P
作为一个严重情况的示例，我们可以构想一个将未知操作符传递给只知四个算术操作符的函数，正如我们在之前章节的练习中所看到的那样：
)

---
    switch (operator) {

    case "+":
        writeln(first + second);
        break;

    case "-":
        writeln(first - second);
        break;

    case "x":
        writeln(first * second);
        break;

    case "/":
        writeln(first / second);
        break;

    default:
        throw new Exception(format("Invalid operator: %s", operator));
    }
---

$(P
上方的 $(C switch) 语句不知如何处理那些不在 $(C case) 语句中列出的操作符，所以抛出了异常。
)

$(P
Phobos 里有很多抛出异常的例子。比如 $(C to!int)，它能将一个整型的字符串表示形式转变为 $(C int) 值，而在该表示形式无效时抛出异常：
)

---
import std.conv;

void main() {
    const int value = to!int("hello");
}
---

$(P
该程序以 $(C to!int) 抛出异常而终止：
)

$(SHELL
std.conv.ConvException@std/conv.d(38): std.conv(1157): $(HILITE Can't
convert value) `hello' of type const(char)[] to type int
)

$(P
信息开头的 $(C std.conv.ConvException) 是抛出的异常对象的类型。我们能由名字来辨认出该类型是定义在 $(C std.conv) 模块的 $(C ConvException)。
)

$(H5 $(IX throw) 用以抛出异常的 $(C throw) 语句 )

$(P
我们在上方示例和先前章节中都看到了 $(C throw) 语句。
)

$(P
$(C throw) 抛出一个(I 异常对象)并终止当前的程序运行。在 $(C throw) 语句之后的表达式或语句将不会执行。这种行为是出于异常的天性：当程序无法继续执行目前的任务时，它们必须被抛出。
)

$(P
相反，如果程序能继续执行，那么该情况下不一定会抛出异常。这样的情况下函数会找到一种方式继续下去。
)

$(H6 $(IX Exception) $(IX Error) $(IX Throwable) 异常类型 $(C Exception) 与 $(C Error))

$(P
只有从 $(C Throwable) 类继承的类型能被抛出。$(C Throwable) 几乎从不在程序里被直接使用。真正被抛出的类型是那些继承自 $(C Exception) 或 $(C Error) 的类型，因而它们本身也继承自 $(C Throwable)。例如，所有由 Phobos 抛出的异常是从 $(C Exception) 或 $(C Error) 继承的。
)

$(P
$(C Error) 代表无法恢复的情况，并且它不建议被$(I 捕捉)。由是，程序所抛出大部分的异常是继承自 $(C Exception) 的类型。($(I $(B 注：) 继承是一个与类相关的主题。我们会在此后的一章中看到类。))
)

$(P
$(C Exception) 对象构建自一个代表错误信息的 $(C string) 值。或许你会觉得以 $(C std.string) 模块的 $(C format()) 函数能很容易地创建该信息：
)

---
import std.stdio;
import std.random;
import std.string;

int[] randomDiceValues(int count) {
    if (count < 0) {
        $(HILITE throw new Exception)(
            format("Invalid dice count: %s", count));
    }

    int[] values;

    foreach (i; 0 .. count) {
        values ~= uniform(1, 7);
    }

    return values;
}

void main() {
    writeln(randomDiceValues(-5));
}
---

$(SHELL
object.Exception...: Invalid dice count: -5
)

$(P
大多数情况下，将会调用 $(C enforce()) 函数，而非由 $(C new) 明确地创建一个异常对象，并由 $(C throw) 直接抛出。例如，上方的错误检查与下方对 $(C enforce()) 的调用等效：
)

---
    enforce(count >= 0, format("Invalid dice count: %s", count));
---

$(P
我们将在后面章节了解到 $(C enforce()) 和 $(C assert()) 的差异。
)

$(H6 抛出异常将终结所有作用域)

$(P
我们已经看到，程序从 $(C main) 函数开始执行并从那里分支进入其他函数。这种逐层执行、深入函数并从它们返回的方式可以被看作是树状图的分支。
)

$(P
例如，$(C main()) 会调用出一个叫 $(C makeOmelet) 的函数，从而调用出另一个名为 $(C prepareAll) 的函数，接着调用出名为 $(C prepareEggs) 的函数，如此继续下去。假设箭头指向所调用的函数，那么这样一个程序的分支可以以下面的函数调用树状图表示出来：
)

$(MONO
main
  │
  ├──▶ makeOmelet
  │      │
  │      ├──▶ prepareAll
  │      │          │
  │      │          ├─▶ prepareEggs
  │      │          ├─▶ prepareButter
  │      │          └─▶ preparePan
  │      │
  │      ├──▶ cookEggs
  │      └──▶ cleanAll
  │
  └──▶ eatOmelet
)

$(P
下面的程序通过使用不同级别的缩进来实现上方输出中的分支化。该程序除了生成合乎我们目的的输出外并没有起到其他任何作用：
)

---
$(CODE_NAME all_functions)import std.stdio;

void indent(in int level) {
    foreach (i; 0 .. level * 2) {
        write(' ');
    }
}

void entering(in char[] functionName, in int level) {
    indent(level);
    writeln("▶ ", functionName, "'s first line");
}

void exiting(in char[] functionName, in int level) {
    indent(level);
    writeln("◁ ", functionName, "'s last line");
}

void main() {
    entering("main", 0);
    makeOmelet();
    eatOmelet();
    exiting("main", 0);
}

void makeOmelet() {
    entering("makeOmelet", 1);
    prepareAll();
    cookEggs();
    cleanAll();
    exiting("makeOmelet", 1);
}

void eatOmelet() {
    entering("eatOmelet", 1);
    exiting("eatOmelet", 1);
}

void prepareAll() {
    entering("prepareAll", 2);
    prepareEggs();
    prepareButter();
    preparePan();
    exiting("prepareAll", 2);
}

void cookEggs() {
    entering("cookEggs", 2);
    exiting("cookEggs", 2);
}

void cleanAll() {
    entering("cleanAll", 2);
    exiting("cleanAll", 2);
}

void prepareEggs() {
    entering("prepareEggs", 3);
    exiting("prepareEggs", 3);
}

void prepareButter() {
    entering("prepareButter", 3);
    exiting("prepareButter", 3);
}

void preparePan() {
    entering("preparePan", 3);
    exiting("preparePan", 3);
}
---

$(P
该程序生成了如下输出：
)

$(SHELL
▶ main, first line
  ▶ makeOmelet, first line
    ▶ prepareAll, first line
      ▶ prepareEggs, first line
      ◁ prepareEggs, last line
      ▶ prepareButter, first line
      ◁ prepareButter, last line
      ▶ preparePan, first line
      ◁ preparePan, last line
    ◁ prepareAll, last line
    ▶ cookEggs, first line
    ◁ cookEggs, last line
    ▶ cleanAll, first line
    ◁ cleanAll, last line
  ◁ makeOmelet, last line
  ▶ eatOmelet, first line
  ◁ eatOmelet, last line
◁ main, last line
)

$(P
$(C entering) 和 $(C exiting) 两个函数通过字符 $(C ▶) 和 $(C ◁) 表示函数的第一行和最后一行。程序由第一行的 $(C main()) 启动，随即分支进入其它函数，并最终由末行的 $(C main) 结束。
)

$(P
我们来修改 $(C prepareEggs) 函数，把鸡蛋的数量作为一个参数。由于这个参数在某些值时会出错，我们让这个函数在鸡蛋数少于一时抛出异常：
)

---
$(CODE_NAME prepareEggs_int)import std.string;

// ...

void prepareEggs($(HILITE int count)) {
    entering("prepareEggs", 3);

    if (count < 1) {
        throw new Exception(
            format("Cannot take %s eggs from the fridge", count));
    }

    exiting("prepareEggs", 3);
}
---

$(P
为了编译该程序，我们必须修改程序的其他行来适应上述变化。冰箱里拿出来的鸡蛋数目可以由 $（C main()） 开始，从一个函数到另一个函数来进行处理。下方是程序中需要更改的部分。-8 这个无效值是有意生成的，用以显示出抛出异常时的程序输出与先前的区别之处：
)

---
$(CODE_NAME makeOmelet_int_etc)$(CODE_XREF all_functions)$(CODE_XREF prepareEggs_int)// ...

void main() {
    entering("main", 0);
    makeOmelet($(HILITE -8));
    eatOmelet();
    exiting("main", 0);
}

void makeOmelet($(HILITE int eggCount)) {
    entering("makeOmelet", 1);
    prepareAll($(HILITE eggCount));
    cookEggs();
    cleanAll();
    exiting("makeOmelet", 1);
}

// ...

void prepareAll($(HILITE int eggCount)) {
    entering("prepareAll", 2);
    prepareEggs($(HILITE eggCount));
    prepareButter();
    preparePan();
    exiting("prepareAll", 2);
}

// ...
---

$(P
我们现在运行程序，便能看到之前在异常抛出点之后的那些输出行丢失了：
)

$(SHELL
▶ main, first line
  ▶ makeOmelet, first line
    ▶ prepareAll, first line
      ▶ prepareEggs, first line
object.Exception: Cannot take -8 eggs from the fridge
)

$(P
抛出异常时，程序会以从底层到顶层的执行顺序，使 $(C prepareEggs)，$(C prepareAll)，$(C makeOmelet) 和 $(C main()) 三个函数依次逐步退出。当程序从这些函数退出时不会执行其他步骤。
)

$(P
这样即刻终止的原因为：低等级函数的失败表明依赖于它的成功执行的高等级函数也是失败的。
)

$(P
由较低等级函数抛出的异常对象逐级地转移到较高等级的函数，使得程序最终退出 $(C main()) 函数。该异常采取的路径在下方的树状图中被高亮标出：
)

$(MONO
     $(HILITE ▲)
     $(HILITE │)
     $(HILITE │)
main $(HILITE &nbsp;◀───────────┐)
  │               $(HILITE │)
  │               $(HILITE │)
  ├──▶ makeOmelet $(HILITE &nbsp;◀─────┐)
  │      │               $(HILITE │)
  │      │               $(HILITE │)
  │      ├──▶ prepareAll $(HILITE &nbsp;◀──────────┐)
  │      │          │                $(HILITE │)
  │      │          │                $(HILITE │)
  │      │          ├─▶ prepareEggs  $(HILITE X) $(I thrown exception)
  │      │          ├─▶ prepareButter
  │      │          └─▶ preparePan
  │      │
  │      ├──▶ cookEggs
  │      └──▶ cleanAll
  │
  └──▶ eatOmelet
)

$(P
异常处理机制的要点正是立即退出所有的函数调用层。
)

$(P
有时$(I 捕捉（catch）)抛出的异常以继续程序的执行是有意义的。我会在下面介绍 $(C catch) 这个关键字。
)

$(H6 何时使用 $(C throw))

$(P
在无法继续执行的情况下使用 $(C throw)。例如，从文件里读取学生数的函数在该信息不可获取或错误时会抛出异常。
)

$(P
另一方面，如果问题是由像输入无效数据这样的用户行为引发，比起抛出异常，再次确认数据会显得更加有意义。在许多情况下显示错误信息并让用户重新输入数据会更恰当一些。
)

$(H5 $(IX try) $(IX catch) 捕获异常的 $(C try-catch) 语句)

$(P
正如我们上方所见，异常抛出导致程序退出了所有函数，并最终终止了整个程序。
)

$(P
退出函数时，异常对象会在路径上的任意点被 $(C try-catch) 语句捕获。$(C try-catch) 语句类似于“$(I 尝试（try）) 做这些事情，并 $(I 捕捉（catch）) 其中可能被抛出的异常”这个短句。这是 $(C try-catch) 的语法：
)

---
    try {
        // 将被执行的代码块
        // 其中可能会有异常抛出

    } catch ($(I an_exception_type)) {
        // 若这种类型的异常被捕获
        // 便要执行的表达式

    } catch ($(I another_exception_type)) {
        // 若这另一种类型的异常被捕获
        // 便要执行的表达式

    // ……更多恰当的 catch 语句块……

    } finally {
        // 无论异常抛出与否
        // 都要执行的表达式
    }
---

$(P
我们以下面这个暂不使用 $(C try-catch) 语句的程序开始。该程序从文件里读取整型变量 die 的值并将它打印到标准输出里：
)

---
import std.stdio;

int readDieFromFile() {
    auto file = File("the_file_that_contains_the_value", "r");

    int die;
    file.readf(" %s", &die);

    return die;
}

void main() {
    const int die = readDieFromFile();

    writeln("Die value: ", die);
}
---

$(P
注意 $(C readDieFromFile) 函数是以忽略错误情况的方式下编写的，默认了它所求的文件和值是有效的。换句话说，该函数只处理它自己的任务，而非关注错误情况。这是异常的一个好处：比之关注于错误情况，许多函数能以关注实际任务的方式被编写。
)

$(P
我们在文件 $(C the_file_that_contains_the_value) 不存在时启动程序：
)

$(SHELL
std.exception.ErrnoException@std/stdio.d(286): Cannot open
file $(BACK_TICK)the_file_that_contains_the_value' in mode $(BACK_TICK)r' (No such
file or directory)
)

$(P
抛出了一个 $(C ErrnoException) 类型的异常对象，并且程序立即终止，而非打印“Die&nbsp;value:&nbsp;”。
)

$(P
我们把一个在 $(C try) 语句块中调用 $(C readDieFromFile) 的中间函数添加到该程序里，并让 $(C main()) 调出这个新函数：
)

---
import std.stdio;

int readDieFromFile() {
    auto file = File("the_file_that_contains_the_value", "r");

    int die;
    file.readf(" %s", &die);

    return die;
}

int $(HILITE tryReadingFromFile)() {
    int die;

    $(HILITE try) {
        die = readDieFromFile();

    } $(HILITE catch) (std.exception.ErrnoException exc) {
        writeln("(Could not read from file; assuming 1)");
        die = 1;
    }

    return die;
}

void main() {
    const int die = $(HILITE tryReadingFromFile)();

    writeln("Die value: ", die);
}
---

$(P
我们在 $(C the_file_that_contains_the_value) 仍然丢失的状态下再次启动程序，这次该程序就不会因异常而终止。
)

$(SHELL
(Could not read from file; assuming 1)
Die value: 1
)

$(P
新程序$(I 尝试（try）)在 $(C try) 语句块里执行 $(C readDieFromFile)。如果那个块成功执行，函数会正常地以 $(C return die;) 语句结束。如果 $(C try) 块的执行以抛出明确指定的 $(C std.exception.ErrnoException) 异常退出，那么程序执行便进入 $(C catch) 语句块。
)

$(P
下面是程序在文件不存在时启动经过的概括：
)

$(UL
$(LI 像先前程序里一样，$(C std.exception.ErrnoException) 对象被（$(C File()，而非由我们的代码）抛出，)
$(LI 该异常对象被 $(C catch) 捕获，)
$(LI 在 $(C catch) 语句块的正常执行中假定值为 1，)
$(LI 而程序会接着以它的正常路径运行。)
)

$(P
$(C catch) 可能会捕获抛出的异常以求继续执行该程序的方法。
)

$(P
作为另一个示例，我们回到煎蛋卷（Omelet）程序并将一个 $(C try-catch) 语句添加到 $(C main()) 函数中：
)

---
$(CODE_XREF makeOmelet_int_etc)void main() {
    entering("main", 0);

    try {
        makeOmelet(-8);
        eatOmelet();

    } catch (Exception exc) {
        write("Failed to eat omelet: ");
        writeln('"', exc.msg, '"');
        writeln("Will eat at neighbor's...");
    }

    exiting("main", 0);
}
---

$(P
($(I $(B 注：)$(C .msg) property（属性）会在下面得到解释。))
)

$(P
$(C try) 语句块包括两行代码。任何从这些行中抛出的异常均会被 $(C catch) 语句块捕获。
)

$(SHELL
▶ main, first line
  ▶ makeOmelet, first line
    ▶ prepareAll, first line
      ▶ prepareEggs, first line
Failed to eat omelet: "Cannot take -8 eggs from the fridge"
Will eat at neighbor's...
◁ main, last line
)

$(P
正如我们在输出中所见，程序不再因为抛出的异常而终止。它从错误状态中恢复，并继续执行到 $(C main()) 函数的末尾。
)

$(H6 $(C catch) 语句块的顺次匹配)

$(P
我们至今为止在示例里用的 $(C Exception) 类型是种一般的异常类型。此类型仅表明程序里发生了错误。尽管它也包含了能更深入解读错误的错误消息，但它不包含关于错误$(I 类型)的信息。
)

$(P
我们在此章节前面所见的 $(C ConvException) 和 $(C ErrnoException) 是更加特殊的异常类型：前一个关于转换错误，后一个关于系统错误。正如 Phobos 里的许多其他异常类型及它们名称所暗示，$(C ConvException) 和 $(C ErrnoException) 都继承自类 $(C Exception)。
)

$(P
类 $(C Exception) 和它的兄弟类 $(C Error) 更进一步是继承自类 $(C Throwable) 的，这是最一般的异常类型。
)

$(P
虽有可能，但仍不建议捕获 $(C Error) 类型和那些自 $(C Error) 继承而来的类型。由于 $(C Throwable) 比 $(C Error) 更一般，所以也不建议去捕获 此类型。需要被正常捕获的是在 $(C Exception) 继承结构下的类型, 包括 $(C Exception) 自身。
)

$(MONO
           throwable$(I （不建议捕获）)
             ↗   ↖
    exception     error$(I （不建议捕获）)
     ↗    ↖        ↗    ↖
   ...    ...    ...    ...
)

$(P $(I $(B 注：) 我会在后面的 $(LINK2 /ders/d.cn/inheritance.html, 继承) 一章中解释层次结构表示形式。上方的树状图表示 $(C Throwable) 最为一般而 $(C Exception) 与 $(C Error) 较为特殊。)
)

$(P
捕获特定类型的异常对象是有可能的。例如，专门捕获 $(C ErrnoException) 对象来检查并处理系统错误是可行的。
)

$(P
异常当且仅当它们匹配由 $(C catch) 语句块规定的类型时才会被捕获。例如，尝试捕获 $(C SpecialExceptionType) 的 catch 语句块捕获块不会捕获 $(C ErrnoException)。
)

$(P
$(C try) 语句块执行时被抛出的异常对象类型以 $(C catch) 语句块的顺序被依次匹配到由 $(C catch) 语句块所指定的类型。如果该对象匹配 $(C catch) 语句块的指定的类型，那么异常便被看作被 $(C catch) 语句块捕获，同时执行编写在这个语句块里的代码。一旦找到一处匹配，剩下的 $(C catch) 语句块就会被忽略。
)

$(P
因为 $(C catch) 语句块的匹配次序为顺序，$(C catch) 语句块必须以从特殊到一般的异常类型顺序排列。因此，如果需要捕获 exception 异常类型，那么类 $(C Exception) 必须被指定在末尾的 $(C catch) 语句块内。
)

$(P
例如，正尝试捕获关于学生记录的特定类型异常的 $(C try-catch) 语句必须以从特殊到一般的顺序来排列 $(C catch) 语句块，正如下方代码所示：
)

---
    try {
        // 可能抛出的有关学生纪录异常的操作……

    } catch (StudentIdDigitException exc) {

        // 特定关于学生 ID
        // 数字错误的异常

    } catch (StudentIdException exc) {

        // 有关学生 ID 的更为一般的异常，
        // 但是不一定关于他们的数字

    } catch (StudentRecordException exc) {

        // 关于学生纪录的更一般的异常

    } catch (Exception exc) {

        // 可能和学生纪录无关
        // 但最为一般的异常

    }
---

$(H6 $(IX finally) $(C finally) 语句块)

$(P
$(C finally) 是 $(C try-catch) 语句的可选块。它包括那些无论异常抛出与否，都一定会执行的表达式。
)

$(P
为了了解 $(C finally) 是怎样运作的，我们看看这个有一半几率抛出异常的程序：
)

---
import std.stdio;
import std.random;

void throwsHalfTheTime() {
    if (uniform(0, 2) == 1) {
        throw new Exception("the error message");
    }
}

void foo() {
    writeln("the first line of foo()");

    try {
        writeln("the first line of the try block");
        throwsHalfTheTime();
        writeln("the last line of the try block");

    // ……这里可能有一个或多个 catch 语句块……

    } $(HILITE finally) {
        writeln("the body of the finally block");
    }

    writeln("the last line of foo()");
}

void main() {
    foo();
}
---

$(P
函数没有抛出异常时，程序输出如下内容：
)

$(SHELL
the first line of foo()
the first line of the try block
the last line of the try block
$(HILITE the body of the finally block)
the last line of foo()
)

$(P
函数抛出异常时，程序输出如下内容：
)

$(SHELL
the first line of foo()
the first line of the try block
$(HILITE the body of the finally block)
object.Exception@deneme.d: the error message
)

$(P
正如所见到的，尽管 "the last line of the try block" 和 "the last line of foo()" 未被输出，$(C finally) 语句块的内容在有异常抛出时仍然被执行。
)

$(H6 何时使用 $(C try-catch) 语句)

$(P
$(C try-catch) 语句对于捕获异常并做出些特殊处理十分有效。
)

$(P
因此，$(C try-catch) 语句必须仅在需要执行某些特殊任务时被使用。另外不要捕获异常，而应该让它们去可能会捕获它们的更高等级函数那里。
)

$(H5 异常的 property)

$(P
程序由于异常而终止、从而自动打印在输出中的信息亦可以在异常对象的 property 中取得获取。这些 property 由类 $(C Throwable) 定义：
)

$(UL

$(LI $(IX .file) $(C .file)：抛出异常的源文件名)

$(LI $(IX .line) $(C .line)：抛出异常的行数)

$(LI $(IX .msg) $(C .msg)：错误消息)

$(LI $(IX .info) $(C .info)：抛出异常时程序堆栈的状态)

$(LI $(IX .next) $(C .next)：下一个附属异常)

)

$(P
我们看到 $(C finally) 语句块在因异常而退出作用域时被执行。（我们会在以后的章节中看到，对于 $(C scope) 语句和$(I 析构函数)也是如此。）
)

$(P
$(IX 附属异常) 当然，这样的代码块也能抛出异常。由于已抛出的异常而在离开作用域时被抛出的异常叫做$(I 附属异常)。主异常和附属异常都是$(I 链表)数据结构中的元素，每个异常对象都可以通过前一个异常对象的 $(C .next) property进行访问。最后一个异常的 $(C .next) property 值为 $(C null)。（我们在之后的一章中将会看到 $(C null)。)
)

$(P
下面例子里有三处异常：主异常在 $(C foo()) 里被抛出，以及在 $(C foo()) 和 $(C bar()) 里的两处 $(C finally) 语句块中被抛出的附属异常。程序通过 $(C .next) property 访问附属异常。
)

$(P
在此程序中使用的一些概念将在之后的章节里作出解释。例如，仅包含 $(C exc) 的 $(C for) 循环持续条件表明$(I 当 $(C exc) 不是 $(C null))就继续循环下去。
)

---
import std.stdio;

void foo() {
    try {
        throw new Exception("Exception thrown in foo");

    } finally {
        throw new Exception(
            "Exception thrown in foo's finally block");
    }
}

void bar() {
    try {
        foo();

    } finally {
        throw new Exception(
            "Exception thrown in bar's finally block");
    }
}

void main() {
    try {
        bar();

    } catch (Exception caughtException) {

        for (Throwable exc = caughtException;
             exc;    // ← 表示：当 exc 不是‘ull’
             exc = exc$(HILITE .next)) {

            writefln("error message: %s", exc$(HILITE .msg));
            writefln("source file  : %s", exc$(HILITE .file));
            writefln("source line  : %s", exc$(HILITE .line));
            writeln();
        }
    }
}
---

$(P
输出为：
)

$(SHELL
error message: Exception thrown in foo
source file  : deneme.d
source line  : 6

error message: Exception thrown in foo's finally block
source file  : deneme.d
source line  : 9

error message: Exception thrown in bar's finally block
source file  : deneme.d
source line  : 20
)

$(H5 $(IX 错误, 种类) 错误种类)

$(P
我们已经见识到异常处理机制是多么有效。比起让程序以错误或丢失的数据或以任何其他错误的状态运行，它使得更低与更高等级的操作立即终止。
)

$(P
但这不意味着每种错误情况都适宜抛出异常。根据错误类型不同也许可以做些更有用的事。
)

$(H6 用户错误)

$(P
有些错误由用户导致。正如我们上方所见，即便程序期望输入数字，用户仍可能输入像“hello”这样的字符串。向用户显示错误信息并让他重新输入合适的数据可能更为恰当。
)

$(P
即便如此，由于无论如何使用错误数据的代码都会抛出异常，不复验数据而直接接受并使用该数据是可行的。重要的是需要告知用户数据错误的原因。
)

$(P
例如，我们看看这个从用户输入获取文件名的程序。这里至少有两种处理潜在错误的文件名的方法：
)

$(UL
$(LI $(B 在使用前验证数据)：我们能通过调用 $(C std.file) 模块的 $(C exists()) 来确认文件名对应的文件存在与否：
---
    if (exists(fileName)) {
        // 是的，文件存在

    } else {
        // 不，文件不存在
    }
---

$(P
这使得我们能够在当且仅当数据存在时打开它。然而，即便 $(C exists()) 返回 $(C true)，如果系统上另一进程在本程序打开它之前将文档删除或重命名，文档仍有可能无法打开。
)

$(P
因此，下列解决方案会更加有用。
)

)

$(LI $(B 在没有复验的情况下使用数据)：我们假定该数据有效，并立即使用它，因为在 $(C File) 无法打开文件时无论如何都会抛出异常。

---
import std.stdio;
import std.string;

void useTheFile(string fileName) {
    auto file = File(fileName, "r");
    // ……
}

string read_string(in char[] prompt) {
    write(prompt, ": ");
    return strip(readln());
}

void main() {
    bool is_fileUsed = false;

    while (!is_fileUsed) {
        try {
            useTheFile(
                read_string("Please enter a file name"));

            /* 如果运行至这一行，这表示
             * useTheFile() 函数已经成功完成
             * 即表明文件名有效
             * 
             * 我们现在可以将循环标志的值
             * 设置为终止循环
             */
            is_fileUsed = true;
            writeln("The file has been used successfully");

        } catch (std.exception.ErrnoException exc) {
            stderr.writeln("This file could not be opened");
        }
    }
}
---

)

)

$(H6 编程错误)

$(P
一些错误由程序员失误而导致。例如，程序员可能认为：一个刚被写入的函数会永远以一个大于或等于零的值调用，根据该程序的设计这是可能成立的。而若它依然被小于零的值调用即指示着在程序设计上或该设计实现上的错误。两者都可以被认为是某种编程错误。
)

$(P
比起异常处理机制，应对由编程失误导致的错误时使用 $(C assert) 会更加合适。（$(I $(B 注：)我们会在 $(LINK2 /ders/d.cn/assert.html, 之后的一章) 中谈及 $(C assert) 。)）
)

---
void processMenuSelection(int selection) {
    assert(selection >= 0);
    // ...
}

void main() {
    processMenuSelection(-1);
}
---

$(P
程序以 $(C assert) 失败终止：
)

$(SHELL_SMALL
core.exception.AssertError@$(HILITE deneme.d(3)): Assertion failure
)

$(P
$(C assert) 验证程序的状态并在失败时输出相关文件名与行数。上方的信息表示文件 deneme.d 第三行的断言失败了。
)

$(H6 意外情况)

$(P
对于除上方两种一般状况之外的意外情况，抛出异常仍然是适宜的。如果程序无法继续执行，那么便只能抛出异常。
)

$(P
对抛出的异常如何处理取决于调用出该函数的更高层函数。它们会捕获我们为了修复该状况而抛出的异常。
)

$(H5 总结)

$(UL

$(LI
当面临用户错误时立即警告用户或确保异常被抛出。该异常可能是由使用错误数据的另一个函数抛出，或者你可以直接抛出它。
)

$(LI
使用 $(C assert) 来验证程序逻辑和执行。($(I $(B 注：)$(C assert) 将会在之后的一章作出解释。))
)

$(LI
存在疑问时，用 $(C throw) 或 $(C enforce()) 抛出异常。($(I $(B 注：)$(C enforce()) 将会在之后的一章作出解释。))
)

$(LI
当且仅当你能对异常做出些有效处理时将它捕获。否则，不要用 $(C try-catch) 语句封装代码，而要把异常留给或能处理它们的更高层代码。
)

$(LI
以从特殊到一般的顺序排布 $(C catch) 语句块。
)

$(LI
把所有离开作用域时必须执行的表达式放在 $(C finally) 语句块里。
)

)

Macros:
        SUBTITLE=异常

        DESCRIPTION=D 语言在意外情况下的异常处理机制

        KEYWORDS=D 编程语言教程 异常 try catch finally exit failure success

MINI_SOZLUK=
