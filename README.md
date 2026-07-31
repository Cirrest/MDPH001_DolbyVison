# 水月雨MD-PH-001 DolbyVison模块
***
适配 Moondrop MAID 01 (MD-PH-001) 设备
***

水月雨不按GPL协议开源kernel，没招就自己逆向这个设备kernel、odm、vendor，自己丰衣足食</br>

###  *模块内容* 
***
1.开启 停用HW叠加层 选项，DolbyVison及HDR能正确显示。</br>
2.系统开启声明支持Dolby Vision,HDR10,HLG,HDR10+。</br>
3.添加手搓DVS服务，注册Codec2解码器。</br>
4.添加自研映射配置及算法，调用GPU映射及解码HEVC。</br>


###  *要求* 
***
1.设备必须为水月雨MD-PH-001原厂ROM并已修补好Magisk。</br>
2.Android版本为14及以上。</br>
3.使用官方Magisk刷入模块。</br>

###  *注意* 
***
1.经DRM HDCP的DolbyVison解码只会调用系统DRM，不会也永远不会支持非法的DRM支持</br>
2.涉及杜比认证原因，仅模块本身进行GPL开源，不涉及Dolby、编码器、自研算法库开源。</br>
3.设备硬件不支持仅通过HDR10+及自研算法映射DolbyVison至Rec.709RGB。</br>
4.原厂底层显示链路写的稀烂，没有安全的nit调试线路，暂不添加适配HDR/SDR比率功能。</br>
6.模块免费，禁止任何形式商业化、收费、二改，所有文件均已打上数字水印。</br>
7.欢迎宣传，转载请注明出处。</br>

###  *安全保证* 
***
该模块保证不含格机脚本、远程遥测等危险操作/后门，安装前请核对SHA256及MD5以免刷到非本人制作模块。</br>
---
<img width="800" height="800" alt="打赏作者，万分感谢" src="https://github.com/user-attachments/assets/456e042d-d526-4d44-825c-d702fa3167ff" />

---
[控制器使用Material Design 3(Material You)风格设计](https://m3.material.io/)
