#!/bin/bash

. ./config.sh

gnuplot=~/usr/bin/gnuplot
svmtrain=~/usr/bin/svm-train


for mix in dom viz txt viz-txt dom-txt-viz; 
do

    case ${mix} in 
        dom)
            cmin=4; cmax=18; cstep=2; gmin=5; gmax=-1; gstep=-2; cross=3;
        ;;
        viz)
            cmin=2; cmax=18; cstep=2; gmin=8; gmax=-1; gstep=-2; cross=3;
        ;;
        txt)
            cmin=0; cmax=18; cstep=2; gmin=0; gmax=-6; gstep=-2; cross=3;
        ;;
        viz-txt)
            cmin=4; cmax=10; cstep=1; gmin=-1; gmax=-6; gstep=-1; cross=5;
        ;;
        dom-txt-viz)
            cmin=0; cmax=10; cstep=1; gmin=0; gmax=-8; gstep=-1; cross=5;
        ;;
        *)
            cmin=-5; cmax=15; cstep=2; gmin=3; gmax=-15; gstep=-2; cross=3;
        ;;
    esac

    for f in svmin/canola/$mix.allvecs.scaled.0.learn
    do
    
        basefn=$(basename ${f} .learn)
        outbasefn=${basefn}.learn_c${cmin}_${cmax}_${cstep}_g${gmin}_${gmax}_${gstep}_v${cross}
        OUT=$PREDICT/${outbasefn}.out
        PNG=$PREDICT/${outbasefn}.png

        if [[ -f $OUT ]]
        then
            echo "SKIP $OUT"; echo
            continue
        fi
        touch $OUT
        echo $OUT

        # grid.py -log2c -2,20,2 -log2g -7,3,2 -v 5 -out viz.allvecs.scaled.0.learn_c-3_17_2_g-7_3_2_v5.out -png viz.allvecs.scaled.0.learn_c-3_17_2_g-7_3_2_v5.png  -gnuplot ~/usr/bin/gnuplot -svmtrain ~/usr/bin/svm-train -m 800 -h 0 svmin/canola/viz.allvecs.scaled.0.learn
        nice grid.py -log2c ${cmin},${cmax},${cstep} -log2g ${gmin},${gmax},${gstep} -v ${cross} -out ${OUT} -png ${PNG} -gnuplot ${gnuplot} -svmtrain ${svmtrain} -m 800 -h 0 ${f}
done
done
