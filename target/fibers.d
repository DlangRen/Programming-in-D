Ddoc

$(DERS_BOLUMU $(IX fiber) 纤程)

$(P
$(IX coroutine) $(IX green thread) $(IX thread, green) 纤程（Fiber）是一个$(I执行线程)，它可以让单个线程完成多个任务。与并行和并发里普遍使用的常规线程相比，纤程之间的切换具有更高的效率纤程与$(I协程（Coroutine）)和$(I绿色线程)相似。
)

$(P
协程可以让每个线程有多个调用栈。因此，想要完全理解和用好纤程，你必须先要理解线程的$(I调用栈（call stack）)。
)

$(H5 $(IX call stack) $(IX program stack) 调用栈)

$(P
$(IX local state) 函数的参数、非静态变量、返回值、临时表达式，以及在它执行期间需要的所有附加信息组合成了它的$(I本地状态)。函数的本地状态会在该函数每次被调用时自动分配和初始化。
)

$(P
$(IX stack frame) 为函数调用的本地状态分配的存储空间叫$(I帧（frame）) 或$(I栈帧（stack frame）)。在线程执行期间，函数会调用其他函数，因此它们的帧会在概念上重叠在一起，从而形成一堆的帧。当前正激活的函数调用的帧构成的栈即为该线程的$(I调用栈)。
)

$(P
例如，当下面程序的主线程开始执行 $(C bar()) 函数时， 会有 3 层激活的函数调用，即 $(C main()) 调用了 $(C foo())，而 $(C foo()) 又调用了 $(C bar())：
)

---
void main() {
    int a;
    int b;

    int c = $(HILITE foo)(a, b);
}

int foo(int x, int y) {
    $(HILITE bar)(x + y);
    return 42;
}

void bar(int param) {
    string[] arr;
    // ...
}
---

$(P
在 $(C bar()) 的执行期间，调用栈里面有 3 帧，分别存储的是那些当前正激活函数调用的本地状态：
)

$(MONO
随着函数调用的深入，
调用栈会不断往上增长。▲  ▲
                                 │  │
   调用栈的顶部 → ┌──────────────┐
                           │ int param    │ ← bar 的帧
                           │ string[] arr │
                           ├──────────────┤
                           │ int x        │
                           │ int y        │ ← foo 的帧
                           │ return value │
                           ├──────────────┤
                           │ int a        │
                           │ int b        │ ← main 的帧
                           │ int c        │
调用栈的底部 → └──────────────┘
)

$(P
函数的调用层次会在函数调用其他函数时变得更深，而在函数返回时变浅，因此调用栈的大小也会相应地增大和减小。例如，当 $(C bar()) 返回之后，它的帧并不再需要，而其空间随后会被其他函数调用使用：
)

$(MONO
$(LIGHT_GRAY                            ┌──────────────┐)
$(LIGHT_GRAY                            │ int param    │)
$(LIGHT_GRAY                            │ string[] arr │)
   调用栈的顶部 → ├──────────────┤
                           │ int a        │
                           │ int b        │ ← foo 的帧
                           │ return value │
                           ├──────────────┤
                           │ int a        │
                           │ int b        │ ← main 的帧
                           │ int c        │
调用栈的底部 → └──────────────┘
)

$(P
在之前编写的每个程序里，我们都利用了调用栈。调用栈对递归函数尤其著显。
)

$(H6 $(IX recursion) 递归)

$(P
递归指的是这样一种情况：函数直接或间接地调用自己对于某些类型的算法（如$(I分治法)），使用递归会显得特别简单。
)

$(P
一起来看看下面这个函数，它会计算一个分片里所有元素的总和。它采用递归调用自己的方式（所用的分片是比它所接收到那个分片少一个元素）实现了这一个功能。这个递归会一直持续到接收到的分片为空才会结束。当前结果则通过下一个递归的第二个参数带回：
)

---
import std.array;

int sum(int[] arr, int currentSum = 0) {
    if (arr.empty) {
        /* 没有需要添加的元素。此时，结果已被
         * 计算出来。*/
        return currentSum;
    }

    /* 将最前面的元素与当前总和相加，然后
     * 用余下的元素调用自己。*/
    return $(HILITE sum)(arr[1..$], currentSum + arr.front);
}

void main() {
    assert(sum([1, 2, 3]) == 6);
}
---

$(P
$(IX sum, std.algorithm) $(I $(B 注意：)上面的代码仅用于演示。其实，想要计算某个范围里所有元素的总和，可以使用 $(C std.algorithm.sum)——它针对浮点类型使用了特殊的算法来实现更精确的计算。)
)

