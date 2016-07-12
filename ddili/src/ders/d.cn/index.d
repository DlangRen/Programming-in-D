Ddoc

$(DERS_BOLUMU Programming in D)

<div style="overflow: auto;">

<img style="border-width:0; float:left; margin:0 2em 1em 1em;" src="$(ROOT_DIR)/ders/d.cn/cover_thumb.png" height="180"/>

$(P
The paper version of this book is available through two publishing platforms:
)

$(P IngramSpark ISBN: 9780692529577)

$(P CreateSpace ISBN: 9781515074601)

$(P
These options have different prices, shipping times, shipping costs, customs and other fees, availability at local book stores, etc.
)

</div>

$(P
$(LINK_DOWNLOAD /ders/d.cn/Programming_in_D_code_samples.zip, Click here to download code samples as a $(C .zip) file.)
)

$(H5 Ebook versions)

$(UL

$(LI $(LINK2 https://gum.co/PinD, Download at Gumroad), which allows you to $(I pay what you want))

$(LI Download here for free as $(LINK_DOWNLOAD http://ddili.org/ders/d.cn/Programming_in_D.pdf, PDF), $(LINK_DOWNLOAD http://ddili.org/ders/d.cn/Programming_in_D.epub, EPUB) (for most ebook readers), $(LINK_DOWNLOAD http://ddili.org/ders/d.cn/Programming_in_D.azw3, AZW3) (for newer Kindles), or $(LINK_DOWNLOAD http://ddili.org/ders/d.cn/Programming_in_D.mobi, MOBI) (for older Kindles).)

)

$(H5 Web version)

$(UL
$(WORK_IN_PROCESS
$(LI $(LINK2 /ders/d.cn/foreword1.html, Foreword by Walter Bright))
)
$(LI $(LINK2 /ders/d.cn/ix.html, Book Index))
$(LI $(LINK2 /ders/d.cn/foreword2.html, Foreword by Andrei Alexandrescu))
$(LI $(LINK2 /ders/d.cn/preface.html, 前言))
$(LI $(LINK2 /ders/d.cn/hello_world.html, The Hello World Program) $(INDEX_KEYWORDS main))
$(LI $(LINK2 /ders/d.cn/writeln.html, writeln and write))
$(LI $(LINK2 /ders/d.cn/compiler.html, 编译))
$(LI $(LINK2 /ders/d.cn/types.html, Fundamental Types) $(INDEX_KEYWORDS char int double (and more)))
$(LI $(LINK2 /ders/d.cn/assignment.html, Assignment and Order of Evaluation) $(INDEX_KEYWORDS =))
$(LI $(LINK2 /ders/d.cn/variables.html, Variables))
$(LI $(LINK2 /ders/d.cn/io.html, Standard Input and Output Streams) $(INDEX_KEYWORDS stdin stdout))
$(LI $(LINK2 /ders/d.cn/input.html, 从标准输入中读取数据))
$(LI $(LINK2 /ders/d.cn/logical_expressions.html, Logical Expressions) $(INDEX_KEYWORDS bool true false ! == != < <= > >= || &&))
$(LI $(LINK2 /ders/d.cn/if.html, if 语句) $(INDEX_KEYWORDS if else))
$(LI $(LINK2 /ders/d.cn/while.html, while Loop) $(INDEX_KEYWORDS while continue break))
$(LI $(LINK2 /ders/d.cn/arithmetic.html, Integers and Arithmetic Operations) $(INDEX_KEYWORDS ++ -- + - * / % ^^ += -= *= /= %= ^^=))
$(LI $(LINK2 /ders/d.cn/floating_point.html, Floating Point Types) $(INDEX_KEYWORDS .nan .infinity isNaN <> !<>= (and more)))
$(LI $(LINK2 /ders/d.cn/arrays.html, Arrays) $(INDEX_KEYWORDS [] .length ~ ~=))
$(LI $(LINK2 /ders/d.cn/characters.html, Characters) $(INDEX_KEYWORDS char wchar dchar))
$(LI $(LINK2 /ders/d.cn/slices.html, Slices and Other Array Features) $(INDEX_KEYWORDS .. $ .dup capacity))
$(LI $(LINK2 /ders/d.cn/strings.html, Strings) $(INDEX_KEYWORDS char[] wchar[] dchar[] string wstring dstring))
$(LI $(LINK2 /ders/d.cn/stream_redirect.html, Redirecting Standard Input and Output Streams))
$(LI $(LINK2 /ders/d.cn/files.html, 文件) $(INDEX_KEYWORDS File))
$(LI $(LINK2 /ders/d.cn/auto_and_typeof.html, auto 和 typeof) $(INDEX_KEYWORDS auto typeof))
$(LI $(LINK2 /ders/d.cn/name_space.html, 命名作用域))
$(LI $(LINK2 /ders/d.cn/for.html, for Loop) $(INDEX_KEYWORDS for))
$(LI $(LINK2 /ders/d.cn/ternary.html, Ternary Operator ?:) $(INDEX_KEYWORDS ?:))
$(LI $(LINK2 /ders/d.cn/literals.html, Literals))
$(LI $(LINK2 /ders/d.cn/formatted_output.html, Formatted Output) $(INDEX_KEYWORDS writef writefln))
$(LI $(LINK2 /ders/d.cn/formatted_input.html, Formatted Input))
$(LI $(LINK2 /ders/d.cn/do_while.html, do-while Loop) $(INDEX_KEYWORDS do while))
$(LI $(LINK2 /ders/d.cn/aa.html, 关联数组) $(INDEX_KEYWORDS .keys .values .byKey .byValue .byKeyValue .get .remove in))
$(LI $(LINK2 /ders/d.cn/foreach.html, foreach Loop) $(INDEX_KEYWORDS foreach .byKey .byValue .byKeyValue))
$(LI $(LINK2 /ders/d.cn/switch_case.html, switch and case) $(INDEX_KEYWORDS switch, case, default, final switch))
$(LI $(LINK2 /ders/d.cn/enum.html, enum) $(INDEX_KEYWORDS enum .min .max))
$(LI $(LINK2 /ders/d.cn/functions.html, Functions) $(INDEX_KEYWORDS return void))
$(LI $(LINK2 /ders/d.cn/const_and_immutable.html, Immutability) $(INDEX_KEYWORDS enum const immutable .dup .idup))
$(LI $(LINK2 /ders/d.cn/value_vs_reference.html, Value Types and Reference Types) $(INDEX_KEYWORDS &))
$(LI $(LINK2 /ders/d.cn/function_parameters.html, Function Parameters) $(INDEX_KEYWORDS in out ref inout lazy scope shared))
$(LI $(LINK2 /ders/d.cn/lvalue_rvalue.html, Lvalues and Rvalues) $(INDEX_KEYWORDS auto ref))
$(LI $(LINK2 /ders/d.cn/lazy_operators.html, Lazy Operators))
$(LI $(LINK2 /ders/d.cn/main.html, Program Environment) $(INDEX_KEYWORDS main stderr))
$(LI $(LINK2 /ders/d.cn/exceptions.html, 异常) $(INDEX_KEYWORDS throw try catch finally))
$(LI $(LINK2 /ders/d.cn/scope.html, scope) $(INDEX_KEYWORDS scope(exit) scope(success) scope(failure)))
$(LI $(LINK2 /ders/d.cn/assert.html, assert and enforce) $(INDEX_KEYWORDS assert enforce))
$(LI $(LINK2 /ders/d.cn/unit_testing.html, Unit Testing) $(INDEX_KEYWORDS unittest))
$(LI $(LINK2 /ders/d.cn/contracts.html, Contract Programming) $(INDEX_KEYWORDS in out body))
$(LI $(LINK2 /ders/d.cn/lifetimes.html, Lifetimes and Fundamental Operations))
$(LI $(LINK2 /ders/d.cn/null_is.html, The null Value and the is Operator) $(INDEX_KEYWORDS null is !is))
$(LI $(LINK2 /ders/d.cn/cast.html, Type Conversions) $(INDEX_KEYWORDS to assumeUnique cast))
$(LI $(LINK2 /ders/d.cn/struct.html, Structs) $(INDEX_KEYWORDS struct . {} static, static this, static ~this))
$(LI $(LINK2 /ders/d.cn/parameter_flexibility.html, Variable Number of Parameters) $(INDEX_KEYWORDS T[]... __MODULE__ __FILE__ __LINE__ __FUNCTION__ __PRETTY_FUNCTION__))
$(LI $(LINK2 /ders/d.cn/function_overloading.html, Function Overloading))
$(LI $(LINK2 /ders/d.cn/member_functions.html, Member Functions) $(INDEX_KEYWORDS toString))
$(LI $(LINK2 /ders/d.cn/const_member_functions.html, const ref Parameters and const Member Functions) $(INDEX_KEYWORDS const ref, in ref, inout))
$(LI $(LINK2 /ders/d.cn/special_functions.html, Constructor and Other Special Functions) $(INDEX_KEYWORDS this ~this this(this) opAssign @disable))
$(LI $(LINK2 /ders/d.cn/operator_overloading.html, Operator Overloading) $(INDEX_KEYWORDS opUnary opBinary opEquals opCmp opIndex (and more)))
$(LI $(LINK2 /ders/d.cn/class.html, 类) $(INDEX_KEYWORDS class new))
$(LI $(LINK2 /ders/d.cn/inheritance.html, Inheritance) $(INDEX_KEYWORDS : super override abstract))
$(LI $(LINK2 /ders/d.cn/object.html, Object) $(INDEX_KEYWORDS toString opEquals opCmp toHash typeid TypeInfo))
$(LI $(LINK2 /ders/d.cn/interface.html, Interfaces) $(INDEX_KEYWORDS interface static final))
$(LI $(LINK2 /ders/d.cn/destroy.html, destroy and scoped) $(INDEX_KEYWORDS destroy scoped))
$(LI $(LINK2 /ders/d.cn/modules.html, Modules and Libraries) $(INDEX_KEYWORDS import, module, static this, static ~this))
$(LI $(LINK2 /ders/d.cn/encapsulation.html, Encapsulation and Protection Attributes) $(INDEX_KEYWORDS private protected public package))
$(LI $(LINK2 /ders/d.cn/ufcs.html, Universal Function Call Syntax (UFCS)))
$(LI $(LINK2 /ders/d.cn/property.html, Properties) $(INDEX_KEYWORDS @property))
$(LI $(LINK2 /ders/d.cn/invariant.html, Contract Programming for Structs and Classes) $(INDEX_KEYWORDS invariant))
$(LI $(LINK2 /ders/d.cn/templates.html, Templates))
$(LI $(LINK2 /ders/d.cn/pragma.html, Pragmas))
$(LI $(LINK2 /ders/d.cn/alias.html, alias and with) $(INDEX_KEYWORDS alias with))
$(LI $(LINK2 /ders/d.cn/alias_this.html, alias this) $(INDEX_KEYWORDS alias this))
$(LI $(LINK2 /ders/d.cn/pointers.html, Pointers) $(INDEX_KEYWORDS * &))
$(LI $(LINK2 /ders/d.cn/bit_operations.html, Bit Operations) $(INDEX_KEYWORDS ~ & | ^ >> >>> <<))
$(LI $(LINK2 /ders/d.cn/cond_comp.html, Conditional Compilation) $(INDEX_KEYWORDS debug, version, static if, static assert, __traits))
$(LI $(LINK2 /ders/d.cn/is_expr.html, is 表达式) $(INDEX_KEYWORDS is()))
$(LI $(LINK2 /ders/d.cn/lambda.html, Function Pointers, Delegates, and Lambdas) $(INDEX_KEYWORDS function delegate => toString))
$(LI $(LINK2 /ders/d.cn/foreach_opapply.html, foreach with Structs and Classes) $(INDEX_KEYWORDS opApply empty popFront front (and more)))
$(LI $(LINK2 /ders/d.cn/nested.html, Nested Functions, Structs, and Classes) $(INDEX_KEYWORDS static))
$(LI $(LINK2 /ders/d.cn/union.html, Unions) $(INDEX_KEYWORDS union))
$(LI $(LINK2 /ders/d.cn/goto.html, Labels and goto) $(INDEX_KEYWORDS goto))
$(LI $(LINK2 /ders/d.cn/tuples.html, 元组) $(INDEX_KEYWORDS tuple Tuple AliasSeq .tupleof foreach))
$(LI $(LINK2 /ders/d.cn/templates_more.html, More Templates) $(INDEX_KEYWORDS template opDollar opIndex opSlice))
$(LI $(LINK2 /ders/d.cn/functions_more.html, More Functions) $(INDEX_KEYWORDS inout pure nothrow @nogc @safe @trusted @system CTFE __ctfe))
$(LI $(LINK2 /ders/d.cn/mixin.html, Mixins) $(INDEX_KEYWORDS mixin))
$(LI $(LINK2 /ders/d.cn/ranges.html, Ranges) $(INDEX_KEYWORDS InputRange ForwardRange BidirectionalRange RandomAccessRange OutputRange))
$(LI $(LINK2 /ders/d.cn/ranges_more.html, More Ranges) $(INDEX_KEYWORDS isInputRange ElementType hasLength inputRangeObject (and more)))
$(LI $(LINK2 /ders/d.cn/parallelism.html, 并行) $(INDEX_KEYWORDS parallel task asyncBuf map amap reduce))
$(LI $(LINK2 /ders/d.cn/concurrency.html, Message Passing Concurrency) $(INDEX_KEYWORDS spawn thisTid ownerTid send receive (and more)))
$(LI $(LINK2 /ders/d.cn/concurrency_shared.html, Data Sharing Concurrency) $(INDEX_KEYWORDS synchronized, shared, shared static this, shared static ~this))
$(LI $(LINK2 /ders/d.cn/fibers.html, Fibers) $(INDEX_KEYWORDS call yield))
$(LI $(LINK2 /ders/d.cn/memory.html, Memory Management) $(INDEX_KEYWORDS calloc realloc emplace destroy .alignof))
$(LI $(LINK2 /ders/d.cn/uda.html, User Defined Attributes (UDA)) $(INDEX_KEYWORDS @))
$(LI $(LINK2 /ders/d.cn/operator_precedence.html, Operator Precedence))
)

Macros:
        SUBTITLE=Programming in D

        DESCRIPTION=D programming language tutorial from the ground up.

        KEYWORDS=d programming language tutorial book novice beginner

        BREADCRUMBS=$(BREADCRUMBS_INDEX)

SOZLER=

MINI_SOZLUK=
