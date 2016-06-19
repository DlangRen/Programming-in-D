Ddoc

$(DERS_BOLUMU $(IX name scope) 命名作用域)

$(P
任何命名，从定义它开始，到它作用域结束之前，包括其所包含的作用域在内，都是可以访问它的。从这一方面来说，每个作用域都定义了一个$(I 命名作用域)。
)

$(P
然而命名在其作用域结束之后，就不能被访问了：
)

---
void main() {
    int outer;

    if (aCondition) $(HILITE {)  // ← 大括号新建了一个作用域
        int inner = 1;
        outer = 2;     // ← 'outer' 是可以被访问的

    $(HILITE }) // ← 从这里开始 'inner' 就不能被访问了

    inner = 3;  $(DERLEME_HATASI)
                //   在 'inner' 的作用域之外，就不能访问它了
}
---

$(P
因为 $(C inner) 是在 $(C if) 判断的作用域内定义的，所以只能在这里访问到它。还有一点就是，在 outer 和 inner 的作用域内 $(C outer) 都是可以访问到的。
)

$(P
在一个内部作用域，不允许定义相同的命名：
)

---
    size_t $(HILITE length) = oddNumbers.length;

    if (aCondition) {
        size_t $(HILITE length) = primeNumbers.length; $(DERLEME_HATASI)
    }
---

$(H5 定义命名，要在距第一次使用最近的地方)

$(P
就像我们以往写过的程序那样，变量必须被定义在第一次使用之前：
)

---
    writeln(number);     $(DERLEME_HATASI)
                         //   number 还没有被定义
    int number = 42;
---

$(P
为了让上面的代码通过编译，$(C number) 必须在 $(C writeln) 调用之前被定义。虽然没有限制，让你把它定义到之前的哪个地方，但是有一个普遍觉得良好的习惯，就是把变量定义在，距它们第一次被使用最近的地方。
)

$(P
我们来看一个这样的程序，它接收用户输入的一些数字，然后输出它们的平均值。一些有经验的开发人员，会把变量定义在作用域最上面的地方：
)

---
    int count;                                 // ← 比如这里
    int[] numbers;                             // ← 还有这里
    double averageValue;                       // ← 最后还有这个地方

    write("How many numbers are there? ");

    readf(" %s", &count);

    if (count >= 1) {
        numbers.length = count;

        // ... 假设计算的部分在这里 ...

    } else {
        writeln("ERROR: You must enter at least one number!");
    }
---

$(P
我们把下面的程序跟上面的比较一下，上面的每个变量都应用到了这个程序中：
)

---
    write("How many numbers are there? ");

    int count;                                 // ← 比如这里
    readf(" %s", &count);

    if (count >= 1) {
        int[] numbers;                         // ← 还有这里
        numbers.length = count;

        double averageValue;                   // ← 最后还有这个地方
        
        // ... 假设计算的部分在这里 ...

    } else {
        writeln("ERROR: You must enter at least one number!");
    }
---

$(P
尽管把变量定义在最上面，在结构上看起来更好些，不过尽可能晚些定义变量有如下几点好处：
)

$(UL
$(LI $(B 性能：)每个变量在被定义的时候，都会对程序造成少量的开销。由于 D 语言里面，每个变量都会被初始化，在顶部定义变量，会导致它们始终都被初始化，甚至它们只是在之后的某些时间才会被使用，这样的话就浪费了资源。
)

$(LI $(B 出错的风险：)对于定义和使用变量来说，每行代码都会带来一些出错的风险。比如，一个变量的名字使用了一个常见的命名 $(C length)。我们很容易把它跟其它的 length 变量混淆，有可能在我们打算第一次使用它之前，就已经不经意地使用了它。然后当程序使用这个变量的时候，它的值早已不是我们所期望的了。
)

$(LI $(B 可读性：)随着作用域内的代码行数增加，我们所定义的变量可能就会离得越来越远，这样的话就会避免强制开发人员，为了查看变量的定义就要回滚到开始的地方。
)

$(LI $(B 代码维护：)源代码都会被持续地进行调整和改进：添加新的、移除旧的特性，修复 bug 等等。对于这些改动来说，有的时候把一些代码封装到一个函数中是很有必要的。

$(P
如果是这种情况的话，在行内定义变量就会让这些工作实施得更加容易和清晰。
)

$(P
比如，在上文提到的后续代码中，在这个程序里面，$(C if) 判断内部的所有代码，都可以被封装到一个新的函数中。
)

$(P
另外，在最上面声明变量的时候，如果某些代码需要被移走，那么这里涉及到的变量每一个都需要确认和检查。
)

)

)

Macros:
        SUBTITLE=命名作用域

        DESCRIPTION=程序当中，有效命名且可访问的作用域，以及把命名定义在，距第一次使用最近地方的好处。

        KEYWORDS=d 编程语言教程 name scopes