$(P
对于上面的初始参数 $(C [1, 2, 3]) ，当最后使用它的空分片调用 $(C sum()) 时，调用栈的相关部分构成了下面这些帧。每个参数的值会在 $(C ==) 符号之后标明。一定要记得从下往上来看帧的内容：
)

$(MONO
              ┌─────────────────────────┐
              │ arr        == []        │ ← 最后一次调用 sum
              │ currentSum == 6         │
              ├─────────────────────────┤
              │ arr        == [3]       │ ← 第三次调用 sum
              │ currentSum == 3         │
              ├─────────────────────────┤
              │ arr        == [2, 3]    │ ← 第二次调用 sum
              │ currentSum == 1         │
              ├─────────────────────────┤
              │ arr        == [1, 2, 3] │ ← 第一次调用 sum
              │ currentSum == 0         │
              ├─────────────────────────┤
              │            ...          │ ← 主函数的帧
              └─────────────────────────┘
)

$(P
$(I $(B 注意：)实际上，当新递归函数直接返回调用自己的结果时，编译器会使用一种名叫“尾调用优化”的技术——它可以去除每次递归调用时生成的各个帧。)
)

$(P
在多线程里，因为每个线程都只负责自己的任务，所以每个线程都会有自己的调用栈，用于维护其执行状态。
)

$(P
纤程的厉害之处在于它虽然不是线程，但是它有其自己的调用栈，从而可以高效地让每个线程拥有多个调用栈。因为一个调用栈可以维护一个任务的执行状态，因此多个调用栈并可以实现一个线程处理多个任务。
)

$(H5 用法)

$(P
下面是纤程的几个常用操作。在后面会看到有关它们的示例。
)

$(UL

$(LI $(IX fiber function) 一个纤程可以执行一个不接受任何参数也不返回任何内容的可调用实例（如函数指针、委托等）。例如，下面这个函数便可以用作纤程函数：

---
void fiberFunction() {
    // ...
}
---

)

$(LI $(IX Fiber, core.thread) 纤程可创建为一个 $(C core.thread.Fiber) 对象，同时带上一个可调用实体：

---
import core.thread;

// ...

    auto fiber = new Fiber($(HILITE &)fiberFunction);
---

$(P
另外，它也可以定义为 $(C Fiber) 的子类，并将纤程函数传递给父类的构造函数。下面的示例里，纤程函数是一个成员函数：
)

---
class MyFiber : $(HILITE Fiber) {
    this() {
        super($(HILITE &)run);
    }

    void run() {
        // ...
    }
}

// ...

    auto fiber = new MyFiber();
---

)

$(LI $(IX call, Fiber) 纤程可以通过成员函数 $(C call()) 来开始和继续：

---
    fiber.call();
---

$(P
与线程不同的是，在纤程执行的同时调用函数会被暂停执行。
)

)

$(LI $(IX yield, Fiber) 纤程通过 $(C Fiber.yield()) 可以将自己暂停（$(I 跳转) 到调用函数）：

---
void fiberFunction() {
    // ...

        Fiber.yield();

    // ...
}
---

$(P
当纤程跳转时，调用函数会继续执行。
)

)

$(LI $(IX .state, Fiber) 纤程的执行状态可以通过它的 $(C .state) 特性来检测：

---
    if (fiber.state == Fiber.State.TERM) {
        // ...
    }
---

$(P
$(IX State, Fiber) $(C Fiber.State) 是一个枚举类型，有下面几种值：
)

$(UL

$(LI $(IX HOLD, Fiber.State) $(C HOLD): 纤程暂停，即表示它可以被开始或继续。)

$(LI $(IX EXEC, Fiber.State) $(C EXEC): 纤程当前正在执行。)

$(LI $(IX TERM, Fiber.State) $(IX reset, Fiber) $(C TERM): 纤程已中止。通过 $(C reset()) 重置后，它可以被再次使用。)

)

)

)

$(H5 范围实现里的纤程)

$(P
几乎所有的范围都需要存储某些信息，以便记住迭代状态。它需要知道当下次调用 $(C popFront()) 时应该做什么。在 $(LINK2 /ders/d.en/ranges.html, 范围)  及后面章节里看到的大部分范围示例为了完成任务都会存储某些状态。
)

$(P
例如，我们之前定义的 $(C FibonacciSeries)会一直记住两个变量，以便计算序列里的 $(I 下一个 next) 成员：
)

---
struct FibonacciSeries {
    int $(HILITE current) = 0;
    int $(HILITE next) = 1;

