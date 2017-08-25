Ddoc

$(DERS_BOLUMU $(IX concurrency, message passing) $(IX message passing concurrency) 基于消息传递的并发)

$(P
虽然并发（concurrency）与并行（parallelism）很相似，但我们不能将其混为一谈。这两个概念都涉及多线程，且并行是基于并发的，在刚接触它们时有些迷惑也是正常的。
)

$(P
$(IX parallelism vs. concurrency) $(IX concurrency vs. parallelism) 下面是并发和并行的区别：
)

$(UL

$(LI
并行的主要目的是利用多核心的运算能力提高程序的性能。而并发这个概念在单核心系统中也有用到。并发即程序同时运行多个线程。并发即程序同时运行多个线程。比如说服务器程序就是并发的，它需要在同一时间处理多个客户端的请求。
)

$(LI
在并行中，任务之间相互独立。事实上如果同时运行的任务依赖其他任务的结果就可能会引发程序的 bug。而对于并发，线程间的相互依赖是很常见的。
)

$(LI
虽然两者都涉及线程操作，但并行用 task 对线程做了包装。而并发则需要显式调用线程。
)

$(LI
并行上手容易，由于任务相互独立的缘故我们写出的程序很少出错。并发则只有在基于 $(I 消息传递) 时才比较简单。若使用传统的基于锁的数据共享模型，则很难写出正确的程序。
)

)

$(P
D 语言支持两种并发模型：消息传递和数据共享。我们将会在本章中学习到消息传递，在下一章中学习数据共享。
)

$(H5 相关概念)

$(P
$(IX thread) $(B 线程)：操作系统执行程序的工作单元叫做 $(I 线程)D 语言程序在操作系统指定的线程上执行 $(C main()) 函数。通常情况下程序的所有操作都将在这个线程中完成。程序也可以自由地创建线程以实现在同一时间执行多个任务的功能。实际上上一章我们学习的 task 就是基于线程的，只不过这些线程是由 $(C std.parallelism) 自动维护的。
)

$(P
操作系统会不定期的将线程暂停一段时间。也就是说，即使是一个简单的自增操作也可能会在执行到一半时被操作系统暂停：
)

---
    ++i;
---

$(P
上面这个看似简单的操作实际上包含三个步骤：读取变量的值、将其加一、将结果写回变量所在的内存。线程可能会暂停在这三步中的任何一步上，停顿一段时间后才会继续。
)

$(P
$(IX message) $(B 消息)：在线程间传递的数据叫做消息。任何类型任何长短的数据都可以被称为消息。
)

$(P
$(IX thread id) $(B 线程 ID)：每一个线程都有一个 ID，你可以使用它们指定消息的接收者。
)

$(P
$(IX owner) $(B 所有者)：启动线程的线程即为被启动线程的所有者。
)

$(P
$(IX worker) $(B 工作线程)：被所有者启动的线叫做工作线程。
)

$(H5 $(IX spawn) 启动线程)

$(P
$(C spawn()) 需要一个函数指针，新线程将会从指定的函数启动。函数中进行的包括函数调用在内的所有操作都将在新线程中执行。使用 $(C spawn()) 启动的线程和使用 $(LINK2 /ders/d.en/parallelism.html, $(C task())) 启动的线程之间最大的差异在于，$(C spawn()) 允许线程间消息传递。
)

$(P
新线程启动后，所有者和工作线程将会独立执行，看上去它们就像是独立的程序：
)

---
import std.stdio;
import std.concurrency;
import core.thread;

void worker() {
    foreach (i; 0 .. 5) {
        Thread.sleep(500.msecs);
        writeln(i, " (worker)");
    }
}

void main() {
    $(HILITE spawn(&worker));

    foreach (i; 0 .. 5) {
        Thread.sleep(300.msecs);
        writeln(i, " (main)");
    }

    writeln("main is done.");
}
---

$(P
本章中的例子调用 $(C Thread.sleep) 减慢线程执行的速度来更方便的展示线程运行的情况。这个程序的输出表明有两个线程：一个用于运行 $(C main())，另一个则由 $(C spawn()) 启动。它们同时相互独立地执行：
)

$(SHELL
0 (main)
0 (worker)
1 (main)
2 (main)
1 (worker)
3 (main)
2 (worker)
4 (main)
main is done.
3 (worker)
4 (worker)
)

$(P
程序在所有线程执行完毕后才会退出。从上面的输出中我们可以看到，在函数 $(C main()) 输出 “main is done.” 并退出之后，$(C worker()) 仍然在继续执行。
)

