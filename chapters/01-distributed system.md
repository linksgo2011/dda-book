# 微服务是怎么被划分出来的？

我："你觉得我们这个架构用微服务怎么样？"

同事："你的问题是什么？"

我："没有问题，我就是感觉可以用微服务来做这个项目比较好，看了一些资料，微服务有 XXX 特点，感觉挺好的。"

同事："所以，你设计这样一个架构，解决的问题是什么呢？"

我陷入沉思。

早期的时候，每一次和架构师同事讨论问题，当我想要说出我的技术方案时，他总是用这个问题反问我。一开始我被弄得莫名其妙，后来慢慢习惯这种对话方式。其实这是一种问题驱动的思维方式，并且对架构师来说，至关重要。

微服务架构几乎成为互联网公司架构的标准形态，我们在讨论如何划分、设计微服务架构，甚至领域驱动设计（DDD）时，我们应该回归初心，当我们开始讨论怎么划分微服务时，我们应该能回答下面的问题：

* 需要解决的问题是什么？
* 什么是微服务，和 SOA（面向服务的架构） 的区别是什么？
* 为什么是微服务而不是其他架构方式（例如：SOA）？
* 带来的好处是什么？
* 微服务带来的成本有多大？
* 对系统造成的影响是什么？

## 需要解决的问题是什么？

一个几个人的小团队提供的服务一般不会太过于复杂，另外应用也不会特别大，这个时候一个单体应用对团队是非常友好的。不用考虑集成、部署等分布式系统的各种麻烦。实际上，大部分应用程序，还达不到使用微服务这样复杂架构的必要条件。

当团队开始变大，或者应用变得越来越复杂时，会产生几个痛点：

* 应用性能瓶颈，扩容困难
* 故障和系统弹性无法隔离
* 应用复杂到无法理解，模块耦合高，应用职责过多
* 过多的人工作到同一个代码库中
* 应用大到编译、部署时间长

其中，促使开发者从单体应用走向分布式系统最大的动机就是应用性能瓶颈，扩容困难的问题。实际上，当下的工程师们都是在开发广义的 "分布式系统"，因为真正的单体应用系统只存在于大型机、小型机时代了。客户端-服务器模式是一个最基本的分布式系统，无论是 C/S 模式还是 B/S 模式。

"客户端-服务器模式" 把需要单体主机需要全部完成的工作分离到了客户端实现了一次扩容，这个过程对软件行业进行了一次革命。但是随着需求量日益扩张，单纯的"客户端-服务器模式"已经不能满足需求。高性能、大容量的需求往往来自于面向 C（customer） 端的系统，这也解释了为什么分布式系统由面向消费者的公司驱动。Google 和 Salesforce 有海量的在线用户，他们比微软、Oracle 更为热衷分布系统的研发。

当单纯的 "客户端-服务器模式" 不能满足需求时，人们开始寻找新的拓展方式。其中一个方向是将 B/S 模式下的服务器工作下放到浏览器，这就是 SPA（Single Page Application） 富客户端，让前端单页应用承载用户交互和界面相关的工作，让服务器专注于处理业务逻辑和运算。另外一个方向是服务器角色分化：状态和运算分离。将数据库和应用分开部署，将应用中的 Session 入库，让应用无状态化，然后大规模部署应用服务器；剥离和业务无关的组件，例如邮件、文件、推送，演化出独立的服务，分布式文件系统应运而生。然而痛点在于，前面是根据技术进行水平切分，那么如何根据业务模块进行拆分，继续拓展呢？

其次的痛点是故障和系统弹性无法隔离。故障隔离的意思是某部分相对独立的业务中断，不应该影响整个系统。例如一个电商系统，因为某些原因造成无法支付，但是不应该影响用户浏览商品的业务。系统弹性是指应用扩容的需求，单体系统无法做到针对某一部分业务单独扩容，例如秒杀的场景，我们无法针对下单或者结算进行单独扩容。下单造成大流量的访问会导致整个系统不可用。

上面这两个痛点，是从最终用户体验的角度出发，这是真正推动技术进步的原因，也是技术变革产生业务价值的地方。另外三点都是从开发和运维的角度出发，这部分痛点来自开发者，但有可以通过各种方式在单体的应用下改善或克服。

当应用变得非常复杂时，程序变成了一个大泥球（A Big Ball of Mud）。模块之间的依赖关系变得极其复杂，程序开始变得混乱不堪，不过需要提前澄清的是单体或者分布式架构对这个问题无能为力。分布式架构的引入，会让大泥球的代码变成分布式大泥球，进一步增加系统熵 \(Entropy，一种物理学概念，系统的混乱程度\)。如何避免大泥球呢？后面会谈到可以通过良好的面向对象设计和重构完成。

