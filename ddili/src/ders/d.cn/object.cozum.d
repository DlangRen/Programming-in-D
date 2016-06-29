Ddoc

$(COZUM_BOLUMU $(CH4 Object))

$(OL

$(LI
对于相等性比较，$(C rhs) 属非 $(C null) 并且成员相等就足够了：

---
enum Color { blue, green, red }

class Point {
    int x;
    int y;
    Color color;

// ...

    override bool opEquals(Object o) const {
        const rhs = cast(const Point)o;

        return rhs && (x == rhs.x) && (y == rhs.y);
    }
}
---

)

$(LI
当右手侧对象的类型也是 $(C Point)，首先根据 $(C x) 成员的值来比较，然后是 $(C y) 成员的值：

---
class Point {
    int x;
    int y;
    Color color;

// ...

    override int opCmp(Object o) const {
        const rhs = cast(const Point)o;
        enforce(rhs);

        return (x != rhs.x
                ? x - rhs.x
                : y - rhs.y);
    }
}
---

)

$(LI
注意下面的 $(C opCmp) 函数内部，要转换到 $(C const TriangularArea) 类型是不可能的。当 $(C rhs) 是 $(C const TriangularArea)，那么它的成员 $(C rhs.points) 也将是 $(C const) 。由于 $(C opCmp) 的参数属非$(C const)，它将不可能给 $(C point.opCmp) 传递 $(C rhs.points[i]) 参数。

---
class TriangularArea {
    Point[3] points;

    this(Point one, Point two, Point three) {
        points = [ one, two, three ];
    }

    override bool opEquals(Object o) const {
        const rhs = cast(const TriangularArea)o;
        return rhs && (points == rhs.points);
    }

    override int opCmp(Object o) const {
        $(HILITE auto) rhs = $(HILITE cast(TriangularArea))o;
        enforce(rhs);

        foreach (i, point; points) {
            immutable comparison = point.opCmp(rhs.points[i]);

            if (comparison != 0) {
                /* 排序顺序已经
                 * 确定。简单的返回结果。*/
                return comparison;
            }
        }

        /* 对象被认为是相等的，因为所有的
         * point已经相等。*/
        return 0;
    }

    override size_t toHash() const {
        /* 由于 'points' 成员是一个数组，我们能
         * 为数组类型利用现有的 
          toHash 算法。*/
        return typeid(points).getHash(&points);
    }
}
---

)

)


Macros:
        SUBTITLE=Object 习题解答

        DESCRIPTION=D语言编程习题解答：Object

        KEYWORDS=D语言编程教程 Object
