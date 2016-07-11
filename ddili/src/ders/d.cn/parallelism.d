Ddoc

$(DERS_BOLUMU $(IX parallelism) 并行)

$(P
$(IX core) 大多数现代微处理器架构都包含一个以上的$(I 核心)， 而其中的每一个核心都可以作为单独的运算单元使用。它们可在同时执行不同程序的不同片段。灵活使用模块 $(C std.parallelism) 中的功能来尽可能地利用所有核心的运算能力，使程序能以更快的速度运行。
)

$(P
本章涉及以下操作 range 的算法。只有当元素操作之间没有相互依赖时，它们才能被$(I 并行)执行。$(I 并行)意味着将要执行的一组操作可以被分派到多个核心同时执行。
)

$(UL

$(LI $(C parallel)：并行访问 range 中的元素。)

$(LI $(C task)：创建并行执行的任务。)

$(LI $(C asyncBuf)：以并行半延时（semi-eagerly）取值的方式迭代 $(C InputRange) 中的元素。)

$(LI $(C map)：以并行半延时（semi-eagerly）取值的方式对 $(C InputRange) 中的每一个元素应用指定的函数。)

$(LI $(C amap)：以并行即时（fully-eagerly）取值的方式对 $(C RandomAccessRange) 中的元素应用指定的函数。) 

$(LI $(C reduce)：使用指定的函数并行归约计算 $(C RandomAccessRange) 中的元素。) 

)

$(P
对于之前我们写过的程序，我们都假定程序中的表达式都是按照确定的顺序执行的，或者说至少通常情况下它们是顺序执行的。
)

---
    ++i;
    ++j;
---

$(P
对于上面的代码我们认为 $(C i) 将在 $(C j) 之前自增 1。虽然从语义上看这种判断是正确的，但实际上我们预计的这种情况很少发生：微处理器和编译器使用的优化技术会将彼此独立的值储存在处理器寄存器中。当出现这种情况时，微处理器会并行处理上面那样的自增操作。
)

$(P
虽然这些优化效果显著，但是它们通常只能自动应用在非常低级别的操作上。只有程序员才能判断哪些高级别的操作是互相独立、可以并行化的。
)

$(P
对于循环，range 中的元素通常是一个一个按顺序被处理的，即上一个循环的操作结束后才会进行下一次循环：
)

---
    auto students =
        [ Student(1), Student(2), Student(3), Student(4) ];

    foreach (student; students) {
        student.aSlowOperation();
    }
---

$(P
正常情况下程序将会在某个操作系统指派的用于运行程序的处理器核心上运行。因为 $(C foreach) 循环通常是顺序操作元素的，学生的 $(C aSlowOperation()) 也会被顺序调用。然而大部分时候这种处理的顺序并不是必须的。如果 $(C Student) 对象相互独立，不去使用那些可能处在空闲状态的微处理器核心是非常浪费的。
)

$(P
$(IX Thread.sleep) 下面的例子使用 $(C core.thread)  模块中的 $(C Thread.sleep()) 来模拟耗时长的操作。$(C Thread.sleep()) 会将操作挂起一段时间，其时间长短可在代码中指定。当然在下面的例子中 $(C Thread.sleep) 只是用来模拟长耗时的任务，因为它并不需要处理器核心处理实际的工作，它只是占用时间。虽然使用了一个和真实任务有差别的工具，但本章的示例还是能很好的展现出并行编程的威力。
)

---
import std.stdio;
import core.thread;

struct Student {
    int number;

    void aSlowOperation() {
        writefln("The work on student %s has begun", number);

        // 在此处暂停一会以模拟耗时长的操作
        Thread.sleep(1.seconds);

        writefln("The work on student %s has ended", number);
    }
}

void main() {
    auto students =
        [ Student(1), Student(2), Student(3), Student(4) ];

    foreach (student; students) {
        student.aSlowOperation();
    }
}
---

$(P
可以使用终端中的 $(C time) 来测量程序的执行时间。
)

$(SHELL
$ $(HILITE time) ./deneme
$(SHELL_OBSERVED
The work on student 1 has begun
The work on student 1 has ended
The work on student 2 has begun
The work on student 2 has ended
The work on student 3 has begun
The work on student 3 has ended
The work on student 4 has begun
The work on student 4 has ended

real    0m4.005s    $(SHELL_NOTE 共 4 秒)
user    0m0.004s
sys     0m0.000s
)
)

$(P
如果处理每个学生需要花费 1 秒，那按照顺序迭代学生总共需要花费 4 秒。然而如果把这 4 个操作分配给 4 个核心执行，它们将会被同时处理。那么处理完这 4 个学生总共耗时 1 秒。
)

$(P
$(IX totalCPUs) 在了解实现方法之前，我们先来看下如何通过使用 $(C std.parallelism.totalCPUs) 来获取系统可用的处理器核心数：
)

---
import std.stdio;
import std.parallelism;

void main() {
    writefln("There are %s cores on this system.", totalCPUs);
}
---

$(P
在本章编写时使用的环境上运行上面的代码将会输出这样的结果：
)

$(SHELL
There are 4 cores on this system.
)

$(H5 $(IX parallel) $(C taskPool.parallel()))

$(P
还可以使用一种简单的方法使用这个函数：直接以 $(C parallel()) 的形式调用。
)

