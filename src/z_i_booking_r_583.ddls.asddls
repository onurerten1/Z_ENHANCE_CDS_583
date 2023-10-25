@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Condumption view from /DMO/I_BOOKING_U'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity Z_I_Booking_R_583
  as select from /DMO/I_Booking_U as Booking
  association to parent Z_I_Travel_R_583 as _Travel on $projection.TravelID = _Travel.TravelID
{
  key TravelID,
  key BookingID,
      BookingDate,
      CustomerID,
      AirlineID,
      ConnectionID,
      FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      FlightPrice,
      CurrencyCode,

      @Semantics.quantity.unitOfMeasure: 'DistanceUnit'
      _Connection.Distance     as Distance,
      _Connection.DistanceUnit as DistanceUnit,
      case
        when _Connection.Distance >= 2000 then 'long-haul flight'
        when _Connection.Distance >= 1000 and
                _Connection.Distance <  2000 then 'medium-haul flight'
        when _Connection.Distance <  1000 then 'short-haul flight'
        else 'error'
      end                      as Flight_type,



      /* Associations */
      _BookSupplement,
      _Carrier,
      _Connection,
      _Customer,
      _Travel
}
where
  _Connection.DistanceUnit = 'KM';
