BEGIN {
    TP=0; FN=0; TN=0; FP=0; errln=0;
};
/^1\t1/ {if ($3) {TP=TP+$3} else TP++};
/^1\t-1/ {if ($3) {FN=FN+$3} else FN++};
/^-1\t-1/ {if ($3) {TN=TN+$3} else TN++};
/^-1\t1/ {if ($3) {FP=FP+$3} else FP++};
$0 !~ /(^-?1\t-?1)|(^$)/ { errln = FNR; exit 1;  };
END { 
    if (errln > 0) 
    { 
        print "error in line: "errln; 
    } 
    else
    { 
        print TP, TN, FP, FN;
        print (TP+TN)/(TP+FP+FN+TN); print TP / (TP + FP); print TP / (TP+FN);
    }
};
