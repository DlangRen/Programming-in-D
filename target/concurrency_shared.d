Ddoc

$(DERS_BOLUMU $(IX data sharing concurrency) $(IX concurrency, data sharing) 基于数据共享的并发)

$(P
在上一章中，我们使用消息传递实现线程间的信息共享。前面章节已提到，消息传递是一种比较安全的并发方法。
)

$(P
另外一种共享消息的方法是多个线程读写同一块数据。例如，所有者线程在启动工作线程的同时向其传递了一个 $(C bool) 值的地址，工作线程可通过读取这个值来判断是否需要终止。或者所有者线程将同一个变量地址发给多个工作线程，这些工作线程可通过修改或读取这个变量来从其他线程获取信息。
)

$(P
$(I 竞态条件)是数据共享不够安全的原因之一。当多个线程以无法控制的顺序访问同一块数据时就会引发竞态条件。由于操作系统会无法预期地暂停和继续线程的执行，含有竞态条件的程序的行为是无法预期的。
)

$(P
本章中的例子看起来都很简单。但是在实际编程中它们代表的问题通常规模很大。除此之外，虽然本章的例子使用的都是 $(C std.concurrency) 模块，但它们所包含的概念同样适用于 $(C core.thread) 模块。
)

$(H5 共享不是自动的)

$(P
与其他大部分编程语言的不同之处在于，D 语言里的数据不会自动共享（默认情况下，数据仅限于线程本地。虽然每个线程都可以访问模块级的变量，但实际上它们访问的都是对应变量在自己线程中的副本：
)

---
import std.stdio;
import std.concurrency;
import core.thread;

int $(HILITE variable);

void printInfo(string message) {
    writefln("%s: %s (@%s)", message, variable, &variable);
}

void worker() {
    variable = $(HILITE 42);
    printInfo("Before the worker is terminated");
}

void main() {
    spawn(&worker);
    thread_joinAll();
    printInfo("After the worker is terminated");
}
---

$(P
$(C worker()) 中修改的 $(C variable) 与 $(C main()) 访问的 $(C variable) 是不同的。这一点你可以从输出的变量值和地址看出来：
)

$(SHELL
Before the worker is terminated: 42 (@7F26C6711670)
After the worker is terminated: 0 (@7F26C68127D0)
)

$(P
由于每个线程都有一份单独的数据拷贝，$(C spawn()) 不允许以引用的形式传递线程内的值。例如，下面这个程序，试图传递 $(C bool) 值的地址只会导致编译错误：
)

---
import std.concurrency;

void worker($(HILITE bool * isDone)) {
    while (!(*isDone)) {
        // ...
    }
}

void main() {
    bool isDone = false;
    spawn(&worker, $(HILITE &isDone));      $(DERLEME_HATASI)

    // ...

    // 希望通知工作线程终止：
    isDone = true;

    // ...
}
---

$(P
$(C std.concurrency) 模块中的 $(C static assert) 阻止线程访问其他线程中的$(I 可变)数据：
)

$(SHELL
src/phobos/std/concurrency.d(329): Error: static assert
"Aliases to $(HILITE mutable thread-local data) not allowed."
)

$(P
可变变量 $(C isDone) 的地址无法在线程间传递：
)

$(P
$(IX __gshared) 除非使用 $(C __gshared) 定义变量：
)

---
__gshared int globallyShared;
---

$(P
这样的话，程序中只会有一 $(C globallyShared)，它会在所有线程间共享。在与像 C 和 C++ 这样默认自动数据共享的语言编写的库交互时，$(C __gshared) 是必须的。
)

$(H5 $(IX shared) 用 $(C shared) 在线程间共享数据))

$(P
需要共享的可变变量必须使用 $(C shared) 关键自定义：
)

---
import std.concurrency;

void worker($(HILITE shared(bool)) * isDone) {
    while (*isDone) {
        // ...
    }
}

