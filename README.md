# Programming in D
The Chinese Translation Project of "Programming in D".

这里是《Programming in D》的中文翻译项目。

## Why "Programming in D"? 为什么选择此书？
Instead of falling for getting things done quickly, "Programming in D" focuses on getting things done properly, to the lasting benefit of its reader. -Andrei Alexandrescu

本书注重于如何恰到好处地使用D语言将任务处理得当，而非试图快速地完成一切却有失于代码质量，这使得它的读者能够长久受益。 ——大A

## How to join us 怎样加入我们
### Tencent QQ
 - 爱好群: 531010036
 - 译者群: 54520002

##License 版权许可 [![LICENSE][license-badge]][license-url]

[license-badge]: http://ddili.org/image/cc_88x31.png
[license-url]: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
保持与原版相同，本书使用 `CC BY-NC-SA 3.0` 许可，转载请注明地址。

## TODO 现行计划
- Get everthing ready for translation 准备待翻译文件及编译文件
- Assign translation tasks to individuals 分派翻译任务到个人
- Seeking for more contributors 寻求更多有兴趣及时间的人参与到项目中来

## Translation 翻译
### Precautions 注意事项
- 译者必须严格遵循 [中文文案排版指北](https://github.com/sparanoid/chinese-copywriting-guidelines) 中所述的排版规范。
- 所有翻译相关 `commit` 消息必须精确后缀文件名：` ~ 相应文件名` ，多个文件务必多次 `commit` 以便于浏览

### Steps 步骤
 1. 在 `Orphans 待领取` 中选择自己心水的章节并发布Issue以领取，格式：`领取人-章节英文名`
 2. `Fork`，需翻译的文件（`*.d`，`*.cozum.d`）在 `ddili/src/ders/d.cn/` 下
 3. 进行翻译，可 `commit` 多次，消息格式：`Update 中文修改原因`
 4. 翻译完成，消息格式：`Final commit`，发起 `Pull request` 以通知审核人员进行审核
 5. 审核完成，在 `ddili/src/ders/d.cn/index.d` 中做相应修改以匹配章节名称，消息格式：`Done`
 6. `Merge`

## Progress 进度
### Translated 已完成翻译
- [编译 Compilation](ddili/src/ders/d.cn/compiler.d) By Lucifer & meatatt

### Outdated 旧项目待更新
- [The Hello World Program](ddili/src/ders/d.cn/hello_world.d) By Lucifer
- [writeln and write](ddili/src/ders/d.cn/writeln.d) By Lucifer
- [Fundamental Types](ddili/src/ders/d.cn/types.d) By Lucifer
- [Assignment and Order of Evaluation](ddili/src/ders/d.cn/assignment.d) By Lucifer
- [Variables](ddili/src/ders/d.cn/variables.d) By Lucifer
- [Standard Input and Output Streams](ddili/src/ders/d.cn/io.d) By Lucifer
- [Classes](ddili/src/ders/d.cn/class.d) By 大处着手小处着眼
- [Associative Arrays](ddili/src/ders/d.cn/aa.d) By 大处着手小处着眼
- [Strings](ddili/src/ders/d.cn/strings.d) By 大处着手小处着眼
- [scope](ddili/src/ders/d.cn/scope.d) By 大处着手小处着眼
- [auto and typeof](ddili/src/ders/d.cn/auto_and_typeof.d) By 小马哥[̲̅V̲̅I̲̅P̲̅]

### Adopted 已被领取
- [Lifetimes and Fundamental Operations](ddili/src/ders/d.cn/lifetimes.d) By 渡世白玉

### Orphans 待领取
- [Arrays](ddili/src/ders/d.cn/arrays.d)
- [Reading from the Standard Input](ddili/src/ders/d.cn/input.d)
- [Conditional Compilation](ddili/src/ders/d.cn/condcomp.d)
- [is Expression](ddili/src/ders/d.cn/isexpr.d)
- [Object](ddili/src/ders/d.cn/object.d)
- [Tuples](ddili/src/ders/d.cn/tuples.d)
- [Immutability](ddili/src/ders/d.cn/immutability.d)
- [Ranges](ddili/src/ders/d.cn/ranges.d)
- [Mixins](ddili/src/ders/d.cn/mixin.d)
- [Function Pointers, Delegates, and Lambdas](ddili/src/ders/d.cn/lambda.d)
- [Memory Management](ddili/src/ders/d.cn/memory.d)
- [Functions](ddili/src/ders/d.cn/functions.d)
- [Function Parameters](ddili/src/ders/d.cn/functionparameters.d)
- [Function Overloading](ddili/src/ders/d.cn/functionoverloading.d)
- [More Functions](ddili/src/ders/d.cn/functionsmore.d)
- [Acknowledgments](ddili/src/ders/d.cn/acknowledgments.d)
- [Introduction](ddili/src/ders/d.cn/intro.d)
- [Practice of Programming](ddili/src/ders/d.cn/programming.d)
- [Logical Expressions](ddili/src/ders/d.cn/logicalexpressions.d)
- [if Statement](ddili/src/ders/d.cn/if.d)
- [while Loop](ddili/src/ders/d.cn/while.d)
- [Integers and Arithmetic Operations](ddili/src/ders/d.cn/arithmetic.d)
- [Floating Point Types](ddili/src/ders/d.cn/floatingpoint.d)
- [Characters](ddili/src/ders/d.cn/characters.d)
- [Slices and Other Array Features](ddili/src/ders/d.cn/slices.d)
- [Redirecting Standard Input and Output Streams](ddili/src/ders/d.cn/streamredirect.d)
- [Files](ddili/src/ders/d.cn/files.d)
- [Name Space](ddili/src/ders/d.cn/namespace.d)
- [for Loop](ddili/src/ders/d.cn/for.d)
- [Ternary Operator ?:](ddili/src/ders/d.cn/ternary.d)
- [Literals](ddili/src/ders/d.cn/literals.d)
- [Formatted Output](ddili/src/ders/d.cn/formattedoutput.d)
- [Formatted Input](ddili/src/ders/d.cn/formattedinput.d)
- [do-while Loop](ddili/src/ders/d.cn/dowhile.d)
- [foreach Loop](ddili/src/ders/d.cn/foreach.d)
- [switch and case](ddili/src/ders/d.cn/switchcase.d)
- [enum](ddili/src/ders/d.cn/enum.d)
- [Lazy Operators](ddili/src/ders/d.cn/lazy.d)
- [Program Environment](ddili/src/ders/d.cn/main.d)
- [Exceptions](ddili/src/ders/d.cn/exceptions.d)
- [assert and enforce](ddili/src/ders/d.cn/assert.d)
- [Unit Testing](ddili/src/ders/d.cn/unittesting.d)
- [Contract Programming](ddili/src/ders/d.cn/contracts.d)
- [Lifetimes and Fundamental Operations](ddili/src/ders/d.cn/lifetimes.d)
- [Value Types and Reference Types](ddili/src/ders/d.cn/valuevsreference.d)
- [The null Value and the is Operator](ddili/src/ders/d.cn/nullis.d)
- [Type Conversions](ddili/src/ders/d.cn/cast.d)
- [Structs](ddili/src/ders/d.cn/struct.d)
- [Variable Number of Parameters](ddili/src/ders/d.cn/parameterflexibility.d)
- [Member Functions](ddili/src/ders/d.cn/memberfunctions.d)
- [const ref Parameters and const Member Functions](ddili/src/ders/d.cn/constmemberfunctions.d)
- [Constructor and Other Special Functions](ddili/src/ders/d.cn/specialfunctions.d)
- [Operator Overloading](ddili/src/ders/d.cn/operatoroverloading.d)
- [Inheritance](ddili/src/ders/d.cn/inheritance.d)
- [Interfaces](ddili/src/ders/d.cn/interface.d)
- [destroy and scoped](ddili/src/ders/d.cn/destroy.d)
- [Modules and Libraries](ddili/src/ders/d.cn/modules.d)
- [Encapsulation and Access Rights](ddili/src/ders/d.cn/encapsulation.d)
- [Universal Function Call Syntax (UFCS)](ddili/src/ders/d.cn/ufcs.d)
- [Properties](ddili/src/ders/d.cn/property.d)
- [Contract Programming for Structs and Classes](ddili/src/ders/d.cn/invariant.d)
- [Templates](ddili/src/ders/d.cn/templates.d)
- [alias](ddili/src/ders/d.cn/alias.d)
- [alias this](ddili/src/ders/d.cn/aliasthis.d)
- [Pointers](ddili/src/ders/d.cn/pointers.d)
- [Bit Operations](ddili/src/ders/d.cn/bitoperations.d)
- [foreach with Structs and Classes](ddili/src/ders/d.cn/foreachopapply.d)
- [Unions](ddili/src/ders/d.cn/union.d)
- [Labels and goto](ddili/src/ders/d.cn/goto.d)
- [More Templates](ddili/src/ders/d.cn/templatesmore.d)
- [More Ranges](ddili/src/ders/d.cn/rangesmore.d)
- [Parallelism](ddili/src/ders/d.cn/parallelism.d)
- [Message Passing Concurrency](ddili/src/ders/d.cn/concurrency.d)
- [Data Sharing Concurrency](ddili/src/ders/d.cn/concurrency_shared.d)
- [User Defined Attributes (UDA)](ddili/src/ders/d.cn/uda.d)