    enum empty = false;

    @property int front() const {
        return current;
    }

    void popFront() {
        const nextNext = current + next;
        current = next;
        next = nextNext;
    }
}
---

$(P
对于某些类似 $(C FibonacciSeries) 那样的范围，维护迭代状态并非什么难事；但是对于其他的范围（如二叉搜索树那样的递归数据结构）则是困难重重。让人惊讶的是，对于这种数据结构，同样的算法在递归实现时并非什么难事。
)

$(P
例如，下面是 $(C insert()) 和 $(C print()) 的递归实现，它们并未定义任何变量，并且与树里包含的元素数量无关。其中的递归调用是亮点。请注意，$(C insert()) 通过 $(C insertOrSet()) 间接实现的递归。
)

---
import std.stdio;
import std.string;
import std.conv;
import std.random;
import std.range;
import std.algorithm;

/* 二叉树的节点表示。此类型只适用于下面的
 *  Tree 结构，而不应该
 * 被直接使用。*/
struct Node {
    int element;
    Node * left;     // 左子树
    Node * right;    // 右子树

    void $(HILITE insert)(int element) {
        if (element < this.element) {
            /* 更小的元素会进入到左子树。*/
            insertOrSet(left, element);

        } else if (element > this.element) {
            /* 更大的元素会进入到右子树。*/
            insertOrSet(right, element);

        } else {
            throw new Exception(format("%s already exists",
                                       element));
        }
    }

    void $(HILITE print)() const {
        /* 首先输出左子树里的元素 */
        if (left) {
            left.$(HILITE print)();
            write(' ');
        }

        /* 然后，输出当前元素 */
        write(element);

        /* 最后，输出右子树里的元素 */
        if (right) {
            write(' ');
            right.$(HILITE print)();
        }
    }
}

/* 将元素插入到指定的子树，同时会根据情况
 * 初始化它的节点。*/
void insertOrSet(ref Node * node, int element) {
    if (!node) {
        /* 当前子树的第一个元素。*/
        node = new Node(element);

    } else {
        node.$(HILITE insert)(element);
    }
}

/* 实际的 Tree 表示。它允许为空树，
 * 即'root'为'null'时。*/
struct Tree {
    Node * root;

    /* 往树里插入元素。*/
    void insert(int element) {
        insertOrSet(root, element);
    }

    /* 按排序方式输出元素。*/
    void print() const {
        if (root) {
            root.print();
        }
    }
}

/* 从一组有'10 * n'个数的集合里
 * 随机选取'n'个数来初始化这个树。*/
Tree makeRandomTree(size_t n) {
    auto numbers = iota((n * 10).to!int)
                   .randomSample(n, Random(unpredictableSeed))
                   .array;

    randomShuffle(numbers);

    /* 使用这些数来初始化树。*/
    auto tree = Tree();
    numbers.each!(e => tree.insert(e));

    return tree;
}

void main() {
    auto tree = makeRandomTree(10);
    tree.print();
}
---

$(P
$(I $(B 请注意：) 上面这个程序使用了下面几个源自 Phobos 库里的功能:)
)

$(UL

$(LI
$(IX iota, std.range) $(C std.range.iota) 懒式生成给定范围里的元素值。默认情况下，第 1 个元素为 $(C .init) 值。例如，$(C iota(10)) 为一个 $(C int) 型元素构成的范围，元素值的范围是 $(C 0) 到 $(C 9)。
)

$(LI
$(IX each, std.algorithm) $(IX map, vs. each) $(C std.algorithm.each) 与 $(C std.algorithm.map) 相似。由于 $(C map()) 会为每个元素生成一个新的结果，因此 $(C each()) 也会为每个元素生成新值。另外，$(C map()) 采取的是懒式执行方式，而 $(C each()) 则是立即执行。
)

$(LI
$(IX randomSample, std.random) $(C std.random.randomSample) 会从给定的范围里随机选取一些样本元素，但不会更改它们的顺序。
)

$(LI
$(IX randomShuffle, std.random) $(C std.random.randomShuffle) 会随机选取范围里的元素，顺序不确定。
)

)

$(P
与大部分容器一样，大家也会想要这个树提供范围接口，以便其中的元素可以与已有的范围算法一起使用。通过定义一个 $(C opSlice()) 成员函数可以达到这一目的功能：
)

---
struct Tree {
// ...

    /* 提供顺序访问树里的各个元素
     * 的接口。*/
    struct InOrderRange {
        $(HILITE ... 具体的实现应该是什么呢？...)
    }

