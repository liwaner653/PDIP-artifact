#!/bin/bash

umask 0002
echo $@
#if [ $# -ne 4 ]; then
#  echo "This script takes 9 arguments"
#  exit
#fi

#USER_DIR=$5
USER_DIR=bgodala
if [ -z ${USER_DIR} ]; then
  echo "USER_DIR not set"
  exit
fi

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
WORK_DIR=$SCRIPT_DIR
echo $USER_DIR

mkdir -p $WORK_DIR
cd $WORK_DIR
mkdir -p  $1
cd $1
BMK=$1
#cp /home/bgodala/lapidary/.lapidary.yaml .
#TODO: insert one switch case here for setting up config_dir related params
config_dir=$2
cfg_name=$3
preserve_ways=$4
pdip_sets=$6
pdip_ways=$7
l1i_assoc=8
L1I_SIZE="32kB"
L2_SIZE="1MB"
L3_SIZE="2MB"
#BTB=131072
#BTB=65536
#BTB=32768
#BTB=16384
BTB=8192
#BTB=4096
RANDOMNESS=3.125
PDIP_RANDOMNESS=25
BP_TYPE=${BP_TYPE:=TAGE}
case $config_dir in
  "m_1")
        rp="LRU"
        #extra="--starvCounts"
        extra="--fdip"
  ;;

  "p_sr_eip_10")
        rp="LRUEmissary"
        extra="--fdip --enable-eip --eip-sets 64 --eip-targets 2 --pureRandom --starveRandomness 3.125"
  ;;

  "p_sr_eip_20")
        rp="LRUEmissary"
        extra="--fdip --enable-eip --eip-sets 128 --eip-targets 2 --pureRandom --starveRandomness 3.125"
  ;;

  "p_sr_eip_40")
        rp="LRUEmissary"
        extra="--fdip --enable-eip --eip-sets 256 --eip-targets 2 --pureRandom --starveRandomness 3.125"
  ;;

  "p_sr_eip")
        rp="LRUEmissary"
        extra="--fdip --enable-eip --pureRandom --starveRandomness 3.125"
  ;;

  "eip_10")
        rp="LRU"
        extra="--fdip --enable-eip --eip-sets 64 --eip-targets 2"
  ;;

  "eip_20")
        rp="LRU"
        extra="--fdip --enable-eip --eip-sets 128 --eip-targets 2"
  ;;

  "eip_40")
        rp="LRU"
        extra="--fdip --enable-eip --eip-sets 256 --eip-targets 2"
  ;;


  "eip_filt_10")
        rp="LRU"
        extra="--fdip --enable-eip --eip-sets 64 --eip-targets 2 --enable-eip-filt"
  ;;

  "eip_filt_20")
        rp="LRU"
        extra="--fdip --enable-eip --eip-sets 128 --eip-targets 2  --enable-eip-filt"
  ;;

  "eip_filt_40")
        rp="LRU"
        extra="--fdip --enable-eip --eip-sets 256 --eip-targets 2  --enable-eip-filt"
  ;;

  "eip")
        rp="LRU"
        extra="--fdip --enable-eip"
  ;;

  "eip_filt")
        rp="LRU"
        extra="--fdip --enable-eip --enable-eip-filt"
  ;;

  "perfect_no_cold")
        rp="PerfectNoCold"
        #extra="--starvCounts"
        extra="--fdip"
  ;;

  "m_1_2x_l1i")
        rp="LRU"
        #extra="--starvCounts"
        L1I_SIZE="64kB"
	l1i_assoc=16
        extra="--fdip"
  ;;

  "m_1_4x_l1i")
        rp="LRU"
        #extra="--starvCounts"
        L1I_SIZE="128kB"
	l1i_assoc=32
        extra="--fdip"
  ;;

  "m_1_8x_l1i")
        rp="LRU"
        #extra="--starvCounts"
        L1I_SIZE="256kB"
	l1i_assoc=64
        extra="--fdip"
  ;;

  "m_1_16x_l1i")
        rp="LRU"
        #extra="--starvCounts"
        L1I_SIZE="512kB"
	l1i_assoc=128
        extra="--fdip"
  ;;


  "m_1_bpb")
        rp="LRU"
        extra="--fdip --bpb"
  ;;

  "m_1_no_fdip")
        rp="LRU"
  ;;

  "perfectICache")
        rp="LRU"
        extra="--perfectICache --fdip"
  ;;

  "scounts_final")
        rp="LRU"
        extra="--starvCounts"
  ;;

  "m_0")
        rp="LIP"
        extra="--fdip"
  ;;

  "m_r")
        rp="BIP"
        extra="--fdip"
  ;;

  "m_s")
        rp="SBIP"
        extra="--fdip"
  ;;

  "m_br")
        rp="BRRIP"
        extra="--fdip"
  ;;

  "m_dr")
        rp="DRRIP"
        extra="--fdip"
  ;;

  "m_rr")
        rp="RRIP"
        extra="--fdip"
  ;;

  "clip")
        rp="CLIP"
        extra="--fdip"
  ;;

  "dclip")
        rp="DCLIP"
        extra="--fdip"
  ;;

  "m_pdp")
        rp="PDP"
        extra="--fdip"
  ;;

  "m_sr")
        rp="SBIP"
        extra="--fdip --randomStarve"
  ;;

  "p_r")
        rp="LRUEmissary"
        extra="--fdip --pureRandom --starveRandomness 3.125"
  ;;

  "p_r2")
        rp="LRUEmissary"
        extra="--fdip --pureRandom --starveRandomness 50.0"
  ;;

  "p_r8")
        rp="LRUEmissary"
        extra="--fdip --pureRandom --starveRandomness 12.5"
  ;;

  "p_r16")
        rp="LRUEmissary"
        extra="--fdip --pureRandom --starveRandomness 6.25"
  ;;

  "p_r32")
        rp="LRUEmissary"
        extra="--fdip --pureRandom --starveRandomness 3.125"
  ;;

  "p_r64")
        rp="LRUEmissary"
        extra="--fdip --pureRandom --starveRandomness 1.5625"
  ;;

  "pdip_s")
        rp="LRUEmissary"
        extra="--fdip --enable-pdip --pdip-sets ${pdip_sets} --pdip-assoc ${pdip_ways}"
	PDIP_SETS=${pdip_sets}
	PDIP_WAYS=${pdip_ways}
  ;;

  "pdip_sr")
        rp="LRUEmissary"
        #extra="--fdip --randomStarve --starveRandomness 3.125 --enable-pdip --pdip-sets ${pdip_sets} --pdip-assoc ${pdip_ways} --randomStarvePDIP"
        extra="--fdip --randomStarve --starveRandomnessPDIP ${PDIP_RANDOMNESS} --starveRandomness ${RANDOMNESS}  --enable-pdip --pdip-sets ${pdip_sets} --pdip-assoc ${pdip_ways} --randomStarvePDIP"
	PDIP_SETS=${pdip_sets}
	PDIP_WAYS=${pdip_ways}
  ;;

  "pdip_only")
        rp="LRU"
        #extra="--fdip --randomStarve --starveRandomness 3.125 --enable-pdip --pdip-sets ${pdip_sets} --pdip-assoc ${pdip_ways} --randomStarvePDIP"
        extra="--fdip --randomStarve --starveRandomnessPDIP ${PDIP_RANDOMNESS} --starveRandomness ${RANDOMNESS}  --enable-pdip --pdip-sets ${pdip_sets} --pdip-assoc ${pdip_ways} --randomStarvePDIP"
	PDIP_SETS=${pdip_sets}
	PDIP_WAYS=${pdip_ways}
  ;;

  "pdipZeroCost_sr")
        rp="LRUEmissary"
        #extra="--fdip --randomStarve --starveRandomness 3.125 --enable-pdip --pdip-sets ${pdip_sets} --pdip-assoc ${pdip_ways} --randomStarvePDIP"
        extra="--fdip --randomStarve --starveRandomnessPDIP ${PDIP_RANDOMNESS} --starveRandomness ${RANDOMNESS}  --enable-pdip --pdip-sets ${pdip_sets} --pdip-assoc ${pdip_ways} --randomStarvePDIP --pdip-zero-cost"
	PDIP_SETS=${pdip_sets}
	PDIP_WAYS=${pdip_ways}
  ;;

  "pdipZeroCost_only")
        rp="LRU"
        #extra="--fdip --randomStarve --starveRandomness 3.125 --enable-pdip --pdip-sets ${pdip_sets} --pdip-assoc ${pdip_ways} --randomStarvePDIP"
        extra="--fdip --randomStarve --starveRandomnessPDIP ${PDIP_RANDOMNESS} --starveRandomness ${RANDOMNESS}  --enable-pdip --pdip-sets ${pdip_sets} --pdip-assoc ${pdip_ways} --randomStarvePDIP --pdip-zero-cost"
	PDIP_SETS=${pdip_sets}
	PDIP_WAYS=${pdip_ways}
  ;;


  "pdip_s_4k_2")
        rp="LRUEmissary"
        extra="--fdip --enable-pdip --pdip-sets 4 --pdip-assoc 2"
  ;;

  "pdip_sr_4k_2")
        rp="LRUEmissary"
        extra="--fdip --randomStarve --starveRandomness 3.125 --enable-pdip --pdip-sets 4 --pdip-assoc 2"
  ;;

  "pdip_s_4k_4")
        rp="LRUEmissary"
        extra="--fdip --enable-pdip --pdip-sets 4 --pdip-assoc 4"
  ;;

  "pdip_sr_4k_4")
        rp="LRUEmissary"
        extra="--fdip --randomStarve --starveRandomness 3.125 --enable-pdip --pdip-sets 4 --pdip-assoc 4"
  ;;

  "pdip_s_4k_8")
        rp="LRUEmissary"
        extra="--fdip --enable-pdip --pdip-sets 4 --pdip-assoc 8"
  ;;

  "pdip_sr_4k_8")
        rp="LRUEmissary"
        extra="--fdip --randomStarve --starveRandomness 3.125 --enable-pdip --pdip-sets 4 --pdip-assoc 8"
  ;;

  "pdip_s_2k_4")
        rp="LRUEmissary"
        extra="--fdip --enable-pdip --pdip-sets 2 --pdip-assoc 4"
  ;;

  "pdip_sr_2k_4")
        rp="LRUEmissary"
        extra="--fdip --randomStarve --starveRandomness 3.125 --enable-pdip --pdip-sets 2 --pdip-assoc 4"
  ;;

  "pdip_s_2k_8")
        rp="LRUEmissary"
        extra="--fdip --enable-pdip --pdip-sets 2 --pdip-assoc 8"
  ;;

  "pdip_sr_2k_8")
        rp="LRUEmissary"
        extra="--fdip --randomStarve --starveRandomness 3.125 --enable-pdip --pdip-sets 2 --pdip-assoc 8"
  ;;

  "pdip_s_8k_4")
        rp="LRUEmissary"
        extra="--fdip --enable-pdip --pdip-sets 8 --pdip-assoc 4"
  ;;

  "pdip_sr_8k_4")
        rp="LRUEmissary"
        extra="--fdip --randomStarve --starveRandomness 3.125 --pdip-sets 8 --enable-pdip --pdip-assoc 4"
  ;;

  "pdip_s_8k_8")
        rp="LRUEmissary"
        extra="--fdip --enable-pdip --pdip-sets 8 --pdip-assoc 8"
  ;;

  "pdip_sr_8k_8")
        rp="LRUEmissary"
        extra="--fdip --randomStarve --starveRandomness 3.125 --enable-pdip --pdip-sets 8 --pdip-assoc 8"
  ;;

  "pdipIdeal_s")
        rp="PDIPIdeal"
        extra="--fdip  --pdip-sets ${pdip_sets} --pdip-assoc ${pdip_ways}"
	PDIP_SETS=${pdip_sets}
	PDIP_WAYS=${pdip_ways}
  ;;

  "pdipIdeal_sr")
        rp="PDIPIdeal"
        extra="--fdip --randomStarve --starveRandomness 3.125  --pdip-sets ${pdip_sets} --pdip-assoc ${pdip_ways} --randomStarvePDIP"
	PDIP_SETS=${pdip_sets}
	PDIP_WAYS=${pdip_ways}
  ;;

   "pdipIdeal_s_2k_4")
        rp="PDIPIdeal"
        extra="--fdip  --pdip-sets 2 --pdip-assoc 4"
  ;;

  "pdipIdeal_sr_2k_4")
        rp="PDIPIdeal"
        extra="--fdip --randomStarve --starveRandomness 3.125  --pdip-sets 2 --pdip-assoc 4"
  ;;

   "pdipIdeal_s_2k_8")
        rp="PDIPIdeal"
        extra="--fdip  --pdip-sets 2 --pdip-assoc 8"
  ;;

  "pdipIdeal_sr_2k_8")
        rp="PDIPIdeal"
        extra="--fdip --randomStarve --starveRandomness 3.125  --pdip-sets 2 --pdip-assoc 8"
  ;;

   "pdipIdeal_s_4k_2")
        rp="PDIPIdeal"
        extra="--fdip  --pdip-sets 4 --pdip-assoc 2"
  ;;

  "pdipIdeal_sr_4k_2")
        rp="PDIPIdeal"
        extra="--fdip --randomStarve --starveRandomness 3.125  --pdip-sets 4 --pdip-assoc 2"
  ;;

   "pdipIdeal_s_4k_4")
        rp="PDIPIdeal"
        extra="--fdip  --pdip-sets 4 --pdip-assoc 4"
  ;;

  "pdipIdeal_sr_4k_4")
        rp="PDIPIdeal"
        extra="--fdip --randomStarve --starveRandomness 3.125  --pdip-sets 4 --pdip-assoc 4"
  ;;

   "pdipIdeal_s_4k_8")
        rp="PDIPIdeal"
        extra="--fdip  --pdip-sets 4 --pdip-assoc 8"
  ;;

  "pdipIdeal_sr_4k_8")
        rp="PDIPIdeal"
        extra="--fdip --randomStarve --starveRandomness 3.125  --pdip-sets 4 --pdip-assoc 8"
  ;;


  "p_s")
        rp="LRUEmissary"
        extra="--fdip"
  ;;

  "p_sr")
        rp="LRUEmissary"
        extra="--fdip --randomStarve --starveRandomness ${RANDOMNESS}"
  ;;

  "p_sr2")
        rp="LRUEmissary"
        extra="--fdip --randomStarve --starveRandomness 50.0"
  ;;

  "p_sr8")
        rp="LRUEmissary"
        extra="--fdip --randomStarve --starveRandomness 12.5"
  ;;

  "p_sr16")
        rp="LRUEmissary"
        extra="--fdip --randomStarve --starveRandomness 6.25"
  ;;

  "p_sr32")
        rp="LRUEmissary"
        extra="--fdip --randomStarve --starveRandomness 3.125"
  ;;

  "p_sr64")
        rp="LRUEmissary"
        extra="--fdip --randomStarve --starveRandomness 1.5625"
  ;;

  "p_si")
        rp="LRUEmissary"
        extra="--fdip --emissary-enable-iq-empty"
  ;;

  "p_sri")
        rp="LRUEmissary"
        extra="--fdip --randomStarve --emissary-enable-iq-empty"
  ;;

  "p_sh1")
        rp="LRUEmissary"
        extra="--fdip --starveAtleast=1"
  ;;

  "p_sh2")
        rp="LRUEmissary"
        extra="--fdip --starveAtleast=2"
  ;;

  "p_sh3")
        rp="LRUEmissary"
        extra="--fdip --starveAtleast=3"
  ;;

  "p_sh4")
        rp="LRUEmissary"
        extra="--fdip --starveAtleast=4"
  ;;

  "p_sh5")
        rp="LRUEmissary"
        extra="--fdip --starveAtleast=5"
  ;;

  "p_sh6")
        rp="LRUEmissary"
        extra="--fdip --starveAtleast=6"
  ;;

  "p_sh7")
        rp="LRUEmissary"
        extra="--fdip --starveAtleast=7"
  ;;

  "p_sh8")
        rp="LRUEmissary"
        extra="--fdip --starveAtleast=8"
  ;;

  "p_sh4r")
        rp="LRUEmissary"
        extra="--fdip --starveAtleast=4 --histRandom"
  ;;


  "opt")
        #if [ -d "${cfg_name}/${config_dir}_${preserve_ways}" ]; then
        #    echo "mv ${cfg_name}/${config_dir}_${preserve_ways} ${cfg_name}/${config_dir}_${preserve_ways}.delete_later"
        #    mv ${cfg_name}/${config_dir}_${preserve_ways} ${cfg_name}/${config_dir}_${preserve_ways}.delete_later
        #fi
        rp="LRU"
	L1I_SIZE="1024kB"
	L2_SIZE="1024kB"
	extra="--opt --numSets=64"
        #case $cfg_name in
        #  "32K_large")
        #      extra="--opt --numSets=64"
        #  ;;
        #  "32K")
        #      extra="--opt --numSets=64"
        #  ;;
        #  "16K")
        #      extra="--opt --numSets=32"
        #  ;;
        #  "8K")
        #      extra="--opt --numSets=16"
        #  ;;
        #  *)
        #      echo "Wrong cofig name $cfg_name"
        #  ;;
        #esac
  ;;

  "optrp_fdip")
        rp="OPT"
	L1I_SIZE="1024kB"
	L2_SIZE="1024kB"
	extra="--fdip"
  ;;

  "optrp")
        rp="OPT"
	L1I_SIZE="1024kB"
	L2_SIZE="1024kB"
  ;;

  *)
        echo "Wrong input config $config_dir"
  ;;

