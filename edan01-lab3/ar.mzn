include "globals.mzn";

% RESULTS
% ===============================
%     File    Cycles   CPU time |    
% ===============================
% 1. ar_1_1		34		159 ms	|
% 2. ar_1_2		18		161 ms	|
% 3. ar_1_3     16		289 ms	|
% 4. ar_2_2		18		619 ms	|
% 5. ar_2_3		15		418 ms	|
% 6. ar_2_4		11		94 ms	|
% ===============================

% Antal klockcykler som krävs
int : del_add;
int : del_mul;

% Antal adders/multipliers tillgängliga
int : number_add;
int : number_mul;

int : n; % Totalt antal operationer

set of int : last; % De element som ligger sist? (vad gör 13 och 14 där?)
set of int : add; % Operationer som är en addition
set of int : mul; % Operationer som är en multiplikation

array[1..n] of set of int : dependencies; % Beroenden mellan operationerna

array[1..n] of var 0..100: start_time;
constraint forall(i in add) ( forall( j in dependencies[i]) (start_time[i] + del_add <= start_time[j]) );
constraint forall(i in mul) ( forall( j in dependencies[i]) (start_time[i] + del_mul <= start_time[j]) );

array[1..length(add)] of var int: start_time_add = [ start_time[i] | i in add ];
array[1..length(mul)] of var int: start_time_mul = [ start_time[i] | i in mul ];

array[1..length(add)] of var {del_add}: duration_add;
array[1..length(mul)] of var {del_mul}: duration_mul;

array[1..length(add)] of var {1}: resource_requirements_add;
array[1..length(mul)] of var {1}: resource_requirements_mul;

constraint cumulative(start_time_add, duration_add, resource_requirements_add, number_add);
constraint cumulative(start_time_mul, duration_mul, resource_requirements_mul, number_mul);

%array[1..length(add)] of var {1}: limit_add;
%array[1..length(mul)] of var {1}: limit_mul;

%constraint diff2(start_time_add,duration_add,diff_res_add,limit_add);
%constraint diff2(start_time_mul,duration_mul,diff_res_add,limit_mul);

var int: cycles = max([start_time[i] + bool2int(i in add)*del_add + bool2int(i in mul)*del_mul | i in last]);

solve :: seq_search([
	int_search([cycles], first_fail, indomain_min, complete),
	int_search(start_time, first_fail, indomain_min, complete)
]) minimize cycles;

output [show("Cycles: "), show(cycles), show("\nStart_times: "), show(start_time)];
