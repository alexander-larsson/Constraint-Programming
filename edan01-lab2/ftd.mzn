include "globals.mzn";

int: N; % number of cities
array[1..N] of set of int: edges;
array[1..N, 1..N] of int: distance;
array[1..N] of int: price;
int: tank_capacity;
int: start;
int: end;

%array[1..N] of var int: cities = array1d(1..N, [var x | x in edges]);


var {2,3,4}: C1;		var {2,3,4}: C2;		var {2,3,5,6}: C3;
var {2,4,5,6,7}: C4;	var {3,4,5,7}: C5;		var {3,4,6,8}: C6;
var {4,5,7,8,9}: C7;	var {6,7,8,9,10}: C8;	var {7,8,9,10}: C9;
var {1}: C10; 

array[1..N] of var int: cities = [C1,C2,C3,C4,C5,C6,C7,C8,C9,C10];

array[1..N] of var 0..tank_capacity: tankIn;
array[1..N] of var 0..tank_capacity: fuelBought;
array[1..N] of var 0..tank_capacity: tankOut;
constraint tankIn[1] = 0;
var int: cost = sum (i in 1..N) (fuelBought[i] * price[i]);

constraint forall(i in 1..N)(tankOut[i] = tankIn[i]+fuelBought[i]);
constraint forall(i in 1..N)(tankOut[i] >= distance[i,cities[i]]);
constraint forall(i in 1..N)(tankIn[cities[i]] = tankOut[i] - distance[i,cities[i]]);

constraint subcircuit(cities);

solve :: int_search(cities, input_order, indomain_min, complete) minimize cost;

output [show("Cost: "), show(cost), show("\nCities: "), show(cities)];

