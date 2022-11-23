import java.util.Comparator;

// The SortingTool allows the user to order the sales collection to their preference.
public interface SortingTool extends Comparator<SaleInfo>{
  Comparator<SaleInfo> compareByCustomer = Comparator.comparing(SaleInfo::get_customer, (o1, o2) -> o1.get_name().toLowerCase().compareTo(o2.get_name().toLowerCase()));
  Comparator<SaleInfo> compareByStore = Comparator.comparing(SaleInfo::get_store, (o1, o2) -> o1.get_name().compareTo(o2.get_name()));
  Comparator<SaleInfo> compareByProduct = Comparator.comparing(SaleInfo::get_product, (o1, o2) -> o1.compareTo(o2));
  Comparator<SaleInfo> compareByDate = Comparator.comparing(SaleInfo::get_date, (o1, o2) -> o1.compareTo(o2));
  Comparator<SaleInfo> compareByPrice = Comparator.comparing(SaleInfo::get_price, (o1, o2) -> o1.compareTo(o2));
  ArrayList<Comparator<SaleInfo>> comparators = new ArrayList(){
    {
      add(compareByCustomer);
      add(compareByStore);
      add(compareByProduct);
      add(compareByDate);
      add(compareByPrice);
    }
  };
  
  static final int CUSTOMER = 0;
  static final int STORE = 1;
  static final int PRODUCT = 2;
  static final int DATE = 3;
  static final int PRICE = 4;
  
  static Comparator<SaleInfo> sortBy(int... keys){
    Comparator<SaleInfo> comparator = comparators.get(keys[0]);
    for(int i = 1; i < keys.length; i++){
      comparator = comparator.thenComparing(comparators.get(keys[i]));
    }
    return comparator;
  }
}
