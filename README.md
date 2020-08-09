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
## 解析原理
1. config\_parser遍历配置文件job.conf的每一行，先查找第一层参数domain，查到则find\_domain=true  
2. 如果domain行匹配不成功或者是'#'号注释行、空行则跳过  
3. 最后解析key、value行，使用awk分割得到key、value  
4. 为了使配置文件清晰，允许'='号前后有空格，并使用trim函数去除字符串两端的空格  
```
function config_parser()
{
    domain=$1
    needed_key=$2
    find_domain='false'
    cat job.conf | while read line
    do
        if [[ $line == \[$domain\]* ]]
        then
            find_domain='true'
        fi
        if [[ $line == \[* || $line == \#*  || $line == '' ]]
        then
            continue
        fi

        key=`echo $line | awk 'sub("=", "==")' | awk -F== '{print $1}'`
        val=`echo $line | awk 'sub("=", "==")' | awk -F== '{print $2}'`
        key=$(trim "$key")
        val=$(trim "$val")
        if [[ $find_domain == true && $needed_key == $key ]]
        then 
            echo $val
            break
        fi
    done
}

function trim()
{
    trimmed=$1
    trimmed=${trimmed%% }
    trimmed=${trimmed## }
    echo $trimmed
}
```
为什么在使用awk分割时，把第一个'='替换成'=='呢？因为有些配置value中是包含'='的，如环境变量
```
set_encoding = export PYTHONIOENCODING=GB18030 && export LANG=zh_CN.gb2312:en_US.UTF-8:zh_CN.UTF-8:en_US
```
## 运行
```
sh run.sh
```
```
input_path: input/xxx.txt
output_path: output/xxx.txt
```