esac

#if [ -d "${cfg_name}/${config_dir}_${preserve_ways}" ]; then
#    echo "mv ${cfg_name}/${config_dir}_${preserve_ways} ${cfg_name}/${config_dir}_${preserve_ways}.old_data"
#    mv ${cfg_name}/${config_dir}_${preserve_ways} ${cfg_name}/${config_dir}_${preserve_ways}.old_data
#fi
case $cfg_name in
  "ftq5")
        ftq_size=5
  ;;

  "ftq10")
        ftq_size=10
  ;;

  "ftq20")
        ftq_size=20
  ;;

  "ftq24")
        ftq_size=24
  ;;

  "ftq100")
        ftq_size=100
  ;;

  *)
        echo "Wrong input config $cfg_name"
  ;;

esac

GEM5_HOME=/qpoints/gem5
GEM5_CFG=$GEM5_HOME/configs/example/fs.py
export M5_PATH=$GEM5_HOME
CKPT_DIR=/qpoints/x86.ckpts/${BMK}
OUTDIR=${cfg_name}/${config_dir}_${preserve_ways}
if [ ! -z "$PDIP_SETS" ] && [ ! -z "$PDIP_WAYS" ]
then
	echo "Condiiton met"
    OUTDIR=${cfg_name}/${config_dir}_${PDIP_SETS}_${PDIP_WAYS}_${preserve_ways}