$(P
线程函数需要的参数应通过 $(C spawn()) 的二个参数传入。下面程序中的两个工作线程分别打印四个数字。线程函数的参数为初始数字：
)

---
import std.stdio;
import std.concurrency;
import core.thread;

void worker($(HILITE int firstNumber)) {
    foreach (i; 0 .. 4) {
        Thread.sleep(500.msecs);
        writeln(firstNumber + i);
    }
}

void main() {
    foreach (i; 1 .. 3) {
        spawn(&worker, $(HILITE i * 10));
    }
}
---

$(P
其中一个线程的输出被高亮了：
)

$(SHELL
10
$(HILITE 20)
11
$(HILITE 21)
12
$(HILITE 22)
13
$(HILITE 23)
)

$(P
程序的输出顺序可能会和上面有所不同，具体情况取决于操作系统对线程的调度。
)

$(P
$(IX CPU bound) $(IX I/O bound) $(IX thread performance) 每个操作系统都有对同时运行线程个数的限制。这种限制可能是对用户的，也可能是对整个操作系统的，当然也可能是对其他某些级别。如果忙碌的工作线程数量比系统中处理器核心数多，系统的整体性能就有可能下降。在指定运行时间消耗大量 CPU 资源的线程叫做 $(I CPU 密集型)。与之相对的是消耗大量时间等待事件、用户输入、来自互联网的数据或调用了 $(C Thread.sleep) 等情况的线程。这种线程被称作 $(I I/O 密集型)。如果大部分线程都是 I/O 密集型的，那程序就不需要担心由于线程数多余核心数而造成的性能下降的问题。基于对性能设计的考量，我们需要谨慎分析并确定线程的类型。
)

$(H5 $(IX Tid) $(IX thisTid) $(IX ownerTid) 线程 ID)

$(P
$(C thisTid()) 返回$(I 当前)线程的 ID。通常调用它的时候不需要带圆括号：
)

---
import std.stdio;
import std.concurrency;

void printTid(string tag) {
    writefln("%s: %s", tag, $(HILITE thisTid));
}

void worker() {
    printTid("Worker");
}

void main() {
    spawn(&worker);
    printTid("Owner ");
}
---

$(P
$(C thisTid()) 返回的类型为 $(C Tid)，它对这个程序没有什么作用。它甚至连 $(C toString()) 都没重载：
)

$(SHELL
Owner : Tid(std.concurrency.MessageBox)
Worker: Tid(std.concurrency.MessageBox)
)

$(P
我们之前一直没有用到的 $(C spawn()) 的返回值即为工作线程的 ID：
)

---
    $(HILITE Tid myWorker) = spawn(&worker);
---

$(P
与之相对的是在工作线程中使用 $(C ownerTid()) 获取其所有者的 ID。
)

$(P
总之，调用 $(C ownerTid) 获取其所有者 ID，通过 $(C spawn()) 的返回值获取工作线程 ID。
)

$(H5 $(IX send) $(IX receiveOnly) 消息传递)

$(P
D 语言使用 $(C send()) 发送消息，使用 $(C receiveOnly()) 等待指定类型的消息。除了它们，标准库还提供了其他实用函数，像 $(C prioritySend())、$(C receive())、$(C receiveTimeout()) 。后面章节会对它们进行解释。
)

$(P
下面这个程序中，线程所有者会向工作线程发送 $(C int) 类型的消息并等待工作线程返回 $(C double) 类型的消息。工作线程会不停地返回消息直到线程所有者发送一个负的 $(C int)。这个就是所有者线程，如下所示：
)

---
void $(CODE_DONT_TEST)main() {
    Tid worker = spawn(&workerFunc);

    foreach (value; 1 .. 5) {
        $(HILITE worker.send)(value);
        double result = $(HILITE receiveOnly!double)();
        writefln("sent: %s, received: %s", value, result);
    }

    /* 向工作线程发送一个负数
     *使其终止*/
    $(HILITE worker.send)(-1);
}
---

$(P
$(C main()) 将 $(C spawn()) 的返回值储存在 $(C worker) 变量中并通过它来给工作线程发送消息。
)

$(P
另一方面，工作线程需要 $(C int) 类型的消息并对其进行计算，之后将计算得到的 $(C double) 类型的结果返回给其所有者：
)

---
void workerFunc() {
    int value = 0;

    while (value >= 0) {
        value = $(HILITE receiveOnly!int)();
        double result = to!double(value) / 5;
        $(HILITE ownerTid.send)(result);
    }
}
---

$(P
主线程会将它发送的和接收的消息一起输出：
)

