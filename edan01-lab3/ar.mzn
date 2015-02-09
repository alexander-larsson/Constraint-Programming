include "globals.mzn";

int : add_operations = 12;
int : mul_operations = 16;

% Antal klockcykler som krävs
int : del_add;
int : del_mul;

% Antal adders/multipliers tillgängliga
int : number_add;
int : number_mul;

int : n; % Totalt antal operationer

set of int : last;
set of int : add; % Operationer som är en addition
set of int : mul; % Operationer som är en multiplikation

array[1..n] of set of int : dependencies; % Beroenden mellan operationerna

array[1..n] of var 0..1000: start_time;
constraint forall(i in add) ( forall( j in dependencies[i]) (start_time[i] + del_add <= start_time[j]) );
constraint forall(i in mul) ( forall( j in dependencies[i]) (start_time[i] + del_mul <= start_time[j]) );

array[1..add_operations] of var int: start_time_add = [ start_time[i] | i in add ];
array[1..mul_operations] of var int: start_time_mul = [ start_time[i] | i in mul ];

array[1..add_operations] of var {del_add}: duration_add;
array[1..mul_operations] of var {del_mul}: duration_mul;

array[1..add_operations] of var {1}: resource_requirements_add;
array[1..mul_operations] of var {1}: resource_requirements_mul;

constraint cumulative(start_time_add,duration_add,resource_requirements_add,number_add);
constraint cumulative(start_time_mul,duration_mul,resource_requirements_mul,number_mul);

var int: finish_time = max([start_time[i] | i in last]);

solve :: int_search(start_time, input_order, indomain_min, complete) minimize finish_time;
