/^1\t1$/ {TP++};
/^1\t-1$/ {FP++};
/^-1\t-1$/ {TN++};
/^-1\t1$/ {FN++};
END {print TP, TN, FP, FN; print (TP+TN)/(TP+FP+FN+TN); print TP / (TP + FP); print TP / (TP+FN);}