$(SHELL
sent: 1, received: 0.2
sent: 2, received: 0.4
sent: 3, received: 0.6
sent: 4, received: 0.8
)

$(P
也可以在一次消息中发送多个值，这些值都会成为这次消息的一部分。下面这个消息就是由三个部分组成：
)

---
    ownerTid.send($(HILITE thisTid, 42, 1.5));
---

$(P
如果在一次消息中传递多个值的话，接收者会将它们看作一个 tuple。此时，$(C receiveOnly()) 的模版参数的类型要与每一个 tuple 成员的类型对应：
)

---
    /* 等待一个包含 Tid、int 和 double 类型的消息。*/
    auto message = receiveOnly!($(HILITE Tid, int, double))();

    auto sender   = message[0];    // Tid 类型
    auto integer  = message[1];    // int 类型
    auto floating = message[2];    // double 类型
---

$(P
$(IX MessageMismatch) 如果类型不匹配，程序将会抛出一个 $(C MessageMismatch) 异常：
)

---
import std.concurrency;

void workerFunc() {
    ownerTid.send("hello");    $(CODE_NOTE 发送 $(HILITE string))
}

void main() {
    spawn(&workerFunc);

    auto message = receiveOnly!double();    $(CODE_NOTE 期望 $(HILITE double))
}
---

$(P
输出：
)

$(SHELL
std.concurrency.$(HILITE MessageMismatch)@std/concurrency.d(235):
Unexpected message type: expected 'double', got 'immutable(char)[]'
)

$(P
所有者无法捕获由工作线程抛出的异常。一种解决方案是在工作线程中捕获潜在的由接收信息引发的异常。随后就会看到这个。
)

$(H6 示例)

$(P
现在我们在一个模拟程序里实践一下刚了解到的内容。
)

$(P
下面这个程序模拟的是两个互不相关的机器人在二维空间中随机移动。每个机器人的移动都是由一个独立的线程控制的。线程在启动时需要传入三个参数：
)

$(UL

$(LI 机器人的编号 (id)：这个参数会随着消息传回线程所有者，这样我们就可以通过它确认消息的来源。
)

$(LI 起点：机器人的初始位置。
)

$(LI 每一步的间隔时间：决定机器人何时走下一步。
)

)

$(P
这些信息可以储存在下面这个 $(C Job) 结构中：
)

---
struct Job {
    size_t robotId;
    Position origin;
    Duration restDuration;
}
---

$(P
移动机器人的线程会不断地将对应机器人的 ID 和它的移动情况发送给所有者线程：
)

---
void robotMover(Job job) {
    Position from = job.origin;

    while (true) {
        Thread.sleep(job.restDuration);

        Position to = randomNeighbor(from);
        Movement movement = Movement(from, to);
        from = to;

        ownerTid.send($(HILITE MovementMessage)(job.robotId, movement));
    }
}
---

$(P
线程所有者仅仅通过一个死循环等待消息。它通过消息中的机器人 ID 来识别机器人。所有者会简单地将其运动情况输出：
)

---
    while (true) {
        auto message = receiveOnly!$(HILITE MovementMessage)();

        writefln("%s %s",
                 robots[message.robotId], message.movement);
    }
---

$(P
本例中的所有消息都是从工作线程向线程所有者传递的。当然在许多程序中消息传递不止这么简单。
)

$(P
下面是完整的程序：
)

---
import std.stdio;
import std.random;
import std.string;
import std.concurrency;
import core.thread;

struct Position {
    int line;
    int column;

    string toString() {
        return format("%s,%s", line, column);
    }
}

struct Movement {
    Position from;
    Position to;

    string toString() {
        return ((from == to)
                ? format("%s (idle)", from)
                : format("%s -> %s", from, to));
    }
}

class Robot {
    string image;
    Duration restDuration;

    this(string image, Duration restDuration) {
        this.image = image;
        this.restDuration = restDuration;
    }

    override string toString() {
        return format("%s(%s)", image, restDuration);
    }
}

/* 返回一个坐标在 0,0 周边的随机位置。*/
Position randomPosition() {
    return Position(uniform!"[]"(-10, 10),
                    uniform!"[]"(-10, 10));
}

/* 返回一个坐标，它相对从指定坐标最多变化一步。*/
int randomStep(int current) {
    return current + uniform!"[]"(-1, 1);
}

/* 返回指定位置周围的坐标。它既可能是
 * 八个方向中的一个，也可能是
 * 指定那个位置本身。*/
Position randomNeighbor(Position position) {
    return Position(randomStep(position.line),
                    randomStep(position.column));
}

