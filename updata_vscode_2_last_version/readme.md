# 绿色版的vscode 半自动更新脚本

非安装版的vs code自动更新比较烦人，它就给你一个下载包
然后你要自己解压、复制旧版data
然后重命名
然后...

于是我写了一几个小脚本
放到你的vscode更目录
然后命令行运行

```bat

up-vscode-to-last-version.3.bat anything

@rem 在非测试环境下，为了数据安全，参数1是必需的，输入任何字符
```

## config_for_up_vscode.3.txt
是升级脚本的一些配置
```ini
;commond

; vs code folder name
dir_vscode_last_version=last_version

up_when_pc_start=up_when_pc_start

; zip file key
up_zip_search_name=VSCode-win32-x64*.zip
up_log_dir=log_vscode_uppdata_1
up_dir_unzip_pre=dir_unzip
up_dir_bak_pre=dir_bak

; 是否在测试环境，默认是生产环境 no
up_is_in_test_dir=no

;升级完是否删除压缩包
up_del_zip_after_sucess=no
;7-zip path
up_z7_exe=%ProgramFiles%\7-Zip\7z.exe

```

up-vscode-to-last-version.3.bat 
会把这个文件的key-val值读到脚本环境

##  clean_4_test.bat

为测试`up-vscode-to-last-version.3.bat`写的一个清理脚本
目标是删除测试中使用的临时文件
它和updata脚本共享`config_for_up_vscode.3.txt`里面的变量

请自行取用，有什么疑问请联系我
谢谢


