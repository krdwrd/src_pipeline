/^1\t1/ {if ($3) {TP=TP+$3} else TP++};
/^1\t-1/ {if ($3) {FN=FN+$3} else FN++};
/^-1\t-1/ {if ($3) {TN=TN+$3} else TN++};
/^-1\t1/ {if ($3) {FP=FP+$3} else FP++};
END {print TP, TN, FP, FN; print (TP+TN)/(TP+FP+FN+TN); print TP / (TP + FP); print TP / (TP+FN);}
