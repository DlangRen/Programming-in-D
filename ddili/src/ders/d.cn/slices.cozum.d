Ddoc

$(COZUM_BOLUMU Slices and Other Array Features)

$(P
通过从开始处缩减切片来遍历元素是一个有意思的想法。在后面的一章中我们将看到这个方法也是 Phobos 的 range 的基本方法。
)

---
import std.stdio;

void main() {
    double[] array = [ 1, 20, 2, 30, 7, 11 ];

    double[] slice = array;    // 允许切片
                               // 访问数组的
                               // 所有元素

    while (slice.length) {     // 只要切片
                               // 至少有一个元素

        if (slice[0] > 10) {   // 在表达式中
            slice[0] /= 2;     // 总是使用第一个元素
        }

        slice = slice[1 .. $]; // 从开始处缩短
                               // 切片
    }

    writeln(array);            // 实际元素已经
                               // 发生变化
}
---

Macros:
        SUBTITLE=切片和其它的数组特征习题解答

        DESCRIPTION=D 语言编程习题解答：数组

        KEYWORDS=D 语言编程教程 数组 习题解答
