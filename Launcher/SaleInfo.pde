import java.time.format.DateTimeFormatter;
import java.time.LocalDate;
import java.util.Locale;
import java.lang.Comparable;

// The SaleInfo class is the mold of a sale entity. It stores the import data from a sale so that it could later be used.
class SaleInfo{
  Avatar customer;
  Avatar store;
  LocalDate date;
  String product;
  double price;
  double discount;
  
  SaleInfo(Avatar customer, Avatar store, String date, String product, double price, double discount){
    this.customer = customer;
    this.store = store;
    this.product = product;
    this.price = price;
    this.discount = discount;
    
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("M/d/yyyy", Locale.ENGLISH);
    this.date = LocalDate.parse(date, formatter);
  }
  
  Avatar get_customer(){
    return customer;
  }
  
  Avatar get_store(){
    return store;
  }
  
  LocalDate get_date(){
    return date;
  }
  
  String get_product(){
    return product;
  }
  
  double get_price(){
    return price;
  }
  
  double get_discount(){
    return discount;
  }
  
  @Override
  public String toString() {
    return customer.get_name() + "\t" 
      + store.get_name() + "\t"
      + date + "\t"
      + product + "\t"
      + price + "\t"
      + discount;
  }
}
