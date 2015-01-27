
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
		int[] requiredEmployees = {5,7,7,10,16,18,12};
		String[] days = {"mon","tue","wed","thu","fri","sat","sun"};
		
		IntVar costVar = new IntVar(store, "Cost",0,10000);

		//All variables in an array to send in to the search
		IntVar[] allVars = new IntVar[21];
		
		//Defines the number of workers that starts working part-time on each day
		IntVar[] startsPartTime = new IntVar[7];
		for(int i = 0; i < 7; i++){
			startsPartTime[i] = new IntVar(store, "start-part-time-" + days[i], 0, 25);
			allVars[i] = startsPartTime[i];
		}
		
		//Defines the number of workers that starts working full-time on each day
		IntVar[] startsFullTime = new IntVar[7];
		for(int i = 0; i < 7; i++){
			startsFullTime[i] = new IntVar(store, "start-full-time-" + days[i], 0, 25);
			allVars[7+i] = startsFullTime[i];
		}
		
		//Defines the number of workers that is  required to work each day
		IntVar[] reqEmpl = new IntVar[7];
		for(int i = 0; i < 7; i++){
			reqEmpl[i] = new IntVar(store, "required-" + days[i], requiredEmployees[i], 25);
			allVars[14+i] = reqEmpl[i];
		}
		
		
		for(int i = 0; i < 7; i++){
			store.impose(new Sum(new IntVar[] {startsFullTime[i],startsFullTime[(i+1)%7],startsFullTime[(i+2)%7],startsFullTime[(i+3)%7],startsPartTime[(i+3)%7],startsFullTime[(i+4)%7],startsPartTime[(i+4)%7]},reqEmpl[(i+4)%7]));
		}
		
		IntVar costFullTime = new IntVar(store,"CostFullTime",0,10000);
		int[] fullWeights = {500,500,500,500,500,500,500};
		Constraint fullTimeConstraint = new SumWeight(startsFullTime,fullWeights,costFullTime);
		store.impose(fullTimeConstraint);
		
		IntVar costPartTime = new IntVar(store,"CostPartTime",0,10000);
		int[] partWeights = {300,300,300,300,300,300,300};
		Constraint partTimeConstraint = new SumWeight(startsPartTime,partWeights,costPartTime);
		store.impose(partTimeConstraint);
		
		Constraint costConstraint = new XplusYeqZ(costFullTime,costPartTime,costVar);
		store.impose(costConstraint);
		
		System.out.println("Number of variables: " + store.size()
				+ "\nNumber of constraints: " + store.numberConstraints());
		
		Search<IntVar> label = new DepthFirstSearch<IntVar>();
		SelectChoicePoint<IntVar> select = new SimpleSelect<IntVar>(allVars,
				new SmallestDomain<IntVar>(), new IndomainMin<IntVar>());
		label.setSolutionListener(new PrintOutListener<IntVar>());
		label.getSolutionListener().searchAll(true);
		boolean Result = label.labeling(store, select,costVar);
		if (Result) {
			System.out.println("\n*** Yes");
			System.out.println("Solution : " + java.util.Arrays.asList(allVars));
		} else
			System.out.println("\n*** No");
	}
}

