using com.logali as logali from '../db/schema';
using com.training as training from '../db/training';

//cds deploy --to sqlite:db/Alberto
//http://erp13.sap4practice.com:9037/sap/opu/odata/sap/YSAPUI5_SRV_01/$metadata
//npm i @sap-cloud-sdk/http-client
//@cap-js/graphql
//cds-swagger-ui-express

define service CatalogService {

    entity Products          as
        select from logali.Products {
            ID,
            Name          as ProductName     @mandatory,
            Description                      @mandatory,
            ImageUrl,
            ReleaseDate,
            DiscontinuedDate,
            @mandatory
            Price,
            Height,
            Width,
            Depth,
            @(
                mandatory,
                assert.range : [
                    0.00,
                    20.00
                ]
            )
            Quantity,
            UnitOfMeasure as ToUnitOfMeasure @mandatory,
            Currency      as ToCurrency      @mandatory,
            Currency.ID   as CurrencyId,
            Category      as ToCategory      @mandatory,
            Category.ID   as CategoryId,
            Category.Name as Category        @readonly,
            DimensionUnit as ToDimensionUnit,
            SalesData,
            Supplier,
            Reviews,
            Rating,
            StockAvailability,
            ToStockAvailability
        };

    @readonly
    entity Supplier          as
        select from logali.Suppliers {
            ID,
            Name,
            Email,
            Phone,
            Fax,
            Product as ToProduct
        };

    entity Reviews           as
        select from logali.ProductReview {
            ID,
            Name,
            Rating,
            Comment,
            createdAt,
            Product as ToProduct
        };

    @readonly
    entity SalesData         as
        select from logali.SalesData {
            ID,
            DeliveryDate,
            Revenue,
            Currency.ID               as CurrencyKey,
            DeliveryMonth.ID          as DeliveryMonthId,
            DeliveryMonth.Description as DeliveryMonth,
            Product                   as ToProduct
        };

    @readonly
    entity StockAvailability as
        select from logali.StockAvailability {
            ID,
            Description,
            Product as ToProduct
        };

    @readonly
    entity VH_Categories     as
        select from logali.Categories {
            ID   as Code,
            Name as Text
        };

    @readonly
    entity VH_Currencies     as
        select from logali.Currencies {
            ID          as Code,
            Description as Text
        };

    @readonly
    entity VH_DimensionUnits as
        select from logali.DimensionUnits {
            ID          as Code,
            Description as Text
        };
}

define service Report {

    entity AverageRating as projection on logali.AverageRating;

    entity EntityCasting as
        select
            cast(
                Price as      Integer
            )     as Price,
            Price as Price2 : Integer
        from logali.Products;

    entity EntityExists  as
        select from logali.Products {
            Name
        }
        where
            exists Supplier[Name = 'Exotic Liquids'];

}

define service Util {

    entity SuppliersProduct as
        select from logali.Product[Name = 'Bread']{
            *,
            Product.Name,
            Description,
            Supplier.Address
        }
        where
            Supplier.Address.PostalCode = 98074;

    entity SuppliersToSales as
        select
            Supplier.Email,
            Category.Name,
            SalesData.Currency.ID,
            SalesData.Currency.Description
        from logali.Products;

    entity EntityInfix      as
        select Supplier[Name = 'Exotic Liquids'].Phone from logali.Product
        where
            Product.Name = 'Bread';

    entity EntityJoin       as
        select Phone from logali.Product
        left join logali.Suppliers as supp
            on(
                supp.ID = Product.Supplier.ID
            )
            and supp.Name = 'Exotic Liquids'
        where
            Product.Name = 'Bread';
}