    InOrderRange opSlice() const {
        return InOrderRange(root);
    }
}
---

$(P
由于上面的成员函数 $(C print()) 实际上已经可以顺序访问每个元素，因此没必要再去为树实现一个 $(C InputRange)。这里不会去实现 $(C InOrderRange)，但是鼓励大家去实现或者试着研究一下树的迭代方法。（有些实现要求树节点拥有一个附加的 $(C Node*)，让其指向每个节点的父节点。）
)

$(P
为何像 $(C print()) 那样的树递归算法无关紧要，主要归因于调用栈的自动管理。调用栈隐形不仅包含当前元素是什么的信息，而且还包含了程序的执行过程是如何到达该元素的信息（例如，执行过程在处理完左节点或右节点之后，接下来会到达什么节点。）
)

$(P
例如，当 $(C left.print()) 的某个递归调用在输出左子树的所有元素之后返回时，当前 $(C print()) 调用的本地状态已表明需要输出一个空格字符：
)

---
    void print() const {
        if (left) {
            left.print();
            write(' ');   // ← 调用栈表明这就是下一步
        }

        // ...
    }
---

$(P
对于使用调用栈比显示维护状态更容易实现的情形，也同样可以使用纤程。
)

$(P
虽然像生成 Fibonacci 序列这样的简单任务并不能突显出纤程的优势，但是为了简化说明，我们还是会实现一个纤程版本，并通过它来了解一下常用的纤程操作。下面我们来实现一个树范围.
)

---
import core.thread;

/* 这个纤程函数会生成每个元素，
 * 并且会设置一个 'ref' 参数引用该元素。*/
void fibonacciSeries($(HILITE ref) int current) {                 // (1)
    current = 0;    // 请注意，'current' 即为该参数
    int next = 1;

    while (true) {
        $(HILITE Fiber.yield());                                  // (2)
        /* 下一次的 call() 会继续从这个点开始执行 */ // (3)

        const nextNext = current + next;
        current = next;
        next = nextNext;
    }
}

void main() {
    int current;                                        // (1)
                         // (4)
    Fiber fiber = new Fiber(() => fibonacciSeries(current));

    foreach (_; 0 .. 10) {
        fiber$(HILITE .call());                                   // (5)

        import std.stdio;
        writef("%s ", current);
    }
}
---