其次，大的单体还会有编译时间长、部署时间长的问题。如果一个上百人的团队工作在一个代码库中，每天的工作除了在修复冲突之外，就是在等待编译。但这些都不是不可以克服的，Linux 内核就是一个超级单体系统，极长的编译时间和极多的参与人数，但 Linux 项目也能良好的运行。

所以这部分比较啰嗦，毛泽东思想告诉我们，分析问题的时候需要分清主要矛盾和次要矛盾。那么我们在分析系统问题的时候，不仅应该见微知著，也应该抓住关键。

所以问题的关键是系统的 "耦合"，"耦合" 的存在让我们难以拓展、故障隔离、开发困难、无法分开编译。

## 什么是微服务？

根据维基百科的定义，微服务是一种 SOA 的变体，特征是服务之间通过松耦合的方式集成。一般采用轻量级的传输协议（HTTP），以及不要求服务内采用同样的技术栈实现，通过暴露统一的 WEB API 实现相互通信。

业界对微服务的共识是：

* 服务根据业务能力划分，能提供一定范围内完整的业务价值
* 服务可以单独部署、运维
* 服务可以基于不同的编程语言、数据库等技术实现
* 服务之间使用轻量级的网络协议通讯，例如 HTTP 
* 服务有自己的独立的生命周期
* 服务之间松耦合

"服务根据业务能力划分"和"松耦合"需要特别注意，这是微服务和 SOA 最大的区别。

在解决扩容这个问题上，让我们看下 SOA 和微服务的区别。在解决拓展性的问题，有一个非常好的模型，叫做 "AKF扩展立方"。AKF可扩展立方 （Scalability Cube），来自于《可扩展的艺术》一书。

这个立方体中沿着三个坐标轴设置分别为：X、Y、Z。

