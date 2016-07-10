Ddoc

$(DERS_BOLUMU $(IX scope(success)) $(IX scope(exit)) $(IX scope(failure)) $(CH4 scope))

$(P
在前面的章节我们已经看到，写在 $(C finally) 块里的表达式一定总被执行。当有错误条件的时候，写在 $(C catch) 块里的表达式总被执行。
)

$(P
对于这些块的用法，我们可以作以下观测：
)

$(UL

$(LI 没有一个 $(C try) 块，$(C catch) 和 $(C finally) 不能使用。)

$(LI 属于块的某些变量，块范围内有可能访问不到：

---
void foo(ref int r) {
    try {
        $(HILITE int addend) = 42;

        r += addend;
        mayThrow();

    } catch (Exception exc) {
        r -= addend;           $(DERLEME_HATASI)
    }
}
---

$(P
上面这个函数首先修改引用参数，当出现异常时再恢复修改。不幸的是，$(C addend) 只能在定义它的 $(C try) 块里访问。$(I ($(B 注：)这与命名作用域，以及对象生存期有关，这将在 $(LINK2 /ders/d.cn/lifetimes.html, 后面的一章) 中解释。))
)

)

$(LI 把所有可能无关联的表达式写在底部单独的 $(C finally) 块，就可以分离那些有关联的可执行代码。
)

)

$(P
$(C scope) 语句与 $(C catch) 和 $(C finally) 有相似功能，但在许多方面表现的更好。像 $(C finally)，下面三个不同的 $(C scope) 语句就是关于离开作用域时应执行的表达式：
)

$(UL
$(LI $(C scope(exit))：表达式总是在退出作用域时被执行，无论是否成功或出现异常。)

$(LI $(C scope(success))：表达式只在成功退出作用域时被执行。)

$(LI $(C scope(failure))：表达式只在因出现异常而退出作用域时被执行。)
)

$(P
虽然这些语句只在特殊情况下使用，但是没有 $(C try-catch) 块也能用。
)

$(P
例如，让我们用 $(C scope(failure)) 语句写一下下面的函数：
)

---
void foo(ref int r) {
    int addend = 42;

    r += addend;
    $(HILITE scope(failure)) r -= addend;

    mayThrow();
}
---

$(P
上面的 $(C scope(failure)) 语句确保 $(C r -= addend) 表达式在因异常退出时被执行。$(C scope(failure)) 的好处是靠近它的表达式可以还原已写的另一个表达式。
)

$(P
$(C scope) 语句也可以像块一样使用：
)

---
    scope(exit) {
        // ... expressions ...
    }
---

$(P
这儿是另一个函数，来测试全部三个语句：
)

---
void test() {
    scope(exit) writeln("when exiting 1");

    scope(success) {
        writeln("if successful 1");
        writeln("if successful 2");
    }

    scope(failure) writeln("if thrown 1");
    scope(exit) writeln("when exiting 2");
    scope(failure) writeln("if thrown 2");

    throwsHalfTheTime();
}
---

$(P
如果没有抛出异常，函数的输出只包括 $(C scope(exit)) 和 $(C scope(success)) 表达式：
)

$(SHELL
when exiting 2
if successful 1
if successful 2
when exiting 1
)

$(P
如果抛出异常，输出包括 $(C scope(exit)) 和 $(C scope(failure)) 表达式：
)

$(SHELL
if thrown 2
when exiting 2
if thrown 1
when exiting 1
object.Exception@...: the error message
)

$(P
在输出中我们看到，$(C scope) 语句块是按相反的顺序执行的。这是因为后边的代码依赖于前边的变量。这样按相反顺序执行 $(C scope) 语句，让程序能按一致的顺序撤消前边表达式的副作用。
)

Macros:
        SUBTITLE=scope

        DESCRIPTION=scope(success)，scope(failure)，和 scope(exit) 语句用于当退出作用域时一定要执行的特殊表达式。

        KEYWORDS=D 语言编程教程 scope
