include "globals.mzn";

% RESULTS
%     File    Cycles   CPU time      
% ===============================
% 1. ar_1_1		34		159 ms	|
% 2. ar_1_2		18		161 ms	|
% 3. ar_1_3     16		289 ms	|
% 4. ar_2_2		18		619 ms	|
% 5. ar_2_3		15		418 ms	|
% 6. ar_2_4		11		94 ms	|
% ===============================

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

%array[1..add_operations] of var {number_add}: limit_add;
%array[1..mul_operations] of var {number_mul}: limit_mul;

%constraint diff2(start_time_add,duration_add,resource_requirements_add,limit_add);
%constraint diff2(start_time_mul,duration_mul,resource_requirements_mul,limit_mul);

var int: cycles = max([start_time[i] | i in last]) + del_add;

solve :: seq_search([
	int_search([cycles], first_fail, indomain_min, complete),
	int_search(start_time, first_fail, indomain_min, complete)
]) minimize cycles; 

output [show("Cycles: "), show(cycles), show("\nStart_times: "), show(start_time)];