![AKF&#x62D3;&#x5C55;&#x7ACB;&#x65B9;](./01-distributed system/akf.png)

* X 轴扩展 —— 无差别的水平的数据和服务复制，具体的实践可以对应为加机器
* Y 轴扩展 —— 根据应用中职责的划分，具体的实践为对各个业务线剥离
* Z 轴扩展 —— 利用特殊属性划分数据集合，例如基于租户模型对用户进行切割

Z 轴拓展实际上非常常见，例如电信运营商基于地域对用户进行划分，北京和上海的用户使用不同的号码段进行管理。微服务出现之前，我们对系统的拓展更多的关注于 X 拓展，负载均衡、读写分离都是为了解决如何进行服务复制来承载更多的请求。SOA 应用进行了一部分的 Y 轴拓展，但是 SOA 和微服务的本质不同在于，SOA 拆分的不是独立的服务，而是组件，SOA 组件必须注册到企业总线或者其他机制中才能对外提供整体的服务。

一个典型的区别在于，SOA 往往将业务逻辑拆分成不同的 SOA 服务，但是数据依然是集中的。业界对微服务的共识在于数据应该被划分到各个微服务中，每个微服务可以独立演进、独立发布甚至独立运营，提供完整的服务能力，并通过松耦合的方式集成。这也是企业实现中台的基本能力。

一个典型的 SOA 架构像这样，又不同的服务，但是服务是作为系统的一部分组件存在的，在 Java EE 的生态下作为一个部署到容器中的 war 包存在的。 这些服务共用基础设施，尤其是数据库。

![&#x4E00;&#x4EFD;&#x7B80;&#x5355;&#x7684; SOA &#x67B6;&#x6784;&#x56FE;](./01-distributed system/SOA.png)

而对比之下，微服务架构下，每个服务有自己的数据库，并且自己单独部署，提供 RESTful API 供其他服务。应用后者其他服务调用微服务时和调用第三方系统并没有两样。

![&#x4E00;&#x4EFD;&#x7B80;&#x5355;&#x7684;&#x5FAE;&#x670D;&#x52A1;&#x67B6;&#x6784;&#x56FE;](./01-distributed system/micro-service.png)

参考下面的韦恩图，让我们对微服务架构的理解更进一步。

![&#x5206;&#x5E03;&#x5F0F;&#x67B6;&#x6784;&#x3001;SOA&#x67B6;&#x6784;&#x3001;&#x5FAE;&#x670D;&#x52A1;&#x67B6;&#x6784;&#x7684;&#x5173;&#x7CFB;](./01-distributed system/microservcie-veen.png)

## 为什么我们需要微服务?

水平划分就够了，完全不需要垂直划分，那就不需要微服务。

前面我们谈到，主流微服务形态是各个微服务彼此独立，内部的实现不可见，能独立的提供服务。回到我们的需要解决的问题上，微服务的基础是建立在 AKF 的 Y 轴拓展上的。

![&#x5FAE;&#x670D;&#x52A1;&#x5728; AKF &#x62D3;&#x5C55;&#x7ACB;&#x65B9;&#x4E2D;&#x7684;&#x4F5C;&#x7528;](./01-distributed system/akf-example.png)

SOA 已经解决了微服务架构同样会遇到的 X 轴拓展和 Z 轴拓展，这些技术已经非常成熟：负载均衡、分库分表等。使用微服务其中一个原因就是 Y 轴拓展。实现 Y 轴的基础是服务解耦，并且随着解耦，给我们带了其他好处。

**应用复杂性的隔离**。分解巨大单体应用为多个微服务，降低了单体应用的复杂性问题。每个应用只需要关注自己的 API 内提供的能力即可，这样每个微服务比单体应用开发难度大大降低。在应用的复杂性上来讲，一加一大于二，所以架构师的工作需要把两个一隔离开，让大多数开发者在低复杂度的状态下开发。

**步速不一致的弹性**。云原生时代，一切都在云上。云，带来革命的优势就是弹性和伸缩，当我们用户量陡然提升的时候，可以快速地创建资源，用户数量减少也可以快速地销毁资源。但是如果我们是一个大的单体应用，每个模块的变化速率是不同的，换句话说就是弹性边界不同。通过服务化的拆分，能良好的实现弹性优化。

**更容易实现敏捷开发**。敏捷开发的理念是快速响应变化，要求频繁部署上线。因此快速编译、快速部署上线，减少服务中断时间，就成了敏捷开发的必要条件。服务化后的每个团队，把原来单体时代负责的模块当做一个独立的服务开发，内部的技术选型、具体实现灵活性更高。

当然，这些好处是对于足够庞大的单体系统良好服务化后而言的。如果你本身工作在一个非常小的团队，应用规模并不大，则很难体会到服务化的优点。（无论是SOA 还是微服务）。同时，如果一个耦合的单体应用，在不经过耦合的过程，被不合理的拆分成微服务，一样非常痛苦。另外，如果微服务被划分的非常小，以致于一个团队修改每一个功能都需要跨微服务操作，也是非常痛苦的。

最后，新技术往往即使令人激动人心也需要付出代价，微服务亦然，下面我们看下在实现微服务的过程中会有那些挑战。

## 微服务的成本和新问题

毋庸置疑，微服务是有成本的。在资源和基础设施有限的创业公司中，这种成本体验的尤为明显。微服务的成本来来自于架构、技术落地和协作等多个方面。

**架构成本**

如果需要将单体系统改造成微服务系统的第一步是解耦，只有当应用本身的耦合降低之后才能进行服务化改造，否则系统从"大泥球"的单体应用编程了分布式"大泥球"。

当服务化后，业务逻辑被分散到多个服务和代码仓库，不仅需要专业的架构师进行架构，也需要专人对架构进行守护和重构。然而，现实中架构并不是一成不变的，分布式架构对架构师的挑战大得多。

虽然服务化后，单个服务可以快速的响应业务需求的变化，但是就系统整体的架构来说，架构的重构是很艰难的。因此强大的架构能力，就成了微服务架构的必要条件。

**基础设施的挑战**

1996年，Gartner 就提出 SOA 的思想，前面我们讲到，微服务也可以算作 SOA 的一种形态。

> 对于复杂的企业IT系统，应按照不同的、可重用的力度划分，将功能相关的一组功能提供者组织在一起为消费者提供服务

为什么 SOA 并没有在业界流传开呢？因为，SOA 对一个企业的基础设施提出了巨大挑战，往往只有少数顶级的公司能做到，或者有必要实施 SOA 架构。随着云、开发运维一体化的兴起，服务化的成本开始降低，一些中型的公司也可以有能力进行服务化变革了。

国标草案 《通用微服务平台》讲微服务实施分为，给出了一个技术设施层能力的要求，部分如下：

* 自动部署
* 资源动态分配
* 认证鉴权
* 服务发现
* 服务注册
* 负载均衡 
* 服务契约
* 健康检查 
* 链路跟踪
* 分布式事务

**人员组织成本**

## 微服务的准入清单

在几年的实践中，被强行采用微服务的项目坑过的不少，有过同样体验的朋友不在少数。当服务内的业务逻辑非常单薄时，开发过程中的大部分工作都在处理服务间调用，尤其是服务内聚不够时，让这种情况雪上加霜。

下面是一份微服务的准入清单，帮助我们在技术选型时候，要不要使用微服务：

## 微服务划分方法论

微服务已经有非常多成熟的实践，大量开源的微服务框架可以供我们选择，Spring Cloud、Dubbo等框架让我们对微服务的实践难度和成本大大降低。有大量的技术书籍在讨论微服务、分布式架构等技术的具体实现方式，一个公司想要实践微服务已经非常容易了。

我在参与和实践了大量微服务项目过后，让我困惑的往往不是某一个具体技术的选型，服务发现、调用链追踪都有成熟的开源组件帮助我们完成。而让我苦思冥想的另一个问题是：如何把一个单体应用拆分出更合理、更有弹性的微服务架构？

当我查阅企业架构相关的书籍时，了解到IT系统架构不仅需要应对技术架构的挑战之外，还需要应对业务架构方面的挑战。如何从业务的角度出发设计出更加贴切企业战略和业务需求的架构，在适合业务发展和避免过度设计之间取得一个平衡？

在过去大量的实践中，我们的架构师关注在软件的基础设施上，云、数据库分库、数据库分表、集群、负载均衡、认证和授权等这些技术实践上。对于设计一个系统而言，做的第一件事就是关注数据库表、字段、关联。

我们往往忽略了一个非常重要的环节，就是领域建模或者叫做业务架构，这个环节被隐藏到架构师或者技术 Leader 的经验决策中了。在单体应用时期这个问题不是很明显，订单和商品需要设计多少个表、有什么字段、表之间的关联怎么样，富有经验的开发者都能做出合适的决策。

然而在微服务的时代，我们遇到的问题就变成了，订单和产品是否应该划分到两个微服务中，每个服务的职责和边界在哪里，服务之间的API怎么设计，服务之间的依赖关系是什么样子。这部分的架构设计看起来好像和我们做技术选型时考虑的角度不太一样，不再关注技术细节，而是关注于业务细节。相对于处理一些非功能需求，这部分工作对抽象能力、业务分析能力、面向对象能力有了更高的要求。

软件设计是一个复杂的系统问题。于是我们在架构设计中，有两类问题需要解决：同非功能需求相关的技术复杂度，以及和功能需求相关的业务复杂度。

非功能需求是指那些跨功能的通用需求，例如安全、性能、并发等，围绕着这些问题我们发展出了各种解决方案，例如OAuth、缓存技术、负载均衡等，但是这些复杂问题其实和业务是没有关系的。我们把解决这类复杂问题的架构思维叫做技术架构。

功能需求是指用户能操作的使用的需求，例如登录、下单、申请退款，这些复杂问题实际上和采用的技术关系并不大，从编程语言、框架、数据库上来说， 都能完成这些业务要求。无论是 Java、.Net、PHP 以及是否采用微服务，都不妨碍我们完成业务功能。

业务复杂度也是软件开发过程中非常重要的一部分， **我们暂且把解决这类问题的思维方式叫做业务架构**

技术架构大量依赖于实践和经验，在行业内具有相当的通用性，可以采用大量的开源方案。而业务架构解决的问题是如何分析业务逻辑，正确的对业务进行抽象，然后得到合理的软件架构。业务架构非常强的依赖于面向对象的思想和高度的抽象思维，是一线应用开发者主要思考的问题，同公司的产品相关，通用性非常弱。

| - | 技术架构 | 业务架构 |
| :--- | :--- | :--- |
| 实践 | 负载均衡、高可用 | 服务划分、应用解耦 |
| 对开发者的要求 | 主流解决方案的经验 | 抽象、逻辑分析能力 |
| 解决的问题 | 技术复杂度 | 业务复杂度 |

当然，这两种架构思维并不能彻底分开。讨论这两种架构的不同可以帮助我们换种思路去看待架构问题。

业务架构不应该限制于技术细节，在做业务架构的时候应该和我们的业务专家讨论，分析业务在逻辑上的可行性或者矛盾。技术架构则不应该和业务过多的捆绑，架构师讨论这些问题的时候，应该听取某个技术领域中的专家意见，例如更换一种缓存策略是否能大幅度提高性能问题。

另外一个方面，技术架构应该是服务于业务架构，而非凌驾于业务架构之上。尽可能的将最优的技术资源花在核心业务逻辑上，优秀的武器应该首先能打中靶子。

## 用 DDD 来设计微服务

被合理划分成多个微服务的分布式系统，在逻辑上和解耦良好的单体系统是一致的。大家可能都有这样的体会，因为单体应用某些模块已经被良好的解耦了，在划分成多个服务时显得非常自然。例如一个企业应用中，配置管理往往相对独立，一般作为单独的模块设计。在划分微服务的时候很容易划分处理，但是订单、商品、支付等部分往往依赖关系错综复杂，调用关系千丝万缕，做微服务划分时显得艰难。

所以，良好的微服务设计，很重要的一部分就是如何对业务的建模和分析，在逻辑上有一个清晰的关系。