struct Job {
    size_t robotId;
    Position origin;
    Duration restDuration;
}

struct MovementMessage {
    size_t robotId;
    Movement movement;
}

void robotMover(Job job) {
    Position from = job.origin;

    while (true) {
        Thread.sleep(job.restDuration);

        Position to = randomNeighbor(from);
        Movement movement = Movement(from, to);
        from = to;

        ownerTid.send(MovementMessage(job.robotId, movement));
    }
}

void main() {
    /* 不同移动时间间隔的机器人。*/
    Robot[] robots = [ new Robot("A",  600.msecs),
                       new Robot("B", 2000.msecs),
                       new Robot("C", 5000.msecs) ];

    /* 为每一个机器人启动一个移动线程。*/
    foreach (robotId, robot; robots) {
        spawn(&robotMover, Job(robotId,
                               randomPosition(),
                               robot.restDuration));
    }

    /* 准备好接收有关机器人的移动情况
     * 的信息。*/
    while (true) {
        auto message = receiveOnly!MovementMessage();

        /* 输出机器人的运动情况。*/
        writefln("%s %s",
                 robots[message.robotId], message.movement);
    }
}
---

$(P
程序会不停地显示所有机器人的运动信息，除非手动终止：
)

$(SHELL
A(600 ms) 6,2 -> 7,3
A(600 ms) 7,3 -> 8,3
A(600 ms) 8,3 -> 7,3
B(2 secs) -7,-4 -> -6,-3
A(600 ms) 7,3 -> 6,2
A(600 ms) 6,2 -> 7,1
A(600 ms) 7,1 (idle)
B(2 secs) -6,-3 (idle)
A(600 ms) 7,1 -> 7,2
A(600 ms) 7,2 -> 7,3
C(5 secs) -4,-4 -> -3,-5
A(600 ms) 7,3 -> 6,4
...
)

$(P
这个程序展现了并发的强大之处：机器人的移动可以在单独的线程中独立计算，而且它们之间无需相互交换信息。所有者线程仅仅是将收件箱中的消息一个一个取出来并$(I 按顺序)输出。
)

$(H5 $(IX delegate, message passing) 接收不同类型的消息)

$(P
$(C receiveOnly()) 只能接收指定的那一个类型的消息。而 $(C receive()) 可以接收多种类型的消息。它通过消息处理委托来处理消息。当它接收到消息时，它会比较消息类型与委托的参数类型。如果委托参数的类型与消息类型相同，它就会把消息交由对应的委托处理。
)

$(P
例如，下面这个 $(C receive()) 使用了两个委托分别用来处理类型为 $(C int) 和 $(C string) 的消息：
)

---
$(CODE_NAME workerFunc)void workerFunc() {
    bool isDone = false;

    while (!isDone) {
        void intHandler($(HILITE int) message) {
            writeln("handling int message: ", message);

            if (message == -1) {
                writeln("exiting");
                isDone = true;
            }
        }

        void stringHandler($(HILITE string) message) {
            writeln("handling string message: ", message);
        }

        receive($(HILITE &intHandler), $(HILITE &stringHandler));
    }
}
---

$(P
$(C int) 消息匹配 $(C intHandler())，而 $(C string) 消息匹配 $(C stringHandler())。上面的工作线程可以用下面程序来测试：
)

---
$(CODE_XREF workerFunc)import std.stdio;
import std.concurrency;

// ...

void main() {
    auto worker = spawn(&workerFunc);

    worker.send(10);
    worker.send(42);
    worker.send("hello");
    worker.send(-1);        // ← 终止工作线程
}
---

$(P
程序的输出表明了接收端的函数是如何匹配和处理消息的：
)

$(SHELL
handling int message: 10
handling int message: 42
handling string message: hello
handling int message: -1
exiting
)

$(P
lambda 函数和定义了 $(C opCall()) 成员函数的对象都可以传递给 $(C receive()) 作为消息处理器。下面这个工作线程使用 lambda 函数处理消息。程序还定义了一个 $(C Exit) 类型来通知线程退出。相对于使用像 -1 这样的任意值，用一个特定的类型来传递特定的消息会让程序更易读。
)

$(P
有 3 个匿名函数被传递给了 $(C receive()) 来作为消息处理器。它们的花括号已被高亮：
)

---
import std.stdio;
import std.concurrency;

struct Exit {
}

