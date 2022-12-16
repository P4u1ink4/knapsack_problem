int: n;
set of int: OBJ = 1..n;
int: bag;
array[OBJ] of int: vals;
array[OBJ] of int: weights;
array[OBJ] of int: priority;
var int: final;
var int: firstweight;
var int: firstval;
var int: nextbag;
array[OBJ] of var int: changepriority;

constraint(firstweight = sum ([weights[i]*priority[i] | i in OBJ]));
constraint(firstval = sum ([vals[i]*priority[i] | i in OBJ]));

constraint(if firstweight <= bag then nextbag = bag - firstweight else nextbag = bag endif);

var int: nextfirstval;

constraint(if nextbag == bag then nextfirstval = 0 else nextfirstval = firstval endif);

constraint forall(i in OBJ)(
    if nextbag == bag then changepriority[i] = 1 
    else
      if priority[i] == 0 then changepriority[i] = 1 else changepriority[i] = 0 endif
    endif );
    
var set of OBJ: obj;

var int: secondweight = sum([weights[i]*changepriority[i] | i in  obj]);
var int: secondval = sum([vals[i]*changepriority[i] | i in obj]); 

constraint secondweight <= nextbag;
solve maximize secondval;

constraint(final = nextfirstval + secondval);

output["Wynik algorytmu: \(final)"];
