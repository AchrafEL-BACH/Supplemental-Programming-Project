import java.util.function.Predicate;
import java.util.Arrays;

// The object filters are premade filters facilitating the stream filter procedure.
public interface ObjectFilter extends Predicate<SaleInfo> {
  
  static ObjectFilter customerFilter(String customer){
    return object -> (object.get_customer().get_name().equals(customer));
  }
  
  static ObjectFilter storeFilter(String store){
    return object -> (object.get_store().get_name().equals(store));
  }
  
  static ObjectFilter productFilter(String product){
    return object -> (object.get_product().equals(product));
  }
  
  static ObjectFilter dateBeforeFilter(LocalDate date){
    return object -> (object.get_date().isAfter(date));
  }
  
  static ObjectFilter dateAfterFilter(LocalDate date){
    return object -> (object.get_date().isBefore(date));
  }
  
  static ObjectFilter merge(ObjectFilter... objectFilters) {
    return object -> Arrays.stream(objectFilters).filter(o -> o != null).allMatch(filter -> filter.test(object));
  }
}
