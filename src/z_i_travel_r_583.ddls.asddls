@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel Model Entity - Read Only'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity Z_I_Travel_R_583
  as select from /DMO/I_Travel_U as Travel
  composition [0..*] of Z_I_Booking_R_583 as _Booking
  association [1..1] to /DMO/I_Agency   as _Agency   on $projection.AgencyID = _Agency.AgencyID
  association [1..1] to /DMO/I_Customer as _Customer on $projection.CustomerID = _Customer.CustomerID
{

  key TravelID,
      @ObjectModel.text.association: '_Agency'
      AgencyID,
      @ObjectModel.text.association: '_Customer'
      CustomerID,
      BeginDate,
      EndDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      BookingFee,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      TotalPrice,
      CurrencyCode,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
      Memo,
      Status,
      LastChangedAt,

      concat_with_space(_Customer.Title, _Customer.LastName, 1) as Addressee,
      //Conversion to USD
      cast( 'USD' as abap.cuky )                                as TargetCurrency,
      @Semantics.amount.currencyCode: 'TargetCurrency'
      currency_conversion(
      amount => TotalPrice,
      source_currency => CurrencyCode,
      round => 'X',
      target_currency => cast('USD' as abap.cuky( 5 )),
      exchange_rate_date => $session.system_date,
      error_handling => 'SET_TO_NULL' )                         as PriceInUSD,



      /* Associations */
      _Agency,
      _Booking,
      _Currency,
      _Customer,
      _TravelStatus
}
