# Programming in D
The Chinese Translation Project of [Programming in D](http://ddili.org/ders/d.en/index.html).

这里是 [《Programming in D》](http://ddili.org/ders/d.en/index.html) 的中文翻译项目。

## Why "Programming in D"? 为什么选择此书？
Instead of falling for getting things done quickly, "Programming in D" focuses on getting things done properly, to the lasting benefit of its reader. -Andrei Alexandrescu

本书注重于如何恰到好处地使用D语言将任务处理得当，而非试图快速地完成一切却有失于代码质量，这使得它的读者能够长久受益。 ——大A

## How to join us 怎样加入我们
### Tencent QQ
 - 爱好群: 531010036
 - 译者群: 54520002

##License 版权许可 [![CC BY-NC-SA 3.0][license-badge]][license-url]

[license-badge]: http://ddili.org/image/cc_88x31.png
[license-url]: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
保持与原版相同，本书使用 `CC BY-NC-SA 3.0` 许可，转载请注明地址。

## TODO 现行计划
- Seeking for more contributors 寻求更多有兴趣及时间的人参与到项目中来

## Translation 翻译
### Precautions 注意事项
- 译者必须严格遵循 [中文文案排版指北](https://github.com/sparanoid/chinese-copywriting-guidelines) 中所述的排版规范。
- 所有翻译相关 `commit` 消息必须精确后缀文件名：` ~ 相应文件名` ，多个文件务必多次 `commit` 以便于浏览
- 释义差异一概以张雪平、谭丽娜的译著《D程序设计语言》为准
- 易于混淆的概念（例如 `property` 与 `attribute`）不译，只需在章节中首次出现时注明字面释义即可，示例：`attribute（属性）`
- .d 文件中符号 `$(CH4，$(P，$(LI，$(CODE_NOATE，注释//　，/*　*/` 中包含的内容需翻译；符号 `$(IX` 中的内容只译非关键字部分
- 中文语句中，英文标点`,` `.` `:` 等等应改为中文标点符号`，` `。` `：`
- 链接中 'd.en' 都需改为 'd.cn'
- 为保证翻译风格一致约定了部分单词的中文翻译，参见 wiki

### Steps 步骤
 1. 在 `Orphans 待领取` 中选择自己心水的章节并发布Issue以领取，格式：`[领取] 章节原名 By 领取人`
 2. `Fork`，需翻译的文件（`*.d`，`*.cozum.d`）在 `ddili/src/ders/d.cn/` 下
 3. 进行翻译，可 `commit` 多次，消息格式：`Update 中文修改原因`
 4. 翻译完成，发起 `Pull request` 以通知审核人员进行审核，格式：`[审核] 章节原名 By 领取人`
 5. 审核完成，在 `ddili/src/ders/d.cn/index.d` 中做相应修改以匹配章节名称，消息格式：`Translated`
 6. `Merge`，`Close Issue`，在 `README.md` 中更新进度

## Progress 进度
### Translated 已完成翻译
- [编译 Compilation](ddili/src/ders/d.cn/compiler.d) By Lucifer & meatatt
- [元组 Tuples](ddili/src/ders/d.cn/tuples.d) By meatatt
- [is 表达式 is Expression](ddili/src/ders/d.cn/is_expr.d) By meatatt
- [命名作用域 Name Scope](ddili/src/ders/d.cn/name_space.d) By LinGo
- [从标准输入中读取数据 Reading from the Standard Input](ddili/src/ders/d.cn/input.d) By Lucifer
- [前言 Preface（合并自：Acknowledgments，Introduction）](ddili/src/ders/d.cn/preface.d) By IceNature
- [文件 Files](ddili/src/ders/d.cn/files.d) By IceNature
- [if 语句 if Statement](ddili/src/ders/d.cn/if.d) By IceNature
- [auto 和 typeof auto and typeof](ddili/src/ders/d.cn/auto_and_typeof.d) By andot
- [Object](ddili/src/ders/d.cn/object.d) By 大处着手小处着眼
- [异常 Exceptions](ddili/src/ders/d.cn/exceptions.d) By xmdqvb
- [scope](ddili/src/ders/d.cn/scope.d) By 大处着手小处着眼
- [类 Classes](ddili/src/ders/d.cn/class.d) By 大处着手小处着眼
- [并行 Parallelism](ddili/src/ders/d.cn/parallelism.d) By IceNature
- [关联数组 Associative Arrays](ddili/src/ders/d.cn/aa.d) By 大处着手小处着眼

### Outdated 旧项目待更新
- [The Hello World Program](ddili/src/ders/d.cn/hello_world.d) By Lucifer
- [writeln and write](ddili/src/ders/d.cn/writeln.d) By Lucifer
- [Fundamental Types](ddili/src/ders/d.cn/types.d) By Lucifer
- [Assignment and Order of Evaluation](ddili/src/ders/d.cn/assignment.d) By Lucifer
- [Variables](ddili/src/ders/d.cn/variables.d) By Lucifer
- [Standard Input and Output Streams](ddili/src/ders/d.cn/io.d) By Lucifer
- [Strings](ddili/src/ders/d.cn/strings.d) By 大处着手小处着眼

### Adopted 已被领取
- [Lifetimes and Fundamental Operations](ddili/src/ders/d.cn/lifetimes.d) By 渡世白玉
- [Templates](ddili/src/ders/d.cn/templates.d) By meatatt
- [do-while Loop](ddili/src/ders/d.cn/do_while.d) By mogucpp
- [Ranges](ddili/src/ders/d.cn/ranges.d) By Lucifer
- [while Loop](ddili/src/ders/d.cn/while.d) By KimmyLeo
- [Message Passing Concurrency](ddili/src/ders/d.cn/concurrency.d) By IceNature

### Orphans 待领取
- [Foreword by Andrei Alexandrescu](ddili/src/ders/d.cn/foreword2.d)
- [Logical Expressions](ddili/src/ders/d.cn/logical_expressions.d)
- [Integers and Arithmetic Operations](ddili/src/ders/d.cn/arithmetic.d)
- [Floating Point Types](ddili/src/ders/d.cn/floating_point.d)
- [Arrays](ddili/src/ders/d.cn/arrays.d)
- [Characters](ddili/src/ders/d.cn/characters.d)
- [Slices and Other Array Features](ddili/src/ders/d.cn/slices.d)
- [Redirecting Standard Input and Output Streams](ddili/src/ders/d.cn/stream_redirect.d)
- [for Loop](ddili/src/ders/d.cn/for.d)
- [Ternary Operator ?:](ddili/src/ders/d.cn/ternary.d)
- [Literals](ddili/src/ders/d.cn/literals.d)
- [Formatted Output](ddili/src/ders/d.cn/formatted_output.d)
- [Formatted Input](ddili/src/ders/d.cn/formatted_input.d)
- [foreach Loop](ddili/src/ders/d.cn/foreach.d)
- [switch and case](ddili/src/ders/d.cn/switch_case.d)
- [enum](ddili/src/ders/d.cn/enum.d)
- [Functions](ddili/src/ders/d.cn/functions.d)
- [Immutability](ddili/src/ders/d.cn/const_and_immutable.d)
- [Value Types and Reference Types](ddili/src/ders/d.cn/value_vs_reference.d)
- [Function Parameters](ddili/src/ders/d.cn/function_parameters.d)
- [Lvalues and Rvalues](ddili/src/ders/d.cn/lvalue_rvalue.d)
- [Lazy Operators](ddili/src/ders/d.cn/lazy_operators.d)
- [Program Environment](ddili/src/ders/d.cn/main.d)
- [assert and enforce](ddili/src/ders/d.cn/assert.d)
- [Unit Testing](ddili/src/ders/d.cn/unit_testing.d)
- [Contract Programming](ddili/src/ders/d.cn/contracts.d)
- [The null Value and the is Operator](ddili/src/ders/d.cn/null_is.d)
- [Type Conversions](ddili/src/ders/d.cn/cast.d)
- [Structs](ddili/src/ders/d.cn/struct.d)
- [Variable Number of Parameters](ddili/src/ders/d.cn/parameter_flexibility.d)
- [Function Overloading](ddili/src/ders/d.cn/function_overloading.d)
- [Member Functions](ddili/src/ders/d.cn/member_functions.d)
- [const ref Parameters and const Member Functions](ddili/src/ders/d.cn/const_member_functions.d)
- [Constructor and Other Special Functions](ddili/src/ders/d.cn/special_functions.d)
- [Operator Overloading](ddili/src/ders/d.cn/operator_overloading.d)
- [Inheritance](ddili/src/ders/d.cn/inheritance.d)
- [Interfaces](ddili/src/ders/d.cn/interface.d)
- [destroy and scoped](ddili/src/ders/d.cn/destroy.d)
- [Modules and Libraries](ddili/src/ders/d.cn/modules.d)
- [Encapsulation and Protection Attributes](ddili/src/ders/d.cn/encapsulation.d)
- [Universal Function Call Syntax (UFCS)](ddili/src/ders/d.cn/ufcs.d)
- [Properties](ddili/src/ders/d.cn/property.d)
- [Contract Programming for Structs and Classes](ddili/src/ders/d.cn/invariant.d)
- [Pragmas](ddili/src/ders/d.cn/pragma.d)
- [alias and with](ddili/src/ders/d.cn/alias.d)
- [alias this](ddili/src/ders/d.cn/alias_this.d)
- [Pointers](ddili/src/ders/d.cn/pointers.d)
- [Bit Operations](ddili/src/ders/d.cn/bit_operations.d)
- [Conditional Compilation](ddili/src/ders/d.cn/cond_comp.d)
- [Function Pointers, Delegates, and Lambdas](ddili/src/ders/d.cn/lambda.d)
- [foreach with Structs and Classes](ddili/src/ders/d.cn/foreach_opapply.d)
- [Nested Functions, Structs, and Classes](ddili/src/ders/d.cn/nested.d)
- [Unions](ddili/src/ders/d.cn/union.d)
- [Labels and goto](ddili/src/ders/d.cn/goto.d)
- [More Templates](ddili/src/ders/d.cn/templates_more.d)
- [More Functions](ddili/src/ders/d.cn/functions_more.d)
- [Mixins](ddili/src/ders/d.cn/mixin.d)
- [More Ranges](ddili/src/ders/d.cn/ranges_more.d)
- [Data Sharing Concurrency](ddili/src/ders/d.cn/concurrency_shared.d)
- [Fibers](ddili/src/ders/d.cn/fibers.d)
- [Memory Management](ddili/src/ders/d.cn/memory.d)
- [User Defined Attributes (UDA)](ddili/src/ders/d.cn/uda.d)
- [Operator Precedence](ddili/src/ders/d.cn/operator_precedence.d)
