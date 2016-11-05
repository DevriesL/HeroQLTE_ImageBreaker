#!/bin/bash

export ARCH=arm64

export SEC_BUILD_OPTION_HW_REVISION=02

export PATH=/home/devries/gcc-linaro-4.9-2016.02-x86_64_aarch64-linux-gnu/bin:$PATH

export CROSS_COMPILE=aarch64-linux-gnu-

make heroqlte_chnzc_defconfig

make

make dtbs

tools/dtbTool -o dt.img -s 4096 -p scripts/dtc/ arch/arm64/boot/dts/samsung/

tools/mkbootimg \
      --kernel arch/arm64/boot/Image \
      --ramdisk ramdisk.packed \
      --cmdline "console=null androidboot.hardware=qcom user_debug=31 msm_rtb.filter=0x37 ehci-hcd.park=3 lpm_levels.sleep_disabled=1 cma=24M@0-0xffffffff rcupdate.rcu_expedited=1" \
      --base 0x80000000 \
      --pagesize 4096 \
      --dt dt.img \
      --ramdisk_offset 0x02200000 \
      --tags_offset 0x02000000 \
      --output boot.img

tar -cvf boot.tar boot.img