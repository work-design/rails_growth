# RailsGrowth

`rails_growth` 是一个用于 运营增长的系统，具有如下特性：

* 除了服务端无法获知的客户端行为，如分享，不需要埋点，只需要监听相关请求即可；
* 支持客户端埋点；
* 可以基于某个 目标，定义任务或者金币奖励；
* 可以对相应请求进行统计记录，用于数据分析；

## Usage
* 赏金的单位是金币；

## 依赖
* [rails_wallet]() 金币兑换到虚拟币功能；

## 注意
由于在`rails_growth`中覆写了`rails_wallet`中 `Coin` 的方法，所以在gemfile中，将`rails_growth`放在更后面的位置，这样在常量查找时，`rails_growth`拥有更高的优先级；

```ruby
gem 'rails_wallet'
gem 'rails_growth' # 放在 `rails_wallet` 后面
```