void workerFunc() {
    bool isDone = false;

    while (!isDone) {
        receive(
            (int message) $(HILITE {)
                writeln("int message: ", message);
            $(HILITE }),

            (string message) $(HILITE {)
                writeln("string message: ", message);
            $(HILITE }),

            (Exit message) $(HILITE {)
                writeln("exiting");
                isDone = true;
            $(HILITE }));
    }
}

void main() {
    auto worker = spawn(&workerFunc);

    worker.send(10);
    worker.send(42);
    worker.send("hello");
    worker.send($(HILITE Exit()));
}
---

$(H6 接收任意类型的消息)

$(P
$(IX Variant, concurrency) $(C std.variant.Variant) 类型可以封装任意类型的数据。如果消息无法与参数列表前面指定的各个处理函数相匹配，那么它们将会与一个 $(C Variant) 类型的处理函数匹配：
)

---
import std.stdio;
import std.concurrency;

void workerFunc() {
    receive(
        (int message) { /* ... */ },

        (double message) { /* ... */ },

        ($(HILITE Variant) message) {
            writeln("Unexpected message: ", message);
        });
}

struct SpecialMessage {
    // ...
}

void main() {
    auto worker = spawn(&workerFunc);
    worker.send(SpecialMessage());
}
---

$(P
输出：
)

$(SHELL
Unexpected message: SpecialMessage()
)

$(P
有关 $(C Variant) 的详细内容已超出本章范围。
)

$(H5 $(IX receiveTimeout) 在指定的时间内等待消息)

$(P
可能经过一段时间后就不再需要继续等待消息了。消息的发送者可能正在忙碌或因异常终止。$(C receiveTimeout()) 可以防止出现无限等待消息这样的情况。
)

$(P
$(C receiveTimeout()) 的第一个参数决定等待消息时要等待多长时间。如果在指定时间内接收到了消息，函数返回值为 $(C true) ；如果超时则返回 $(C false)。
)

---
import std.stdio;
import std.concurrency;
import core.thread;

void workerFunc() {
    Thread.sleep(3.seconds);
    ownerTid.send("hello");
}

void main() {
    spawn(&workerFunc);

    writeln("Waiting for a message");
    bool received = false;
    while (!received) {
        received = $(HILITE receiveTimeout)(600.msecs,
                                  (string message) {
                                      writeln("received: ", message);
                                });

        if (!received) {
            writeln("... no message yet");

            /* ... 可在此处执行其他操作... */
        }
    }
}
---

$(P
上面的线程所有者将等待消息 600 毫秒。如果消息超时它还会继续执行其他操作：
)

$(SHELL
Waiting for a message
... no message yet
... no message yet
... no message yet
... no message yet
received: hello
)

$(H5 $(IX exception, concurrency) 工作线程中的异常)

$(P
上一章的 $(C std.parallelism) 自动捕获 task 执行中抛出的异常并在所有者的线程中重新抛出。它使得所有者线程可以捕获工作线程的异常：
)

---
    try {
        theTask.yieldForce();

    } catch (Exception exc) {
        writefln("Detected an error in the task: '%s'",
                 exc.msg);
    }
---

$(P
$(C std.concurrency) 并未提供这种捕获异常的方法。但你也可以在工作线程中手动捕获异常并将其发送给所有者。就像我们下面看到的那样，可以将 $(C OwnerTerminated) 和 $(C LinkTerminated) 当作消息传递。
)

$(P
下面这个 $(C calculate()) 接收一个 $(C string) 消息，将其转换为 $(C double) 并加 0.5，之后将运算的结果作为消息传递回去：
)

---
$(CODE_NAME calculate)void calculate() {
    while (true) {
        auto message = receiveOnly!string();
        ownerTid.send(to!double(message) + 0.5);
    }
}
---

$(P
如果该字符串不能转换为一个 $(C double) 值，则调用 $(C to!double()) 会抛出异常。由于异常会立刻终止工作线程，所有者只能收到第一条消息的反馈：
)

---
$(CODE_XREF calculate)import std.stdio;
import std.concurrency;
import std.conv;

// ...

void main() {
    Tid calculator = spawn(&calculate);

    calculator.send("1.2");
    calculator.send("hello");  // ← 错误的输入
    calculator.send("3.4");

    foreach (i; 0 .. 3) {
        auto message = receiveOnly!double();
        writefln("result %s: %s", i, message);
    }
}
---

$(P
由于工作线程已被终止，所有者只会收到将“1.2”变为 1.7 的消息的反馈。而它并不知道工作线程已经终止，所有者线程会被阻塞来等待永远不会到达的消息：
)

$(SHELL
result 0: 1.7
                 $(SHELL_NOTE 等待永远不会到达的消息)
)

