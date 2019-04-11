# Programming in D
The Chinese Translation Project of [Programming in D](http://ddili.org/ders/d.en/index.html).

这里是 [《Programming in D》](http://ddili.org/ders/d.en/index.html) 的中文翻译项目。

## Why "Programming in D"? 为什么选择此书？
Instead of falling for getting things done quickly, "Programming in D" focuses on getting things done properly, to the lasting benefit of its reader. -Andrei Alexandrescu

本书没有急于求成，而是将各方面都处理得恰到好处，让读者受益匪浅。 ——Andrei Alexandrescu

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
### Tools 工具
本书源码为 [Ddoc](https://dlang.org/spec/ddoc.html)，相关编辑工具：
- 计算机辅助翻译工具 [OmegaT](http://omegat.org/)，配置教程参见 [Programming in D - OmegaT: Wiki](https://github.com/DlangRen/Programming-in-D-OmegaT/wiki)
- 文本编辑器（vim、emacs、[vscode](https://github.com/dlang-vscode/dlang-vscode)……）

### Precautions 注意事项
- 译者必须严格遵循 [中文文案排版指北](https://github.com/sparanoid/chinese-copywriting-guidelines) 中所述的排版规范。
- 所有翻译相关 `commit` 消息必须精确后缀文件名：` ~ 相应文件名`，应使用钩子来确保正确的提交信息格式和提交文件个数（参见 `Wiki`）
- 释义差异一概以张雪平、谭丽娜的译著《D程序设计语言》为准
- 易于混淆的概念（例如 `property` 与 `attribute`）不译，只需在章节中首次出现时注明字面释义即可，示例：`attribute（属性）`
- .d 文件中符号 `$(CH4，$(P，$(LI，$(CODE_NOTE，注释//　，/*　*/` 中包含的内容需翻译；符号 `$(IX` 中的内容只译非关键字部分
- 中文语句中，英文标点`,` `.` `:` 等等应改为中文标点符号`，` `。` `：`
- 链接中 `d.en` 都需改为 `d.cn`
- 为保证翻译风格一致约定了部分单词的中文翻译，参见 `Wiki`

### Steps 流程
 1. 在 `Orphans 待领取` 中选择自己心水的章节，发布 `Issue` 以领取：`[领取] 章节原名 By 领取人`
 2. `Fork`，需翻译的文件（`*.d`，`*.cozum.d`）在 `ddili/src/ders/d.cn/` 下
 3. 进行翻译，参见上示注意事项、参考已译好的章节，`commit` 消息格式：`Update 中文修改原因`
 4. 翻译完成，发起 `Pull request` 以通知审核人员进行审核：`[审核] 章节原名 By 领取人`
 5. 审核相关修正亦将 `Pull request` 到个人分支上，请注意查看，有疑议请就地 `comment` 并 @审核人 做批注修改，审核  `Pull request` 应用快进合并，参见 `Wiki`
 6. 审核通过：`Merge` => 更新 [章节目录](ddili/src/ders/d.cn/index.d) => `Close Issue`=> 更新 [本文件](README.md)

## Progress 进度
### Translated 已完成翻译
- [数组 Arrays](target/arrays.d) By 大处着手小处着眼
- [编译 Compilation](target/compiler.d) By Lucifer & meatatt
- [元组 Tuples](target/tuples.d) By meatatt
- [is 表达式 is Expression](target/is_expr.d) By meatatt
- [命名作用域 Name Scope](target/name_space.d) By LinGo
- [从标准输入中读取数据 Reading from the Standard Input](target/input.d) By Lucifer
- [前言 Preface（合并自：Acknowledgments，Introduction）](target/preface.d) By IceNature
- [文件 Files](target/files.d) By IceNature
- [if 语句 if Statement](target/if.d) By IceNature
- [auto 和 typeof auto and typeof](target/auto_and_typeof.d) By andot
- [Object](target/object.d) By 大处着手小处着眼
- [异常 Exceptions](target/exceptions.d) By xmdqvb
- [scope](target/scope.d) By 大处着手小处着眼
- [类 Classes](target/class.d) By 大处着手小处着眼
- [并行 Parallelism](target/parallelism.d) By IceNature
- [关联数组 Associative Arrays](target/aa.d) By 大处着手小处着眼
- [do-while 循环 do-while Loop](target/do_while.d) By mogu
- [alias 与 with alias and with](target/alias.d) By mogu
- [alias this](target/alias_this.d) By mogu
- [并发消息传递 Message Passing Concurrency](target/concurrency.d) By IceNature
- [字符串 Strings](target/strings.d) By 大处着手小处着眼
- [惰性运算符 Lazy Operators](target/lazy_operators.d) By mogu
- [左值与右值 Lvalues and Rvalues](target/lvalue_rvalue.d) By mogu
- [三元运算符 ?: Ternary Operator ?:](target/ternary.d) By IceNature
- [模板 Templates](target/templates.d) By meatatt
- [通用函数调用语法 Universal Function Call Syntax (UFCS)](target/ufcs.d) By mogu
- [属性 Properties](target/property.d) By IceNature
- [const ref 参数 and const 成员函数 const ref Parameters and const Member Functions](target/const_member_functions.d) By IceNature
- [格式化输出 Formatted Output](target/formatted_output.d) By IceNature
- [Pragmas](target/pragma.d) By mogu
- [自定义属性 (UDA)](target/uda.d) by Heromyth

### Reviewing 审核中
- [Slices and Other Array Features](target/slices.d) By 大处着手小处着眼
- [More Templates](target/templates_more.d) By meatatt

### Review Delayed 审核搁置


### Outdated 旧项目待更新
- [The Hello World Program](target/hello_world.d) By Lucifer
- [writeln and write](target/writeln.d) By Lucifer
- [Fundamental Types](target/types.d) By Lucifer
- [Assignment and Order of Evaluation](target/assignment.d) By Lucifer
- [Variables](target/variables.d) By Lucifer
- [Standard Input and Output Streams](target/io.d) By Lucifer

### Adopted 已被领取
- [Lifetimes and Fundamental Operations](target/lifetimes.d) By 渡世白玉
- [Ranges](target/ranges.d) By Lucifer
- [while Loop](target/while.d) By KimmyLeo
- [Redirecting Standard Input and Output Streams](target/stream_redirect.d) By mogu
- [Function Pointers, Delegates, and Lambdas](target/lambda.d) By zhaopuming
- [Modules and Libraries](target/modules.d) By 大处着手小处着眼
- [Variable Number of Parameters](target/parameter_flexibility.d) By meatatt
- [Conditional Compilation](target/cond_comp.d) By IceNature
- [Immutability](target/const_and_immutable.d) By IceNature
- [Type Conversions](target/cast.d) By IceNature
- [Formatted Input](target/formatted_input.d) By IceNature

### Orphans 待领取
- [Foreword by Andrei Alexandrescu](target/foreword2.d)
- [Logical Expressions](target/logical_expressions.d)
- [Integers and Arithmetic Operations](target/arithmetic.d)
- [Floating Point Types](target/floating_point.d)
- [Characters](target/characters.d)
- [for Loop](target/for.d)
- [Literals](target/literals.d)
- [foreach Loop](target/foreach.d)
- [switch and case](target/switch_case.d)
- [enum](target/enum.d)
- [Functions](target/functions.d)
- [Value Types and Reference Types](target/value_vs_reference.d)
- [Function Parameters](target/function_parameters.d)
- [Program Environment](target/main.d)
- [assert and enforce](target/assert.d)
- [Unit Testing](target/unit_testing.d)
- [Contract Programming](target/contracts.d)
- [The null Value and the is Operator](target/null_is.d)
- [Structs](target/struct.d)
- [Function Overloading](target/function_overloading.d)
- [Member Functions](target/member_functions.d)
- [Constructor and Other Special Functions](target/special_functions.d)
- [Operator Overloading](target/operator_overloading.d)
- [Inheritance](target/inheritance.d)
- [Interfaces](target/interface.d)
- [destroy and scoped](target/destroy.d)
- [Encapsulation and Protection Attributes](target/encapsulation.d)
- [Contract Programming for Structs and Classes](target/invariant.d)
- [Pointers](target/pointers.d)
- [Bit Operations](target/bit_operations.d)
- [foreach with Structs and Classes](target/foreach_opapply.d)
- [Nested Functions, Structs, and Classes](target/nested.d)
- [Unions](target/union.d)
- [Labels and goto](target/goto.d)
- [More Functions](target/functions_more.d)
- [Mixins](target/mixin.d)
- [More Ranges](target/ranges_more.d)
- [Data Sharing Concurrency](target/concurrency_shared.d)
- [Fibers](target/fibers.d)
- [Memory Management](target/memory.d)
- [Operator Precedence](target/operator_precedence.d)