fi
BOOT_DIR=/qpoints/x86.ckpts/boot
KERN_IMG=${BOOT_DIR}/vmlinux-final
DISK_IMG=${BOOT_DIR}/ubuntu-image-new_x86_octane.img
#DISK_IMG=${BOOT_DIR}/ubuntu-image-new_x86.img
INSTS=100000000
#MORE_ARGS="--disableApicTimerInterrupt --pdip-mispred-br-trigger --pdip-prefetch-all --pdip-lookup-all-brs"
#MORE_ARGS="--disableApicTimerInterrupt --pdip-mispred-br-trigger --pdip-indirect-br-trigger --pdip-out-of-page --pdip-targets 2 --pdip-next-n-lines 0 --pdip-lookup-all-brs"
#MORE_ARGS="--disableApicTimerInterrupt --pdip-out-of-page --pdip-mispred-br-trigger --pdip-indirect-br-trigger --pdip-targets 8 --pdip-next-n-lines 0 --pdip-lookup-all-brs --pdip-full-tag"
##MORE_ARGS="--disableApicTimerInterrupt --pdip-out-of-page --pdip-mispred-br-trigger --pdip-indirect-br-trigger --pdip-targets 8 --pdip-next-n-lines 0 --pdip-lookup-all-brs --pdip-full-tag"
#MORE_ARGS="--disableApicTimerInterrupt --pdip-out-of-page --pdip-mispred-br-trigger --pdip-indirect-br-trigger --pdip-targets 4 --pdip-next-n-lines 0 --pdip-lookup-all-brs --pdip-tag-bits 10 --pdip-compress-targets --pdip-compress-targets-range 4"
MORE_ARGS="--disableApicTimerInterrupt --pdip-out-of-page --pdip-mispred-br-trigger --pdip-indirect-br-trigger --pdip-targets 2 --pdip-next-n-lines 0 --pdip-lookup-all-brs --pdip-tag-bits 10 --pdip-compress-targets --pdip-compress-targets-range 4"
#MORE_ARGS="--disableApicTimerInterrupt --pdip-mispred-br-trigger --pdip-indirect-br-trigger --pdip-targets 4 --pdip-next-n-lines 0 --pdip-lookup-all-brs --pdip-tag-bits 10"
#MORE_ARGS="--disableApicTimerInterrupt --pdip-out-of-page --pdip-mispred-br-trigger --pdip-indirect-br-trigger --pdip-targets 4 --pdip-next-n-lines 0 --pdip-tag-bits 10"
#MORE_ARGS="--disableApicTimerInterrupt --pdip-out-of-page --pdip-mispred-br-trigger --pdip-targets 4 --pdip-next-n-lines 0 --pdip-lookup-all-brs --pdip-tag-bits 10"
#MORE_ARGS="--disableApicTimerInterrupt --pdip-mispred-br-trigger --pdip-indirect-br-trigger --pdip-targets 8 --pdip-next-n-lines 0 --pdip-lookup-all-brs"
#MORE_ARGS="--disableApicTimerInterrupt --pdip-out-of-page --pdip-indirect-br-trigger --pdip-targets 4 --pdip-next-n-lines 0 --pdip-full-tag"
#OUTDIR=${cfg_name}/${config_dir}_${preserve_ways}
#EMISSARY_CFG='-W 5000000 -I 100000000 --ftqSize '${ftq_size}' --cpu=ooo --cpu-type=O3CPU --bp-type TAGE --caches --l1i_size '${L1I_SIZE}'  --l2cache --l2_size '${L2_SIZE}' --btb-entries 4096 --fetchQSize 32 --mem-size 16384MiB'
EMISSARY_CFG='-W 5000000 -I 100000000 --ftqSize '${ftq_size}' --cpu=ooo --cpu-type=O3CPU --bp-type TAGE --caches --l1i_size '${L1I_SIZE}'  --l2cache --l2_size '${L2_SIZE}' --btb-entries 16384 --fetchQSize 32 --mem-size 16384MiB --l3_rp=SFL'
mkdir -p ${OUTDIR}
echo "TEST"
echo $GEM5_HOME/build/X86/gem5.fast  --outdir=${OUTDIR} $GEM5_CFG -s 10000000 -W 10000000 -I ${INSTS}  --kernel="${KERN_IMG}" --root-device="/dev/vda2" --btb-entries ${BTB}  --ftqSize $3 --disk-image="${DISK_IMG}" --l2cache --l2_rp=${rp} --emissary-retirement --preserve_ways=${preserve_ways} --l2_size="${L2_SIZE}" --l3cache --l3_size="${L3_SIZE}" --l1i_size=${L1I_SIZE} --l1i_assoc=${l1i_assoc} --l1d_assoc=16 --cpu-type DerivO3CPU --caches --bp-type TAGE --checkpoint-dir ${CKPT_DIR} -r 1 -n 1 --mem-size 8192MiB ${MORE_ARGS} ${extra} > ${OUTDIR}/out.inst
#$GEM5_HOME/build/ARM/gem5.fast --outdir="${OUTDIR}" $GEM5_CFG $EMISSARY_CFG --preserve_ways ${preserve_ways} --l2_rp=${rp} --disk-image="${CKPT_DIR}/ubuntu-image.img" --bootloader="${M5_PATH}/binaries/boot_v2_qemu_virt.arm64" --restore "${CKPT_DIR}" $5 --hist_freq_cycles ${6} ${extra} 2>&1 | tee "${OUTDIR}/out.emissary.sr"
#$GEM5_HOME/build/ARM/gem5.fast --outdir="${OUTDIR}" $GEM5_CFG $EMISSARY_CFG --preserve_ways ${preserve_ways} --l2_rp=${rp} --disk-image="${CKPT_DIR}/ubuntu-image.img" --bootloader="${M5_PATH}/binaries/boot_v2_qemu_virt.arm64" --restore "${CKPT_DIR}" $5 --emissary-enable-iq-empty --emissary-retirement --hist_freq_cycles ${6} ${extra}  2>&1 | tee "${OUTDIR}/out.emissary.sr"
$GEM5_HOME/build/X86/gem5.fast  --outdir=${OUTDIR} $GEM5_CFG -s 10000000 -W 10000000 -I ${INSTS}  --kernel="${KERN_IMG}" --root-device="/dev/vda2" --btb-entries ${BTB}  --ftqSize ${ftq_size} --disk-image="${DISK_IMG}" --l2cache --l2_rp=${rp} --emissary-retirement --emissary-enable-iq-empty --preserve_ways=${preserve_ways} --l2_size="${L2_SIZE}" --l3cache --l3_size="${L3_SIZE}" --l1i_size=${L1I_SIZE} --l1i_assoc=${l1i_assoc} --l1d_assoc=16 --cpu-type DerivO3CPU --caches --bp-type ${BP_TYPE} --checkpoint-dir ${CKPT_DIR} -r 1 -n 1 --mem-size 8192MiB ${MORE_ARGS} ${extra} > ${OUTDIR}/out.inst 2>&1
