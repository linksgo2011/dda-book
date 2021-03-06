# 《互联网应用系统设计方法》

子标题 《用DDD写好业务代码》



本书的写作思路：

从问题出发，每个章节都解决了什么问题。本书的大问题是如何做好一个互联网应用系统设计，然后拆分出各种小问题，这些小问题单独从具体的细节中解决。

通过问题采访获取材料，通过英文资料获取材料。每个章节的具体的方案需要有输出物，方案要有实例。

最好填充大量的案例，案例来源可以是翻译的外文材料、协议、标准文档。

不要谈架构，而是谈整体的应用设计方法，架构应该结合业务、需要解决的问题出发。单独的架构设计没有意义，每种业务场景之下架构也是不一样的。



写作的本质是发现问题、解决问题、整理问题。



前言

从失败的项目出发，和读者共鸣。

- 产品定位混乱

- 大量定制化需求侵入产品

- 架构设计不清晰

- 部署流程不规范

- 安全不规范

- 项目管理为0

- 软件小作坊

- 瀑布开发的一个极端

- 敏捷开发的一个极端

- 混乱的软件架构

- ”口口相传“的知识传递

- bug 丛生、加班无底洞

- 总以为能找到”牛逼的人“解决所有问题

- 以为有一项技术能把现在项目带出泥潭

- 相信业界对某一项技术过度吹捧

  

第一章 互联网应用系统和微服务基础

解决的问题是：互联网应用系统开发是个啥，为啥都闹着要用微服务。



互联网应用的本质和解决的问题是什么，我们做的产品到底是一个什么？



互联网的产品本质上是服务业，加速和解决现实中的问题。相对行业应用软件面向企业市场来说，互联网产品往往面向最终消费者市场。因此互联网产品有用户基数大、需求变化快的特点。



相对行业应用来说，贴近用户生活，体验要求高，但业务相对简单。给人一种互联网产品的产品设计、业务分析毫无门槛的错觉。从行业的经验来看，不同公司的产品经理和业务分析师水平差距比较大，专业的产品经理不会堆砌毫无意义的功能，对业务需求更加克制。



为什么需要微服务？

微服务或者说分布式系统，是业务规模增大，团队成员增多，用户容量压力下不得不选择的一种软件形态。

介绍分布式系统的基本概念和微服务设计的一些基本原理和误区。



第二章 DDD 基础

解决的问题是：DDD 到底是个啥，能拿来干什么。



介绍 DDD 作为业务系统设计的基本逻辑，DDD 解决业务复杂度的问题，其他特定技术解决某个技术问题。

DDD 是分析业务设计的一个好方法，但不是唯一的方法，最好也别把它拿去干别的。让 DDD 干它该干的事情。



- DDD 基本概念
- DDD 能指导方案设计
- DDD 编码实践



使用 DDD 分析和设计业务系统的一个前提是业务分析和设计已经清楚明白，否则就是空中楼阁，无源之水。



第三章 业务分析和设计

解决的问题是：怎么样把需求搞清楚。



PRD 文档最大的问题是不是一个”活文档“，但不能没有。业务逻辑传递过程是：老板的想法、BA 的PRD和线框图、已经实现的代码、测试用例。



因此解决的第二个问题应该是，软件的业务知识应该怎么被传递。答案是：QA 应该沉淀一套测试用例，UX 应该沉淀一套设计系统。

- 敏捷中 BA 的工作
  - 业务分析
  - 编写 Story
  - 原型（线框图）设计
- DesignThiking
- 调研 没有调查就没有发言权
  - 行业调研，一些行业分析工具、网站
  - 竞品分析
- 用户测试
- Design Systems
  - 统一交互逻辑
- 产品需求描述文档 PRD



第四章  协作式的方案设计

解决的问题是：把服务拆出来，完成战略设计。



- 几种建模

- 软件设计工作坊 

- 事件风暴 - DDD 工作坊

  

第五章 技术方案的宏观设计

解决的问题是：怎么做一个技术方案，拿什么和领导汇报？



技术方案设计的方法论，参考 Inception 报告，输出可以指导项目启动的输出件，例如输出 C4 模型、架构图、API 列表。

解决的问题是一个项目大方向的问题。但是宏观设计的现实是需要迭代演进，不能一开始就上微服务、分库分表。



技术方案设计的逻辑

- 问题分析
- 业务现状分析 
- 方案草稿
- 方案评审，代入场景论证
- 原型搭建，关键技术点验证 
- 实施计划，分阶段实施

技术方案出具

- 设计指标

  - 容量
  - 性能
  - 安全

- 架构设计

  - 服务划分
  - 系统逻辑图
  - 状态图

- 领域建模

  - UML 类图

- 数据库表设计

  - E-R 图

- API 设计

  - OpenAPI yaml 文件

- 技术选型清单

  - 语言
  - 工具
  - 框架
  - 云平台选择
  - 消息中间件
  - RPC

