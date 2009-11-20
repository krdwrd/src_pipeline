/^1\t1\t/ {TP=TP+$3};
/^1\t-1\t/ {FP=FP+$3};
/^-1\t-1\t/ {TN=TN+$3};
/^-1\t1\t/ {FN=FN+$3};
END {print TP, TN, FP, FN; print (TP+TN)/(TP+FP+FN+TN); print TP / (TP + FP); print TP / (TP+FN);}
