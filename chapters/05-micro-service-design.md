微服务系统设计
===

微服务划分的参考原则

- 可拆可不拆的，先不拆
- 参考限界上下文作为业务边界
- 参考弹性边界作为云环境下的伸缩边界
- 参考子域划分
- 参考领域模型的设计结果，以及依赖情况，和事务边界对齐
- 结合未来团队、架构组织方式
- 结合 devops 能力
- 和变化对其

## API 设计

API 本身的含义指应用程序接口，包括所依赖的库、平台、操作系统提供的能力都可以叫做 API。我们在讨论微服务场景下的 API 设计都是指 WEB API，一般的实现有 RESTful、RPC等。API 代表了一个微服务实例对外提供的能力，因此 API 的传输格式（XML、JSON）对我们在设计 API 时的影响并不大。

API 设计时微服务设计中非常重要的环节，代表服务之间交互的方式，会影响服务之间的集成。
通常来说，一个好的 API 设计需要满足两个主要的目的：

- 平台独立性。任何客户端都能消费 API，而不需要关注系统内部实现。API 应该使用标准的协议和消息格式和外部系统保持通行。传输协议和传输格式不应该侵入到业务逻辑中，也就是系统应该具备随时支持不同传输协议和消息格式的能力。

- 系统可靠性。在 API 已经被发布和非 API 版本改变的情况下，API 应该对契约负责，不应该导致数据格式发生破坏性的修改。在 API 需要重大更新时，使用版本升级的方式修改，并对旧版本预留下线时间窗口。

### API 设计的原则

实践中发现，API 设计是一件很难的事情，同时也很难衡量设计是否优秀。根据系统设计和消费者的角度，给出了一些简单的设计原则。

### 使用成熟度合适的 RESTful API

RESTful 风格的 API 具有一些天然的优势，例如通过 HTTP 协议降低了客户端的耦合，具有极好的开放性。因此越来越多的开发者使用 RESTful 这种风格设计 API，但是 RESTful 只能算是一个设计思想或理念，不是一个 API 规范，没有一些具体的约束条件。

因此在设计 RESTful 风格的 API 时候，需要参考 RESTful 成熟度模型。


| 成熟度等级             | 解释           | 示例           |
| -------------- | ------------------ | ------------------ |
| Level 0           | 定义一个根 URI，所有的操作通过 POST 请求完成   | `POST /?action=changeUserPassword` |
| Level 1 | 创建独立的资源地址，隔离 API 范围 | `POST /user?action=update` |
| Level 2     |   使用 HTTP 动词定义对资源的操作       | `GET /users/001`        |
| Level 3     | 使用 API 超媒体（HATEOAS，返回的 body 中索引相关的资源地址 ）        |    `{"links":["/users/","/products/"]}`     |

根据自己的应用场景选择对应的成熟度模型，一般来说系统成熟度模型在 Level 2 左右。

### 避免简单封装

API 应该服务业务能力的封装，避免简单封装让 API 彻底变成了数据库操作接口。例如标记订单状态为已支付，应该提供形如 `POST /orders/1/pay` 这样的API。而非 `PATCH /orders/1`，然后通过具体的字段更新订单。

因为订单支付是有具体的业务逻辑，可能涉及到大量复杂的操作，使用简单的更新操作将业务逻辑泄漏到系统之外。同时系统外也需要知道 `订单状态` 这个内部使用的字段。

更重要的是，破坏了业务逻辑的封装，同时也会影响其他非功能需求。例如，权限控制、日志记录、通知等。

### 关注点分离 

好的接口应该做到，不多东西，不少东西。怎么理解呢？在用户修改密码和修改个人资料的场景中，这两个操作看起来很类似，然后设计 API 的时候使用了一个通用的 `/users/1/udpate` URI。

然后定义了一个对象，这个对象可能直接使用了 `User` 这个类：

```json

{
  "username": "用户名",
  "password":"密码"
}

```
这个对象在修改用户名的时候， `password` 是不必要的，但是在修改密码的操作中，一个 `password` 字段却不够用了，可能还需要 `confirmPassword`。

于是这个接口变成：

```json

{
  "username": "用户名",
  "password":"密码",
  "confirmPassword":"重复密码"
}

```
这种类的复用会给后续维护的开发者带来困惑，同时对消费者也非常不友好。合理的设计应该是两个分离的 API：

```json

// POST /users/{userId}/password

{
  "password":"密码",
  "confirmPassword":"重复密码"
}

```

```json

// PATCH /users/{userId}

{
  "username":"用户名",
  "xxxx":"其他可更新的字段"
}

```
对应的实现，在 Java 中需要定义两个 DTO，分别处理不同的接口。这也体现了面向对象思想中的关注点分离。

### 完全穷尽,彼此独立

