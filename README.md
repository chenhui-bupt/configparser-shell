# configparser-shell
configparser shell版本可以帮助在执行shell任务时, 方便配置任务参数和版本控制, 特别是针对需要持续集成的任务情景下, 只需更改远端的job.conf即可轻松实现任务参数控制
## 参数形式
configparser可以实现两层参数的解析工作, 第一层是domain, 中括号'[]'标识, 第二层是key、value, 用等号'='分隔, 参数形式见job.conf
```
[JOB]
input_path = input/xxx.txt
output_path = output/xxx.txt
```
## 参数解析
函数: config\_parser, 参数: domain, key, 输出: value
```
input_path=$(config_parser 'JOB' 'input_path')
output_path=$(config_parser 'JOB' 'output_path')
```
## 运行
```
sh run.sh
```
```
input_path: input/xxx.txt
output_path: output/xxx.txt
```