$(P
工作线程能做的就是手动捕获异常并将其作为特殊的错误信息发送给所有者。下面这个程序就把出错的原因封装在 $(C CalculationFailure) 消息中传递回去。此外，这个程序还使用了特殊的消息类型来通知工作线程退出：
)

---
import std.stdio;
import std.concurrency;
import std.conv;

struct CalculationFailure {
    string reason;
}

struct Exit {
}

void calculate() {
    bool isDone = false;

    while (!isDone) {
        receive(
            (string message) {
                try {
                    ownerTid.send(to!double(message) + 0.5);

                } $(HILITE catch) (Exception exc) {
                    ownerTid.send(CalculationFailure(exc.msg));
                }
            },

            (Exit message) {
                isDone = true;
            });
    }
}

void main() {
    Tid calculator = spawn(&calculate);

    calculator.send("1.2");
    calculator.send("hello");  // ← 错误的输入
    calculator.send("3.4");
    calculator.send(Exit());

    foreach (i; 0 .. 3) {
        writef("result %s: ", i);

        receive(
            (double message) {
                writeln(message);
            },

            (CalculationFailure message) {
                writefln("ERROR! '%s'", message.reason);
            });
    }
}
---

$(P
这次错误的原因会被所有者输出：
)

$(SHELL
result 0: 1.7
result 1: ERROR! 'no digits seen'
result 2: 3.9
)

$(P
另外一种方法是直接将将异常对象发送回所有者。所有者既可以处理异常对象也可以重新抛出：
)

---
// ... 工作线程中 ...
                try {
                    // ...

                } catch ($(HILITE shared(Exception)) exc) {
                    ownerTid.send(exc);
                }},

// ... 所有者线程 ...
        receive(
            // ...

            ($(HILITE shared(Exception)) exc) {
                throw exc;
            });
---

$(P
我们会在下一章解释为什么此处必须使用 $(C shared) 说明符。
)

$(H5 检测线程终止)

$(P
线程可以检测消息的接收者是否已经终止。
)

$(H6 $(IX OwnerTerminated) $(C OwnerTerminated) 异常)

$(P
如果所有者线程已被终止，工作线程在接收消息时就会抛出这个异常。下方程序中处在中间层的线程所有者在发送两条消息后就立即退出。这会导致工作线程抛出 $(C OwnerTerminated) 异常：
)

---
import std.stdio;
import std.concurrency;

void main() {
    spawn(&intermediaryFunc);
}

void intermediaryFunc() {
    auto worker = spawn(&workerFunc);
    worker.send(1);
    worker.send(2);
}  // ← 发送两条消息后立刻终止

void workerFunc() {
    while (true) {
        auto m = receiveOnly!int(); // ← 如果
                                    //   拥有者线程已经终止，
                                    //   它将抛出异常。
        writeln("Message: ", m);
    }
}
---

$(P
输出：
)

$(SHELL
Message: 1
Message: 2
std.concurrency.$(HILITE OwnerTerminated)@std/concurrency.d(248):
Owner terminated
)

$(P
工作线程也可以通过捕获这个异常来优雅地退出：
)

---
void workerFunc() {
    bool isDone = false;

    while (!isDone) {
        try {
            auto m = receiveOnly!int();
            writeln("Message: ", m);

        } catch ($(HILITE OwnerTerminated) exc) {
            writeln("The owner has terminated.");
            isDone = true;
        }
    }
}
---

$(P
输出：
)

$(SHELL
Message: 1
Message: 2
The owner has terminated.
)

$(P
之后我们会看到也可以将这个异常当作消息发送。
)

$(H6 $(IX LinkTerminated) $(IX spawnLinked) $(C LinkTerminated) 异常)

$(P
$(C spawnLinked()) 与 $(C spawn()) 用法相同。当由 $(C spawnLinked()) 创建的线程终止时，拥有者线程将会抛出 $(C LinkTerminated) 异常。
)

---
import std.stdio;
import std.concurrency;

void main() {
    auto worker = $(HILITE spawnLinked)(&workerFunc);

    while (true) {
        auto m = receiveOnly!int(); // ← 如果
                                    //   工作线程已经终止，
                                    //   它将抛出异常。
        writeln("Message: ", m);
    }
}

void workerFunc() {
    ownerTid.send(10);
    ownerTid.send(20);
}  // ← 发送两条消息后立刻终止
---

$(P
发送两条消息后工作线程立刻终止。由于工作线程是通过 $(C spawnLinked()) 启动的，它将通过向所有者线程抛出 $(C LinkTerminated) 异常以通知其工作线程已终止。
)

