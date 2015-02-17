include "globals.mzn";

% RESULTS
% =============================================
%     File    Cycles   CPU time    Optimal    |    
% =============================================
% 1. ar_1_1		34		159 ms	     YES      |
% 2. ar_1_2		18		161 ms	     YES      |
% 3. ar_1_3     16		289 ms	     YES      |
% 4. ar_2_2		18		619 ms	     YES      |
% 5. ar_2_3		15		418 ms	     YES      |
% 6. ar_2_4		11		94 ms	     YES      |
% =============================================

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

constraint cumulative(start_time_add, [del_add | i in 1..length(add)], [1 | i in 1..length(add)], number_add);
constraint cumulative(start_time_mul, [del_mul | i in 1..length(mul)], [1 | i in 1..length(mul)], number_mul);

%===================DIFF 2 constraints och variabler======================

array[1..length(add)] of var {1}: limit_add;
array[1..length(mul)] of var {1}: limit_mul;

array[1..length(add)] of var 1..number_add : add_resource;
array[1..length(mul)] of var 1..number_mul : mul_resource;

constraint diff2(start_time_add,add_resource,[del_add | i in 1..length(add)],limit_add);
constraint diff2(start_time_mul,mul_resource,[del_mul | i in 1..length(mul)],limit_mul);

%========================================================================

var int: cycles = max([start_time[i] + bool2int(i in add)*del_add + bool2int(i in mul)*del_mul | i in last]);

solve :: seq_search([
	int_search([cycles], first_fail, indomain_min, complete),
	int_search(start_time, first_fail, indomain_min, complete)
]) minimize cycles;

output [show("Cycles: "), show(cycles), show("\nStart_times: "), show(start_time),show("\nAdd resource: "), show(add_resource),show("\nMul resource: "), show(mul_resource)];
