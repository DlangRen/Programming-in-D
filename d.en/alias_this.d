Ddoc

$(DERS_BOLUMU $(IX alias this) $(CH4 alias this))

$(P
We have seen the individual meanings of the $(C alias) and the $(C this) keywords in previous chapters. These two keywords have a completely different meaning when used together as $(C alias&nbsp;this).
)

$(P
$(IX automatic type conversion) $(IX type conversion, automatic) $(IX implicit type conversion) $(IX type conversion, implicit) $(C alias this) enables $(I automatic type conversions) (also known as $(I implicit type conversions)) of user-defined types. As we have seen in $(LINK2 /ders/d.en/operator_overloading.html, the Operator Overloading chapter), another way of providing type conversions for a type is by defining $(C opCast) for that type. The difference is that, while $(C opCast) is for explicit type conversions, $(C alias this) is for automatic type conversions.
)

$(P
The keywords $(C alias) and $(C this) are written separately where the name of a member variable or a member function is specified between them:
)

---
    alias $(I member_variable_or_member_function) this;
---

$(P
$(C alias this) enables the specific conversion from the user-defined type to the type of that member. The value of the member becomes the resulting value of the conversion .
)

$(P
The following $(C Fraction) example uses $(C alias this) with a $(I member function). The $(C TeachingAssistant) example that is further below will use it with $(I member variables).
)

$(P
Since the return type of $(C value()) below is $(C double), the following $(C alias this) enables automatic conversion of $(C Fraction) objects to $(C double) values:
)

---
import std.stdio;

struct Fraction {
    long numerator;
    long denominator;

    $(HILITE double value()) const @property {
        return double(numerator) / denominator;
    }

    alias $(HILITE value) this;

    // ...
}

double calculate(double lhs, double rhs) {
    return 2 * lhs + rhs;
}

void main() {
    auto fraction = Fraction(1, 4);    // meaning 1/4
    writeln(calculate($(HILITE fraction), 0.75));
}
---

$(P
$(C value()) gets called automatically to produce a $(C double) value when $(C Fraction) objects appear in places where a $(C double) value is expected. That is why the variable $(C fraction) can be passed to $(C calculate()) as an argument. $(C value()) returns 0.25 as the value of 1/4 and the program prints the result of 2 * 0.25 + 0.75:
)

$(SHELL
1.25
)

$(H5 $(IX multiple inheritance) $(IX inheritance, multiple) Multiple inheritance)

$(P
We have seen in $(LINK2 /ders/d.en/inheritance.html, the Inheritance chapter) that classes can inherit from only one $(C class). (On the other hand, there is no limit in the number of $(C interface)s to inherit from.) Some other object oriented languages allow inheriting from multiple classes. This is called $(I multiple inheritance).
)

$(P
$(C alias this) enables using D classes in designs that could benefit from multiple inheritance. Multiple $(C alias this) declarations enable types to be used in places of multiple different types.
)

$(P
$(HILITE $(I $(B Note:) dmd 2.078.0, the compiler that was used last to compile the examples in this chapter, allowed only one $(C alias this) declaration.))
)

$(P
The following $(C TeachingAssistant) class has two member variables of types $(C Student) and $(C Teacher). The $(C alias this) declarations would allow objects of this type to be used in places of both $(C Student) and $(C Teacher):
)

---
import std.stdio;

class Student {
    string name;
    uint[] grades;

    this(string name) {
        this.name = name;
    }
}

class Teacher {
    string name;
    string subject;

    this(string name, string subject) {
        this.name = name;
        this.subject = subject;
    }
}

class TeachingAssistant {
    Student studentIdentity;
    Teacher teacherIdentity;

    this(string name, string subject) {
        this.studentIdentity = new Student(name);
        this.teacherIdentity = new Teacher(name, subject);
    }

    /* The following two 'alias this' declarations will enable
     * this type to be used both as a Student and as a Teacher.
     *
     * Note: dmd 2.078.0 did not support multiple 'alias this'
     *       declarations. */
    alias $(HILITE teacherIdentity) this;
    $(CODE_COMMENT_OUT compiler limitation)alias $(HILITE studentIdentity) this;
}

void attendClass(Teacher teacher, Student[] students)
in {
    assert(teacher !is null);
    assert(students.length > 0);

} do {
    writef("%s is teaching %s to the following students:",
           teacher.name, teacher.subject);

    foreach (student; students) {
        writef(" %s", student.name);
    }

    writeln();
}

void main() {
    auto students = [ new Student("Shelly"),
                      new Student("Stan") ];

    /* An object that can be used both as a Teacher and a
     * Student: */
    auto tim = new TeachingAssistant("Tim", "math");

    // 'tim' is the teacher in the following use:
    attendClass($(HILITE tim), students);

    // 'tim' is one of the students in the following use:
    auto amy = new Teacher("Amy", "physics");
    $(CODE_COMMENT_OUT compiler limitation)attendClass(amy, students ~ $(HILITE tim));
}
---

$(P
The output of the program shows that the same object has been used as two different types:
)

$(SHELL
$(HILITE Tim) is teaching math to the following students: Shelly Stan
Amy is teaching physics to the following students: Shelly Stan $(HILITE Tim)
)

Macros:
        SUBTITLE=alias this

        DESCRIPTION=Nesnelerin otomatik olarak başka tür olarak kullanılmalarını sağlayan 'alias this'.

        KEYWORDS=d programlama dili ders dersler öğrenmek tutorial alias takma isim alias this

SOZLER=
$(kalitim)