API 之间尽量遵守完全穷尽，彼此独立 (MECE) 原则，不应该提供相互叠加的 API。例如订单和订单项这两个资源，如果提供了形如 `PUT /orders/1/order-items/1` 这样的接口去修改订单项，接口 `PUT /orders/1` 就不应该具备处理某一个 `order-item` 的能力。

这样的好处是不会存在重复的 API，造成维护和理解上的复杂性。如何做到完全穷尽和彼此独立呢？

简单的方法是使用一个表格设计 API，标出每个 URI 具备的能力。

| URI             | 业务能力           | 
| -------------- | ------------------ |
|     /orders/1  | 对订单本身操作   | 
|     /orders/1/order-items  | 对订单项操作   | 

资源 URL 设计来源于 DDD 领域建模就非常简单了，聚合根作为根 URL，实体作为二级 URI 设计。聚合根之间应该彻底没有任何联系，实体和聚合根之间的责任应该明确。

产生这类问题的根源还是缺乏合理的抽象。如果存在 API 中可以通过用户组操作用户，通过用户的 URI 操作用户属于的用户组，这其中的问题是缺少了成员这一概念。用户组下面的本质上并不是用户，而是用户和用户组的关系，即成员。

### 版本化

一个对外开放的服务，极小的概率不发生改变。业务变化可能修改 API 参数或响应数据结构，以及资源之间的关系。一般来说，字段的增加不会影响旧的客户端运行。但是当存在一些破坏性修改时，就需要使用新的版本将数据导向到新的资源地址。

版本信息的传输，可以通过下面几种方式

- URI 前缀
- Header
- Query 

比较推荐的做法是使用 URI 前缀，例如 `/v1/users/` 表达获取 `v1` 版本下的用户列表。

常见的反模式是通过增加 URI 后缀来实现的，例如 `/users/1/updateV2`。这样做的缺陷是版本信息侵入到业务逻辑中，对路由的统一管理带来不便。

使用 Header 和 Query 发送版本信息则较为相似，不同之处在于，使用 URI 前缀在 MVC 框架中实现相对简单，只需要定义好路由即可。使用 Header 和 Query 还需要编写额外的拦截器。

### 合理命名

设计 API 时候的命名涉及多个地方：URI、请求参数、响应数据等。通常来说最主要，也是最难的一个是全局命名统一。

其次，命名需要注意这些：

- 尽可能和领域名词保持一致，例如聚合根、实体、事件等
- RESTful 设计的 URI 中使用名词复数
- 尽可能不要过度简写，例如将 `user` 简写成 `usr`
- 尽可能使用不需要编码的字符

用领域名词来对 API 设计命名不是一件特别难的事情。识别出的领域名词可以直接作为 URI 来使用。如果存在多个单词的连接可以使用中横线，例如 `/orders/1/order-items`

### 安全

安全是任何一项软件设计都必须要考虑的事情，对于 API 设计来说，暴露给内部系统的 API 和开放给外部系统的 API 略有不同。

内部系统，更多的是考虑是否足够健壮。对接收的数据有足够的验证，并给出错误信息，而不是什么信息都接收，然后内部业务逻辑应该边界值的影响变得莫名其妙。

而对于外部系统的 API 则有更多的挑战。

- 错误的调用方式
- 接口滥用
- 浏览器消费 API 时存在的安全漏洞非法访问

所以设计 API 时应该考虑响应的应对措施。针对错误的调用方式，API 不应该进入业务处理流程，及时给出错误信息；对于接口滥用的情况，需要做一些限速的方案；对于一些浏览器消费者的问题，可以在让 API 返回一些安全增强头部，例如：X-XSS-Protection、Content-Security-Policy等。

## API 设计评审清单

- URI 命名是否通过聚合根和实体统一
- URI 命名是否采用名词复数和连接线
- URI 命名是否都是单词小写
- URI 是否暴露了不必要的信息，例如 `/cgi-bin`
- URI 规则是否统一
- 资源提供的能力是否彼此独立
- URI 是否存在需要编码的字符
- 请求和返回的参数是否不多不少
- 资源的 ID 参数是否通过 PATH 参数传递
- 认证和授权信息是否暴露到 query 参数中
- 参数是否使用奇怪的缩写
- 参数和响应数据中的字段命名统一
- 是否存在无意义的对象包装 例如 `{"data":{}'}`
- 出错时是否破坏约定的数据结构
- 是否使用合适的状态码
- 是否使用合适的媒体类型
- 响应数据的单复是否和数据内容一致
- 响应头中是否有缓存信息
- 是否进行了版本管理
- 版本信息是否作为 URI 的前缀存在
- 是否提供 API 服务期限
- 是否提供了 API 返回所有 API 的索引
- 是否进行了认证和授权
- 是否采用 HTTPS
- 是否检查了非法参数
- 是否增加安全性的头部
- 是否有限流策略
- 是否支持 CORS
- 响应中的时间格式是否采用 `ISO 8601` 标准
- 是否存在越权访问