$(OL

$(LI 上面这个函数接收的是一个 $(C int) 型引用参数。它使用此参数来与将当前元素与其调用者联系在一起。（这个参数除了使用 $(C ref) 来修饰以外，还可以使用 $(C out) ）。)

$(LI When the current element is ready for use, the fiber pauses itself by calling $(C Fiber.yield()).)

$(LI A later $(C call()) will resume the function right after the fiber's last $(C Fiber.yield()) call. (The first $(C call()) starts the function.))

$(LI Because fiber functions do not take parameters, $(C fibonacciSeries()) cannot be used directly as a fiber function. Instead, a parameter-less $(LINK2 /ders/d.en/lambda.html, delegate) is used as an adaptor to be passed to the $(C Fiber) constructor.)

$(LI The caller starts and resumes the fiber by its $(C call()) member function.)

)

$(P
As a result, $(C main()) receives the elements of the series through $(C current) and prints them:
)

$(SHELL
0 1 1 2 3 5 8 13 21 34 
)

$(H6 $(IX Generator, std.concurrency) $(C std.concurrency.Generator) for presenting fibers as ranges)

$(P
Although we have achieved generating the Fibonacci series with a fiber, that implementation has the following shortcomings:
)

$(UL

$(LI The solution above does not provide a range interface, making it incompatible with existing range algorithms.)

$(LI Presenting the elements by mutating a $(C ref) parameter is less desirable compared to a design where the elements are copied to the caller's context.)

$(LI Constructing and using the fiber explicitly through its member functions exposes $(I lower level) implementation details, compared to alternative designs.)

)

$(P
The $(C std.concurrency.Generator) class addresses all of these issues. Note how $(C fibonacciSeries()) below is written as a simple function. The only difference is that instead of returning a single element by $(C return), it can make multiple elements available by $(C yield()) ($(I infinite elements) in this example).
)

$(P
$(IX yield, std.concurrency) Also note that this time it is the $(C std.concurrency.yield) function, not the $(C Fiber.yield) member function that we used above.
)

---
import std.stdio;
import std.range;
import std.concurrency;

/* This alias is used for resolving the name conflict with
 * std.range.Generator. */
alias FiberRange = std.concurrency.Generator;

void fibonacciSeries() {
    int current = 0;
    int next = 1;

    while (true) {
        $(HILITE yield(current));

        const nextNext = current + next;
        current = next;
        next = nextNext;
    }
}

void main() {
    auto series = new $(HILITE FiberRange!int)(&fibonacciSeries);
    writefln("%(%s %)", series.take(10));
}
---

$(P
As a result, the elements that are produced by a fiber function are used conveniently as an $(C InputRange):
)

$(SHELL
0 1 1 2 3 5 8 13 21 34
)

$(P
Using $(C Generator), we can easily present the elements of a tree as an $(C InputRange) as well. Further, once the tree has an $(C InputRange) interface, the $(C print()) member function would not be needed anymore; hence it is removed. Especially note how $(C byNode()) is implemented as an adaptor over the recursive function $(C nextNode()):
)

---
import std.concurrency;

alias FiberRange = std.concurrency.Generator;

struct Node {
// ...

    /* Note: print() member function is removed because it is
     * not needed anymore. */

    auto opSlice() const {
        return byNode(&this);
    }
}

/* This is the fiber function that yields the next tree node
 * in sorted order. */
void nextNode(const(Node) * node) {
    if (!node) {
        /* No element at or under this node */
        return;
    }

    nextNode(node.left);    // First, elements on the left
    $(HILITE yield(node));            // Then, this element
    nextNode(node.right);   // Finally, elements on the right
}

/* Returns an InputRange to the nodes of the tree. */
auto byNode(const(Node) * node) {
    return new FiberRange!(const(Node)*)(
        () => nextNode(node));
}

// ...

struct Tree {
// ...

    /* Note: print() member function is removed because it is
     * not needed anymore. */

    auto opSlice() const {
        /* A translation from the nodes to the elements. */
        return byNode(this).map!(n => n.element);
    }
}

/* Returns an InputRange to the nodes of the tree. 这个
 * returned range is empty if the tree has no elements (i.e.
 * if 'root' is 'null'). */
auto byNode(const(Tree) tree) {
    if (tree.root) {
        return byNode(tree.root);

    } else {
        alias RangeType = typeof(return);
        return new RangeType(() {});    $(CODE_NOTE Empty range)
    }
}
---

$(P
$(C Tree) objects can now be sliced with $(C []) and the result can be used as an $(C InputRange):
)

---
    writefln("%(%s %)", tree$(HILITE []));
---

$(H5 $(IX asynchronous I/O, fiber) Fibers in asynchronous input and output)

$(P
The call stack of a fiber can simplify asynchronous input and output tasks as well.
)

$(P
As an example, let's imagine a system where users sign on to a service by connecting to a server and providing their $(I name), $(I email), and $(I age), in that order. This would be similar to the $(I sign-on user flow) of a website. To keep the example simple, instead of implementing an actual web service, let's simulate user interactions using data entered on the command line. Let's use the following simple sign-on protocol, where input data is highlighted:
)

$(UL
$(LI $(HILITE $(C hi)): A user connects and a flow id is generated)
$(LI $(HILITE $(C $(I id data))): The user of flow that corresponds to $(C id) enters the next expected data. For example, if the expected data for flow $(C 42) is $(I name), then the command for Alice would be $(C 42&nbsp;Alice).)
$(LI $(HILITE $(C bye)): Program exits)
)

$(P
For example, the following can be the interactions of Alice and Bob, where the inputs to the simulation program are highlighted. Each user connects and then provides $(I name), $(I email), and $(I age):
)

$(SHELL
> $(HILITE hi)                     $(SHELL_NOTE Alice connects)
Flow 0 started.
> $(HILITE 0 Alice)
> $(HILITE 0 alice@example.com)
> $(HILITE 0 20)
Flow 0 has completed.    $(SHELL_NOTE Alice finishes)
Added user 'Alice'.
> $(HILITE hi)                     $(SHELL_NOTE Bob connects)
Flow 1 started.
> $(HILITE 1 Bob)
> $(HILITE 1 bob@example.com)
> $(HILITE 1 30)
Flow 1 has completed.    $(SHELL_NOTE Bob finishes)
Added user 'Bob'.
> $(HILITE bye)
Goodbye.
Users:
  User("Alice", "alice@example.com", 20)
  User("Bob", "bob@example.com", 30)
)

$(P
This program can be designed to wait for the command $(C hi) in a loop and then call a function to receive the input data of the connected user:
)

---
    if (input == "hi") {
        signOnNewUser();    $(CODE_NOTE_WRONG WARNING: Blocking design)
    }
---

$(P
Unless the program had some kind of support for multitasking, such a design would be considered $(I blocking), meaning that all other users would be blocked until the current user completes their sign on flow. This would impact the responsiveness of even lightly-used services if users took several minutes to provide data.
)

$(P
There can be several designs that makes this service $(I non-blocking), meaning that more than one user can sign on at the same time:
)

$(UL

$(LI Maintaining tasks explicitly: The main thread can spawn one thread per user sign-on and pass input data to that thread by means of messages. Although this method would work, it might involve thread synchronization and it can be slower than a fiber. (The reasons for this potential performance penalty will be explained in the $(I cooperative multitasking) section below.))

$(LI Maintaining state: The program can accept more than one sign-on and remember the state of each sign-on explicitly. For example, if Alice has entered only her name so far, her state would have to indicate that the next input data would be her email information.)

)

$(P
Alternatively, a design based on fibers can employ one fiber per sign-on flow. This would enable implementing the flow in a linear fashion, matching the protocol exactly: first the name, then the email, and finally the age. For example, $(C run()) below does not need to do anything special to remember the state of the sign-on flow. When it is $(C call())'ed next time, it continues right after the last $(C Fiber.yield()) call that had paused it. The next line to be executed is implied by the call stack.
)

$(P
Differently from earlier examples, the following program uses a $(C Fiber) subclass:
)

---
import std.stdio;
import std.string;
import std.format;
import std.exception;
import std.conv;
import std.array;
import core.thread;

struct User {
    string name;
    string email;
    uint age;
}

/* This Fiber subclass represents the sign-on flow of a
 * user. */
class SignOnFlow : Fiber {
    /* The data read most recently for this flow. */
    string inputData_;

    /* The information to construct a User object. */
    string name;
    string email;
    uint age;

    this() {
        /* Set our 'run' member function as the starting point
         * of the fiber. */
        super(&run);
    }

    void run() {
        /* First input is name. */
        name = inputData_;
        $(HILITE Fiber.yield());

        /* Second input is email. */
        email = inputData_;
        $(HILITE Fiber.yield());

        /* Last input is age. */
        age = inputData_.to!uint;

        /* At this point we have collected all information to
         * construct the user. We now "return" instead of
         * 'Fiber.yield()'. As a result, the state of this
         * fiber becomes Fiber.State.TERM. */
    }

    /* This property function is to receive data from the
     * caller. */
    @property void inputData(string data) {
        inputData_ = data;
    }

    /* This property function is to construct a user and
     * return it to the caller. */
    @property User user() const {
        return User(name, email, age);
    }
}

/* Represents data read from the input for a specific flow. */
struct FlowData {
    size_t id;
    string data;
}

/* Parses data related to a flow. */
FlowData parseFlowData(string line) {
    size_t id;
    string data;

    const items = line.formattedRead!" %s %s"(id, data);
    enforce(items == 2, format("Bad input '%s'.", line));

    return FlowData(id, data);
}

void main() {
    User[] users;
    SignOnFlow[] flows;

    bool done = false;

    while (!done) {
        write("> ");
        string line = readln.strip;

        switch (line) {
        case "hi":
            /* Start a flow for the new connection. */
            flows ~= new SignOnFlow();

            writefln("Flow %s started.", flows.length - 1);
            break;

        case "bye":
            /* Exit the program. */
            done = true;
            break;

        default:
            /* Try to use the input as flow data. */
            try {
                auto user = handleFlowData(line, flows);

                if (!user.name.empty) {
                    users ~= user;
                    writefln("Added user '%s'.", user.name);
                }

            } catch (Exception exc) {
                writefln("Error: %s", exc.msg);
            }
            break;
        }
    }

    writeln("Goodbye.");
    writefln("Users:\n%(  %s\n%)", users);
}

/* Identifies the owner fiber for the input, sets its input
 * data, and resumes that fiber. Returns a user with valid
 * fields if the flow has been completed. */
User handleFlowData(string line, SignOnFlow[] flows) {
    const input = parseFlowData(line);
    const id = input.id;

    enforce(id < flows.length, format("Invalid id: %s.", id));

    auto flow = flows[id];

    enforce(flow.state == Fiber.State.HOLD,
            format("Flow %s is not runnable.", id));

    /* Set flow data. */
    flow.inputData = input.data;

    /* Resume the flow. */
    flow$(HILITE .call());

    User user;

    if (flow.state == Fiber.State.TERM) {
        writefln("Flow %s has completed.", id);

        /* Set the return value to the newly created user. */
        user = flow.user;

        /* TODO: This fiber's entry in the 'flows' array can
         * be reused for a new flow in the future. However, it
         * must first be reset by 'flow.reset()'. */
    }

    return user;
}
---

$(P
$(C main()) reads lines from the input, parses them, and dispatches flow data to the appropriate flow to be processed. The call stack of each flow maintains the flow state automatically. New users are added to the system when the complete user information becomes available.
)

$(P
When you run the program above, you see that no matter how long a user takes to complete their individual sign-on flow, the system always accepts new user connections. As an example, Alice's interaction is highlighted:
)

$(SHELL
> $(HILITE hi)                     $(SHELL_NOTE Alice connects)
Flow 0 started.
> $(HILITE 0 Alice)
> hi                     $(SHELL_NOTE Bob connects)
Flow 1 started.
> hi                     $(SHELL_NOTE Cindy connects)
Flow 2 started.
> $(HILITE 0 alice@example.com)
> 1 Bob
> 2 Cindy
> 2 cindy@example.com
> 2 40                   $(SHELL_NOTE Cindy finishes)
Flow 2 has completed.
Added user 'Cindy'.
> 1 bob@example.com
> 1 30                   $(SHELL_NOTE Bob finishes)
Flow 1 has completed.
Added user 'Bob'.
> $(HILITE 0 20)                   $(SHELL_NOTE Alice finishes)
Flow 0 has completed.
Added user 'Alice'.
> bye
Goodbye.
Users:
  User("Cindy", "cindy@example.com", 40)
  User("Bob", "bob@example.com", 30)
  User("Alice", "alice@example.com", 20)
)

$(P
Although Alice, Bob, and Cindy connect in that order, they complete their sign-on flows at different paces. As a result, the $(C users) array is populated in the order that the flows are completed.
)

$(P
One benefit of using fibers in this program is that $(C SignOnFlow.run()) is written trivially without regard to how fast or slow a user's input has been. Additionally, no user is blocked when other sign-on flows are in progress.
)

$(P
$(IX vibe.d) Many asynchronous input/output frameworks like $(LINK2 http://vibed.org, vibe.d) use similar designs based on fibers.
)

$(H5 $(IX exception, fiber) Exceptions and fibers)

$(P
In $(LINK2 /ders/d.en/exceptions.html, the Exceptions chapter) we saw how "an exception object that is thrown from a lower level function is transferred to the higher level functions one level at a time". We also saw that an uncaught exception "causes the program to finally exit the $(C main()) function." Although that chapter did not mention the call stack, the described behavior of the exception mechanism is achieved by the call stack as well.
)

$(P
$(IX stack unwinding) Continuing with the first example in this chapter, if an exception is thrown inside $(C bar()), first the frame of $(C bar()) would be removed from the call stack, then $(C foo())'s, and finally $(C main())'s. As functions are exited and their frames are removed from the call stack, the destructors of local variables are executed for their final operations. The process of leaving functions and executing destructors of local variables due to a thrown exception is called $(I stack unwinding).
)

$(P
Since fibers have their own stack, an exception that is thrown during the execution of the fiber unwinds the fiber's call stack, not its caller's. If the exception is not caught, the fiber function terminates and the fiber's state becomes $(C Fiber.State.TERM).
)

$(P
$(IX yieldAndThrow, Fiber) Although that may be the desired behavior in some cases, sometimes a fiber may need to communicate an error condition to its caller without losing its execution state. $(C Fiber.yieldAndThrow) allows a fiber to yield and immediately throw an exception in the caller's context.
)

$(P
To see how it can be used let's enter invalid age data to the sign-on program:
)

$(SHELL
> hi
Flow 0 started.
> 0 Alice
> 0 alice@example.com
> 0 $(HILITE hello)                       $(SHELL_NOTE_WRONG the user enters invalid age)
Error: Unexpected 'h' when converting from type string to type uint
> 0 $(HILITE 20)                          $(SHELL_NOTE attempts to correct the error)
Error: Flow 0 is not runnable.  $(SHELL_NOTE but the flow is terminated)
)

$(P
Instead of terminating the fiber and losing the entire sign-on flow, the fiber can catch the conversion error and communicate it to the caller by $(C yieldAndThrow()). This can be done by replacing the following line of the program where the fiber converts age data:
)

---
        age = inputData_.to!uint;
---

$(P
Wrapping that line with a $(C try-catch) statement inside an unconditional loop would be sufficient to keep the fiber alive until there is data that can be converted to a $(C uint):
)

---
        while (true) {
            try {
                age = inputData_.to!uint;
                break;  // ← Conversion worked; leave the loop

            } catch (ConvException exc) {
                Fiber.yieldAndThrow(exc);
            }
        }
---

$(P
This time the fiber remains in an unconditional loop until data is valid:
)

$(SHELL
> hi
Flow 0 started.
> 0 Alice
> 0 alice@example.com
> 0 $(HILITE hello)                       $(SHELL_NOTE_WRONG the user enters invalid age)
Error: Unexpected 'h' when converting from type string to type uint
> 0 $(HILITE world)                       $(SHELL_NOTE_WRONG enters invalid age again)
Error: Unexpected 'w' when converting from type string to type uint
> 0 $(HILITE 20)                          $(SHELL_NOTE finally, enters valid data)
Flow 0 has completed.
Added user 'Alice'.
> bye
Goodbye.
Users:
  User("Alice", "alice@example.com", 20)
)

$(P
As can be seen from the output, this time the sign-on flow is not lost and the user is added to the system.
)

$(H5 $(IX preemptive multitasking, vs. cooperative multitasking) $(IX cooperative multitasking) $(IX thread performance) Cooperative multitasking)

$(P
Unlike operating system threads, which are paused (suspended) and resumed by the operating system at unknown points in time, a fiber pauses itself explicitly and is resumed by its caller explicitly. According to this distinction, the kind of multitasking that the operating system provides is called $(I preemptive multitasking) and the kind that fibers provide is called $(I cooperative multitasking).
)

$(P
$(IX context switching) In preemptive multitasking, the operating system allots a certain amount of time to a thread when it starts or resumes its execution. When the time is up, that thread is paused and another one is resumed in its place. Moving from one thread to another is called $(I context switching). Context switching takes a relatively large amount of time, which could have better been spent doing actual work by threads.
)

$(P
Considering that a system is usually busy with high number of threads, context switching is unavoidable and is actually desired. However, sometimes threads need to pause themselves voluntarily before they use up the entire time that was alloted to them. This can happen when a thread needs information from another thread or from a device. When a thread pauses itself, the operating system must spend time again to switch to another thread. As a result, time that could have been used for doing actual work ends up being used for context switching.
)

$(P
With fibers, the caller and the fiber execute as parts of the same thread. (That is the reason why the caller and the fiber cannot execute at the same time.) As a benefit, there is no overhead of context switching between the caller and the fiber. (However, there is still some light overhead which is comparable to the overhead of a regular function call.)
)

$(P
Another benefit of cooperative multitasking is that the data that the caller and the fiber exchange is more likely to be in the CPU's data cache. Because data that is in the CPU cache can be accessed hundreds of times faster than data that needs to be read back from system memory, this further improves the performance of fibers.
)

$(P
Additionally, because the caller and the fiber are never executed at the same time, there is no possibility of race conditions, obviating the need for data synchronization. However, the programmer must still ensure that a fiber yields at the intended time (e.g. when data is actually ready). For example, the $(C func()) call below must not execute a $(C Fiber.yield()) call, even indirectly, as that would be premature, before the value of $(C sharedData) was doubled:
)

---
void fiberFunction() {
    // ...

        func();           $(CODE_NOTE must not yield prematurely)
        sharedData *= 2;
        Fiber.yield();    $(CODE_NOTE intended point to yield)

    // ...
}
---

$(P
$(IX M:N, threading) One obvious shortcoming of fibers is that only one core of the CPU is used for the caller and its fibers. The other cores of the CPU might be sitting idle, effectively wasting resources. It is possible to use different designs like the $(I M:N threading model (hybrid threading)) that employ other cores as well. I encourage you to research and compare different threading models.
)

$(H5 小结)

$(UL

$(LI The call stack enables efficient allocation of local state and simplifies certain algorithms, especially the recursive ones.)

$(LI Fibers enable multiple call stacks per thread instead of the default single call stack per thread.)

$(LI A fiber and its caller are executed on the same thread (i.e. not at the same time).)

$(LI A fiber pauses itself by $(I yielding) to its caller and the caller resumes its fiber by $(I calling) it again.)

$(LI $(C Generator) presents a fiber as an $(C InputRange).)

$(LI Fibers simplify algorithms that rely heavily on the call stack.)

$(LI Fibers simplify asynchronous input/output operations.)

$(LI Fibers provide cooperative multitasking, which has different trade-offs from preemptive multitasking.)

)

macros:
        SUBTITLE=Fibers

        DESCRIPTION=Generators and cooperative multitasking by fibers.

        KEYWORDS=d programming language tutorial book fiber cooperative multitasking
