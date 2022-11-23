import java.util.stream.Stream;
// The filtering tool's purpose is to create a subset of sales according to some attribute values

static class FilteringTool {
  static ObjectFilter customerFilter;  //Custom filters/Predicates are used to save time on conversion and increase the readability of the code
  static ObjectFilter storeFilter;
  static ObjectFilter productFilter;
  static ObjectFilter dateFilter;
  
  static void setCustomerFilter(String customer){
    if(!customer.equals("")) customerFilter = ObjectFilter.customerFilter(customer);
    else customerFilter = null;
  }
  
  static void setStoreFilter(String store){
    if(!store.equals("")) storeFilter = ObjectFilter.storeFilter(store);
    else storeFilter = null;
  }
  
  static void setProductFilter(String product){
    if(!product.equals("")) productFilter = ObjectFilter.productFilter(product);
    else productFilter = null;
  }
  
  static void setDateFilter(String lower, String upper){
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("M/d/yyyy", Locale.ENGLISH);
    LocalDate before = LocalDate.parse(lower, formatter);
    LocalDate after = LocalDate.parse(upper, formatter);
    dateFilter = ObjectFilter.merge(
     ObjectFilter.dateBeforeFilter(before),
     ObjectFilter.dateAfterFilter(after)
    );
  }
  
  static SaleInfo[] getFilterResults(SaleInfo[] objects, Comparator<SaleInfo>... sortBy){ //Merge of the filter and sort functions
    Stream<SaleInfo> sales = Arrays.stream(objects).filter(ObjectFilter.merge(customerFilter, storeFilter, productFilter, dateFilter));
    customerFilter = null;
    storeFilter = null;
    productFilter = null;
    dateFilter = null;
    if(sortBy.length > 0) sales = sales.sorted(sortBy[0]); //This step was added to prevent a useless stream to array to stream to array transformation when we filter and sort an array.
    return sales.toArray(SaleInfo[]::new);        //Return an arry of object filtered then sorted according to the given parameters
  }
}