$(P
$(IX foreach, parallel) $(IX foreach, 并行) $(C parallel()) 以并行的方式访问 range 中的元素。它可以在 $(C foreach) 循环中起到非常大的作用。只需要导入 $(C std.parallelism) 模块并将上面代码中的 $(C students) 换为 $(C parallel(students)) 即可充分利用系统中全部核心的运算能力。
)

---
import std.parallelism;
// ...
    foreach (student; $(HILITE parallel(students))) {
---

$(P
在之前 $(LINK2 /ders/d.cn/foreach_opapply.html, $(C foreach) 结构体和类) 一章中我们了解到： $(C foreach)  块中的表达式将会被包装成委托传递给对象的 $(C opApply()) 成员函数。$(C parallel()) 返回一个 range 对象，它将决定如何将处理元素的$(C 委托)分发给独立的处理器核心执行。
)

$(P
在一个 4 核心的系统上运行上面的程序，传递给  $(C parallel()) 的 $(C Student) range 使处理时间缩小到 1 秒：
)

$(SHELL
$ time ./deneme
$(SHELL_OBSERVED The work on student 2 has begun
The work on student 1 has begun
The work on student 4 has begun
The work on student 3 has begun
The work on student 1 has ended
The work on student 2 has ended
The work on student 4 has ended
The work on student 3 has ended

real    0m1.005s    $(SHELL_NOTE 现在只需 1 秒)
user    0m0.004s
sys     0m0.004s)
)

$(P
$(I $(B 注：)在不同的系统上运行上面的程序可能会有不同的执行时间，但大致都是“4 秒除以核心数”这样的结果。)
)

$(P
$(IX thread) 执行程序某一部分的执行流被称为$(I 执行线程)或$(I 线程)。程序可由多个同时执行操作的线程组成。操作系统可在一个核心上启动和执行线程，在需要时将其挂起来让出核心运算资源去执行另一个线程。每个线程的执行都可能包含多轮启动和挂起。
)

$(P
所有程序的所有在操作系统指定时间活动的线程将会在微处理器的每个核心上执行。操作系统将会决定在合适何种情况启动或挂起线程。这就是上面程序中 $(C aSlowOperation()) 输出的信息是乱序的原因。 如果对 $(C Student) 对象的操作是相互独立的，那以一种不确定的顺序执行线程也不会有什么副作用。
)

$(P
只有在确定在每一次迭代中对元素的操作相互独立后，程序员才能调用 $(C parallel()) 来实现并行。举个例子：如果输出信息的顺序非常重要，那么上面程序中的 $(C parallel()) 调用将会使程序出错。支持线程的编程模型依赖线程的$(I 并发)调用。 并发性是下一章的话题。
)

$(P
对每个元素的所有操作完成后，并行的 $(C foreach) 才算完成执行。在 $(C foreach) 循环完成后，程序可以安全地继续执行下面的代码。
)

$(H6 $(IX work unit size) 工作单元大小)

$(P
$(C parallel()) 的重载为其第二个参数赋予了多个含义，或使其在某些情况下被忽略：
)

---
    /* ... */ = parallel($(I range), $(I work_unit_size) = 100);
---

$(UL

$(LI 在迭代 $(C RandomAccessRange) range 时：

$(P
虽然将线程分派给核心的开销极小。但在某些情况下这个开销会显得极其昂贵，尤其是在每次循环的操作耗时都非常短的时候。在这种情况下，让一个线程去执行多个迭代反而会使处理速度加快。工作单元大小决定了线程在其迭代中要处理元素的个数。
)

---
    foreach (student; parallel(students, $(HILITE 2))) {
        // ...
    }
---

$(P
工作单元大小的默认值是 100。在大多数情况下这个大小是合适的。
)

)

$(LI 在迭代非 $(C RandomAccessRange) range 时：

$(P
只有在非 $(C RandomAccessRange) 中的与$(I 工作单元大小)数目相同的元素被顺序处理后，$(C parallel()) 才会开始并行执行。
由于提供的默认值 100 相对较高，$(C parallel()) 会给人一种错觉：在处理较短的非 $(C RandomAccessRange) range 时效率不高。
)

)

$(LI 在迭代 $(C asyncBuf()) 或 $(C map()) 返回的 range 时（稍后本章会介绍这两个函数）：

$(P
若使用 $(C parallel()) 处理 $(C asyncBuf()) 或 $(C map()) 的返回值时，它将忽略工作单元大小参数。$(C parallel()) 将会使用这两个函数返回的 range 中的缓冲区。
)

)

)

$(H5 $(IX Task) $(C Task))

$(P
程序中以并行的方式执行的操作叫做$(I 任务)。标准库中的 $(C std.parallelism.Task) 表示的就是我们所说的任务。
)

$(P
实际上，$(C parallel()) 为每个工作线程构建并自动启动了一个 $(C Task)。之后 $(C parallel()) 会等待所有任务都完成后再退出循环。$(C parallel()) 用起来非常方便，因为无论是$(I 构建)、$(I 启动)还是$(I 等待任务执行完成)都是自动进行的。
)

$(P
$(IX task) $(IX executeInNewThread) $(IX yieldForce) 如果要在处理 range 中元素之外的地方使用 task，程序员需要按照以下三步手动处理任务：使用 $(C task()) 创建 task，使用 $(C executeInNewThread()) 启动 task，使用 $(C yieldForce()) 等待 task 完成。在下方程序的注释中有对这三个函数详细的解释。
)

$(P
在下方的程序中 $(C anOperation()) 函数被调用两次。它将打印出 $(C id) 的第一个字符，这样我们就可以通过这个字符来判断程序正在等待哪一个 task 执行完成。
)

$(P
$(IX flush, std.stdio)$(I $(B 注：)正常情况下向类似 $(C stdout) 这样的输出流直接输出的字符并不会立刻显示出来。它们将会被储存在输出缓冲区中，当缓冲区中累计了完整的一行时，stdout 才会将其显示在屏幕上。因为 $(C write) 并不会输出换行符，而为了能够在下面的程序中观察并行执行的情况，我们使用 $(C stdout.flush()) 使缓冲区中的数据能在未到达行尾时就被发送至 $(C stdout)。)
)

---
import std.stdio;
import std.parallelism;
import std.array;
import core.thread;

/* 每半秒打印一次‘id’的首字母函数
 * 会随便返回一个值，假装进行了运算。
 * 下面的程序中这个返回值为 1。稍后会在 main 函数中使用本函数返回的结果。*/
int anOperation(string id, int duration) {
    writefln("%s will take %s seconds", id, duration);

    foreach (i; 0 .. (duration * 2)) {
        Thread.sleep(500.msecs);  /* 半秒 */
        write(id.front);
        stdout.flush();
    }

    return 1;
}

void main() {
    /* 构建一个将要执行
     * anOperation() 的 task。在此处被指定的函数实参
     * 将会被作为将要并行执行的任务函数的实参
     * 传递给任务函数。*/
    auto theTask = $(HILITE task!anOperation)("theTask", 5);

    /* 启动 task */
    theTask.$(HILITE executeInNewThread());

    /* 在‘theTask’执行的时候，main 函数会直接调用
     * ‘anOperation()’一次。*/
    immutable result = anOperation("main's call", 3);

    /* 此处我们可以确认
     * 直接在 main 函数中启动的操作
     * 已经执行完成，因为它是一个常规
     * 函数调用，而不是 task。*/

    /* 但在此处我们无法确定
     * ‘theTask’执行的操作是否已经
     * 完成。yieldForce() 会等待 task 完成
     * 操作，只有在任务完成时它才会
     * 返回。它的返回值即为
     * 任务执行的函数的返回值。例如 anOperation()。*/
    immutable taskResult = theTask.$(HILITE yieldForce());

    writeln();
    writefln("All finished; the result is %s.",
             result + taskResult);
}
---

$(P
程序的输出和下面这样差不多：字符 $(C m) 和字符 $(C t) 无序的输出顺序表明这些操作是并行的：
)

$(SHELL
main's call will take 3 seconds
theTask will take 5 seconds
mtmttmmttmmttttt
All finished; the result is 2.
)

$(P
上面的任务函数是 $(C task()) 的一个参数模版 $(C task!anOperation) 的实参。虽然这种方法在大多数情况下都工作的很好，但就如我们在 $(LINK2 /ders/d.cn/templates.html, 模版) 一章中看到的那样：每个不同的模版实例都是一个不同的类型。两个看起来$(I 相同)的 task 对象实际上不是同一个类型，在某些特定的情况下这种差别可能是我们不想看到的。
)

$(P
比如，虽然两个函数有相同的函数签名，但两个通过 $(C task()) 函数模版创建的 $(C Task) 示例类型是不同的。因此它们不能被放在同一个数组里：
)

---
import std.parallelism;

double foo(int i) {
    return i * 1.5;
}

double bar(int i) {
    return i * 2.5;
}

void main() {
    auto tasks = [ task$(HILITE !)foo(1),
                   task$(HILITE !)bar(2) ];    $(DERLEME_HATASI)
}
---

$(SHELL
Error: $(HILITE incompatible types) for ((task(1)) : (task(2))):
'Task!($(HILITE foo), int)*' and 'Task!($(HILITE bar), int)*'
)

$(P
$(C task()) 函数的另一个重载将函数作为其第一个形参：
)

---
    void someFunction(int value) {
        // ...
    }

    auto theTask = task($(HILITE &someFunction), 42);
---

$(P
这种方法并不会产生不同类型的 $(C Task) 模版实例，这样你就可以把它们放在同一个数组里了：
)

---
import std.parallelism;

double foo(int i) {
    return i * 1.5;
}

double bar(int i) {
    return i * 2.5;
}

void main() {
    auto tasks = [ task($(HILITE &)foo, 1),
                   task($(HILITE &)bar, 2) ];    $(CODE_NOTE compiles)
}
---

$(P
lambda 函数和定义了 $(C opCall) 的对象都可以被当作任务函数使用。下面这个例子就是让任务执行了一个 lambda 函数：
)

---
    auto theTask = task((int value) $(HILITE {)
                            /* ... */
                        $(HILITE }), 42);
---

$(H6 $(IX exception, 并行化) 异常处理)

$(P
因为 task 是执行在另外一个线程上的，所以它们抛出的异常并不能被启动任务的线程捕捉到。因此，task 抛出的异常将会被 task 自动捕获。当调用像 $(C yieldForce()) 这样的 $(C Task) 的成员函数时，异常将会被重新抛出。这样我们就可以在主线程中捕获 task 中抛出的异常了。
)

---
import std.stdio;
import std.parallelism;
import core.thread;

void mayThrow() {
    writeln("mayThrow() is started");
    Thread.sleep(1.seconds);
    writeln("mayThrow() is throwing an exception");
    throw new Exception("Error message");
}

void main() {
    auto theTask = task!mayThrow();
    theTask.executeInNewThread();

    writeln("main is continuing");
    Thread.sleep(3.seconds);

    writeln("main is waiting for the task");
    theTask.yieldForce();
}
---

$(P
程序的输出显示由 task 抛出的异常并不会立刻导致整个程序终止运行（它只终止了对应的 task）：
)

$(SHELL
main is continuing
mayThrow() is started
mayThrow() is throwing an exception                 $(SHELL_NOTE 抛出)
main is waiting for the task
object.Exception@deneme.d(10): Error message        $(SHELL_NOTE 终止)
)

$(P
可以在 $(C try-catch) 语句块中调用 $(C yieldForce()) 来捕获由 task 抛出的异常。这与单线程有着极大的不同：像本章上面的程序如果写成单线程的话，应该将 $(C try-catch) 包裹住可能会抛出异常的代码。而在多线程中，它只需包裹 $(C yieldForce())：
)

---
    try {
        theTask.yieldForce();

    } catch (Exception exc) {
        writefln("Detected an error in the task: '%s'", exc.msg);
    }
---

$(P
这次异常将会被主线程捕获而不是终止程序：
)

$(SHELL
main is continuing
mayThrow() is started
mayThrow() is throwing an exception                 $(SHELL_NOTE 抛出)
main is waiting for the task
Detected an error in the task: 'Error message'      $(SHELL_NOTE 捕获)
)

$(H6 $(C Task) 的成员函数)

$(UL

$(LI $(C done)：指明 task 是否完成；如果任务中有捕获异常，此处将重新抛出。

---
    if (theTask.done) {
        writeln("Yes, the task has been completed");

    } else {
        writeln("No, the task is still going on");
    }
---

)

$(LI $(C executeInNewThread())：在新线程中启动 task。)

$(LI $(C executeInNewThread(int priority))：在新线程中启动 task，并指定线程优先级。（优先级是一个操作系统概念，它决定了线程执行的优先次序。）)

)

$(P
有三个用来等待 task 完成的函数：
)

$(UL

$(LI $(C yieldForce())：如果 task 没有启动，则启动 task；如果 task 已经完成，则返回任务函数的返回值；如果 task 正在执行，则以不耗费处理器资源的方式等待 task 完成；如果 task 在执行中抛出了一个异常，它将在此处重新抛出那个异常。)

$(LI $(IX spinForce) $(C spinForce())：与 $(C yieldForce()) 功能相似。不同的是在等待时它将以消耗更多处理器资源为代价换取更快的检测 task 完成的速度。)

$(LI $(IX workForce) $(C workForce())：与 $(C yieldForce()) 功能相似。不同的是在等待任务完成时它将在当前线程中启动一个新的 task。)

)

$(P
在大多数情况下 $(C yieldForce()) 都是最适合用来等待任务完成的函数，$(C yieldForce()) 将阻塞调用它的线程直到任务完成。虽然在等待时 $(C spinForce()) 会使处理器忙绿，但它非常适合等待耗时短的 task。$(C workForce()) 则适合用需要在启动 task 的同时当前线程的情况。
)

$(P
要获得更多有关成 $(C Task) 员函数的信息请参见 Phobos 在线文档。
)

$(H5 $(IX asyncBuf) $(C taskPool.asyncBuf()))

$(P
$(C asyncBuf()) 与 $(C parallel()) 相似，都是用来并行迭代 $(C InputRange) 的。它将 range 中的元素储存在缓冲区中，需要时用户再从缓冲区中获取元素。
)

$(P
为了防止将输入的可能为延迟取值（fully-lazy）的 range 转换为即时取值（fully-eager）的 range，它会$(I 轮)的方式进行迭代。每轮在缓冲区中载入一定数量的元素用于并行迭代。只有当上一轮缓冲的元素被 $(C popFront()) 消耗完后，它才会开始为下一轮迭代缓冲元素。
)

$(P
$(C asyncBuf()) 有两个形参：一个是 range，另一个是可选的$(I 缓冲区大小)。缓冲区大小决定了每轮将有多少元素被加载到缓冲区。
)

---
    auto elements = taskPool.asyncBuf($(I range), $(I buffer_size));
---

$(P
为了能突出 $(C asyncBuf()) 的作用，示例中的 range 与之前的 range 有些不同：遍历一次要耗时半秒，处理一个元素也要耗费半秒。这个 range 的作用就是提供一个不高于指定上限的整数。
)

---
import std.stdio;
import core.thread;

struct Range {
    int limit;
    int i;

    bool empty() const @property {
        return i >= limit;
    }

    int front() const @property {
        return i;
    }

    void popFront() {
        writefln("Producing the element after %s", i);
        Thread.sleep(500.msecs);
        ++i;
    }
}

void main() {
    auto range = Range(10);

    foreach (element; range) {
        writefln("Using element %s", element);
        Thread.sleep(500.msecs);
    }
}
---

$(P
range 中的元素是延迟取值的。因为处理一个元素耗时 1 秒，整个程序总共花费 10 秒。
)

$(SHELL
$ time ./deneme
$(SHELL_OBSERVED
Using element 0
Producing the element after 0
Using element 1
Producing the element after 1
Using element 2
...
Producing the element after 8
Using element 9
Producing the element after 9

real    0m10.007s    $(SHELL_NOTE 共 10 秒)
user    0m0.004s
sys     0m0.000s)
)

$(P
从输出可以看出，元素是被依次求值并使用的。
)

$(P
但我们并不需要严格的按照顺序等待上一个元素被处理完后才开始计算下一个元素的值。如果能在上一个元素被使用时就开始计算下一个元素，那程序消耗的时间就会大大减小。
)

---
import std.parallelism;
//...
    foreach (element; $(HILITE taskPool.asyncBuf)(range, $(HILITE 2))) {
---

$(P
通过上面 $(C asyncBuf()) 的调用，缓冲区中已经准备好了两个元素。在元素被使用时，剩下的元素也在被并行求值
)

$(SHELL
$ time ./deneme
$(SHELL_OBSERVED
Producing the element after 0
Producing the element after 1
Using element 0
Producing the element after 2
Using element 1
Producing the element after 3
Using element 2
Producing the element after 4
Using element 3
Producing the element after 5
Using element 4
Producing the element after 6
Producing the element after 7
Using element 5
Using element 6
Producing the element after 8
Producing the element after 9
Using element 7
Using element 8
Using element 9

real    0m6.007s    $(SHELL_NOTE 现在只耗时 6 秒)
user    0m0.000s
sys     0m0.004s)
)

$(P
缓冲区的默认大小为 100。能使程序获得最大性能的缓冲区大小会随着使用情况的不同而有所不同。
)

$(P
$(C asyncBuf()) 也可以在 $(C foreach) 外使用。比如下面这个例子就将 $(C asyncBuf()) 的返回值作为一个半延迟（semi-eagerly）取值的 $(C InputRange)：
)

---
    auto range = Range(10);
    auto asyncRange = taskPool.asyncBuf(range, 2);
    writeln($(HILITE asyncRange.front));
---

$(H5 $(IX map, parallel) $(IX map, 并行) $(C taskPool.map()))

$(P
$(IX map, std.algorithm) 在介绍 $(C taskPool.map()) 之前，先了解一下 $(C std.algorithm) 模块的 $(C map()) 对理解本节的内容是非常有帮助的。在大多数函数式编程语言中你都能找到 $(C std.algorithm.map) 这样的算法。它会对 range 中的每一个元素应用指定的函数，并将函数的返回值组合为 range 返回。这是一个延迟求值的算法，只有在返回的结果被使用时它才会调用指定的函数进行运算。（标准库中还有一个与之相似的 $(C std.algorithm.each)。但不同的是它并不会返回新的 range 来储存结果，而是直接将结果应用到传入的 range 的元素上。）
)

$(P
实际上对很多程序来说， $(C std.algorithm.map) 的延迟取值是非常有用的。但如果 range 中的每个元素都注定要被作为实参传递给函数而且每次操作又都是独立的的话，我们根本就没必要使用速度较慢的延迟取值而不是并行操作。$(C std.parallelism) 模块中的 $(C taskPool.map()) 和 $(C taskPool.amap()) 可以有效利用多核心的计算能力，在大多数情况下它可以加快程序的运行。
)

$(P
我们会用 $(C Student) 作为例子来比较个三个算法。我们假设 $(C Student) 有一个计算并返回学生平均分的成员函数。为了能够突出并行算法的速度，我们还是使用 $(C Thread.sleep()) 让整个过程消耗更多的时间。
)

$(P
$(C std.algorithm.map) 有一个模版参数用来接收函数，有一个函数形参用来接收 range 。它会返回一个新的 range 来储存应用函数后得到的结果：
)

---
    auto $(I result_range) = map!$(I func)($(I range));
---

$(P
这个函数也可以是由 $(C =>) 语法声明的 $(I lambda 表达式)。下面这个程序使用 $(C map()) 来调用每一个元素的成员函数 $(C averageGrade())：
)

---
import std.stdio;
import std.algorithm;
import core.thread;

struct Student {
    int number;
    int[] grades;

    double averageGrade() @property {
        writefln("Started working on student %s",
                 number);
        Thread.sleep(1.seconds);

        const average = grades.sum / grades.length;

        writefln("Finished working on student %s", number);
        return average;
    }
}

void main() {
    Student[] students;

    foreach (i; 0 .. 10) {
        /* 每个学生有两个成绩 */
        students ~= Student(i, [80 + i, 90 + i]);
    }

    auto results = $(HILITE map)!(a => a.averageGrade)(students);

    foreach (result; results) {
        writeln(result);
    }
}
---

$(P
从程序的输出可以看出 $(C map()) 是延迟取值的；它调用 $(C averageGrade()) 的行为与 $(C foreach) 循环相似：
)

$(SHELL
$ time ./deneme
$(SHELL_OBSERVED
Started working on student 0
Finished working on student 0
85                   $(SHELL_NOTE 像 foreach 一样迭代元素)
Started working on student 1
Finished working on student 1
86
...
Started working on student 9
Finished working on student 9
94

real    0m10.006s    $(SHELL_NOTE 共 10 秒)
user    0m0.000s
sys     0m0.004s)
)

$(P
如果 $(C std.algorithm.map) 是一个即时取值的算法，那表示操作开始和操作结束的信息应该在程序最开始的时候一下全部显示出来。
)

$(P
$(C std.parallelism) 模块中的 $(C taskPool.map()) 和 $(C std.algorithm.map) 的功能相同。唯一不同的是 $(C taskPool.map()) 是以半延迟（semi-eagerly）取值的方式调用函数操作元素，并将结果储存在缓冲区中。缓冲区的大小由第二个形参决定。例如下面的代码，每次将会准备三个对元素应用函数后的结果：
)

---
import std.parallelism;
// ...
double averageGrade(Student student) {
    return student.averageGrade;
}
// ...
    auto results = $(HILITE taskPool.map)!averageGrade(students, $(HILITE 3));
---

$(P
$(I $(B 注：) 之所以上面的代码需要一个独立的 $(C averageGrade()) 函数是因为像 $(C TaskPool.map) 这样的成员模版函数存在无法使用局部委托的限制。如果不使用独立的函数的话，程序将不能通过编译：
))

---
auto results =
    taskPool.map!(a => a.averageGrade)(students, 3);  $(DERLEME_HATASI)
---

$(P
这次每轮将会对三个元素进行操作：
)

$(SHELL
$ time ./deneme
$(SHELL_OBSERVED
Started working on student 1  $(SHELL_NOTE 并行)
Started working on student 2  $(SHELL_NOTE 但是顺序不确定)
Started working on student 0
Finished working on student 1
Finished working on student 2
Finished working on student 0
85
86
87
Started working on student 4
Started working on student 5
Started working on student 3
Finished working on student 4
Finished working on student 3
Finished working on student 5
88
89
90
Started working on student 7
Started working on student 8
Started working on student 6
Finished working on student 7
Finished working on student 6
Finished working on student 8
91
92
93
Started working on student 9
Finished working on student 9
94

real    0m4.007s    $(SHELL_NOTE 共 4 秒)
user    0m0.000s
sys     0m0.004s)
)

$(P
$(C map()) 的第二个参数与 $(C asyncBuf()) 的第二个参数含义相同：它决定了 $(C map()) 储存结果的缓冲区的大小。第三个参数为工作单元大小，与 $(C parallel()) 中对应的参数作用相同但默认值不同；此处它的默认值为 $(C size_t.max)：
)

---
    /* ... */ = taskPool.map!$(I func)($(I range),
                                  $(I buffer_size) = 100
                                  $(I work_unit_size) = size_t.max);
---

$(H5 $(IX amap) $(C taskPool.amap()))

$(P
并行 $(C amap()) 与 并行 $(C map()) 作用相似，但有两点不同：
)

$(UL

$(LI
它是即时求值的。
)

$(LI
它是用于处理 $(C RandomAccessRange) ranges 的。
)

)

---
    auto results = $(HILITE taskPool.amap)!averageGrade(students);
---

$(P
因为它是即时求值的，所以在 $(C amap()) 返回时所有元素都已被运算完成：
)

$(SHELL
$ time ./deneme
$(SHELL_OBSERVED
Started working on student 1    $(SHELL_NOTE 所有元素已被提前准备好)
Started working on student 0
Started working on student 2
Started working on student 3
Finished working on student 1
Started working on student 4
Finished working on student 2
Finished working on student 3
Started working on student 6
Finished working on student 0
Started working on student 7
Started working on student 5
Finished working on student 4
Started working on student 8
Finished working on student 6
Started working on student 9
Finished working on student 7
Finished working on student 5
Finished working on student 8
Finished working on student 9
85
86
87
88
89
90
91
92
93
94

real    0m3.005s    $(SHELL_NOTE 共 3 秒)
user    0m0.000s
sys     0m0.004s)
)

$(P
$(C amap()) 的确比 $(C map()) 的速度快。但相应的代价是它需要提前准备好一个足够大的数组来储存结果。它是通过消耗更多的内存来换取更快的速度。
)

$(P
$(C amap()) 的第二个参数也是工作单元大小，也同样是可选的：
)

---
    auto results = taskPool.amap!averageGrade(students, $(HILITE 2));
---

$(P
还可以通过 $(C amap()) 的第三个参数传递一个 $(C RandomAccessRange) 进去来储存运算结果：
)

---
    double[] results;
    results.length = students.length;
    taskPool.amap!averageGrade(students, 2, $(HILITE results));
---

$(H5 $(IX reduce, parallel) $(IX reduce, 并行) $(C taskPool.reduce()))

$(P
$(IX reduce, std.algorithm) 与 $(C map()) 一样，先来了解下 $(C std.algorithm) 模块的 $(C reduce()) 有助于本节的我们讲解的知识。
)

$(P
$(IX fold, std.algorithm) $(C reduce()) 与 $(C std.algorithm.fold) 相同。我们已经在 $(LINK2 /ders/d.cn/ranges.html, Ranges) 一章中学习到了相关知识。两者的不同点在于它们的形参顺序正好相反。（因此，我建议你最好在非并行代码中使用 $(C fold())。因为它可以利用链式 range 表达式的 $(LINK2 /ders/d.cn/ufcs.html, UFCS)。）
)

$(P
$(C reduce()) 也是一个经常在函数式编程中使用的高阶函数。和 $(C map()) 一样，它也可以接收一个或多个函数作为模版实参。除了用于接收函数的模版形参，它需要传入一个运算结果的初始值和一个 range。$(C reduce()) 将传入的函数作为运算方法对每个元素进行计算并按照合并到结果中。传入的函数应有两个参数：一个表示当前运算的总结果，一个表示 range 中的元素。如果没有指定初始值，它会把 range 的第一个元素作为初始值。
)

$(P
假设它在执行过程中定义了一个名为 $(C result) 的变量，那 $(C reduce()) 就是按照下面这几步运作的：
)

$(OL

$(LI 把初始值赋给 $(C result))

$(LI 对每一个元素执行 $(C result = func(result, element)) 这样的表达式)

$(LI 返回最终 $(C result) 的值)

)

$(P
例如下面这个计算数组元素的平方和的程序：
)

---
import std.stdio;
import std.algorithm;

void main() {
    writeln(reduce!((a, b) => a + b * b)(0, [5, 10]));
}
---

$(P
如果传入的函数是以 $(C =>) 声明的，那它的第一个参数（即上方程序中的 $(C a)）代表当前运算结果（使用 reduce 的参数 $(C 0) 初始化），第二个参数（即上方程序中的 $(C b)）代表当前元素。
)

$(P
这个程序将输出 5 和 10 的平方的和：
)

$(SHELL
125
)

$(P
就像我们看到的那样，$(C reduce()) 使用一个循环来实现其功能。因为通常情况下这个操作时运行在一个处理器核心上的，那么如果对每个元素的操作是独立的，这将造成不必要的执行速度的降低。在这种情况下你就可以使用 $(C std.parallelism) 模块中的 $(C taskPool.reduce()) 来利用多核心的运算能力。
)

$(P
为了展现出 $(C reduce()) 的威力，我们的例子依旧使用一个被人为减慢的函数来模拟长耗时的操作：
)

---
import std.stdio;
import std.algorithm;
import core.thread;

int aCalculation(int result, int element) {
    writefln("started  - element: %s, result: %s",
             element, result);

    Thread.sleep(1.seconds);
    result += element;

    writefln("finished - element: %s, result: %s",
             element, result);

    return result;
}

void main() {
    writeln("Result: ", $(HILITE reduce)!aCalculation(0, [1, 2, 3, 4]));
}
---

$(P
$(C reduce()) 将按照顺序使用元素：
)

$(SHELL
$ time ./deneme
$(SHELL_OBSERVED
started  - element: 1, result: 0
finished - element: 1, result: 1
started  - element: 2, result: 1
finished - element: 2, result: 3
started  - element: 3, result: 3
finished - element: 3, result: 6
started  - element: 4, result: 6
finished - element: 4, result: 10
Result: 10

real    0m4.003s    $(SHELL_NOTE 共 4 秒)
user    0m0.000s
sys     0m0.000s)
)

$(P
与之前 $(C parallel()) 和 $(C map()) 的例子一样，只需要导入 $(C std.parallelism) 模块并调用 $(C taskPool.reduce()) 就可以利用多核心的资源了：
)

---
import std.parallelism;
// ...
    writeln("Result: ", $(HILITE taskPool.reduce)!aCalculation(0, [1, 2, 3, 4]));
---

$(P
但与之前的函数相比， $(C taskPool.reduce()) 的行为有一个非常重要的不同点。
)

$(P
$(C taskPool.reduce()) 在不同的任务中并行执行函数，这与其它的并行算法相同。但每一个任务都会去计算分派给它的元素并最终得出一个对应的 $(C result)。因为 $(C reduce()) 只有一个初始值，所以每个任务都会使用相同的初始值来初始化 $(C result)（就是之前代码中我们的参数 $(C 0)）。
)

$(P
每个任务都会得到一个结果，这些最终结果将会按照与计算元素相同的方法计算，得到最终的 $(C result)。这个最终结果的计算是串行的。因此，在某些耗时少的例子（比如本章中的某些例子）中 $(C taskPool.reduce()) 可能会比非并行版本执行速度慢。
)

$(P
又由于所有任务都是用相同的初始值，这些初始值会被多次使用，因此 $(C taskPool.reduce()) 的运算结果可能和 $(C std.algorithm.reduce()) 不同。所以指定的初始值应为$(I 恒等值)。比如本例中的 $(C 0) 就不会产生任何副作用。
)

$(P
除此之外，由于在最后串行运算的时候使用的函数与之前相同，函数的返回值必须与函数的参数类型相同或可以相互转换。
)

$(P
只有在满足以上条件的情况下才可以使用 $(C taskPool.reduce())。
)

---
import std.parallelism;
// ...
    writeln("Result: ", $(HILITE taskPool.reduce)!aCalculation(0, [1, 2, 3, 4]));
---

$(P
程序的输出信息表明起初对元素的计算是并行的，而之后对结果的计算是串行的。被高亮的部分为串行运算的输出：
)

$(SHELL
$ time ./deneme
$(SHELL_OBSERVED
started  - element: 3, result: 0 $(SHELL_NOTE 起初时使用任务并行计算)
started  - element: 2, result: 0
started  - element: 1, result: 0
started  - element: 4, result: 0
finished - element: 3, result: 3
finished - element: 1, result: 1
$(HILITE started  - element: 1, result: 0) $(SHELL_NOTE 之后串行计算结果)
finished - element: 4, result: 4
finished - element: 2, result: 2
$(HILITE finished - element: 1, result: 1)
$(HILITE started  - element: 2, result: 1)
$(HILITE finished - element: 2, result: 3)
$(HILITE started  - element: 3, result: 3)
$(HILITE finished - element: 3, result: 6)
$(HILITE started  - element: 4, result: 6)
$(HILITE finished - element: 4, result: 10)
Result: 10

real    0m5.006s    $(SHELL_NOTE 在本例中并行算法比串行算法慢)
user    0m0.004s
sys     0m0.000s)
)

$(P
不过对于许多算法来说并行 $(C reduce()) 要比其串行版本快，例如计算 $(I pi) （π）的算法。
)

$(H5 多个函数和 tuple 结果)

$(P
$(C std.algorithm.map())、$(C taskPool.map())、$(C taskPool.amap()) 和 $(C taskPool.reduce()) 都允许传入多个函数处理元素，并返回类型为 $(C Tuple) 的结果。我们之前已经在 $(LINK2 /ders/d.cn/tuples.html, Tuples) 一章中了解过 $(C Tuple)。传入函数的顺序将决定 tuple 中与之对应的结果的顺序。例如：第一个函数的结果即为 tuple 的第一个元素。
)

$(P
下面这个例子演示如何向 $(C std.algorithm.map) 传入多个函数并使用其返回的结果。注意这些函数的返回值类型不一定非要相同，就像下面例子中的 $(C quarterOf()) 和 $(C tenTimes())，一个返回 double 一个返回 string。因此 tuples 中的元素类型也不一定相同：
)

---
import std.stdio;
import std.algorithm;
import std.conv;

double quarterOf(double value) {
    return value / 4;
}

string tenTimes(double value) {
    return to!string(value * 10);
}

void main() {
    auto values = [10, 42, 100];
    auto results = map!($(HILITE quarterOf, tenTimes))(values);

    writefln(" Quarters  Ten Times");

    foreach (quarterResult, tenTimesResult; results) {
        writefln("%8.2f%8s", quarterResult, tenTimesResult);
    }
}
---

$(P
输出为：
)

$(SHELL
 Quarters  Ten Times
    2.50     100
   10.50     420
   25.00    1000
)

$(P
如果向 $(C taskPool.reduce()) 传入多个函数，那为其指定的初始值也需要改为 tuple 类型：
)

---
    taskPool.reduce!(foo, bar)($(HILITE tuple(0, 1)), [1, 2, 3, 4]);
---

$(H5 $(IX TaskPool) $(C TaskPool))

$(P
当我们享受 $(C std.parallelism) 模块带来的便利时，标准库在后台默默地维护着 $(C TaskPool) 容器中的 task 对象。正常情况下，所有算法使用的都是一个容器，即 $(C taskPool)。
)

$(P
$(C taskPool) 包含的 task 的个数取决于程序运行的环境。因此通常我们不需要手动创建 $(C TaskPool) 对象。即便如此我们还是可以在需要的时候显示创建 $(C TaskPool) 对象。
)

$(P
$(C TaskPool) 构造函数有一个参数。通过指定这个参数就可以控制之后并行执行的线程个数。参数的默认值不会比处理器核心数大。本章介绍的所有功能都可以通过使用一个单独的 $(C TaskPool) 来调用。
)

$(P
下面这个例子使用了一个局部 $(C TaskPool) 对象来调用 $(C parallel())。
)


---
import std.stdio;
import std.parallelism;

void $(CODE_DONT_TEST compiler_asm_deprecation_warning)main() {
    auto workers = new $(HILITE TaskPool(2));

    foreach (i; $(HILITE workers).parallel([1, 2, 3, 4])) {
        writefln("Working on %s", i);
    }

    $(HILITE workers).finish();
}
---

$(P
$(C TaskPool.finish()) 会在所有任务完成后停止程序进程。
)

$(H5 小结)


$(UL

$(LI 只有在操作相互独立时才可以将它们并行化。否则将出错。)

$(LI $(C parallel()) 并行访问 range 中的元素。)

$(LI Tasks 可手动通过 $(C task()) 创建、通过 $(C executeInNewThread()) 启动、通过 $(C yieldForce()) 等待完成。)

$(LI task 中操作抛出的异常可在之后调用类似 $(C yieldForce()) 这样的并行函数时捕获。)

$(LI $(C asyncBuf)：以并行半延时（semi-eagerly）取值的方式迭代 $(C InputRange) 中的元素。)

$(LI $(C map)：以并行半延时（semi-eagerly）取值的方式对 $(C InputRange) 中的每一个元素应用指定的函数。)

$(LI $(C amap)：以并行即时（fully-eagerly）取值的方式对 $(C RandomAccessRange) 中的元素应用指定的函数。) 

$(LI $(C reduce)：使用指定的函数并行归约计算 $(C RandomAccessRange) 中的元素。)

$(LI $(C map())、$(C amap()) 或 $(C reduce()) 可以传入多个函数并返回 tuples 类型的结果。)

$(LI 如果需要的话，可以使用 $(C TaskPool) 对象而不是 $(C taskPool) 进行操作。)

)

macros:
        SUBTITLE=并行

        DESCRIPTION=并行编程来利用多核心微处理器的运算能力

        KEYWORDS=D 编程语言教程 并行编程

MINI_SOZLUK=
