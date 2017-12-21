import java.util.LinkedList;
import java.util.Queue;
import java.util.Stack;

class Calculator {

	class Led{ //Dummy class for LEDs
		void lightup(){
			
		}
	}
	
	class ButtonSet{ //Class for all buttons
		int val=0; //used for buttons 0-9
		String value=""; //used for operator buttons
		boolean isPressed=false;;
	}
	
	int current_index=0; //pointer to current variable location
	boolean[] isValid=new boolean[10]; //track of if variables have been assigned
	int[] variables=new int[10];
	int current=0; //value of current variable
	Queue<String> inp=new LinkedList<String>(); 
	Led right_led=new Led();
	Led left_led=new Led();
	ButtonSet black1=new ButtonSet();
	ButtonSet black2=new ButtonSet();
	ButtonSet number=new ButtonSet();
	ButtonSet operator=new ButtonSet();
	ButtonSet recall1=new ButtonSet();
	ButtonSet recall2=new ButtonSet();
	int x;//Current coordinates on LCD screen
	int y;//Current coordinates on LCD screen

	void BluePressed(){
		if (number.isPressed) { //number is defined as the set of buttons corresponding to [0-9]
			int buffer=0;;
			while (number.isPressed){
				display_int(number.val,x,y);
				buffer=10*buffer+number.val; // in case multiple numbers are pressed consecutively concatenate them
			}
			inp.offer(String.valueOf(buffer));
			display_int(buffer,x,y);
		}
		else if (operator.isPressed) { //operator is defined as the set of buttons corresponding to +,-,/,*
			inp.offer(operator.value);
			display_string(operator.value,x,y);
		}
		else if (recall1.isPressed){ //<-pressed
			recall(1);
		}
		else if (recall2.isPressed){ //->pressed
			recall(2);
		}
		else assign();
	}

	void BlackPressed(){
		if (black1.isPressed){ //right black button pressed
			current_index++;
			display8(current_index);
		}
		else if (black2.isPressed){ //left black button pressed
			current_index--;
			display8(current_index);
		}
	}

	void assign(){
		variables[current]=evaluate_expression(inp);
	}

	void recall(int i){
		if (i==1){ //if <- is pressed
			int z=current_index-1;
			if (isValid[z]){
				display_int(variables[z],x,y); //display on LCD screen
			}
			else {
				left_led.lightup(); // light up led if invalid value recalled
			}
		}
		else if (i==2){ //if -> is pressed
			int z=current_index+1;
			if (isValid[z]){
				display_int(variables[z],x,y);  //display on LCD screen
			}
			else {
				left_led.lightup(); // light up led if invalid value recalled
			}
		}
	}

	void clear_scrn(){
		//Clears the LCD screen
	}

	void display_int(int i,int x,int y){
		//display integer on LCD from position (x,y)
		x++;
		if (x>40){
			x=0;  //switch lines if x reaches end of a line
			y++;
		}
		if (y>15){ //clear screen and start from the top
			y=0;
			x=0;
			clear_scrn();
		}
	}

	void display_string(String s,int x,int y){
		//display string on LCD from position (x,y)
		x=x+s.length();
		if (x>40){
			x=0;
			y++;
		}
		if (y>15){ //clear screen and start from the top
			y=0;
			x=0;
			clear_scrn();
		}
	}

	void display8(int i){
		//displays integer on 8 segment display
	}

	void lightup(Led led){
		//lights up LED
	}

	int Eval(int a,int b,String c){
		int x = 0;
		//Evaluate result of a binary operation x= a c b
		switch(c){
			case "+":
			x=a+b;
			break;
			case "-":
			x=a-b;
			break;
			case "*":
			x=a*b;
			break;
			case "/":
			x=a/b;
			break;
		}
		return x;
	}

	int Eval(int a,String c){
		int x = 0;
		//Evaluate result of a binary operation x= c a
		switch(c){
			case "+":
			x=a;
			break;
			case "-":
			x=0-a;
			break;
		}
		return x;
	}

	boolean isBinary(String c){
		//to check if c is binary operator, should exclude cases of +,- unary
		return c.equals("*")|c.equals("/")|c.equals("+")|c.equals("-");
	}

	boolean isOverflow(int x){
		//return true in case of integer overflow
		return false;
	}
	
	int priority(String c){
		//assign priority to the operators(binary ones)
		switch(c){
		case "+":
		return 1;
		case "-":
		return 0;
		case "*":
		return 2;
		case "/":
		return 3;
		}
		return 0;
	}

	Queue<String> inp_to_infix(Queue<String> in){
		//convert input to postfix evaluatable form
		Queue<String> q=new LinkedList<String>();
		Stack<String> temp=new Stack<String>();
		while (!in.isEmpty()){
			String c=in.poll();
			if (c.matches("[0-9]")){
				q.offer(c);
				//enqueue numbrs directly
			}
			else{
				//push operators onto stack
				if (temp.empty()){
					temp.push(c);
				}
				else{
					//check clash of operators
					if (priority(temp.peek())>=priority(c)){
						while (!temp.empty()){
							if (priority(temp.peek())>=priority(c)){
								//put operators into queue
								q.offer(temp.pop());
							}
							else{
								break;
							}
						}
						temp.push(c);
					}
					else{
						temp.push(c);
					}
				}
			}
		}
		return q;
	}

	int evaluate_expression(Queue<String> in){
		//evaluate expression via postfix method using extra stack
		int eval = 0;
		Queue<String> infix=inp_to_infix(in);
		Stack<String> pfix=new Stack<String>();

		while (!infix.isEmpty()){
			String c=infix.poll();
			if (c.matches("[0-9]")){
				pfix.push(c); // if c is a number push into stack
			}
			else{
				if (isBinary(c)){ //operate binary operator
					int a=Integer.parseInt(pfix.pop());
					int b=Integer.parseInt(pfix.pop());
					String x=String.valueOf(Eval(a,b,c)); //repush result in to stack
					pfix.push(x);
				}
				else{ //evaluate unary operator
					int a=Integer.parseInt(pfix.pop());
					int x=Eval(a,c);
					pfix.push(String.valueOf(x));
				}
			}
		eval=Integer.parseInt(pfix.pop());
		}
		//evaluate the stored expression store in eval
		if (isOverflow(eval)){
			lightup(right_led); //light up right led if eval records an overflow
		}
		return eval;
	}

	int divide(int a, int b){
		//divide a by b
		return a/b;
	}

	public static void main(String[] args){//main loop to respond to button presses
		Calculator c=new Calculator();
		while (true){
			c.BlackPressed();
			c.BluePressed();
			break;			
		}
	}
}