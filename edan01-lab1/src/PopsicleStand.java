
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

		//Defines the number of workers that starts working part-time on each day
		IntVar[] startsPartTime = new IntVar[7];
		for(int i = 0; i < 7; i++){
			startsPartTime[i] = new IntVar(store, "start-part-time-" + days[i], 0, requiredEmployees[i]);
		}
		
		//Defines the number of workers that starts working full-time on each day
		IntVar[] startsFullTime = new IntVar[7];
		for(int i = 0; i < 7; i++){
			startsFullTime[i] = new IntVar(store, "start-full-time-" + days[i], 0, requiredEmployees[i]);
		}
		
		
		//Defines the number of workers that is working part-time on each day
		IntVar[] worksPartTime = new IntVar[7];
		for(int i = 0; i < 7; i++){
			worksPartTime[i] = new IntVar(store, "work-part-time-" + days[i], 0, requiredEmployees[i]);
		}
		
		//Defines the number of workers that is working full-time on each day
		IntVar[] worksFullTime = new IntVar[7];
		for(int i = 0; i < 7; i++){
			worksFullTime[i] = new IntVar(store, "work-part-time-" + days[i], 0, requiredEmployees[i]);
		}
		
		//All variables in an array to send in to the search
		IntVar[] allVars = new IntVar[28];
		for(int i = 0;i < 7; i++){
			allVars[i] = startsPartTime[i];
		}
		for(int i = 0;i < 7; i++){
			allVars[7+i] = startsFullTime[i];
		}
		for(int i = 0;i < 7; i++){
			allVars[14+i] = worksPartTime[i];
		}
		for(int i = 0;i < 7; i++){
			allVars[21+i] = worksFullTime[i];
		}
		
		
		for(int i = 0; i < 7; i++){
			store.impose(new Sum(new IntVar[] {startsPartTime[i],startsPartTime[(i+1)%7]},worksPartTime[(i+1)%7]));
		}
		
		for(int i = 0; i < 7; i++){
			store.impose(new Sum(new IntVar[] {startsFullTime[i],startsFullTime[(i+1)%7],startsFullTime[(i+2)%7],startsFullTime[(i+3)%7],startsFullTime[(i+4)%7]},worksFullTime[(i+4)%7]));
		}
		
		for(int i = 0; i < 7; i++){
			store.impose(new XplusYeqC(worksPartTime[i],worksFullTime[i],requiredEmployees[i]));
		}
		
		IntVar costFullTime = new IntVar(store,"CostFullTime",0,10000);
		int[] fullWeights = {100,100,100,100,100,100,100};
		Constraint fullTimeConstraint = new SumWeight(worksFullTime,fullWeights,costFullTime);
		store.impose(fullTimeConstraint);
		
		IntVar costPartTime = new IntVar(store,"CostPartTime",0,10000);
		int[] partWeights = {150,150,150,150,150,150,150};
		Constraint partTimeConstraint = new SumWeight(worksPartTime,partWeights,costPartTime);
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

