import org.jacop.constraints.*;
import org.jacop.core.*;
import org.jacop.search.*;

public class GoodBurger {
	public static void main(String[] args) {
		long T1, T2, T;
		T1 = System.currentTimeMillis();
		send();
		T2 = System.currentTimeMillis();
		T = T2 - T1;
		System.out.println("\n\t*** Execution time = " + T + " ms");
	}

	static void send() {
		Store store = new Store();
		
		int sodium[] = {50,330,310,1,260,3,160,3};
		int fat[] = {17,9,6,2,0,0,0,0};
		int cals[] = {220,260,70,10,5,4,20,9};
		int cost[] = {-25,-15,-10,-9,-3,-4,-2,-4};

		IntVar[] v = new IntVar[8];
		
		for(int i = 0;i<8; i++){
			v[i] = new IntVar(store,"i"+i,1,5);
		}
		
		IntVar sodVar = new IntVar(store, "Sodium sum",0,3000);
		Constraint sod = new SumWeight(v,sodium,sodVar);
		store.impose(sod);
		
		IntVar fatVar = new IntVar(store, "Fat sum",0,150);
		Constraint fatc = new SumWeight(v,fat,fatVar);
		store.impose(fatc);
		
		IntVar calVar = new IntVar(store, "Calories sum",0,3000);
		Constraint cal = new SumWeight(v,cals,calVar);
		store.impose(cal);
		
		IntVar costVar = new IntVar(store, "Cost sum",-1000,0);
		Constraint totCost = new SumWeight(v,cost,costVar);
		store.impose(totCost);
		
		Constraint ketchup = new XeqY(v[5],v[6]);
		store.impose(ketchup);
		
		Constraint pickles = new XeqY(v[4],v[7]);
		store.impose(pickles);
		
		
		
		System.out.println("Number of variables: " + store.size()
				+ "\nNumber of constraints: " + store.numberConstraints());
		
		
		
		Search<IntVar> label = new DepthFirstSearch<IntVar>();
		SelectChoicePoint<IntVar> select = new SimpleSelect<IntVar>(v,
				new SmallestDomain<IntVar>(), new IndomainMin<IntVar>());
		label.setSolutionListener(new PrintOutListener<IntVar>());
		label.getSolutionListener().searchAll(true);
		boolean Result = label.labeling(store, select, costVar);
		if (Result) {
			System.out.println("\n*** Yes");
			System.out.println("Solution : " + java.util.Arrays.asList(v));
		} else
			System.out.println("\n*** No");
	}
}
