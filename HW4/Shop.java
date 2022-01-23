import java.io.*;
import java.sql.*;
import java.util.Scanner;

class Shop{
	public static final String oracleServer="dbs3.cs.umb.edu";
	public static final String oracleServerSid= "dbs3";
	public static void main(String args[]){
		Connection conn = null;
		conn = getConnection();
		if (conn == null)
			System.exit(1);

		Scanner input = new Scanner(System.in);
		try{
		
			System.out.print("\nEnter a valid customer id= ");
			int custId = input.nextInt();
			if(custId ==-1){
				System.out.println("*************** Add New Customer Menu **************");
				System.out.print("\nPlease enter a valid numeric customerId: ");
				Scanner customerId = new Scanner(System.in);
				int cid = customerId.nextInt();
				System.out.print("Please enter the name of customer: ");
				Scanner nameIn = new Scanner(System.in);
				String name = nameIn.nextLine();
				System.out.print("Please enter the customer budget: ");
				Scanner budgetIn = new Scanner(System.in);
				int budget = budgetIn.nextInt();
				PreparedStatement stmt= conn.prepareStatement("insert into customers values(?,?,?)");
				stmt.setInt(1,cid);
				stmt.setString(2,name);
				stmt.setInt(3,budget);
				int i=stmt.executeUpdate();
				System.out.println(i+ " New customer addded!");
				custId = cid;
			}

			PreparedStatement stm = conn.prepareStatement("select cid, name from customers" + " where cid=" + custId);
		        ResultSet cs = stm.executeQuery();
		       	if(cs.next()){
				do{
					System.out.println("\nCID: " + cs.getInt("cid") + " ,NAME: " + cs.getString("name"));
				}while(cs.next());
			}
			else{
				System.out.println("No records retrieved");
				System.out.println("Please try again with valid customer id");
				Scanner validIdIn = new Scanner(System.in);
				System.out.print("Enter a customer id: ");
				int validId = validIdIn.nextInt();
				custId = validId;
				PreparedStatement s = conn.prepareStatement("select cid, name from customers" + " where cid=" + validId);
				ResultSet r=s.executeQuery();
				if(r.next()){
					do{
						System.out.println("\nCID: " + r.getInt("cid") + " ,NAME: " + r.getString("name"));
					}while(r.next());
				}
			}
			   while(true){
				System.out.println("\n-------------------------------------------------------------------------------"); 
				System.out.println("1. Press P to display all products");
				System.out.println("2. Press O to place the order of product");
				System.out.println("3. Press R to return the product");
				System.out.println("4. Press S to search the product in the database");
				System.out.println("5. Press E to calculate the expenditure of customer");
				System.out.println("6. Press C to list the current budget of the cutsomer");
				System.out.println("7. Press X to exit the application");
				System.out.print("\nEnter any of the above choice: ");
				Scanner inp = new Scanner(System.in);
				String choice = inp.nextLine();
				if(choice.equals("X")){
					System.exit(1);
				}
				if(choice.equals("P")){
					System.out.println("*************** Displaying All Products ****************");
					PreparedStatement stmt = conn.prepareStatement("select * from products");
					ResultSet products = stmt.executeQuery();
					if(products.next()){
						do{
							
							System.out.println("PID: " + products.getString("pid") + ", NAME: " + products.getString("name") + ", PRICE: " + 								products.getString("price"));
						}while(products.next());
					}
				}
				if(choice.equals("O")){
					System.out.println("******************* Order Menu *******************");
					Scanner idIn = new Scanner(System.in);
					Scanner quantityIn = new Scanner(System.in);
			
					System.out.print("Enter the product id: ");
					int id = idIn.nextInt();
					System.out.print("Enter the quantity you want to order: ");
					int quantity = quantityIn.nextInt();
					PreparedStatement PS = conn.prepareStatement("select p.price, c.budget from products p, customers c " + "where p.pid= " + id + " and c.cid= " + custId );		
				       
					ResultSet order = PS.executeQuery();	
					if(order.next()){
				       		do{
						    System.out.println(" TOTAL PRICE: " +  order.getInt("price")*quantity + " BUDGET: " + order.getInt("budget") );
						    int totalPrice = order.getInt("price")*quantity;
						    int budget = order.getInt("budget");
						    int ans = budget - totalPrice;
						    PreparedStatement stmt= conn.prepareStatement("update customers set budget=? where cid=? ");
						    stmt.setInt(1,ans); 
						    stmt.setInt(2,custId);
						    int x = stmt.executeUpdate();
						    PreparedStatement s = conn.prepareStatement("insert into sales values(?,?,?)");
						    s.setInt(1,id);
						    s.setInt(2,custId);
						    s.setInt(3,quantity);
						    int i =s.executeUpdate();
						   // System.out.println(i+" records updated");  
						    System.out.println(" AFTER THE ORDER NEW BUDGET IS: " + (budget - totalPrice));
						}while(order.next());
				       }	
				}
				if(choice.equals("R")){
					System.out.println("****************** Return A Product Menu *****************");
					Scanner idIn = new Scanner(System.in);
					System.out.print("Enter the  product id to return your product: ");
					int productId = idIn.nextInt();
					PreparedStatement PS = conn.prepareStatement("select p.price, c.budget from products p, customers c " + "where p.pid= "+ productId + " and c.cid= " + custId);
					ResultSet ret = PS.executeQuery();      
				        PreparedStatement PStmt = conn.prepareStatement("select s.pid, s.cid from sales s where s.pid= " + productId +" and s.cid =" + custId);
			       		ResultSet trs = PStmt.executeQuery();
			 		if(trs.next()){		
					if(ret.next()){
						do{
						    System.out.println(" PRICE OF PRODUCT: " + ret.getInt("price") + " , BUDGET OF CUSTOMER: " + ret.getInt("budget"));
						    int price = ret.getInt("price");
						    int budget = ret.getInt("budget");
						    PreparedStatement stmt = conn.prepareStatement("update customers set budget=? where cid=? ");
						    stmt.setInt(1,budget + price);
						    stmt.setInt(2,custId);
						    int x = stmt.executeUpdate();
						    System.out.println(x + " record updated");
						    System.out.println("UPDATED BUDGET OF CUSTOMER: " + custId + " is " + (price+budget));
	 
						}while(ret.next());
					}}
					else
						System.out.println("User has not purchased any product with ID: " + productId);	
				}
				if(choice.equals("E")){
					System.out.println("******************* Expenditure of Customer Menu ******************");
					PreparedStatement PS = conn.prepareStatement("select s.pid, s.quantity from sales s where s.cid= " + custId);
					ResultSet exp = PS.executeQuery();
					if(exp.next()){
						do{
							//System.out.println("PID: " + exp.getInt("pid") +  " , QUANTITY: " + exp.getInt("quantity"));
							int pid = exp.getInt("pid");
							int quantity = exp.getInt("quantity");
							PreparedStatement stmt = conn.prepareStatement("select p.price, p.name from products p where p.pid= " + pid);
							ResultSet prod = stmt.executeQuery();
							if(prod.next()){
								do{
									System.out.println("PID: " + pid + ", NAME: " + prod.getString("name") + ", EXPENDITURE: " + quantity * prod.getInt("price"));
								}while(prod.next());
							}
						}while(exp.next());
					}
					else
						System.out.println("No orders from the customer with ID " + custId + " so expenditure is 0");
				
				}
				if(choice.equals("C")){
					System.out.println("********************* Current Budget Menu *********************");
					PreparedStatement PS = conn.prepareStatement("select c.budget from customers c where c.cid = " + custId);
					ResultSet currentBudget = PS.executeQuery();
					if(currentBudget.next()){
						do{
							System.out.println("The current budget of customer id " + custId + " is " + currentBudget.getInt("budget"));
						}while(currentBudget.next());
					}
				}
				if(choice.equals("S")){
					System.out.println("******************** Product Search Menu *********************");
					Scanner productIn = new Scanner(System.in);
					System.out.println("NOTE: The starting characters must be in LOWER CASE");
					System.out.print("Enter the starting characters of the Product name: ");
					String first = productIn.nextLine();
					PreparedStatement stmt = conn.prepareStatement("select p.name from products p where p.name like '" + first + "_%'");
					ResultSet trs = stmt.executeQuery();
					if(trs.next()){
						do{
							System.out.println("NAME: " + trs.getString("name"));
						}while(trs.next());		
					}

				
				}

		  	 }
		}
		
		catch(SQLException e){
			System.out.println("Error Occured");
		}
	}
		
	
	public static Connection getConnection(){
		String jdbcDriver = "oracle.jdbc.OracleDriver";
		try{
			Class.forName(jdbcDriver);
		}
		catch(Exception e){
			e.printStackTrace();
		}

		Scanner input = new Scanner(System.in);
		System.out.print("Username: ");
		String username = input.nextLine();
		System.out.print("Password: ");
		Console console = System.console();
		String password = new String(console.readPassword());
		String connString = "jdbc:oracle:thin:@" + oracleServer + ":1521:"+ oracleServerSid;
		System.out.println("Connecting to the database...");
		Connection conn;
		try{
			conn = DriverManager.getConnection(connString, username, password);
			System.out.println("Connection Successful");
		}
		catch (Exception e){
			System.out.println("Connection Error");
			e.printStackTrace();
			return null;
		}
		return conn;
	} 

}