- 安全设计

  - XSS
  - CRSF

- devops 实施方法

  - 部署图

- 实施计划

  - 工时估算
  - 里程碑计划

- 风险分析

- 方案评审

  

第六章 技术方案的细节设计

解决的问题是：现在互联网开发中的一些典型细节都有些啥。



目前主流的互联网技术的选择和对比进行选型和细节设计，解决的是项目中遇到的一个具体问题采用的方案，该方案需要细化到时序图、数据库字段级别，需要明确具体的技术细节，能指导编写代码。

- ID 生成和优化
- 缓存策略
- 分页、排序
- 日志
- 并发争用设计
  - 分布式锁
- 最终一致性问题
  - 可靠消息模式
  - 幂等方案
  - 重试方案
- 应用升级设计
  - 应用升级
  - APP 升级
  - API 版本化
  - 数据迁移
  - Web 升级
- IAM
  - 多端授权
  - 多用户来源设计
- 国际化
- 线上数据修复、迁移
- 搜索引擎
- 风控系统
- 通知系统
- 活体监测
- 行为分析
- 文件存储
  - 图片空间和失联问题
- CDN
- 鉴黄和敏感词
- 发票税务
- 支付对账
- 离线应用分析
- 报表统计
- APM
  - 活跃用户统计
  - 调用链
  - 监控告警

第九章 借助工具

解决的问题是：如何减少样板代码，加速软件开发速度。



利用 domain-driven-design.org 上的工具进行代码生成

- API 生成
- 领域模型生成
- 数据库查询生成
- SDK 生成



第七章 系统扩容和演进

解决的问题是：三高场景下的各种问题和系统性能优化，该如何扩容。



- 性能测试
  - 性能测试环境搭建
  - 性能测试方
- 无状态扩容
  - 负载均衡
  - 网络带宽
- 存储扩容
  - 读写分离
  - 分库、分表、分片
  - redis 集群化
- 性能优化
  - 方案优化
    - 异步操作
    - 响应式编程
  - JVM 优化
  - 网络优化
  - 数据库优化
- 系统限流
  - API 限流
  - 熔断降级
- ”三高“ 相关经验
  - 对业务进行取舍和克制
  - 应对浪涌的方法



第七章 遗留系统改造

解决的问题是：怎么把老系统安全的改造成适合的架构。



- 遗留系统现状分析
- 测试先行
  - 测试金字塔
  - 单元测试
  - 契约测试
  - E2E 测试
  - API 测试
- 重构基础
  - code smell
  - IDEA 的重构工具
- 改造技巧
  - 通过 interface 隔离实现
  - 旧的系统兼容
  - 数据迁移



第八章 案例学习

- 某移动
- 某IOT
- 某船运
- 某会议系统



第九章 服务边界和SLA 

解决的问题是：清晰的知道提供什么服务，避免自定义的需求干扰产品。



避免产品经理无克制的增加产品的复杂性，以及加入无价值的需求，伤害系统架构。好的架构师应该审视需求，避免不合理的需求引入，尤其是个别用户的定制化需求。

差的的产品是贪婪，好的产品是克制，平衡系统稳定性和功能丰富性的平衡点。



- 服务边界，什么才算外部系统

- 弹性边界

- SLA  服务级别

- 需求池，提取出有价值的需求

  

第十章 团队设计

解决的问题是：人多的项目怎么办？

使用 DDD 拆分上下文后的组织架构问题，如何组织团队，以及各个团队如何沟通。解决分布式系统下的团队组织问题。

 超过 15 人的团队就无法被有效管理就需要有效拆分，但是拆分成多个团队之后，团队成员可以互相沟通，但是决策应该通过聚合根之间沟通。



立足这部分理论是分形企业模式。

- 几种组织架构方式

  - 树形
  - 扁平
  - 矩阵

- 分形组织

  

第十一章 项目管理

解决的问题是：如何管理项目。

项目管理过程中的各种问题，基于产品制的团队工作管理方式。软件开发行业经历了三次危机，然后制定出一系列软件工程实践，互联网公司打着敏捷的旗号又把这些软件工程实践推的一干二净。



- 代码管理和 git 分支策略
- Devops
- 代码质量扫描
- 开源软件管理
- 安全运维
  - 堡垒机
  - 拨测告警
- 风险管理

  - 威胁建模和容灾演练
  - 安全扫描
- 系统安全
  - 凭证管理
  - 密码策略
  - 渗透测试
- 敏捷实践
  - 站会
  - IPM 
  - codereview
  - retro 和 AAR
- 团队梯队建设和人员培训
- 培训工作的展开

附录1 DDD 术语清单



附录2 项目中操作规范和清单

- 版本管理规范

- 线上操作规范

- 网络安全规范

- API 设计规范

- 隐私和版权规范

- Java 编码规范

- 前端编码规范

- 测试用例编写规范

- UI&UX 设计规范

  





参考资料

- Design Thinking 
- DDD reference
- 信通院微服务标准