void main() {
    $(HILITE shared(bool)) isDone = false;
    spawn(&worker, &isDone);

    // ...

    // 通知工作线程终止：
    isDone = true;

    // ...
}
---

$(P
$(I $(B 注意：) 推荐使用消息传递向线程发送控制信号。)
)

$(P
$(IX immutable, concurrency) 另一方面，由于 $(C immutable) 变量无法被修改，它们可以直接共享。因此，$(C immutable) 隐含了 $(C shared)：
)

---
import std.stdio;
import std.concurrency;
import core.thread;

void worker($(HILITE immutable(int)) * data) {
    writeln("data: ", *data);
}

void main() {
    $(HILITE immutable(int)) i = 42;
    spawn(&worker, &i);         // ← 编译正常

    thread_joinAll();
}
---

$(P
输出：
)

$(SHELL
data: 42
)

$(P
请注意：$(C i) 的生命期即为 $(C main()) 函数作用域，所以为了防止出现错误应确保 $(C main()) 函数在工作线程终止后才返回。所以，我们调用 $(C core.thread.thread_joinAll) 函数阻塞主线程来等待子线程执行完毕。
)

$(H5 竞态条件示例)

$(P
为了保证程序的正确性，我们需要为那些在线程间共享的可变数据付出额外的精力。
)

$(P
下面这个竞态条件的例子就是多个线程共享同一个可变变量。这些线程将会收到两个变量的地址，并将它们的值对调。对调过程将执行多次：
)

---
import std.stdio;
import std.concurrency;
import core.thread;

void swapper($(HILITE shared(int)) * first, $(HILITE shared(int)) * second) {
    foreach (i; 0 .. 10_000) {
        int temp = *second;
        *second = *first;
        *first = temp;
    }
}

void main() {
    $(HILITE shared(int)) i = 1;
    $(HILITE shared(int)) j = 2;

    writefln("before: %s and %s", i, j);

    foreach (id; 0 .. 10) {
        spawn(&swapper, &i, &j);
    }

    // 等待所有线程完成它们的任务
    thread_joinAll();

    writefln("after : %s and %s", i, j);
}
---

$(P
虽然上面这个程序顺利通过了编译，但在大多数情况下它并不能正确工作。你看它启动了 10 个线程，这些线程都要去访问变量 $(C i) 和 $(C j)。由于它们处在$(I 竞态条件)，这些线程会在不经意间破坏其他线程的操作。
)

$(P
除此之外我们还可以看到程序一共启动了 10 个线程，每个线程执行 1 万次交换。由于交换总次数一样，我们会很自然的认为交换后的值与初始值相同，即 1 和 2：
)

$(SHELL
before: 1 and 2
after : 1 and 2    $(SHELL_NOTE 期望的结果)
)

$(P
虽然程序的确可以得到我们预期的那种结果，但是实际上大多数情况下程序的输出都是下面这样的：
)

$(SHELL
before: 1 and 2
after : 1 and 1    $(SHELL_NOTE_WRONG 错误结果)
)

$(SHELL
before: 1 and 2
after : 2 and 2    $(SHELL_NOTE_WRONG 错误结果)
)

$(P
当然最终结果也有可能是“2 and 1”，只不过这种情况的可能性比较小而已。
)

$(P
下面这两个处在竞态条件的线程可以用来解释为什么之前的程序不能得到正确的结果。由于操作系统暂停和继续线程的不确定性，这两个线程操作的执行顺序也是不确定的。
)

$(P
先来看下 $(C i) 为 1 $(C j) 为 2 的情况。虽然两个线程执行的都是 $(C swapper()) 函数，但别忘了由于 $(C temp) 是是个局部变量，每个线程都会拥有一个独立的 $(C temp) 副本。为了区分这两个 $(C temp)，我们将其分别称为 $(C tempA) 和 $(C tempB)。
)

$(P
下面这个表格展示了 $(C for) 循环中的 3 行语句是如何执行的。按照从上到下的顺序，操作 1 第一个执行，操作 6 最后一个执行。高亮的步骤修改了 $(C i) 和 $(C j)：
)

