include "globals.mzn";

int : tankSize = 10;
int : nbrCities = 10;

var {2,3,4}: C1;		var {2,3,4}: C2;		var {2,3,5,6}: C3;
var {2,4,5,6,7}: C4;	var {3,4,5,7}: C5;		var {3,4,6,8}: C6;
var {4,5,7,8,9}: C7;	var {6,7,8,9,10}: C8;	var {7,8,9,10}: C9;
var {1}: C10; 


array[1..nbrCities, 1..nbrCities] of int: costs;

%	      1  2   3   4  5   6   7   8  9  10
 costs = [|0, 10, 11, 6, 0,  0,  0,  0, 0, 0 % 1
 	    |10, 0,  5,  8, 0,  0,  0,  0, 0, 0  % 2
 	    |11, 5,  0,  0, 3,  5,  0,  0, 0, 0  % 3
 	    | 6, 8,  0,  0, 2,  6,  7,  0, 0, 0  % 4
 	    | 0, 0,  3,  2, 0,  0, 12,  0, 0, 0  % 5
 	    | 0, 0,  5,  6, 0,  0,  0, 14, 0, 0  % 6
 	    | 0, 0,  0,  7,12,  0,  0,  5, 3, 0  % 7
 	    | 0, 0,  0,  0, 0, 14,  5,  0, 1, 9  % 8
 	    | 0, 0,  0,  0, 0,  0,  3,  1, 0, 2  % 9
 	    | 0, 0,  0,  0, 0,  0,  0,  9, 2, 0  % 10
 |];



array[1..nbrCities] of var int: cities = [C1,C2,C3,C4,C5,C6,C7,C8,C9,C10];
array[1..nbrCities] of var int: fuelPrice = [10,10,8,12,13,9,10,11,12,8];

array[1..nbrCities] of var 0..tankSize: tankIn;
array[1..nbrCities] of var 0..tankSize: fuelBought;
array[1..nbrCities] of var 0..tankSize: tankOut;
constraint tankIn[1] = 0;
var int: cost = sum (i in 1..nbrCities) (fuelBought[i] * fuelPrice[i]);

constraint forall(i in 1..nbrCities)(tankOut[i] = tankIn[i]+fuelBought[i]);
constraint forall(i in 1..nbrCities)(tankOut[i] >= costs[i,cities[i]]);
constraint forall(i in 1..nbrCities)(tankIn[cities[i]] = tankOut[i] - costs[i,cities[i]]);

constraint subcircuit(cities);

solve :: int_search(cities, input_order, indomain_min, complete) minimize cost;

output [show("Cost: "), show(cost), show("\nCities: "), show(cities)];

