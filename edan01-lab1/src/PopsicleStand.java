
import org.jacop.constraints.*;
import org.jacop.core.*;
import org.jacop.search.*;

public class PopsicleStand {
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
		int[] reqEmpl = {5,7,7,10,16,18,12};
		
		
		IntVar costVar = new IntVar(store, "Cost",0,10000);

		IntVar[] partTime = new IntVar[7];
		for(int i = 0; i < 7; i++){
			partTime[i] = new IntVar(store, "part-time-" + i, 0, reqEmpl[i]);
		}
		
		IntVar[] fullTime = new IntVar[7];
		for(int i = 0; i < 7; i++){
			fullTime[i] = new IntVar(store, "full-time-" + i, 0, reqEmpl[i]);
		}
		
		Constraint[] totalTime = new Constraint[7];
		for(int i = 0; i < 7; i++){
			totalTime[i] = new XplusYeqC(partTime[i],fullTime[i],reqEmpl[i]);
			store.impose(totalTime[i]);
		}
		
		IntVar costFullTime = new IntVar(store,"CostFullTime",0,10000);
		int[] fullWeights = {100,100,100,100,100,100,100};
		Constraint fullTimeConstraint = new SumWeight(fullTime,fullWeights,costFullTime);
		store.impose(fullTimeConstraint);
		
		IntVar costPartTime = new IntVar(store,"CostPartTime",0,10000);
		int[] partWeights = {150,150,150,150,150,150,150};
		Constraint partTimeConstraint = new SumWeight(partTime,partWeights,costPartTime);
		store.impose(partTimeConstraint);
		
		Constraint costConstraint = new XplusYeqZ(costFullTime,costPartTime,costVar);
		store.impose(costConstraint);
		
		System.out.println("Number of variables: " + store.size()
				+ "\nNumber of constraints: " + store.numberConstraints());
		
		Search<IntVar> label = new DepthFirstSearch<IntVar>();
		SelectChoicePoint<IntVar> select = new SimpleSelect<IntVar>(fullTime,
				new SmallestDomain<IntVar>(), new IndomainMin<IntVar>());
		label.setSolutionListener(new PrintOutListener<IntVar>());
		label.getSolutionListener().searchAll(true);
		boolean Result = label.labeling(store, select,costVar);
		if (Result) {
			System.out.println("\n*** Yes");
			System.out.println("Solution : " + java.util.Arrays.asList(partTime));
		} else
			System.out.println("\n*** No");
	}
}