$(MONO
$(B 操作        线程 A                             线程 B)
────────────────────────────────────────────────────────────────────────────

  1:   int temp = *second; (tempA==2)
  2:   *second = *first;   (i==1, $(HILITE j==1))

          $(I (假设此处 A 暂停 B 启动))

  3:                                        int temp = *second; (tempB==1)
  4:                                        *second = *first;   (i==1, $(HILITE j==1))

          $(I (假设此处 B 暂停 A 继续))

  5:   *first = temp;    ($(HILITE i==2), j==1)

          $(I (假设此处 A 暂停 B 继续))

  6:                                        *first = temp;    ($(HILITE i==1), j==1)
)

$(P
经过这种情况的执行后 $(C i) 和 $(C j) 的值最后都变成了 1。此处不可能会再有其他的值。
)

$(P
上面那种情况只是为了解释程序得出错误结果的原因而创建的例子。10 条线程的实际情况要比例子复杂得多。
)

$(H5 $(IX synchronized) $(C synchronized) 避免竞态条件)

$(P
程序出错的原因是多个线程访问同一块可变数据（并且其中至少有一条线程修改了数据）。一种解决方案是使用关键字 $(C synchronized) 标记公共代码以消除竞态条件。经过下面的修改之后程序能正确执行：
)

---
    foreach (i; 0 .. 10_000) {
        $(HILITE synchronized {)
            int temp = *b;
            *b = *a;
            *a = temp;
        $(HILITE })
    }
---

$(P
输出：
)

$(SHELL
before: 1 and 2
after : 1 and 2      $(SHELL_NOTE 正确结果)
)

$(P
$(IX lock) $(C synchronized) 会在后台创建一个锁，同一时间只有一个线程能持有这个锁。只有持有锁的那个线程才可以执行，其他线程都需要等待持有锁的线程执行完成并释放 $(C synchronized) 锁。由于同一时间只有一个执行 $(I synchronized) 代码的线程，我们就可以安全的进行交换。在同步块执行后 $(C i) 与 $(C j) 只会有种情况：要么是“1 and 2”，要么是“2 and 1”。
)

$(P
$(I $(B 注意：) 等待锁是一个相对昂贵的操作，它可能会显著降低程序的执行速度。幸运的是大多数程序可以使用 $(I 原子操作) 替代 $(C synchronized) 块（随后会介绍它）。)
)

$(P
当需要 synchronize 多个代码块时，最好是使用多个 $(C synchronized) 关键字指定多个锁。
)

$(P
下面的例子包含两个独立的访问共享变量的代码块。程序会将同一个变量的地址传递给这两个函数，一个函数对其加 1，一个函数对其减 1，加减次数相同：
)

---
void incrementer(shared(int) * value) {
    foreach (i; 0 .. count) {
        *value = *value + 1;
    }
}

void decrementer(shared(int) * value) {
    foreach (i; 0 .. count) {
        *value = *value - 1;
    }
}
---

