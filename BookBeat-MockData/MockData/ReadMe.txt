

The data sets included should give you some data to replicate our user and book consumption flow. 

The fact table fact.UsageConsumption and surrounding dimensions is the baseline for all consumption reporting, analytical as well as financial. It is based on stg.Settlements and the lowest grain for this fact is User, Edition, ConsumptionsSource and Date.

From this we load other fact tables and dashbboards for specialized analysis. Like applying price models from publishers so we can calculate their revenue or follow up of campaigns and how the books have performed.

In the document DWHFundamentals you can find a detailed documentationof the different DW layers. In short, starting after midnight, we extract yesterday data from backend storage to the data lake and then load the Data Warehouse

BackendStorages -> DWStage (External tables) -> DWHist -> DWCore -> Dim and Facts

DWStage and DW hist contains the same columns or a subset of the columns from the backend source.

Core.abcKey tables generate technial keys from the IDs to be used in dimension and fact tables.

Core tables without suffix key contains the data that is active for the loading data. So basically hist.tables with date condition in the where clause.

We talked about delivering source data, that would be our stg files, but I have not included that for all dimensions because of the complexity. 

For example, to load our dimension Edition, containing all data related to a book, we load from many sources and combine them.

You would have to set up something like the join bleow and set up all those tables 

INNER JOIN [core].[EditionKey] ek1 ON ek1.[Isbn] = be1.[Isbn]
LEFT OUTER JOIN [hist].[DistributionContentMeasurements] dcm ON be1.[Isbn] = dcm.[Isbn]
	AND @dStart BETWEEN dcm.DwhValidFrom
		AND dcm.DwhValidTo
LEFT OUTER JOIN [core].[EditionAuthors] ea ON ek1.[EditionKey] = ea.[EditionKey] 
LEFT OUTER JOIN [core].[EditionNarrators] en ON ek1.[EditionKey] = en.[EditionKey] 
LEFT OUTER JOIN [core].[EditionTranslators] et ON ek1.[EditionKey] = et.[EditionKey] 
LEFT OUTER JOIN [hist].[BooksBooks] bb ON bb.Id = be1.Book_Id
	AND @dStart BETWEEN bb.DwhValidFrom
		AND bb.DwhValidTo 
FROM [hist].[BooksCategories] bc
INNER JOIN [hist].[BooksEditions] be ON be.Book_Id = bc.BookId
INNER JOIN [core].[EditionKey] ek ON ek.Isbn = be.Isbn
FROM [core].[OrganizationsPublisherName] a
INNER JOIN [core].[OrganizationsPublisherGroup] b ON b.PublisherId = a.PublisherId
INNER JOIN [core].[OrganizationsGroup] c ON c.GroupId = b.GroupId
LEFT OUTER JOIN core.SettlementsAxiellIsbns sai ON sai.[Isbn] = be1.[Isbn]
FROM [hist].[BooksSeriesParts] sp
INNER JOIN [hist].[BooksSeries] s
FROM [hist].[ReadingsWishes]
FROM [hist].[ReadingsBookmarks]
FROM [hist].[DistributionContentItems] i1
INNER JOIN [hist].[DistributionContentParts] p1 ON p1.[ContentItem_Id] = i1.[Id]
FROM [core].editionprices

So instead I added source data from one of the table, BooksEditions, which contains the central parts

Rasmus

