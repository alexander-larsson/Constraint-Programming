include "globals.mzn";

int: N; % number of cities
array[1..N] of set of int: edges;
array[1..N, 1..N] of int: distance;
array[1..N] of int: price;
int: tank_capacity;
int: start;
int: end;

array[1..N] of var 1..N: cities;

constraint cities[start] in edges[start];
constraint forall(i in 2..(N-1)) (cities[i] in (edges[i] union {i}));
constraint cities[end] in (edges[end] union {start});

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

