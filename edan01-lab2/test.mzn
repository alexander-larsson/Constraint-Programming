% Ex2 for course edan01
% Made by ada10lgu and ada07cli
% Made: 2014-03-07

include "globals.mzn";

int: number_of_cities = 10;

var {2,3}: C1;       % Path 1 -> 1 is ignored to force 1 to be in the subcircuit.
var {2,3,4}: C2;
var {2,3,5,6}: C3;
var {2,4,5,6,7}: C4;
var {3,4,5,7}: C5;
var {3,4,6,8}: C6;
var {4,5,7,8,9}: C7;
var {6,7,8,9,10}: C8;
var {7,8,9,10}: C9;
var {1}: C10;         % City 10 is the only one that can lead to city 1 to force a subcircuit where both 1 and 10 is included.

array[1..number_of_cities,1..number_of_cities] of var int: costs;
constraint forall(i in 1..number_of_cities) (costs[i,i] = 0);
constraint costs[1,2] = 10;
constraint costs[1,3] = 11;
constraint costs[1,4] = 6;
constraint costs[2,3] = 5;
constraint costs[2,4] = 8;
constraint costs[3,5] = 3;
constraint costs[3,6] = 5;
constraint costs[4,5] = 2;
constraint costs[4,6] = 6;
constraint costs[4,7] = 7;
constraint costs[5,7] = 12;
constraint costs[6,8] = 14;
constraint costs[7,8] = 5;
constraint costs[7,9] = 3;
constraint costs[8,9] = 1;
constraint costs[8,10] = 9;
constraint costs[9,10] = 2;
constraint costs[2,1] = 10;
constraint costs[3,1] = 11;
constraint costs[4,1] = 6;
constraint costs[3,2] = 5;
constraint costs[4,2] = 8;
constraint costs[5,3] = 3;
constraint costs[6,3] = 5;
constraint costs[5,4] = 2;
constraint costs[6,4] = 6;
constraint costs[7,4] = 7;
constraint costs[7,5] = 12;
constraint costs[8,6] = 14;
constraint costs[8,7] = 5;
constraint costs[9,7] = 3;
constraint costs[9,8] = 1;
constraint costs[10,8] = 9;
constraint costs[10,9] = 2;

% This cost does not exist in the original graph but is needed to be able to create a subcircuit without altering the cost.
constraint costs[10,1] = 0; 




% gas_bought  consists of the amount of gas bought in a given city.
% tank        consists of the amount of gas we had when arriving to a given city.
% tankLeaving consists of the amount of gas we had when leaving a given ciry (gas_bought + tank).
array[1..number_of_cities] of var int: cities = [C1,C2,C3,C4,C5,C6,C7,C8,C9,C10];
array[1..number_of_cities] of var int: gas_cost = [10,10,8,12,13,9,10,11,12,8];
array[1..number_of_cities] of var 0..15: tank;
constraint tank[1] = 0;
array[1..number_of_cities] of var 0..15: gas_bought;
var int: cost = sum(i in 1..number_of_cities)(gas_cost[i]*gas_bought[i]);
array[1..number_of_cities] of var 0..15: tankLeaving;
constraint forall(i in 1..number_of_cities)(tankLeaving[i] = tank[i] + gas_bought[i]);
constraint forall(i in 1..number_of_cities)(tankLeaving[i] >= costs[i,cities[i]]);
constraint forall(i in 1..number_of_cities) (tank[cities[i]] = tankLeaving[i] - costs[i,cities[i]]);

constraint subcircuit(cities);
solve minimize(cost);


output [show("Cost:\t\t"),show(cost),show("\nSubcircuit:\t"),show(cities)];