$(SHELL
Message: 10
Message: 20
std.concurrency.$(HILITE LinkTerminated)@std/concurrency.d(263):
Link terminated
)

$(P
所有者线程可以捕获这个异常并执行某些操作，比如优雅地退出：
)

---
    bool isDone = false;

    while (!isDone) {
        try {
            auto m = receiveOnly!int();
            writeln("Message: ", m);

        } catch ($(HILITE LinkTerminated) exc) {
            writeln("The worker has terminated.");
            isDone = true;
        }
    }
---

$(P
输出：
)

$(SHELL
Message: 10
Message: 20
The worker has terminated.
)

$(P
这个异常也可以被当作消息发送。
)

$(H6 接收异常消息)

$(P
$(C OwnerTerminated) 和 $(C LinkTerminated) 都可以作为消息在线程间传递。下面的代码演示了如何传递 $(C OwnerTerminated) 异常：
)

---
    bool isDone = false;

    while (!isDone) {
        receive(
            (int message) {
                writeln("Message: ", message);
            },

            ($(HILITE OwnerTerminated exc)) {
                writeln("The owner has terminated; exiting.");
                isDone = true;
            }
        );
    }
---

$(H5 邮箱管理)

$(P
每一个线程都有一个用来保存消息的邮箱。邮箱中的消息个数会随着程序接收和处理消息的速度而有所变化。邮箱中持续增加的消息不仅会加重整个系统的负担，还会成为程序设计的瑕疵。这也意味着线程永远只能拿到许久之前接收的消息。
)

$(P
$(IX setMaxMailboxSize) $(C setMaxMailboxSize()) 可以限制邮箱保存的消息数量。它的三个参数分别指代的是邮箱、最大保存消息数量和邮箱被填满之后需要进行的操作。最后一个参数有四个选项：
)

$(UL

$(LI $(IX OnCrowding) $(C OnCrowding.block)：阻塞发送者直到邮箱中有空闲空间。)

$(LI $(C OnCrowding.ignore)：多余的消息将被抛弃。)

$(LI $(IX MailboxFull) $(C OnCrowding.throwException)：向发送者线程中抛出$(C MailboxFull) 异常。)

$(LI 类型为 $(C bool function(Tid) 的函数指针)：调用指定的函数。)

)

$(P
在接触 $(C setMaxMailboxSize()) 的例子之前，我们先来创建一个消息数量会持续增长的邮箱。下面这个工作线程会不停地向主线程发送消息，但主线程处理消息的速度就没有工作线程这么快了，每条消息主线程都会花费一点时间来处理：
)

---
/* 注意：在运行这个程序时你的系统可能会
 *          失去响应。*/
import std.concurrency;
import core.thread;

void workerFunc() {
    while (true) {
        ownerTid.send(42);    // ← 持续产生消息
    }
}

void main() {
    spawn(&workerFunc);

    while (true) {
        receive(
            (int message) {
                // 每条消息都要花费一点时间来处理
                Thread.sleep(1.seconds);
            });
    }
}
---

$(P
因为消费者处理消息的速度远低于生产者产生消息的速度，程序的内存占用会持续增长。为了防止出现这样的情况，线程所有者会在启动工作线程前限制邮箱大小：
)

---
void $(CODE_DONT_TEST)main() {
    setMaxMailboxSize(thisTid, 1000, OnCrowding.block);

    spawn(&workerFunc);
// ...
}
---

$(P
$(C setMaxMailboxSize()) 将邮箱大小限制为 1000。$(C OnCrowding.block) 会阻塞消息发送者的线程直到邮箱中有空闲空间。
)

$(P
下面这个例子使用了 $(C OnCrowding.throwException)。它将在邮箱满时抛出 $(C MailboxFull) 异常：
)

---
import std.concurrency;
import core.thread;

void workerFunc() {
    while (true) {
        try {
            ownerTid.send(42);

        } catch ($(HILITE MailboxFull) exc) {
            /* 无法发送消息；稍候会重新发送。*/
            Thread.sleep(1.msecs);
        }
    }
}

void main() {
    setMaxMailboxSize(thisTid, 1000, $(HILITE OnCrowding.throwException));

    spawn(&workerFunc);

    while (true) {
        receive(
            (int message) {
                Thread.sleep(1.seconds);
            });
    }
}
---

$(H5 $(IX prioritySend) $(IX PriorityMessageException) 消息优先级)

$(P
可以使用 $(C prioritySend()) 发送高标准优先级的消息。这些高优先级消息会比其他邮箱中的消息先被处理：
)

