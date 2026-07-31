#!/system/bin/sh

EXPECTED_DEVICE="MD_PH_001"
EXPECTED_ANDROID="14"

DEVICE="$(getprop ro.product.device)"
ANDROID_VERSION="$(getprop ro.build.version.release)"

ui_print "- 安装前的设备兼容检查"
[ "$DEVICE" = "$EXPECTED_DEVICE" ] || abort "不支持的设备: $DEVICE"
[ "$ANDROID_VERSION" = "$EXPECTED_ANDROID" ] || abort "不支持的安卓版本: $ANDROID_VERSION"

LIVE_MEDIA_XML="/vendor/etc/media_codecs.xml"
[ -r "$LIVE_MEDIA_XML" ] || abort "无法读取XML配置"
[ -r "$MODPATH/system/vendor/etc/media_codecs_dolby_vision.xml" ] || \
    abort "缺少Dolby Vision编解码器配置"

ui_print "- ✔设备检查通过，进行安装"
ui_print "- 该模块安装以下为MD-PH-001适配的DolbyVison服务及依赖"
ui_print "- "
ui_print "- "
ui_print "- "
ui_print "- 显示规格：1080x2400，500nit，BT.2020/PQ"
ui_print "- 开启 停用HW叠加层 选项，DolbyVison及HDR能正确显示"
ui_print "- 系统开启声明支持Dolby Vision,HDR10,HLG,HDR10+"
ui_print "- 添加DVS服务，注册Codec2解码器"
ui_print "- 添加自研映射配置及算法，调用GPU映射及解码HEVC"
ui_print "- 注：经DRM HDCP的DolbyVison解码只会调用系统DRM"
ui_print "- 不会也永远不会支持非法的DRM支持"
ui_print "- "
ui_print "- "
ui_print "- ⚠该模块为免费模块，自己逆向半年kernel适配手搓的成果之一⚠"
ui_print "- ⚠禁止任何形式商业化、收费、二改⚠"
ui_print "- ⚠该模块所有文件均已打上数字水印，均可追溯⚠"

set_perm_recursive "$MODPATH" 0 0 0755 0644
set_perm "$MODPATH/customize.sh" 0 0 0755
set_perm "$MODPATH/post-fs-data.sh" 0 0 0755
set_perm "$MODPATH/service.sh" 0 0 0755
set_perm "$MODPATH/uninstall.sh" 0 0 0755
set_perm_recursive "$MODPATH/payload/bin" 0 0 0755 0755
set_perm_recursive "$MODPATH/payload/lib64" 0 0 0755 0644

