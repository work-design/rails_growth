# RailsGrowth

`rails_growth` 是一个用于运营增长的系统，具有如下特性：

* 不需要埋点：除了服务端无法获知的客户端行为（如分享、跳转），只需要监听相关请求即可；
* 支持客户端埋点；
* 可以基于某个目标定义任务、奖励；
* 可以对相应请求进行统计记录，用于数据分析；

## 赏金类型
* 现金，可提现；
* 会员卡额度，可用于消费；
* 优惠券

## 原理

```
aim -> aim_user -> aim_entity -> aim_log
```

## 依赖
* [rails_vip](https://github.com/work-design/rails_vip) 发放奖励；
* [rails_trade](https://github.com/work-design/rails_trade) 发放优惠券；

## 注意