---
    prioritySend(ownerTid, ImportantMessage(100));
---

$(P
如果消息接收者没有能与优先级消息匹配的处理函数，它会抛出一个 $(C PriorityMessageException) 异常：
)

$(SHELL
std.concurrency.$(HILITE PriorityMessageException)@std/concurrency.d(280):
Priority message
)

$(H5 线程名)

$(P
之前我们看到的程序都很简单，所以在线程间传递线程 ID 还是比较方便的。一旦线程数增加，它将会大大增加程序的复杂度。为了降低这种复杂度，我们可以为线程命名。所有线程都可以通过线程名访问这个线程。
)

$(P
下面这三个函数定义了一个接口。通过这个接口每个线程都可以访问一个关联线程与线程名的数组：
)

$(UL

$(LI $(IX register, concurrency) $(C register())：给线程关联一个名字。)

$(LI $(IX locate) $(C locate())：返回线程名关联的线程。如果没有线程关联到这个名字，则返回 $(C Tid.init)。)

$(LI $(IX unregister) $(C unregister())：解除线程和线程名之间的关联。)

)

$(P
下面这个程序启动了两个线程。它们会通过线程名找到对方。线程会不停地互相发送信息，只有在收到 $(C Exit) 消息后它们才会终止：
)

---
import std.stdio;
import std.concurrency;
import core.thread;

struct Exit {
}

void main() {
    // 兄弟线程为 "second"
    auto first = spawn(&player, "second");
    $(HILITE register)("first", first);
    scope(exit) $(HILITE unregister)("first");

    // 兄弟线程为 "first"
    auto second = spawn(&player, "first");
    $(HILITE register)("second", second);
    scope(exit) $(HILITE unregister)("second");

    Thread.sleep(2.seconds);

    prioritySend(first, Exit());
    prioritySend(second, Exit());

    // 为了能成功调用 unregister()，main() 需要等待
    // 工作线程终止。
    thread_joinAll();
}

void player(string nameOfPartner) {
    Tid partner;

    while (partner == Tid.init) {
        Thread.sleep(1.msecs);
        partner = $(HILITE locate)(nameOfPartner);
    }

    bool isDone = false;

    while (!isDone) {
        partner.send("hello " ~ nameOfPartner);
        receive(
            (string message) {
                writeln("Message: ", message);
                Thread.sleep(500.msecs);
            },

            (Exit message) {
                writefln("%s, I am exiting.", nameOfPartner);
                isDone = true;
            });
    }
}
---

$(P
$(IX thread_joinAll) $(C main()) 末尾处的  $(C thread_joinAll()) 会阻塞所有者线程，等待所有工作线程终止。
)

$(P
输出：
)

$(SHELL
Message: hello second
Message: hello first
Message: hello second
Message: hello first
Message: hello first
Message: hello second
Message: hello first
Message: hello second
second, I am exiting.
first, I am exiting.
)

$(H5 小结)

$(UL

$(LI 如果线程相互独立，推荐使用上一章的 $(I parallelism)。只有线程间有相互依赖的操作时再考虑 $(I concurrency)。)

$(LI 基于数据共享的并行难以编写出正确的代码，所以推荐使用本章讲解的消息传递并行。)

$(LI $(C spawn()) 和 $(C spawnLinked()) 用于启动线程。)

$(LI $(C thisTid) 为当前线程的线程 ID。)

$(LI $(C ownerTid) 为当前线程所有者的线程 ID。)

$(LI $(C send()) 和 $(C prioritySend()) 用于发送消息。)

$(LI $(C receiveOnly())、$(C receive()) 和 $(C receiveTimeout()) 用于等待消息。)

$(LI $(C Variant) 用来匹配所有类型的消息。)

$(LI $(C setMaxMailboxSize()) 用来限制邮箱大小。)

$(LI $(C register())、$(C unregister()) 和 $(C locate()) 允许程序员通过线程名访问线程。)

$(LI 消息传递的过程中也可能会抛出异常：$(C MessageMismatch)、$(C OwnerTerminated)、$(C LinkTerminated)、$(C MailboxFull) 以及 $(C PriorityMessageException)。)

$(LI 所有者无法自动捕获工作线程中的异常。)

)

macros:
        SUBTITLE=基于消息传递的并发

        DESCRIPTION=在 D 语言中启动多个线程并通过消息传递实现多线程交互。

        KEYWORDS=d programming language tutorial book concurrency thread 编程 语言 教程 书籍 并发 线程

MINI_SOZLUK=