$(P
$(I $(B 注意：) 如果将上方的等式换成自增或自检（例如， $(C ++(*value)) 和 $(C &#8209;&#8209;(*value))），编译器会警告：对 $(C shared) 变量执行的读取-修改-写入操作已被弃用。)
)

$(P
很可惜，直接使用 $(C synchronized) 并不能起到我们预期的效果，因为两个代码块的匿名锁是相互独立的。因此 ，这两块代码还是会同时访问那个变量：
)

---
import std.stdio;
import std.concurrency;
import core.thread;

enum count = 1000;

void incrementer(shared(int) * value) {
    foreach (i; 0 .. count) {
        $(HILITE synchronized) { // ← 此处的锁与下方的锁不同。
            *value = *value + 1;
        }
    }
}

void decrementer(shared(int) * value) {
    foreach (i; 0 .. count) {
        $(HILITE synchronized) { // ← 此处的锁与上方的锁不同。
            *value = *value - 1;
        }
    }
}

void main() {
    shared(int) number = 0;

    foreach (i; 0 .. 100) {
        spawn(&incrementer, &number);
        spawn(&decrementer, &number);
    }

    thread_joinAll();
    writeln("Final value: ", number);
}
---

$(P
线程数相同且加减次数相同，可能有人就会认为 $(C number) 的最终结果是 0。但是，这个程序几乎不会得出这个结果：
)

$(SHELL
Final value: -672    $(SHELL_NOTE_WRONG 不是 0)
)

$(P
为了能够给多个代码块套上同样的锁，你必须在 $(C synchronized) 后加一个圆括号并在其中指定锁对象：
)

$(P
$(HILITE $(I $(B 注意：) dmd 2.074.0 并不支持此功能。))
)

---
    // 注意：dmd 2.074.0 并不支持此功能。
    synchronized ($(I lock_object), $(I another_lock_object), ...)
---

$(P
D 语言中没有专门的锁类型，任何类型都可以作为 $(C synchronized) 锁。下面这个程序定义了一个空的 $(C Lock) 类作为锁：
)

---
import std.stdio;
import std.concurrency;
import core.thread;

enum count = 1000;

$(HILITE class Lock {
})

void incrementer(shared(int) * value, $(HILITE shared(Lock) lock)) {
    foreach (i; 0 .. count) {
        synchronized $(HILITE (lock)) {
            *value = *value + 1;
        }
    }
}

void decrementer(shared(int) * value, $(HILITE shared(Lock) lock)) {
    foreach (i; 0 .. count) {
        synchronized $(HILITE (lock)) {
            *value = *value - 1;
        }
    }
}

void main() {
    $(HILITE shared(Lock) lock = new shared(Lock)());
    shared(int) number = 0;

    foreach (i; 0 .. 100) {
        spawn(&incrementer, &number, $(HILITE lock));
        spawn(&decrementer, &number, $(HILITE lock));
    }

    thread_joinAll();
    writeln("Final value: ", number);
}
---

$(P
这次两个 $(C synchronized) 块使用了同一个锁，因此在同一时间它们当中只有一个可以执行。
)

$(SHELL
Final value: 0       $(SHELL_NOTE 正确结果)
)

$(P
类也可以定义为 $(C synchronized)。即表示同一时间只能有一个线程调用类的示例对象的非静态成员函数：
)

---
$(HILITE synchronized) class Class {
    void foo() {
        // ...
    }

    void bar() {
        // ...
    }
}
---

$(P
下面的类和上面的是等价的：
)

---
class Class {
    void foo() {
        synchronized (this) {
            // ...
        }
    }

    void bar() {
        synchronized (this) {
            // ...
        }
    }
}
---

$(P
如果几块代码需要锁住多个对象来同步，指定在一个 $(C synchronized) 中。不然的话就可能出现几个线程分别拿到了不同的锁，而它们又在等待其他线程手中的锁的情况，即$(I 死锁)。
)

$(P
这个问题有一个著名的例子：想要编写一个函数将某个银行账户中的资金转到另一个账户。为了能让函数在多线程环境中正确运行，每个账户都要先被锁锁住。但下面这个程序并不能实现我们的要求：
)

---
void transferMoney(shared BankAccount from,
                   shared BankAccount to) {
    synchronized (from) {           $(CODE_NOTE_WRONG 错误)
        synchronized (to) {
            // ...
        }
    }
}
---

$(P
$(IX deadlock) 我们会用一个例子来解释程序为什么出错。示例中有一个线程想要将账户 A 中的资金转到账户 B，而另一个线程想要将账户 B 中的资金转到账户 A。每个线程都会先锁住各自的 $(C from) 对象，然后再尝试去锁 $(C to) 对象。由于代表 A 和 B 的 $(C from) 对象已分别被两个线程锁住，它们将无法获取另一个线程的 $(C to) 对象（即刚刚被锁住的 B 和 A）。这个现象就是$(I 死锁)。
)

$(P
解决方法是为对象定义一个顺序并按照这个顺序锁住对象。如果使用 $(C synchronized) 语句这个过程将被自动实现。对于 D 语言，在同一个 $(C synchronized) 中指定这些对象即可有效避免死锁的情况：
)

$(P
$(HILITE $(I $(B 注意：) dmd 2.074.0 并不支持此功能。))
)

---
void transferMoney(shared BankAccount from,
                   shared BankAccount to) {
    // 注意：dmd 2.074.0 并不支持此功能。
    synchronized (from, to) {       $(CODE_NOTE 正确)
        // ...
    }
}
---

$(H5 $(IX shared static this) $(IX static this, shared) $(IX shared static ~this) $(IX static ~this, shared) $(IX this, shared static) $(IX ~this, shared static) $(IX module constructor, shared)$(C shared static this()) 可用于单个初始化；$(C shared static ~this()) 可用于单个析构)

$(P
我们已经见到过 $(C static this())，它是用来初始化模块和模块中包含的变量的。由于默认情况下每个线程都会有一个数据的副本，$(C static this()) 需要在每个线程中执行一次来初始化对应线程中的模块级变量：
)

---
import std.stdio;
import std.concurrency;
import core.thread;

static this() {
    writeln("executing static this()");
}

void worker() {
}

void main() {
    spawn(&worker);

    thread_joinAll();
}
---

$(P
上面这个 $(C static this()) 会为主线程执行一次，为工作线程执行一次：
)

$(SHELL
executing static this()
executing static this()
)

$(P
对于指定了 $(C shared) 的模块变量来说，重复初始化有可能导致并发中的竞态条件而造成程序出错。（这也适用于 $(C immutable) 因为它已隐含 $(C shared)。）解决方案是使用 $(C shared static this()) 块，它只会在程序中执行一次：
)

---
int a;              // 仅限线程本地
immutable int b;    // 所有线程共享

static this() {
    writeln("Initializing per-thread variable at ", &a);
    a = 42;
}

$(HILITE shared) static this() {
    writeln("Initializing per-program variable at ", &b);
    b = 43;
}
---

$(P
输出：
)

$(SHELL
Initializing per-program variable at 6B0120    $(SHELL_NOTE 只有一次)
Initializing per-thread variable at 7FBDB36557D0
Initializing per-thread variable at 7FBDB3554670
)

$(P
同样地，$(C shared static ~this()) 适用于结束操作——每个程序只会执行一次来释放资源。.
)

$(H5 $(IX atomic operation) 原子操作)

$(P
另一种确保同一时间只有一个线程能修改变量的方法是原子操作。这个功能是由处理器、编译器或操作系统提供的。
)

$(P
D 语言中的原子操作都在 $(C core.atomic) 模块里。本章我们只会接触到其中两种：
)

$(H6 $(IX atomicOp, core.atomic) $(C atomicOp))

$(P
这个函数会将它的模版参数应用到两个函数参数上。它的模版参数必须是一个$(I 二元运算符)，如 $(STRING "+")、$(STRING "+=") 等。
)

---
import core.atomic;

// ...

        atomicOp!"+="(*value, 1);    // 原子的
---

$(P
上面这一行和下面这一行功能相同，但原子操作会使 $(C +=) 不被其他线程打断（或者说它们$(I 像原子一样)不可拆分）：
)

---
        *value += 1;                 // 非原子的
---

$(P
如果只是一个二元运算的话，我们没必要使用会影响效率的 $(C synchronized) 块。下面是$(C incrementer()) 和 $(C decrementer()) 函数使用 $(C atomicOp) 之后的等效情况。请注意，现在不再需要 $(C Lock) 类：
)

---
import core.atomic;

//...

void incrementer(shared(int) * value) {
    foreach (i; 0 .. count) {
        $(HILITE atomicOp!"+="(*value, 1));
    }
}

void decrementer(shared(int) * value) {
    foreach (i; 0 .. count) {
        $(HILITE atomicOp!"-="(*value, 1));
    }
}
---

$(P
$(C atomicOp) 也可以用在其他二元操作符上。
)

$(H6 $(IX cas, core.atomic) $(C cas))

$(P
这个函数的名字是“比较并交换（compare and swap）”的缩写。它的操作的理念是：$(I 如果变量的值与已知当前值相同，则修改变量)。使用方法是同时指定当前值和期望值：
)

---
    bool is_mutated = cas(address_of_variable, currentValue, newValue);
---

$(P
在 $(C cas()) 开始执行时，如果变量的值还是等于 $(C currentValue)，则说明自当前线程读入后这个变量没有被其他线程修改。这样的话 $(C cas()) 会将 $(C newValue) 赋给这个变量并返回 $(C true)。另一方面，如果 $(C cas()) 发现变量的值不再等于 $(C currentValue) ，那么它将直接返回 $(C false)，不再修改变量的值。
)

$(P
下面这个函数使用将重新读取当前值并调用 $(C cas()) 直到操作成功。你可以这样描述这种调用：$(I 如果变量值没有被其它线程改变则将新值赋给它)：
)

---
void incrementer(shared(int) * value) {
    foreach (i; 0 .. count) {
        int currentValue;

        do {
            currentValue = *value;
        } while (!$(HILITE cas(value, currentValue, currentValue + 1)));
    }
}

void decrementer(shared(int) * value) {
    foreach (i; 0 .. count) {
        int currentValue;

        do {
            currentValue = *value;
        } while (!$(HILITE cas(value, currentValue, currentValue - 1)));
    }
}
---

$(P
上面这个程序在不使用 $(C synchronized) 块的情况下也能正确工作。
)

$(P
在大多数情况下 $(C core.atomic) 模块中的功能要比 $(C synchronized) 块执行速度快。所以如果需要同步的只是一些简单操作而不是一块代码的话，我建议你优先考虑这个模块。
)

$(P
原子操作还能让我们实现$(I 无锁数据结构)，但这已经超出了本书的范围。
)

$(P
你也可以深入看看 $(C core.sync) 包中，在它的以下模块中包含了很多经典的并发基本操作：
)

$(UL

$(LI $(C core.sync.barrier))
$(LI $(C core.sync.condition))
$(LI $(C core.sync.config))
$(LI $(C core.sync.exception))
$(LI $(C core.sync.mutex))
$(LI $(C core.sync.rwmutex))
$(LI $(C core.sync.semaphore))

)

$(H5 小结)

$(UL

$(LI 如果线程相互独立，优先选择$(I 并行)。只有线程间有相互依赖的操作时再考虑 $(I 并发)。)

$(LI 若要使用并发，优先选择上一章的 $(I 基于消息传递的并发) 模型。)

$(LI 只有用 $(C shared) 定义的变量才能共享；$(C immutable) 隐含了 $(C shared)。)

$(LI $(C __gshared) 提供了与 C 和 C++ 共享数据的能力。)

$(LI $(C synchronized) 可防止其他线程在当前现成的操作执行到一半时横插一脚致使结果错误。)

$(LI 类也可以被定义为 $(C synchronized)，这样同一时间只能有一个线程调用这个类实例对象的成员函数。换句话说，线程只能在没有其他线程调用这个类的实例的成员函数的情况下才能操作它。)

$(LI $(C static this()) 会为每个线程执行一次；$(C shared static this()) 则只会在整个程序中执行一次。)

$(LI $(C core.atomic) 模块提供安全的数据共享方案，而且还比 $(C synchronized) 快很多倍。)

$(LI $(C core.sync) 包包含了许多其他经典的并发基本操作。)

)

macros:
        SUBTITLE=数据共享与并发

        DESCRIPTION=执行多条共享数据的线程

        KEYWORDS=d programming language tutorial book concurrency thread data sharing 编程 语言 教程 书籍 并发 线程 数据 共享

