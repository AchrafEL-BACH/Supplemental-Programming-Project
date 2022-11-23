// The parsing tool creates a collection of sales object from a data text file.

class ParsingTool {
  ArrayList<SaleInfo> objectList;
  
  HashMap<String, Avatar> customers;    //A list of all indivdual customers with their respective graphical representation
  HashMap<String, Avatar> stores;       //A list of all indivdual stores with their respective graphical representation
  HashMap<String, Avatar> products;     //A list of all indivdual products with their respective graphical representation
  HashMap<String, ArrayList<Avatar>> storeToCustomer;    //A list of all the customers associated with each stores (i.e. that have made at least one purchase in the store)
  
  ParsingTool (String filePath){
    objectList = new ArrayList();
    customers = new HashMap();
    stores = new HashMap();
    products = new HashMap();
    storeToCustomer = new HashMap<String, ArrayList<Avatar>>(){
      public ArrayList<Avatar> get(Object key) {                  //We override the get method of the HashMap class to prevent an NullPointerException when retrieving and trying to process an Entry
        ArrayList<Avatar> list = super.get(key);
        if(list==null && key instanceof String) super.put((String)key, list = new ArrayList<Avatar>());
        return list;
      }
    };
    String[] lines = loadStrings(filePath);
    for(int i = 1; i < lines.length; i++){
      String[] sale = lines[i].split("\t");
      Avatar customer, store;
      
      if (customers.containsKey(sale[0])){
        customer = customers.get(sale[0]);
      }else{
        customer = new Avatar(0, sale[0]);
        customers.put(sale[0], customer);
      }
      
      if (stores.containsKey(sale[1])){
        store = stores.get(sale[1]);
      }else{
        store = new Avatar(1, sale[1]);
        stores.put(sale[1], store);
      }
      if(!products.containsKey(sale[3])) products.put(sale[3], new Avatar(2, sale[3]));
      
      if(!storeToCustomer.get(sale[1]).contains(customer)) storeToCustomer.get(sale[1]).add(customer);
      objectList.add(new SaleInfo(customer, store, sale[2], sale[3], Double.parseDouble(sale[4]), Double.parseDouble(sale[5]))); //<>//
    }
  }
  
  ArrayList<Avatar> get_customers(){
    return new ArrayList<>(customers.values());
  }
  
  ArrayList<Avatar> get_stores(){
    return new ArrayList<>(stores.values());
  }
  
  ArrayList<Avatar> get_products(){
    return new ArrayList<>(products.values());
  }
  
  ArrayList<Avatar> get_storeCustomerList(String storeName){
    return storeToCustomer.get(storeName);
  }
  
  SaleInfo[] get_sales(){
    return objectList.toArray(new SaleInfo[0]);
  }
}
