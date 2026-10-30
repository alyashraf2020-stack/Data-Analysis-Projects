# Restaurant Sales Analytics — simplified project

Open the new separate project:

`E:\DATA ANALYSIS\Restaurant_Sales_Analytics_Simplified\Restaurant_Sales_Analytics_Simplified.pbip`

The source of this copy was the repaired project in `E:\DATA ANALYSIS\Restaurant_Sales_Analytics_ImportDims`. That project, the original PBIX, and Databricks were not modified.

## Final model

| Table | Storage | Purpose |
|---|---|---|
| resturant_final | DirectQuery | Original Databricks fact and categorical/customer fields |
| Calendar | Import, calculated | Original dynamic marked Date table |
| _Measures | Import, calculated; disconnected | All 39 existing DAX measures |

There is exactly one relationship: **Calendar[Date] (1) → resturant_final[order_date] (*)**, active, with single-direction filtering from Calendar to the fact. Its existing identity and definition were preserved. Calendar's definition, columns, sorting, and Date-table marking were preserved.

Branch, Category, Menu Item, Customer, Payment Method, and Order Type tables and their six relationships were removed **only from this copy**. Their dependent report fields and measures were updated and validated first, while all six tables still existed. The Databricks M expression and fact partition remain unchanged; no fact records were imported, deduplicated, or deleted.

## Field mapping

| Former field | New field |
|---|---|
| Branch[Branch] | resturant_final[branch] |
| Category[Category] | resturant_final[category] |
| Menu Item[Menu Item] | resturant_final[item_name] |
| Menu Item[Category] | resturant_final[category] |
| Customer[Customer ID] | resturant_final[customer_id] |
| Payment Method[Payment Method] | resturant_final[payment_method] |
| Order Type[Order Type] | resturant_final[order_type] |

The six categorical/customer fact columns are now visible for report authoring. Technical date fields remain hidden so date reporting continues through Calendar. Existing friendly visual labels are retained through display names and slicer headers.

## DAX changes

All 39 measures were preserved, with their names, formatting, folders, lineage tags, and visibility. Only these two expressions changed:

```dax
Menu Item Revenue Rank =
RANKX(
    ALLSELECTED('resturant_final'[item_name]),
    [Total Revenue],
    , DESC, Dense
)

Menu Item Quantity Rank =
RANKX(
    ALLSELECTED('resturant_final'[item_name]),
    [Total Quantity Sold],
    , DESC, Dense
)
```

The other 37 measure expressions are unchanged. The existing Total Orders transaction-grain definition and reconstructed-discount description were not altered by this model simplification.

## Report preservation and validation

- All three pages and 75 native visuals remain, with the same IDs, positions, sizes, types, titles, colors, fonts, container styling, and page interactions.
- Twenty-two visual definitions needed field remapping, including charts, table columns, and the categorical slicers. Sort fields, query references, column-width metadata, and saved bookmark filter sources were updated consistently.
- Seven synchronized slicer groups remain consistent across the three pages. Reset bookmarks were updated to use fact fields for categorical filters.
- Sales by Branch, Sales by Category, Top 10 Menu Items, and Revenue by Order Type were explicitly checked for direct fact-field bindings. Their measure values remain bound to _Measures.
- Dependency checks passed **before** removing the dimension files. No visual or measure depends on a removed table.
- Final TMDL parsing confirms exactly three tables, 39 measures, and the single valid active date relationship. _Measures has no relationships.
- All 85 report-definition JSON files passed their Microsoft schemas. Checks resolved 107 field bindings, 99 query/metadata references, and 36 qualified DAX column references.
- Source project files and the original PBIX were checked against their original hashes. Only the separate simplified copy was edited.

Machine-readable results are in `Validation.json`, with the before-removal dependency checkpoint in `Dependencies_Before_Removal.json`.

## Desktop verification status

**Desktop loading, refreshed calculations, native rendering, and click-through interactions have not been tested for this simplified copy.** No Power BI Desktop/model-engine process was running during validation. The checks above are model-file, dependency, and design-preservation checks; they do not establish successful Desktop loading.

Open the new PBIP, select **Refresh**, then check the four named charts. Select a branch, category, order type, payment method, and Calendar period; navigate through all three pages and test Reset filters. Confirm the slicers stay synchronized and the fact remains DirectQuery. `Verify_Simplified_Visuals.dax` contains read-only queries for checking the chart data and ranking measures in DAX query view.

Keep this simplified PBIP with its `.Report` and `.SemanticModel` folders. Save any final PBIX to a new location; do not overwrite the original PBIX.
