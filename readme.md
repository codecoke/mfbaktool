
# mfbaktool guide

基于fastcopy写的备份脚本
方便设置到windows计划任务里，执行成功或者失败都能写入日志。

目前v1版本仅支持fastcopy的job功能
后续版本准备增加多任务功能，以及配合bitlocker 加密备份功能

## 用法

推荐用法：

将v1下面的caller_job.bat复制到你备份的目标文件夹父目录下（即，和目标文件夹同级）

重命名你复制的caller_job.bat为 mbt_1---你的fastcopy任务名---你要检测的源文件夹路径

例如： mbt_1---job_name_1---C##test 1#bak source dir#.bai
意为： 检测 "C:\test 1\bak source dir\" 如果存在就执行fastcopy任务job_name_1

打开你重名命的文件，修改其中两处变量：

```bat

set "mbt_tool_dir=D:\some dir\\mfbaktool\v1\"
:: mfbaktool执行脚本的目录

set "mbt_log_custom=C:\some path\your bak dir\any your bakname.log.txt"
:: 存放你备份日志文件名，必需以.txt结尾

```
如果你的clller_job bat文件和job_1文件同目录，则不需要设置

执行caller_job bat就能看到效果


## about


first init

echo "# mfbaktool_dev" >> README.md

git init
git add README.md

git commit -m "first commit"

git branch -M main

git remote add origin https://github.com/codecoke/mfbaktool.git

git push -u origin main